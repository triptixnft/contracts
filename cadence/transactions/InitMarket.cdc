/**
SPDX-FileCopyrightText: 2021 copyright 52a74d3b580cdb48eb87979860ca6efe <creator@themasterpiece.art>
SPDX-License-Identifier: GPL-3.0-or-later
*/

import TheMasterPixelContract from "../contracts/TheMasterPixelContract.cdc"
import TheMasterMarketContract from "../contracts/TheMasterMarketContract.cdc"

transaction() {

  prepare(acct: AuthAccount) {
    let newMarket <- TheMasterMarketContract.createTheMasterMarket(sectorsRef: acct.getCapability<&TheMasterPixelContract.TheMasterSectors>(TheMasterPixelContract.CollectionPrivatePath))
    acct.save(<- newMarket, to: TheMasterMarketContract.CollectionStoragePath)
    acct.link<&{TheMasterMarketContract.TheMasterMarketInterface}>(TheMasterMarketContract.CollectionPublicPath, target: TheMasterMarketContract.CollectionStoragePath)
  }

  execute {
  }

}
