// SPDX-License-Identifier: MIT
pragma solidity 0.5.7;

import "@openzeppelin/contracts/ownership/Ownable.sol";

contract UserMaster is Ownable {
  struct Locale {
    uint256 feederId;
    uint256 nodeId;
  }

  mapping(address => Locale) public userToLocale;

  function create(
    address _addr,
    uint256 _feederId,
    uint256 _nodeId
  ) external onlyOwner {
    userToLocale[_addr] = Locale(_feederId, _nodeId);
  }
}
