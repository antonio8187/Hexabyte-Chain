// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Wallet {
    address public owner;
    uint256 public fee; // Taxa de saque em partes por 10000 (0.01%)

    constructor() {
        owner = msg.sender;
        fee = 10; // Equivalente a 0.01%
    }

    receive() external payable {}

    function withdraw(address payable to, uint256 amount) public payable {
        require(msg.sender == owner, "Only owner can withdraw");

        uint256 feeAmount = amount * fee / 10000;
        require(address(this).balance >= amount + feeAmount, "Insufficient balance");

        payable(to).transfer(amount);
        owner.transfer(feeAmount);
    }
}
