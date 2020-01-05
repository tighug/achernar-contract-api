pragma solidity 0.5.14;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "./ElectricityMarket.sol";


contract ElectricityMarketCreator is Ownable {
    ElectricityMarket[] private _markets;

    function createMarket(address owner, string calldata tokenName, uint bidPeriod) external onlyOwner returns(ElectricityMarket market) {
        market = new ElectricityMarket(tokenName, bidPeriod);
        market.transferOwnership(owner);
        _markets.push(market);
    }
}
