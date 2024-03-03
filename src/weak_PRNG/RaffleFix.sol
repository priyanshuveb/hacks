// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {VRFv2Consumer} from "./utils/VRFv2Consumer.sol";
/*
Raffle is a game where you can win all of the Ether in the contract
if you can submit a transaction at a specific timing.
A player needs to send 10 Ether and wins if the block.timestamp % 15 == 0.
*/

/*
1. Deploy Roulette with 10 Ether
2. Eve runs a powerful miner that can manipulate the block timestamp.
3. Eve sets the block.timestamp to a number in the future that is divisible by
   15 and finds the target block hash.
4. Eve's block is successfully included into the chain, Eve wins the
   Raffle game.
*/

contract Raffle {
    uint256 public pastBlockTime;
    VRFv2Consumer public vrfV2Consumer;
    mapping(address => uint256) public userToRequestId;

    modifier onlyOwner() {
        require(msg.sender == 0xC6ad6C00877a05a0ac1BBD456e31792c6b561F8D, "Not Owner");
        _;
    }
    event winnigstatus(address user, bool ifWon);
    constructor() payable {}

    // function setVRFv2Consumer(address _vrfV2Consumer) internal onlyOwner {
    //     vrfV2Consumer = VRFv2Consumer(_vrfV2Consumer);
    // }

    function setVRFv2Consumer(uint64 _subId) external onlyOwner returns(address){
        vrfV2Consumer = new VRFv2Consumer(_subId);
        return address(vrfV2Consumer);
    }

    function spin() external payable {
        require(msg.value == 0.00001 ether, "Atleast 10 ether are required"); // must send 10 ether to play
        require(block.timestamp != pastBlockTime, "only 1 tx per block"); // only 1 transaction per block
        pastBlockTime = block.timestamp;
        vrfV2Consumer.requestRandomWords();
        uint requestId = vrfV2Consumer.lastRequestId();
        userToRequestId[msg.sender] = requestId;
    }

    function checkIfWon() external returns(bool){
        (bool fulfilled,uint[] memory randomNum) = vrfV2Consumer.getRequestStatus(userToRequestId[msg.sender]);
        require(fulfilled, "Check again after sometime");
        if (randomNum[0] % 15 == 0) {
            (bool sent,) = msg.sender.call{value: 0.000015 ether}("");
            require(sent, "Failed to send Ether");
            emit winnigstatus(msg.sender, true);
            return true;
        }
        emit winnigstatus(msg.sender, false);
        return false;
    }
}
