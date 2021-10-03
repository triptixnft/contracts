import TheMasterPixelContract from 0x01

transaction(sector: UInt16, ids: [UInt32], color: UInt32) {
  let theMasterSectorsRef: &TheMasterPixelContract.TheMasterSectors
  let theMasterPixelMinterRef: &TheMasterPixelContract.TheMasterPixelMinter

  prepare(acct: AuthAccount) {
    self.theMasterSectorsRef = acct.borrow<&TheMasterPixelContract.TheMasterSectors>(from: /storage/TheMasterSectors)!
    self.theMasterPixelMinterRef = acct.borrow<&TheMasterPixelContract.TheMasterPixelMinter>(from: /storage/TheMasterPixelMinter)!
  }

  execute {
    self.theMasterPixelMinterRef.mintTheMasterPixel(theMasterSectorsRef: self.theMasterSectorsRef, ids: ids, sector: sector, color: color)
  }
}
