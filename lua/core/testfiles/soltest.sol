// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @notice Minimal counter with events and access control
contract Counter {
    address public owner;
    uint256 public count;

    event Increment(address indexed who, uint256 newValue);
    event Decrement(address indexed who, uint256 newValue);

    modifier onlyOwner() {
        require(msg.sender == owner, "owner only");
        _;
    }

    constructor() { owner = msg.sender; }

    function increment() external { count += 1; emit Increment(msg.sender, count); }
    function decrement() external onlyOwner {
        require(count > 0, "zero");
        count -= 1;
        emit Decrement(msg.sender, count);
    }
}
