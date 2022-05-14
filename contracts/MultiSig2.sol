// SPDX-License-Identifier: MIT

//  Off-chain signature gathering multisig that streams funds - @austingriffith
//
// started from 🏗 scaffold-eth - meta-multi-sig-wallet example https://github.com/austintgriffith/scaffold-eth/tree/meta-multi-sig
//    (off-chain signature based multi-sig)
//  added a very simple streaming mechanism where `onlySelf` can open a withdraw-based stream
//

pragma solidity >=0.8.0 <0.9.0;
// Not needed to be explicitly imported in Solidity 0.8.x
// pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract MultiSig {

    using ECDSA for bytes32; // you need this for signatures 

    event Deposit(address indexed sender, uint amount);

    event ExecuteTransaction(address indexed owner, address payable to, uint256 value, bytes data, uint256 nonce, bytes32 hash, bytes result);
    event Owner(address indexed owner, bool added);
    
    mapping(address => bool) public isOwner;

    address[] public allOwners; //because can't get addresses from mapping 

    uint public signaturesRequired;

    uint public nonce;
    uint public chainId;

    constructor(address[] memory _owners, uint _signaturesRequired) {
        require(_signaturesRequired > 0, "must have required signature");
        signaturesRequired = _signaturesRequired;
        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "ser plz enter address");
            require(!isOwner[owner], "ser u are already owner");
            isOwner[owner] = true;

            allOwners.push(_owners[i]); // since we can not get from mapping 

            emit Owner(owner, isOwner[owner]);
        }
    }

    function getAllOwners() view public returns (address[] memory) {
        return allOwners;
    }
    function getIndex(address _addr) public view returns(uint) {
        uint i = 0;
        while (allOwners[i] != _addr) {
            i++;
        }
        return i;
    }
    function removeOwner(address _addr) public{
        uint i = getIndex(_addr);
        delete allOwners[i]; // it will leave a blank in the array     
    }

    modifier onlySelf() {
        require(isOwner[msg.sender], "ser you are not an owner");
        _;
    }

    function addSigner(address newSigner, uint256 newSignaturesRequired) public onlySelf {
        require(newSigner != address(0), "addSigner: zero address");
        require(!isOwner[newSigner], "addSigner: owner not unique");
        require(newSignaturesRequired > 0, "addSigner: must be non-zero sigs required");
        isOwner[newSigner] = true;
        signaturesRequired = newSignaturesRequired;
        allOwners.push(newSigner); 
        emit Owner(newSigner, isOwner[newSigner]);
    }

    function removeSigner(address oldSigner, uint256 newSignaturesRequired) public onlySelf {
        require(isOwner[oldSigner], "removeSigner: not owner");
        require(newSignaturesRequired > 0, "removeSigner: must be non-zero sigs required");
        isOwner[oldSigner] = false;
        signaturesRequired = newSignaturesRequired;
        removeOwner(oldSigner);
        emit Owner(oldSigner, isOwner[oldSigner]);
    }

    function getTransactionHash(uint256 _nonce, address to, uint256 value, bytes memory data) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), chainId, _nonce, to, value, data));
    }

    function executeTransaction( address payable to, uint256 value, bytes memory data, bytes[] memory signatures) onlySelf public returns (bytes memory) {
        bytes32 _hash =  getTransactionHash(nonce, to, value, data);
        nonce++;
        uint256 validSignatures;
        address duplicateGuard;
        for (uint i = 0; i < signatures.length; i++) {
            address recovered = recover(_hash,signatures[i]);
            require(recovered>duplicateGuard, "executeTransaction: duplicate or unordered signatures");
            duplicateGuard = recovered;
            if(isOwner[recovered]){
              validSignatures++;
            }
        }

        require(validSignatures>=signaturesRequired, "executeTransaction: not enough valid signatures");

        (bool success, bytes memory result) = to.call{value: value}(data);
        require(success, "executeTransaction: tx failed");

        emit ExecuteTransaction(msg.sender, to, value, data, nonce-1, _hash, result);
        return result;
    }

    function recover(bytes32 _hash, bytes memory _signature) public pure returns (address) {
        return _hash.toEthSignedMessageHash().recover(_signature);
    }

    receive() payable external {
        emit Deposit(msg.sender, msg.value);
    }

}
