pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";

// Study Notes from: https://www.youtube.com/watch?v=8ja72g_Dac4&ab_channel=SmartContractProgrammer

contract MultiSig {

    // Step 1: Add the Events 

    // indexed parameters are for logged events, they allow to search for the event
    event Deposit(address indexed sender, uint amount); // someone adds money to wallet
    event Submit(uint indexed txId); // submit the transaction waiting for other owners 

    //other owners 
    event Approve(address indexed owner, uint indexed txId); // ok to approve by signers
    event Revoke(address indexed owner, uint indexed txId); // not apporved by signers 

    // when sufficent amount of approvals, since multisig wait for others 
    event Execute(uint indexed txId); // execute the transactions once all signers are ok 

    // Step 2: state varibales 

    address [ ] public owners; // store the owners 
    mapping(address => bool) public isOwner;// only owners can call the functions, mapping from address to bool 

    // when a transaction is submitted to the smart contract other owners must approve before the tx is submittied
    uint public required; // number of approvales needed to submit the transaction

    // Step 3: Transactions  

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed; // approved if there are enough people signing the tx
    }
    // store all the transctions 
    Transaction[] public transactions;
    //store who is approving the tx and who is not
    mapping(uint => mapping(address => bool)) public approved;

    // Step 4: Constructor

    // memory variable? in solidity 
    constructor(address [] memory _owners, uint _required){
        require(_owners.length >0 , "can't have no signers");
        require(_required > 0 && _required <= _owners.length, "not enough required owners");
        
        // save the owners to the variable and make checks 
        for (uint i; i< _owners.length; i++){
            address owner = _owners[i];
            require(owner != address(0), "invalid owner");
            require(!isOwner[owner],"already in the signers list" );

            isOwner[owner] = true; // add the owner to the mapping
            owners.push(owner); // add the owner to the state var
        }
        required = _required;
    }

    // Step 5: Wallet transactions 

    // Wallet can receive money 
    // external functions are to be called by other contracts
    receive() external payable{
        // this will directly parse the msg 
        emit Deposit(msg.sender, msg.value);
    }

    
    // modifiers are used to modify the behaviour of a function
    // method for only owners to call
    modifier onlyOwner() {
        // to find if address is owner we can scroll through owners to use the mappings 
        // second option to save on gas
        require(isOwner[msg.sender], "not owner");
        _; // <-- allow the execution of the rest of the functions 
    }

    // Wallet can recieve transactions 
    // calldata : Non-modifiable, non-persistent data; cheaper than using memory
    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner{
        transactions.push(Transaction ({
            to: _to,
            value: _value,
            data: _data, // calldata for gas
            executed: false // not executed yet
        }));
        emit Submit(transactions.length-1); //txId is where the tx is stored 
        // once the tx is submitted other owners are able to approve the tx
    }

    modifier txExists(uint _txId){
        require(_txId < transactions.length, "not tx");
        _; // <-- allow the execution of the rest of the functions       
    }
    modifier notApproved(uint _txId){
        require(!approved[_txId][msg.sender], "tx already approved by this address");
        _; // <-- allow the execution of the rest of the functions       
    }
    modifier notExcuted(uint _txId){
        require(!transactions[_txId].executed, "not excuted");
        _; // <-- allow the execution of the rest of the functions       
    }

    // Once the tx is submitted other owners can call the fun 
    function approive(uint _txId) external onlyOwner txExists(_txId) notApproved(_txId) notExcuted(_txId){
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId); // this does not approve, it only makes the event
    } 
    function _getApprovcalCount(uint _txId) private view returns(uint count){
        for (uint i; i< owners.length; i++){
            if (approved[_txId][owners[i]]){
                count += 1; 
            }
        } 
        // we don't need to return again, already do this in the returns statement 
    }

    // Execute the function if enough people have approved 
    // someone needs to click execute 
    function execute(uint _txId) external txExists(_txId) notExcuted(_txId){
        require(_getApprovcalCount(_txId) >= required, "ser not addresses enough approved");
        // solidity storage: holds data between calls
        //  each execution of the Smart contract has access to the data previously stored on the storage area 
        Transaction storage transaction = transactions[_txId];
        transaction.executed = true;
        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(success = true, "tx failed");
        emit Execute(_txId);
    }

    // lets say an owner said yes and then before the tx is approved changes mind 
    function revoke(uint _txId) external onlyOwner txExists(_txId) notExcuted(_txId){
        require(approved[_txId][msg.sender]=true, "ser you haven't approved so can't revoke");
        approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txId);
    } 


}
