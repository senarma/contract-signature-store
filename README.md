# contract-signature-store
A Solidity contract to store Ethereum digital signature on Block Notal(https://blocknotal.com)

This contract receive a String that need to be sign and a array of address who are authorized to sign.

This contract validates signatures created by metamask, status and other web3 providers who join the prefix "Ethereum Signed Message:" with the signature.


**Constructor**

     ContractStore.constructor(string _proofContract, address[] _signataries)


You need to pass the _proofContract string, and a array of addresses allow to sign



**IsSigner**

    ContractStore.IsSigner(address _address)
You can pass an Ethereum Address and know if you can sign



**getProofContract**

    ContractStore.getProofContract()
Return the string that need to be sign

**SignContract**

    ContractStore.signContract(bytes _signature)
Send the signature of the string on proofContract using metamask or other web3 provider.



**getSignByAddress**

    ContractStore.getSignByAddress(address _address)
You pass an address and will be returned the signature of the user



**getUnsigned**
     ContractStore.getUnsigned()
Return the address that not sign the contract



