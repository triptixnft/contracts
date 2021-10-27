/**
SPDX-FileCopyrightText: 2021 copyright 52a74d3b580cdb48eb87979860ca6efe <creator@themasterpiece.art>
SPDX-License-Identifier: GPL-3.0-or-later
*/

import TheMasterPixelContract from "../contracts/TheMasterPixelContract.cdc"

pub fun main(sector: UInt16, address: Address): {UInt32: UInt32} {
    let ownerRef = getAccount(address).getCapability<&AnyResource{TheMasterPixelContract.TheMasterSectorsInterface}>(TheMasterPixelContract.CollectionPublicPath)
      .borrow()
      ?? panic("Could not borrow TheMasterSectorsInterface reference")

    return ownerRef.getPixels(sectorId: sector)
}
