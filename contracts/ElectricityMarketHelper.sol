pragma solidity 0.5.14;

import "./provableAPI.sol";
import "./strings.sol";
import "./ElectricityMarketModel.sol";


contract ElectricityMarketHelper is usingProvable, ElectricityMarketModel {
  using strings for *;

  function createBidJson(Bid[] memory bids)
    internal
    pure
    returns (string memory)
  {
    string memory s_bids;

    for(uint256 i = 0; i < bids.length; i++) {
      Bid memory bid = bids[i];
      string memory s_bidType;
      if(bid.bidType == BidTypes.Buy) {
        s_bidType = "b";
      }else {
        s_bidType = "s";
      }
      
      string memory s_index = uint2str(i);
      string memory s_price = uint2str(bid.price);
      string memory s_amount = uint2str(bid.amount);
      string memory s_nodeNum = uint2str(bid.nodeNum);
      string memory concatedIndex = strConcat("{ index: ", s_index, ",");
      string memory concatedBidType = strConcat("bidType: ", s_bidType, ",");
      string memory concatedPrice = strConcat("price: ", s_price, ",");
      string memory concatedAmount = strConcat("amount: ", s_amount, ",");
      string memory concatedNodeNum = strConcat("nodeNum: ", s_nodeNum, "}");
      string memory concated = strConcat(
        concatedIndex,
        concatedBidType,
        concatedPrice,
        concatedAmount,
        concatedNodeNum
      );

      s_bids = strConcat(s_bids, concated);

      if(i != bids.length - 1) {
        s_bids = strConcat(s_bids, ",");
      }
    }

    return strConcat("{ bids: [", s_bids, "] }");
  }

  function createBidAmmounts(string memory auctionJson)
    internal
    returns (uint[] memory)
  {

  }
}