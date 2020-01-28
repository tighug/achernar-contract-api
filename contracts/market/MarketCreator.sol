pragma solidity 0.5.14;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "./Market.sol";


contract MarketCreator is Ownable {
    Market[] private _markets;

    function createMarket(
        address owner,
        string calldata tokenName,
        uint256 bidPeriod
    ) external onlyOwner returns (Market market)
    {
        market = new Market(tokenName, bidPeriod);
        market.transferOwnership(owner);
        _markets.push(market);
    }
}
