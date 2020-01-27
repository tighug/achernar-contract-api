pragma solidity 0.5.14;


contract MarketModel {
    enum BidTypes {Buy, Sell}

    struct Bid {
        BidTypes bidType;
        uint256 price;
        uint256 amount;
        uint256 agreedAmount;
    }
}
