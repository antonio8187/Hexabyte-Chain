// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "./IERC20.sol"; // Importe o interface ERC-20

contract Wallet {
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowances;

    // Adicione um array para armazenar os endereços dos tokens suportados
    address[] public supportedTokens;

    function deposit(address token, uint amount) public {
        require(contains(supportedTokens, token), "Token not supported");
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        // ... lógica para atualizar o balance do usuário
    }

    // Outras funções...

    function contains(address[] memory arr, address element) private pure returns (bool) {
        for (uint i = 0; i < arr.length; i++) {
            if (arr[i] == element) {
                return true;
            }
        }
        return false;
    }
}
