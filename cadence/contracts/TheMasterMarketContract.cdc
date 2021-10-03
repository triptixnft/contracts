/**

## `TheMasterMarketContract` contract

The contract will manage a collection of TheMasterPixel and prices organized by sector
Allowing anyone to trade TheMasterPixel NFTs


## `TheMasterMarket`, `TheMasterMarketSector` resources

TheMasterMarket will manage a dictionnary of TheMasterMarketSector oraganized by sector
TheMasterMarketSector will manage a dictionnary of TheMasterPixel organized by id and a dictionnary of prices

TheMasterMarket
    {sector -> TheMasterMarketSector}
        {id ->  TheMasterPixel}
        {id ->  prices}

## `TheMasterMarketInterface` resource interfaces

Exposes functions to purchase TheMasterPixel

*/

import TheMasterPieceContract from 0x01
import TheMasterPixelContract from 0x01
import FungibleToken from 0x02

pub contract TheMasterMarketContract {

    pub event ForSale(sectorId: UInt16, ids: [UInt32], price: UFix64)
    pub event TokenPurchased(sectorId: UInt16, ids: [UInt32], price: UFix64)

    pub fun createTheMasterMarket(sectorsRef: Capability<&TheMasterPixelContract.TheMasterSectors>): @TheMasterMarket {
        return <- create TheMasterMarket(sectorsRef: sectorsRef)
    }

    init() {
        if (self.account.borrow<&TheMasterMarketState>(from: /storage/TheMasterMarketState) == nil) {
          self.account.save(<- create TheMasterMarketState(), to: /storage/TheMasterMarketState)
          self.account.link<&{TheMasterMarketStateInterface}>(/public/TheMasterMarketState, target: /storage/TheMasterMarketState)
        }

        if (self.account.borrow<&TheMasterMarket>(from: /storage/TheMasterMarket) == nil) {
          self.account.save(<-self.createTheMasterMarket(sectorsRef: self.account.getCapability<&TheMasterPixelContract.TheMasterSectors>(/private/TheMasterSectors)), to: /storage/TheMasterMarket)
          self.account.link<&{TheMasterMarketInterface}>(/public/TheMasterMarket, target: /storage/TheMasterMarket)
        }
    }

    access(contract) fun isOpened(ownerAddress: Address): Bool {
      let refMarketState = getAccount(self.account.address).getCapability<&AnyResource{TheMasterMarketStateInterface}>(/public/TheMasterMarketState).borrow()!
      return refMarketState.isOpened() || (self.account.address == ownerAddress)
    }

    // ########################################################################################

    pub resource TheMasterMarketSector {
        pub var forSale: @{UInt32: TheMasterPixelContract.TheMasterPixel}
        pub var prices: {UInt32: UFix64}
        pub var sectorId: UInt16

        access(account) let ownerVault: Capability<&AnyResource{FungibleToken.Receiver}>
        access(account) let creatorVault: Capability<&AnyResource{FungibleToken.Receiver}>
        access(account) let sectorsRef: Capability<&TheMasterPixelContract.TheMasterSectors>

        init (sectorId: UInt16, ownerVault: Capability<&AnyResource{FungibleToken.Receiver}>, creatorVault: Capability<&AnyResource{FungibleToken.Receiver}>, sectorsRef: Capability<&TheMasterPixelContract.TheMasterSectors>) {
            self.sectorId = sectorId
            self.forSale <- {}
            self.prices = {}

            self.ownerVault = ownerVault
            self.creatorVault = creatorVault
            self.sectorsRef = sectorsRef
        }

        access(contract) fun withdraw(tokenID: UInt32): @TheMasterPixelContract.TheMasterPixel {
            self.prices.remove(key: tokenID)
            let token <- self.forSale.remove(key: tokenID) ?? panic("The pixel you are trying to buy has been sold.")
            TheMasterPieceContract.setSaleSize(sectorId: self.sectorId, address: (self.owner!).address, size: UInt16(self.forSale.length))
            return <-token
        }

        pub fun listForSale(tokenIDs: [UInt32], price: UFix64) {
            pre {
              TheMasterMarketContract.isOpened(ownerAddress: (self.owner!).address):
                    "The trade market is not opened yet."
            }

            for tokenID in tokenIDs {
              self.prices[tokenID] = price
              let oldToken <- self.forSale[tokenID] <- (self.sectorsRef.borrow()!).withdraw(sectorId: self.sectorId, withdrawID: tokenID)
              destroy oldToken
            }

            TheMasterPieceContract.setSaleSize(sectorId: self.sectorId, address: (self.owner!).address, size: UInt16(self.forSale.length))

            emit ForSale(sectorId: self.sectorId, ids: tokenIDs, price: UFix64(tokenIDs.length) * price)
        }

        pub fun purchase(tokenIDs: [UInt32], recipient: &AnyResource{TheMasterPixelContract.TheMasterSectorsInterface}, vaultRef: &AnyResource{FungibleToken.Provider}) {
            // pre {
            //     (self.forSale[tokenID] != nil && self.prices[tokenID] != nil) && (buyTokens.balance >= (self.prices[tokenID] ?? 0.0)):
            //       "No token matching this ID for sale! or Not enough tokens to by the NFT!"
            // }

            var totalPrice: UFix64 = 0.0

            for tokenID in tokenIDs {
              totalPrice = totalPrice + self.prices[tokenID]!
              recipient.deposit(sectorId: self.sectorId, token: <-self.withdraw(tokenID: tokenID), color: (self.sectorsRef.borrow()!).removeColor(sectorId: self.sectorId, id: tokenID)!)
              self.prices[tokenID] = nil
            }

            (self.creatorVault.borrow()!).deposit(from: <- vaultRef.withdraw(amount: totalPrice * 0.025))
            (self.ownerVault.borrow()!).deposit(from: <- vaultRef.withdraw(amount: totalPrice * 0.975))

            emit TokenPurchased(sectorId: self.sectorId, ids: tokenIDs, price: totalPrice)
        }

        pub fun idPrice(tokenID: UInt32): UFix64? {
            return self.prices[tokenID]
        }

        pub fun getPrices(): {UInt32: UFix64} {
            return self.prices
        }

        destroy() {
            destroy self.forSale
        }
    }

    // ########################################################################################

    pub resource interface TheMasterMarketInterface {
        pub fun purchase(sectorId: UInt16, tokenIDs: [UInt32], recipient: &AnyResource{TheMasterPixelContract.TheMasterSectorsInterface}, vaultRef: &AnyResource{FungibleToken.Provider})
        pub fun getPrices(sectorId: UInt16): {UInt32: UFix64}
    }

    pub resource TheMasterMarket: TheMasterMarketInterface {
        pub var saleSectors: @{UInt16: TheMasterMarketSector}

        access(account) let ownerVault: Capability<&AnyResource{FungibleToken.Receiver}>
        access(account) let creatorVault: Capability<&AnyResource{FungibleToken.Receiver}>
        access(account) let sectorsRef: Capability<&TheMasterPixelContract.TheMasterSectors>

        init (sectorsRef: Capability<&TheMasterPixelContract.TheMasterSectors>) {
            self.saleSectors <- {}
            self.ownerVault = getAccount(sectorsRef.address).getCapability<&AnyResource{FungibleToken.Receiver}>(/public/flowTokenReceiver)
            self.creatorVault  =  getAccount(TheMasterPieceContract.getAddress()).getCapability<&AnyResource{FungibleToken.Receiver}>(/public/flowTokenReceiver)
            self.sectorsRef = sectorsRef
        }

        pub fun listForSale(sectorId: UInt16, tokenIDs: [UInt32], price: UFix64) {
            if self.saleSectors[sectorId] == nil {
                self.saleSectors[sectorId] <-! create TheMasterMarketSector(sectorId: sectorId, ownerVault: self.ownerVault, creatorVault: self.creatorVault, sectorsRef: self.sectorsRef)
            }

            let masterSectorRef: &TheMasterMarketSector = &self.saleSectors[sectorId] as &TheMasterMarketSector
            masterSectorRef.listForSale(tokenIDs: tokenIDs, price: price)
        }

        pub fun purchase(sectorId: UInt16, tokenIDs: [UInt32], recipient: &AnyResource{TheMasterPixelContract.TheMasterSectorsInterface}, vaultRef: &AnyResource{FungibleToken.Provider}) {
            (&self.saleSectors[sectorId] as &TheMasterMarketSector).purchase(tokenIDs: tokenIDs, recipient: recipient, vaultRef: vaultRef)
        }

        pub fun withdraw(sectorId: UInt16, tokenID: UInt32): @TheMasterPixelContract.TheMasterPixel {
          let masterSectorRef: &TheMasterMarketSector = &self.saleSectors[sectorId] as &TheMasterMarketSector
          return <- masterSectorRef.withdraw(tokenID: tokenID)!
        }

        pub fun getPrices(sectorId: UInt16): {UInt32: UFix64} {
            if (self.saleSectors.containsKey(sectorId)) {
              let masterSectorRef: &TheMasterMarketSector = &self.saleSectors[sectorId] as &TheMasterMarketSector
              return masterSectorRef.getPrices()
            } else {
              return {}
            }
        }

        destroy() {
            destroy self.saleSectors
        }
    }

    // ########################################################################################

    pub resource interface TheMasterMarketStateInterface {
      pub fun isOpened(): Bool
    }

    pub resource TheMasterMarketState: TheMasterMarketStateInterface {
      pub var opened: Bool

      init() {
          self.opened = false
      }

      pub fun setOpened(state: Bool) {
          self.opened = state
      }

      pub fun isOpened(): Bool {
          return self.opened
      }
    }
}
