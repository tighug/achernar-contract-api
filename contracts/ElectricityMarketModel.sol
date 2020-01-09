pragma solidity 0.5.14;

contract ElectricityMarketModel {
  enum BidTypes {Buy, Sell}

  struct Bid {
      BidTypes bidType;
      uint256 price;
      uint256 amount;
      uint256 nodeNum;
      bool didBid;
  }
}