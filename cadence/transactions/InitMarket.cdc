import TheMasterPixelContract from 0x01
import TheMasterMarketContract from 0x01

transaction() {

  prepare(acct: AuthAccount) {
    let newMarket <- TheMasterMarketContract.createTheMasterMarket(sectorsRef: acct.getCapability<&TheMasterPixelContract.TheMasterSectors>(/private/TheMasterSectors))
    acct.save(<- newMarket, to: /storage/TheMasterMarket)
    acct.link<&{TheMasterMarketContract.TheMasterMarketInterface}>(/public/TheMasterMarket, target: /storage/TheMasterMarket)
  }

  execute {
  }

}
