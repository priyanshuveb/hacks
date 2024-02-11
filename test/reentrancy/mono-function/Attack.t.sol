// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Bank} from "../../../src/reentrancy/mono-function/Bank.sol";
import {Attack} from "../../../src/reentrancy/mono-function/Attack.sol";


contract AttackTest is Test {
    Bank bank;
    Attack attack;
    address ALICE_THE_ATTACKER = makeAddr("alice");
    address DEREK_THE_DEPOSITOR = makeAddr("derek");
    uint256 balanceInit = 1 ether;
    uint256 bankBalanceInit = 20 ether;

    function setUp() external {
        bank = new Bank();
        attack = new Attack(address(bank));
        vm.deal(ALICE_THE_ATTACKER, balanceInit);
        vm.deal(DEREK_THE_DEPOSITOR, bankBalanceInit);
    }

    function test_Attack() external {
        vm.prank(DEREK_THE_DEPOSITOR);
        bank.deposit{value: bankBalanceInit}();

        vm.startPrank(ALICE_THE_ATTACKER);
        attack.attack{value: balanceInit}();
        vm.stopPrank();

        assertEq(address(attack).balance, bankBalanceInit + balanceInit);
    
    }
}