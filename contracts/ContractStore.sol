pragma solidity 0.4.25;
import "./VerifySignature.sol";



contract ContractStore is VerifySignature {
    
    string proofContract;
    address[] signataries;
    mapping (address => bytes) signatures;
    mapping (address => bool) signed;

    event newSignature (address _address, bytes _signature);

    modifier validateSignature(bytes _signature){
        require(verifySignString(proofContract, _signature) == msg.sender);
        _;
    }
    
    modifier validateSigner(address _address){
        require(isSigner(_address) == true);
        _;
    }

    constructor (string _proofContract, address[] _signataries) public {
        proofContract = _proofContract;
        for (uint i = 0; i < _signataries.length; i++){
            signataries.push(_signataries[i]);
        }
    }

    function isSigner(address _address) public view returns (bool){
        for (uint i = 0; i < signataries.length; i++) {
            if (signataries[i] == _address) {
                return true;
                }
        } 
        return false;       
    }

    function signContract(bytes _signature) public validateSignature(_signature) validateSigner(msg.sender) returns (bool){
        require(signatures[msg.sender].length == 0);
        signatures[msg.sender] = _signature;
        signed[msg.sender] = true;
        emit newSignature(msg.sender, _signature);
        return true;
    }

    function getSignByAddress(address _address) public view returns (bytes){
        return signatures[_address];
    }

    function getProofContract() external view returns (string){
        return proofContract;
    }

    function getSignataries() external view returns (address[]){
        return signataries;
    }

    function getUnsigned() public view returns (address[]){
        address[] memory unsigned = new address[](signataries.length);
        uint counter = 0;
        for (uint i = 0; i < signataries.length; i++) {
            if (signatures[signataries[i]].length == 0) {
                unsigned[counter] = signataries[i];
                counter++; 
                }
        }
        
        return unsigned;
    }

}