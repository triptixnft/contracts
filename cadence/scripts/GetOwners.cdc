import TheMasterPieceContract from 0x01

pub fun main(sector: UInt16): {Address: TheMasterPieceContract.TMPOwner} {
    let tmpAccount = getAccount(TheMasterPieceContract.getAddress())
    let ownersRef= tmpAccount.getCapability<&AnyResource{TheMasterPieceContract.TMPOwnersInterface}>(/public/TMPOwners)
      .borrow()
      ?? panic("Could not borrow TMPOwnersInterface reference")

    return ownersRef.getOwners(sectorId: sector)
}
