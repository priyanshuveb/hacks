// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Lottery {

    error NotOwner();

    address[] public participants;
    uint256 public amountToParticipate;
    bool hasEnded;
    address public winner;
    address immutable public owner; 

    modifier onlyOwner() {
        if(msg.sender != owner){
            revert NotOwner();
        }
        _;
    }

    constructor(uint256 _amount) {
        amountToParticipate = _amount;
        owner = msg.sender;
    }

    /// @notice Check for minimum amount to participate
    /// @notice Check for duplicate users
    /// @notice unbound for-loop which will increasingly make the gas fee high enough for a DoS attack 
    function enterLottery() external payable {
        require(msg.value == amountToParticipate, "Not enought funds to participate");
        for(uint256 i=0; i<participants.length;i++) {
            if(msg.sender == participants[i]) {
                revert("One address can only participate once");
            }
        }
        participants.push(msg.sender);
    }

    function declareResult(address _winner) external onlyOwner {
        winner = _winner;
        hasEnded = true;

    }

    function claimWinAmount() external {
        require(hasEnded,"The lottery has not ended yet");
        require(msg.sender == winner, "Not the winner");
        payable(msg.sender).transfer(address(this).balance);
    }

}