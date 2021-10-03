import TheMasterPixelContract from 0x01

transaction() {

  prepare(acct: AuthAccount) {
    let newCollection <- TheMasterPixelContract.createEmptySectors();
    acct.save(<- newCollection, to: /storage/TheMasterSectors)
    acct.link<&TheMasterPixelContract.TheMasterSectors{TheMasterPixelContract.TheMasterSectorsInterface}>(/public/TheMasterSectors, target: /storage/TheMasterSectors)
    acct.link<&TheMasterPixelContract.TheMasterSectors>(/private/TheMasterSectors, target: /storage/TheMasterSectors)
  }

  execute {
  }
  
}
