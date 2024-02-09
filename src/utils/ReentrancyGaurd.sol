// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract ReentrancyGaurd {
    bool internal locked;

    modifier nonReentrant() {
        require(!lock, "Non-Reentrant");
        lock = true;
        _;
        lock = false;
    }
}