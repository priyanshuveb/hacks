// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract ReentrancyGaurd {
    bool internal lock;

    modifier nonReentrant() {
        require(!lock, "Non-Reentrant");
        lock = true;
        _;
        lock = false;
    }
}