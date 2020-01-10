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
        string memory strBids;

        for (uint256 i = 0; i < bids.length; i++) {
            Bid memory bid = bids[i];
            string memory strBidType;

            if (bid.bidType == BidTypes.Buy) {
                strBidType = "b";
            } else {
                strBidType = "s";
            }

            string memory strIndex = uint2str(i);
            string memory strPrice = uint2str(bid.price);
            string memory strAmount = uint2str(bid.amount);
            string memory strNodeNum = uint2str(bid.nodeNum);
            string memory concatedIndex = strConcat("{ index: ", strIndex, ",");
            string memory concatedBidType = strConcat("bidType: ", strBidType, ",");
            string memory concatedPrice = strConcat("price: ", strPrice, ",");
            string memory concatedAmount = strConcat("amount: ", strAmount, ",");
            string memory concatedNodeNum = strConcat("nodeNum: ", strNodeNum, "}");
            string memory concated = strConcat(
                concatedIndex,
                concatedBidType,
                concatedPrice,
                concatedAmount,
                concatedNodeNum
            );

            strBids = strConcat(strBids, concated);

            if (i != bids.length - 1) {
                strBids = strConcat(strBids, ",");
            }
        }

        return strConcat("{ bids: [", strBids, "] }");
    }

    function createBidAmmounts(string memory auctionJson)
        internal
        returns (uint[] memory)
    { }
}