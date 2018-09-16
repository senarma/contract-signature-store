pragma solidity 0.4.25;

contract VerifySignature {
    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256("\x19Ethereum Signed Message:\n32", hash);
}
    
    
    function splitSignature(bytes sig) internal pure returns (uint8, bytes32, bytes32) {
        require(sig.length == 65);

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

  // Returns the address that signed a given string message
    function verifySignString(string message, bytes sig) public pure returns (address signer) {

    // The message header; we will fill in the length next
    string memory header = "\x19Ethereum Signed Message:\n000000";

    uint256 lengthOffset;
    uint256 length;
    assembly {
      // The first word of a string is its length
      length := mload(message)

      // The beginning of the base-10 message length in the prefix
      lengthOffset := add(header, 57)
    }

    // Maximum length we support
    require(length <= 999999);

    // The length of the message's length in base-10
    uint256 lengthLength = 0;

    // The divisor to get the next left-most message length digit
    uint256 divisor = 100000;

    // Move one digit of the message length to the right at a time
    while (divisor != 0) {

      // The place value at the divisor
      uint256 digit = length / divisor;

      if (digit == 0) {
        // Skip leading zeros
        if (lengthLength == 0) {
          divisor /= 10;
          continue;
        }
      }

      // Found a non-zero digit or non-leading zero digit
      lengthLength++;

      // Remove this digit from the message length's current value
      length -= digit * divisor;

      // Shift our base-10 divisor over
      divisor /= 10;
      
      // Convert the digit to its ASCII representation (man ascii)
      digit += 0x30;

      // Move to the next character and write the digit
      lengthOffset++;
      assembly {
        mstore8(lengthOffset, digit)
      }
    }

    // The null string requires exactly 1 zero (unskip 1 leading 0)
    if (lengthLength == 0) {
      lengthLength = 1 + 0x19 + 1;

    } else {
      lengthLength += 1 + 0x19;
    }

    // Truncate the tailing zeros from the header
    assembly {
      mstore(header, lengthLength)
    }
        uint8 v;
        bytes32 r;
        bytes32 s;

        (v, r, s) = splitSignature(sig);


    // Perform the elliptic curve recover operation
    bytes32 check = keccak256(header, message);
    return ecrecover(check, v, r, s);
  }
  
  function verifySignByte(bytes32 message, bytes sig) internal pure returns (address){
    uint8 v;
    bytes32 r;
    bytes32 s;
    bytes32 result = prefixed(message);

    (v, r, s) = splitSignature(sig);

    return ecrecover(result, v, r, s);
}

  
  

}