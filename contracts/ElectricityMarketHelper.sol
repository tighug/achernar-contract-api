pragma solidity 0.5.14;

import "./provableAPI.sol";
import "./ElectricityMarketModel.sol";


contract ElectricityMarketHelper is usingProvable, ElectricityMarketModel {
  function createBidJson(Bid[] memory bids)
    internal
    returns (string memory)
  {

  }

  function createBidVols(string memory auctionJson)
    internal
    returns (uint[] memory)
  {

  }
}