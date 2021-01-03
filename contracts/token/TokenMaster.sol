// SPDX-License-Identifier: MIT
pragma solidity 0.5.7;

import "./Token.sol";

contract TokenMaster {
  Token[] public tokens;
  address[] private operators;

  function create(string memory name) public returns (Token) {
    operators.push(msg.sender);
    Token token = new Token(name, operators);

    tokens.push(token);

    return token;
  }
}
