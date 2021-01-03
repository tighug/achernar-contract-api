// SPDX-License-Identifier: MIT
pragma solidity 0.5.7;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "./NonTransferableToken.sol";

contract Token is ERC777, NonTransferableToken {
  constructor(string memory name, address[] memory defaultOperators)
    public
    ERC777(name, "W", defaultOperators)
  {}

  /**
   * @dev Similar to operator burn, see `IERC777.operatorBurn`.
   *
   * Emits `Minted` and `Transfer` events.
   */
  function operatorMint(
    address account,
    uint256 amount,
    bytes calldata data,
    bytes calldata operatorData
  ) external {
    require(msg.sender != account, "Error: caller cannot be holder");
    require(
      isOperatorFor(msg.sender, account),
      "ERC777: caller is not an operator for holder"
    );
    _mint(msg.sender, account, amount, data, operatorData);
  }
}
