// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {EtherGame} from "../../src/self-destruct/EtherGame.sol";
import {Attack} from "../../src/self-destruct/Attack.sol";

contract AttackTest is Test {
    EtherGame etherGame;
    Attack attack;
    address ALICE_THE_ATTACKER = makeAddr("alice");
    address DEREK = makeAddr("derek");
    uint256 balanceInit = 11 ether;

    function setUp() external {
        etherGame = new EtherGame();
        attack = new Attack(etherGame);
        vm.deal(ALICE_THE_ATTACKER, balanceInit);
        vm.deal(DEREK, balanceInit);
    }

    function test_CannotDepositMoreThan1ETH() external {
        vm.prank(DEREK);
        vm.expectRevert(bytes("You can only send 1 Ether"));
        etherGame.deposit{value: 2 ether}();
    }

    function test_ClaimReward() external {
        uint256 contractBalance = address(etherGame).balance;
        while (contractBalance < 10 ether) {
            vm.prank(DEREK);
            etherGame.deposit{value: 1 ether}();
            contractBalance = address(etherGame).balance;
        }
        assertEq(address(DEREK).balance + contractBalance, balanceInit);
        vm.prank(DEREK);
        etherGame.claimReward();
        assertEq(address(DEREK).balance, balanceInit);
    }

    function test_Attack() external {
        vm.prank(ALICE_THE_ATTACKER);
        attack.attack{value: 10 ether}();

        vm.expectRevert(bytes("Game is over"));    
        vm.prank(DEREK);
        etherGame.deposit{value: 1 ether}();

        vm.expectRevert(bytes("Not winner"));
        vm.prank(address(attack));
        etherGame.claimReward();

        assertEq(etherGame.winner(), address(0));     

    }
}
