import TheMasterMarketContract from 0x01

transaction(state: Bool) {
  let theMasterMarketRef: &TheMasterMarketContract.TheMasterMarketState

  prepare(acct: AuthAccount) {
    self.theMasterMarketRef = acct.borrow<&TheMasterMarketContract.TheMasterMarketState>(from: /storage/TheMasterMarketState)!
  }

  execute {
    self.theMasterMarketRef.setOpened(state: state)
  }
}
