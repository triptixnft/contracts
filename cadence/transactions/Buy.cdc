import TheMasterPixelContract from 0x01
import TheMasterMarketContract from 0x01
import FlowToken from 0x02

transaction(sector: UInt16, address: Address, ids: [UInt32]) {
  let theMasterSectorsRef: &TheMasterPixelContract.TheMasterSectors
  let vaultRef: &FlowToken.Vault

  prepare(acct: AuthAccount) {
    self.theMasterSectorsRef = acct.borrow<&TheMasterPixelContract.TheMasterSectors>(from: /storage/TheMasterSectors) ?? panic("Could not borrow reference to the buyer's sectors")
    self.vaultRef = acct.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault) ?? panic("Could not borrow reference to the buyer's Vault!")
  }

  execute {
    let theMasterMarketRef = getAccount(address).getCapability<&{TheMasterMarketContract.TheMasterMarketInterface}>(/public/TheMasterMarket).borrow() ?? panic("Could not borrow reference to the seller's market")

    theMasterMarketRef.purchase(sectorId: sector,
        tokenIDs: ids,
        recipient: self.theMasterSectorsRef,
        vaultRef: self.vaultRef)
  }
}
