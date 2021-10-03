import TheMasterPixelContract from 0x01

pub fun main(sector: UInt16, address: Address): {UInt32: UInt32} {
    let ownerRef = getAccount(address).getCapability<&AnyResource{TheMasterPixelContract.TheMasterSectorsInterface}>(/public/TheMasterSectors)
      .borrow()
      ?? panic("Could not borrow TheMasterSectorsInterface reference")

    return ownerRef.getPixels(sectorId: sector)
}
