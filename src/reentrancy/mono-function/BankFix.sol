// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ReentrancyGaurd} from "../utils/ReentrancyGaurd.sol";

contract Bank is ReentrancyGaurd {
    mapping(address => uint256) balanceOf;
    uint256 public constant MIN_VALUE = 1 ether;

    function deposit() external payable {
        require(msg.value > MIN_VALUE, "Less than minimum deposit value");
        balanceOf[msg.sender] += msg.value;
    }

    // Fix1: Use non-reentrant modifier
    // Fix2: Update the state variable first then transfer ETH
    function withdraw() external nonReentrant {
        require(balanceOf[msg.sender] > MIN_VALUE, "Less than minimum withdraw value");
        uint256 balance = balanceOf[msg.sender];
        (bool success,) = msg.sender.call{value: balance}("");
        require(success, "transaction failed");
        balanceOf[msg.sender] = 0;
    }

    function totalBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function userBalance(address user) public view returns (uint256 bal) {
        bal = balanceOf[user];
    }
}
