pragma solidity 0.5.14;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "./Market.sol";


contract MarketMaster is Ownable {
    Market[] public markets;

    function createMarket(
        address _owner,
        address _userMaster,
        address _elecMaster,
        string calldata _name,
        uint256 _feederId,
        uint256 _bidPeriod,
        string calldata _auctionApi
    )
        external onlyOwner returns (Market)
    {
        Market market = new Market(
            _userMaster,
            _elecMaster,
            _name,
            _feederId,
            _bidPeriod,
            _auctionApi
        );
        // market.transferOwnership(_owner);
        // markets.push(market);

        return market;
    }
}
