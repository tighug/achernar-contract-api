pragma solidity 0.5.14;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "./provableAPI.sol";
import "./ELEC.sol";
import "./MarketStateMachine.sol";


contract ElectricityMarket is Ownable, usingProvable, StateMachine {
    enum BidTypes {Buy, Sell}

    struct Bid {
        BidTypes bidType;
        uint256 price;
        uint256 amount;
        uint256 nodeNum;
        bool didBid;
    }

    mapping(address => Bid) private bidderToBid;

    string constant PROVABLE_API = "aaa";
    string private _name;
    ELEC private _token;
    Bid[] private _bids;

    modifier onlyBuyer(address account) {
        require(
            bidderToBid[account].bidType == BidTypes.Buy,
            "You doesn't have buyer role."
        );
        _;
    }

    modifier onlySeller(address account) {
        require(
            bidderToBid[account].bidType == BidTypes.Sell,
            "You doesn't have seller role."
        );
        _;
    }

    event LogInfo(string message);

    constructor(string memory name, uint bidPeriod)
        public
        payable
        StateMachine(bidPeriod)
    {
        _token = new ELEC(name);
        _name = name;
    }

    function registerBuyer(address buyer, uint256 nodeNum)
        external
        onlyOwner
        atStage(Stages.RegisteringBidders)
    {
        Bid memory bid = Bid(BidTypes.Buy, 0, 0, nodeNum, false);
        _bids.push(bid);
        bidderToBid[buyer] = bid;
    }

    function registerSeller(address seller, uint256 nodeNum, uint256 surplus)
        external
        onlyOwner
        atStage(Stages.RegisteringBidders)
    {
        Bid memory bid = Bid(BidTypes.Sell, 0, 0, nodeNum, false);
        _bids.push(bid);
        bidderToBid[seller] = bid;
        _token.mint(seller, surplus);
    }

    function openMarket()
        external
        onlyOwner
        timedTransitions()
        atStage(Stages.RegisteringBidders)
    {
        _nextStage();
    }

    function bidBuy(uint256 _price, uint256 _amount)
        external
        onlyBuyer(msg.sender)
        timedTransitions()
        atStage(Stages.AcceptingBids)
    {
        require(!bidderToBid[msg.sender].didBid, "You already bidded.");

        bidderToBid[msg.sender].price = _price;
        bidderToBid[msg.sender].amount = _amount;
        bidderToBid[msg.sender].didBid = true;
    }

    function bidSell(uint256 _price)
        external
        onlySeller(msg.sender)
        timedTransitions()
        atStage(Stages.AcceptingBids)
    {
        require(!bidderToBid[msg.sender].didBid, "You already bidded.");

        bidderToBid[msg.sender].price = _price;
        bidderToBid[msg.sender].amount = _token.balanceOf(msg.sender);
        bidderToBid[msg.sender].didBid = true;
    }

    function beginAuction()
        external
        onlyOwner
        timedTransitions()
        atStage(Stages.AcceptingAuction)
    {
        if (provable_getPrice("URL") > address(this).balance) {
            emit LogInfo(
                "Provable query was NOT sent, please add some ETH to cover for the query fee"
            );
        } else {
            emit LogInfo(
                "Provable query was sent, standing by for the answer.."
            );
            provable_query("URL", PROVABLE_API);
        }
        _nextStage();
    }

    // function __callback(bytes32 myid, string memory result) public {
    //     if (msg.sender != provable_cbAddress()) revert();
    // }

    function provableApi() external pure returns (string memory) {
        return PROVABLE_API;
    }

    function bids() external view returns (Bid[] memory) {
        return _bids;
    }
}
