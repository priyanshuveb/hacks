// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ReentrancyGaurd} from "../utils/ReentrancyGaurd.sol";

error InsufficientBalance();
contract Bank is ReentrancyGaurd {
    mapping(address => uint256) balanceOf;
    uint256 public constant MIN_VALUE = 1 ether;

    function deposit() external payable {
        require(msg.value >= MIN_VALUE, "Less than minimum deposit value");
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw() external nonReentrant {
        require(balanceOf[msg.sender] >= MIN_VALUE, "Less than minimum withdraw value");
        uint256 balance = balanceOf[msg.sender];
        (bool success,) = msg.sender.call{value: balance}("");
        require(success, "transaction failed");
        balanceOf[msg.sender] = 0;
    }

    function transfer(address to, uint256 amount) external {
        if(balanceOf[msg.sender]>= amount) {
            balanceOf[to] += amount;
            balanceOf[msg.sender] -= amount;
        } else revert InsufficientBalance();
    }

    function totalBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function userBalance(address user) external view returns (uint256 bal) {
        bal = balanceOf[user];
    }
}
