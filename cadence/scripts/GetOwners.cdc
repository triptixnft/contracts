/**
SPDX-FileCopyrightText: 2021 copyright 52a74d3b580cdb48eb87979860ca6efe <creator@themasterpiece.art>
SPDX-License-Identifier: GPL-3.0-or-later
*/

import TheMasterPieceContract from "../contracts/TheMasterPieceContract.cdc"

pub fun main(sector: UInt16): {Address: TheMasterPieceContract.TMPOwner} {
    let tmpAccount = getAccount(TheMasterPieceContract.getAddress())
    let ownersRef= tmpAccount.getCapability<&AnyResource{TheMasterPieceContract.TMPOwnersInterface}>(TheMasterPieceContract.CollectionPublicPath)
      .borrow()
      ?? panic("Could not borrow TMPOwnersInterface reference")

    return ownersRef.getOwners(sectorId: sector)
}
