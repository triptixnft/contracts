/**
SPDX-FileCopyrightText: 2021 copyright 52a74d3b580cdb48eb87979860ca6efe <creator@themasterpiece.art>
SPDX-License-Identifier: GPL-3.0-or-later
*/

import TheMasterMarketContract from "../contracts/TheMasterMarketContract.cdc"

transaction(sector: UInt16, price: UFix64, ids: [UInt32]) {
  let theMasterMarketRef: &TheMasterMarketContract.TheMasterMarket

  prepare(acct: AuthAccount) {
    self.theMasterMarketRef = acct.borrow<&TheMasterMarketContract.TheMasterMarket>(from: TheMasterMarketContract.CollectionStoragePath)!
  }

  execute {
    self.theMasterMarketRef.listForSale(sectorId: sector, tokenIDs: ids, price: price)
  }
}
