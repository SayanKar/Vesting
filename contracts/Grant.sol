// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Grant is Ownable, ERC20 {
    
    struct addressDetail {
        uint256 tokens;
        uint256 lastClaimed;
    }

    mapping(address => addressDetail) public tokensPerAddress;
    uint256 public startTime;
    uint256 constant public grantingPeriod = 2 minutes;

    constructor() ERC20("Raj", "YOY") {}

    function addTokensForAddresses(address[] calldata _users, uint256[] calldata _tokens) external onlyOwner {
        require(_users.length == _tokens.length, "UserList and TokenList length not same");
        require(_users.length <= 1000, "UserList limit exceeded");
        require(startTime == 0, "Cannot update tokensPerAddess after Vesting period has started");
        for(uint index = 0; index < _users.length; index++) {
            tokensPerAddress[_users[index]].tokens += _tokens[index] * (10**decimals());
        }
    }

    function startGrant() external onlyOwner {
        require(startTime == 0, "Vesting cannot be started more than once");
        startTime = block.timestamp;
    }

    function claimFunds() external {

    }
}
