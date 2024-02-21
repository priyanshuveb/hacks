// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Lottery} from "../../src/DoS/DoS.sol";
import {DeployLottery} from "../../script/DeployDoS.s.sol";

contract DoSTest is Test {
        Lottery lottery;
    function setUp() public{
        DeployLottery deployLottery = new DeployLottery();
        lottery = deployLottery.run();
    }

    function test_DoSAttack() external {
        vm.hoax();
    }
}