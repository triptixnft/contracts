/**
SPDX-FileCopyrightText: 2021 copyright 52a74d3b580cdb48eb87979860ca6efe <creator@themasterpiece.art>
SPDX-License-Identifier: GPL-3.0-or-later
*/

import TheMasterPixelContract from "../contracts/TheMasterPixelContract.cdc"
import TheMasterMarketContract from "../contracts/TheMasterMarketContract.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

transaction(sector: UInt16, address: Address, ids: [UInt32]) {
  let theMasterSectorsRef: &TheMasterPixelContract.TheMasterSectors
  let vaultRef: &FlowToken.Vault

  prepare(acct: AuthAccount) {
    self.theMasterSectorsRef = acct.borrow<&TheMasterPixelContract.TheMasterSectors>(from: TheMasterPixelContract.CollectionStoragePath) ?? panic("Could not borrow reference to the buyer's sectors")
    self.vaultRef = acct.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault) ?? panic("Could not borrow reference to the buyer's Vault!")
  }

  execute {
    let theMasterMarketRef = getAccount(address).getCapability<&{TheMasterMarketContract.TheMasterMarketInterface}>(TheMasterMarketContract.CollectionPublicPath).borrow() ?? panic("Could not borrow reference to the seller's market")

    theMasterMarketRef.purchase(sectorId: sector,
        tokenIDs: ids,
        recipient: self.theMasterSectorsRef,
        vaultRef: self.vaultRef)
  }
}
