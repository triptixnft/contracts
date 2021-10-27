/**
SPDX-FileCopyrightText: 2021 copyright 52a74d3b580cdb48eb87979860ca6efe <creator@themasterpiece.art>
SPDX-License-Identifier: GPL-3.0-or-later
*/

import TheMasterPixelContract from "../contracts/TheMasterPixelContract.cdc"

transaction(sector: UInt16, ids: [UInt32], color: UInt32) {
  let theMasterSectorsRef: &TheMasterPixelContract.TheMasterSectors
  let theMasterPixelMinterRef: &TheMasterPixelContract.TheMasterPixelMinter

  prepare(acct: AuthAccount) {
    self.theMasterSectorsRef = acct.borrow<&TheMasterPixelContract.TheMasterSectors>(from: TheMasterPixelContract.CollectionStoragePath)!
    self.theMasterPixelMinterRef = acct.borrow<&TheMasterPixelContract.TheMasterPixelMinter>(from: TheMasterPixelContract.MinterStoragePath)!
  }

  execute {
    self.theMasterPixelMinterRef.mintTheMasterPixel(theMasterSectorsRef: self.theMasterSectorsRef, ids: ids, sector: sector, color: color)
  }
}
