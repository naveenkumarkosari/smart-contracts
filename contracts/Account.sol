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

    function createAccount()public onlyOwner{
        accounts[msg.sender].balance =0;
        accounts[msg.sender].nonce =0;
        accounts[msg.sender].codehash = keccak256("");
        accounts[msg.sender].stateroot = bytes32(0);
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
        uint64 nonce;
        nonce =accounts[_id].nonce;
        nonce =nonce+1;
        accounts[_id].nonce = nonce;
    }

}
