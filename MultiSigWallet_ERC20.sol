// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MultiSigWallet_ERC20 {
    address[] public owners;
    uint256 public required;
    mapping(address => uint256) public confirmed;

    mapping(address => uint256) public balances;
    mapping(address => bool) public tokens;
    uint256 public fee;

    event Deposit(address indexed from, address indexed token, uint256 amount);
    event Withdraw(address indexed to, address indexed token, uint256 amount);
    event AddOwner(address owner);
    event RemoveOwner(address owner);
    event ReplaceOwner(address oldOwner, address newOwner);
    event RequireSignaturesChanged(uint256 required);
    event AddToken(address token);
    event RemoveToken(address token);
    event FeeChanged(uint256 fee);

    constructor(address[] memory _owners, uint256 _required) {
        owners = _owners;
        required = _required;
    }

    receive() external payable {
        emit Deposit(msg.sender, address(0), msg.value);
    }

    function deposit(address token, uint256 amount) public {
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        balances[token] += amount;
        emit Deposit(msg.sender, token, amount);
    }

    function withdraw(address to, address token, uint256 amount) public {
        require(confirmed[msg.sender] == 0, "You have already confirmed this transaction");
        confirmed[msg.sender] = 1;
        require(confirmed[token] + 1 >= required, "Signatures not enough");

        uint256 balance = balances[token];
        require(balance >= amount, "Insufficient balance");

        uint256 feeAmount = amount * fee / 10000;
        balances[token] -= amount + feeAmount;
        IERC20(token).transfer(to, amount);

        delete confirmed[token];
        emit Withdraw(to, token, amount);
    }

    // ... outras funções para adicionar/remover signatários, tokens, e alterar a taxa ...
}
