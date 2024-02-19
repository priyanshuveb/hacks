// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Storage} from "../src/private-var/Storage.sol";

contract DeployStorage is Script {
    Storage storageContract;

    bytes32 password = bytes32(abi.encodePacked("Hello"));
    function run() public returns (address) {
        vm.broadcast();
        storageContract = new Storage(password);

        return address(storageContract);
    }
}
