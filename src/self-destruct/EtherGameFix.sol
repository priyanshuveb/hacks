// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice Instead oof using address(this).balance, maintain a state variable to 
///track the ether deposited into the contract 
contract EtherGame {
    uint public targetAmount = 10 ether;
    address public winner;
    uint balance;

    function deposit() public payable {
        require(msg.value == 1 ether, "You can only send 1 Ether");

        balance += msg.value;
        require(balance <= targetAmount, "Game is over");

        if (balance == targetAmount) {
            winner = msg.sender;
        }
    }

    function claimReward() public {
        require(msg.sender == winner, "Not winner");

        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }
}