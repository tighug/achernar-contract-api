pragma solidity 0.5.14;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "./Market.sol";


contract MarketMaster is Ownable {
    Market[] private _markets;

    function createMarket(
        address owner,
        string calldata name,
        uint256 bidPeriod
    ) external onlyOwner returns (Market market)
    {
        market = new Market(name, bidPeriod);
        market.transferOwnership(owner);
        _markets.push(market);
    }

    function markets() public view returns (Market[] memory) {
        return _markets;
    }
}
