pragma solidity 0.5.14;

import "./vendor/provableAPI.sol";
// import "./vendor/strings.sol";
import "./ElectricityMarketModel.sol";


contract ElectricityMarketHelper is usingProvable, ElectricityMarketModel {
    // using strings for *;

    function createBidAmmounts(string memory auctionJson)
        internal
        returns (uint[] memory)
    { }
}