import TheMasterPixelContract from 0x01

transaction(sector: UInt16, ids: [UInt32], color: UInt32) {
  let collectionRef: &TheMasterPixelContract.TheMasterSectors

  prepare(acct: AuthAccount) {
      self.collectionRef = acct.borrow<&TheMasterPixelContract.TheMasterSectors>(from: /storage/TheMasterSectors)
          ?? panic("could not borrow TMPCollection reference")
  }

  execute {
      for id in ids {
          self.collectionRef.setColor(sectorId: sector, id: id, color: color)
      }
  }
}
