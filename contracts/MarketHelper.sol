pragma solidity 0.5.14;

import "./vendor/provableAPI.sol";
import "./MarketModel.sol";


contract MarketHelper is usingProvable, MarketModel {
    function createBidAmmounts(string memory auctionJson)
        internal
        returns (uint256[] memory)
    {}
}
