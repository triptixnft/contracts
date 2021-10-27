/**
SPDX-FileCopyrightText: 2021 copyright 52a74d3b580cdb48eb87979860ca6efe <creator@themasterpiece.art>
SPDX-License-Identifier: GPL-3.0-or-later
*/

import TheMasterPixelContract from "../contracts/TheMasterPixelContract.cdc"

transaction() {

  prepare(acct: AuthAccount) {
    let newCollection <- TheMasterPixelContract.createEmptySectors();
    acct.save(<- newCollection, to: TheMasterPixelContract.CollectionStoragePath)
    acct.link<&TheMasterPixelContract.TheMasterSectors{TheMasterPixelContract.TheMasterSectorsInterface}>(TheMasterPixelContract.CollectionPublicPath, target: TheMasterPixelContract.CollectionStoragePath)
    acct.link<&TheMasterPixelContract.TheMasterSectors>(TheMasterPixelContract.CollectionPrivatePath, target: TheMasterPixelContract.CollectionStoragePath)
  }

  execute {
  }

}
