/**
SPDX-FileCopyrightText: 2021 copyright 52a74d3b580cdb48eb87979860ca6efe <creator@themasterpiece.art>
SPDX-License-Identifier: GPL-3.0-or-later
*/

import TheMasterPixelContract from "../contracts/TheMasterPixelContract.cdc"

transaction(sector: UInt16, ids: [UInt32], color: UInt32) {
  let collectionRef: &TheMasterPixelContract.TheMasterSectors

  prepare(acct: AuthAccount) {
      self.collectionRef = acct.borrow<&TheMasterPixelContract.TheMasterSectors>(from: TheMasterPixelContract.CollectionStoragePath)
          ?? panic("could not borrow TMPCollection reference")
  }

  execute {
      for id in ids {
          self.collectionRef.setColor(sectorId: sector, id: id, color: color)
      }
  }
}
