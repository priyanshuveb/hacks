// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Lottery} from "../src/DoS/DoS.sol";

contract DeployLottery is Script {
    Lottery lotteryContract;

    function run() public returns (Lottery) {
        vm.broadcast();
        lotteryContract = new Lottery(0.1 ether);

        return lotteryContract;
    }
}
