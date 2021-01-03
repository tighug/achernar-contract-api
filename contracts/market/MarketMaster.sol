// SPDX-License-Identifier: MIT
pragma solidity 0.5.7;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "./Market.sol";

contract MarketMaster is Ownable {
  Market[] public markets;

  function createMarket(
    address _userMaster,
    address _tokenMaster,
    string calldata _name,
    uint256 _feederId,
    uint256 _period,
    string calldata _oracleUrl
  ) external onlyOwner returns (Market) {
    Market market =
      new Market(
        _userMaster,
        _tokenMaster,
        _name,
        _feederId,
        _period,
        _oracleUrl
      );
    markets.push(market);

    return market;
  }
}
