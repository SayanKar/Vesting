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

    }

    function startGrant() external onlyOwner {

    }

    function claimFunds() external {

    }
}
