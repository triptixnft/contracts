import TheMasterMarketContract from 0x01

transaction(sector: UInt16, price: UFix64, ids: [UInt32]) {
  let theMasterMarketRef: &TheMasterMarketContract.TheMasterMarket

  prepare(acct: AuthAccount) {
    self.theMasterMarketRef = acct.borrow<&TheMasterMarketContract.TheMasterMarket>(from: /storage/TheMasterMarket)!
  }

  execute {
    self.theMasterMarketRef.listForSale(sectorId: sector, tokenIDs: ids, price: price)
  }
}
