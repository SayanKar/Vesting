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
        require(_users.length == _tokens.length, "UserList and TokenList length not same");
        require(_users.length <= 1000, "UserList limit exceeded");
        require(startTime == 0, "Cannot update tokensPerAddess after Vesting period has started");
        for(uint index = 0; index < _users.length; index++) {
            tokensPerAddress[_users[index]].tokens += _tokens[index] * (10**decimals());
        }
    }

    // Start vesting tokens over six months
    function startVesting() external onlyOwner {
        require(startTime == 0, "Vesting cannot be started more than once");
        startTime = block.timestamp;
    }

    // Releases the tokens for the msg.sender 
    function claimFunds() external {
        require(startTime != 0, "Vesting period not started");
        require(tokensPerAddress[msg.sender].tokens > 0, "Zero tokens assigned");
        require(tokensPerAddress[msg.sender].lastClaimed <= startTime + vestingPeriod, "You have fully claimed your funds");
        
        uint claimAmount;
        
        if(tokensPerAddress[msg.sender].lastClaimed == 0)
            tokensPerAddress[msg.sender].lastClaimed = startTime;

        if( block.timestamp >= startTime + vestingPeriod){
            uint previousClaimedAmount = ((tokensPerAddress[msg.sender].lastClaimed - startTime) * tokensPerAddress[msg.sender].tokens) / vestingPeriod;
            claimAmount = tokensPerAddress[msg.sender].tokens - previousClaimedAmount;
        } else {
            uint rewardTime = block.timestamp - tokensPerAddress[msg.sender].lastClaimed;
            claimAmount = (rewardTime * tokensPerAddress[msg.sender].tokens) / vestingPeriod; 
        }

        tokensPerAddress[msg.sender].lastClaimed = block.timestamp;
        _mint(msg.sender, claimAmount);
    }
}
