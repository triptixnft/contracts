import FungibleToken from 0x02
import FlowToken from 0x03

pub fun main(address: Address): UFix64 {
    let vaultRef = getAccount(address)
        .getCapability(/public/flowTokenBalance)
        .borrow<&FlowToken.Vault{FungibleToken.Balance}>()
        ?? panic("Could not borrow Balance reference to the Vault")

    return vaultRef.balance
}
