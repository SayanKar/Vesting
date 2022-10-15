// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Vest is Ownable, ERC20 {
    
    struct addressDetail {
        uint256 tokens;     // Amount of total tokens 
        uint lastClaimed;   // Stores the timestamp when funds were last claimed
    }

    mapping(address => addressDetail) public tokensPerAddress;     // Stores mappings of tokens vested fo each address
    uint public startTime;                                         // Stores the start time when vesting starts 
    uint constant public vestingPeriod = 2 minutes;                // Stores the vesting period duration

    constructor() ERC20("Sayan", "KAR") {}
    
    // Helps update tokens per address
    // The users list length should be less than equal to 1000
    function addTokensForAddresses(address[] calldata _users, uint[] calldata _tokens) external onlyOwner {

    }

    // Start vesting tokens over six months
    // Can be called to start vesting period even if no tokens are assigned to any address
    function startVesting() external onlyOwner {

    }

    // Releases the tokens for the msg.sender 
    function claimFunds() external {

    }
}
