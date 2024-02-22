// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Lottery} from "../../src/DoS/DoS.sol";
import {DeployLottery} from "../../script/DeployDoS.s.sol";

contract DoSTest is Test {
    Lottery lottery;

    function setUp() public {
        DeployLottery deployLottery = new DeployLottery();
        lottery = deployLottery.run();
    }

    function test_DoSAttack() external {
        // 1st set of 100 players
        uint256 gasStartFirst = gasleft();
        for (uint256 i = 1; i <= 100; i++) {
            address user = vm.addr(i);
            hoax(user, 1 ether);
            lottery.enterLottery{value: 0.1 ether}();
        }
        uint256 gasEndFirst = gasleft();

        // 2nd set of 100 players
        uint256 gasStartSecond = gasleft();
        for (uint256 i = 101; i <= 200; i++) {
            address user = vm.addr(i);
            hoax(user, 1 ether);
            lottery.enterLottery{value: 0.1 ether}();
        }
        uint256 gasEndSecond = gasleft();

        uint256 gasCostFirst = gasStartFirst - gasEndFirst;
        uint256 gasCostSecond = gasStartSecond - gasEndSecond;

        console.log("gasCostFirst", gasCostFirst); // 5483323 gas
        console.log("gasCostSecond", gasCostSecond); // 10142450 gas

        assert(gasCostFirst < gasCostSecond);
    }
}
