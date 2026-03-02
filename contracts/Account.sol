// SPDX-License-Identifier:MIT
pragma solidity >=0.8.20;

contract Account{
    struct account {
        uint256 balance;
        uint64 nonce;
        bytes code;
        bytes32 codehash;
        mapping(bytes32=>bytes32) store;
        bytes32  stateroot;
    }
    //storage
    mapping(address=>account) accounts;
    address isOwner;

    constructor(){
        isOwner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == isOwner,"you are not the owner");
        _;
    }

    event AccountCreated(address indexed account,uint256 timestamp);
    event Transfer(address indexed from,address indexed to,uint256 balance,uint256 timestamp);

    function createAccount()public onlyOwner{
        require(accounts[msg.sender].codehash == bytes32(0),"Account exists");
        accounts[msg.sender].balance =0;
        accounts[msg.sender].nonce =0;
        accounts[msg.sender].codehash = keccak256("");
        accounts[msg.sender].stateroot = bytes32(0);
        emit AccountCreated(msg.sender,block.timestamp);
    }

    function getOwner() public view onlyOwner returns (
    uint256 balance,
    uint64 nonce,
    bytes memory code,
    bytes32 codehash,
    bytes32 stateroot
) {
    account storage acc = accounts[msg.sender];
    return (
        acc.balance,
        acc.nonce,
        acc.code,
        acc.codehash,
        acc.stateroot
    );
}

    function getAddress()public view onlyOwner returns(address){
        return msg.sender;
    }

    function getAccountBalance(address _id)internal view returns(uint256){
        return accounts[_id].balance;
    }

    function incrementNonce(address _id)internal {
        accounts[_id].nonce++;
    }

    function increaseBalance(address _id,uint256 _bal) internal   {
        accounts[_id].balance += _bal;
    }
    function decreaseBalance(address _id,uint256 _bal)internal  {
         require(accounts[_id].balance >= _bal, "Insufficient balance");
         accounts[_id].balance -= _bal;
    }

    function transfer(address to,uint value)public onlyOwner{
         require(value  > 0, "Amount must be positive");
         require(accounts[msg.sender].balance >= value, "Insufficient balance");
         require(to != address(0), "Invalid address");
         require(to != msg.sender,"you cant send yourself");
         accounts[msg.sender].balance -= value;
         accounts[to].balance += value;
         emit Transfer(isOwner,to, value, block.timestamp);
    }


}
