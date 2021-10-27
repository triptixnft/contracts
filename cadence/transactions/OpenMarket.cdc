/**
SPDX-FileCopyrightText: 2021 copyright 52a74d3b580cdb48eb87979860ca6efe <creator@themasterpiece.art>
SPDX-License-Identifier: GPL-3.0-or-later
*/

import TheMasterMarketContract from "../contracts/TheMasterMarketContract.cdc"

transaction(state: Bool) {
  let theMasterMarketRef: &TheMasterMarketContract.TheMasterMarketState

  prepare(acct: AuthAccount) {
    self.theMasterMarketRef = acct.borrow<&TheMasterMarketContract.TheMasterMarketState>(from: TheMasterMarketContract.MarketStateStoragePath)!
  }

  execute {
    self.theMasterMarketRef.setOpened(state: state)
  }
}
