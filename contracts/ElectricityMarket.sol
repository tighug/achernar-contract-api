pragma solidity ^0.5.0;

import "../node_modules/@openzeppelin/contracts/ownership/Ownable.sol";
import "./JsmnSolLib.sol";
import "./provableAPI.sol";
import "./ENGToken.sol";
import "./StateMachine.sol";

contract ElectricityMarket is Ownable, usingProvable, StateMachine {
    enum BidTypes {Buy, Sell}

    struct Bid {
        BidTypes bidType;
        uint256 price;
        uint256 amount;
        uint256 _nodeNum;
        bool didBid;
    }

    string constant PROVABLE_API = "";
    ENGToken private token;
    Bid[] private bids;
    mapping(address => Bid) private bidderToBid;

    modifier onlyBuyer(address account) {
        require(
            bidderToBid[account].bidType == BidTypes.Buy,
            "You doesn't have _buyer role."
        );
        _;
    }

    modifier onlySeller(address account) {
        require(
            bidderToBid[account].bidType == BidTypes.Sell,
            "You doesn't have _seller role."
        );
        _;
    }

    event LogInfo(string message);

    constructor(address _ENGTokenAddress, uint256 biddingTime)
        public
        payable
        StateMachine(biddingTime)
    {
        token = ENGToken(_ENGTokenAddress);
    }

    function registerBuyer(address _buyer, uint256 _nodeNum)
        public
        timedTransitions()
        atStage(Stages.RegisteringBidders)
        onlyOwner()
    {
        Bid memory bid = Bid(BidTypes.Buy, 0, 0, _nodeNum, false);
        bids.push(bid);
        bidderToBid[_buyer] = bid;
    }

    function registerSeller(address _seller, uint256 _nodeNum, uint256 _surplus)
        public
        timedTransitions()
        atStage(Stages.RegisteringBidders)
        onlyOwner()
    {
        Bid memory bid = Bid(BidTypes.Sell, 0, 0, _nodeNum, false);
        bids.push(bid);
        bidderToBid[_seller] = bid;
        token.mint(msg.sender, _seller, _surplus);
    }

    function openMarket()
        public
        timedTransitions()
        atStage(Stages.RegisteringBidders)
        onlyOwner()
    {
        _nextStage();
    }

    function bidBuy(uint256 _price, uint256 _amount)
        public
        timedTransitions()
        atStage(Stages.AcceptingBids)
        onlyBuyer(msg.sender)
    {
        require(!bidderToBid[msg.sender].didBid, "You already bidded.");

        bidderToBid[msg.sender].price = _price;
        bidderToBid[msg.sender].amount = _amount;
        bidderToBid[msg.sender].didBid = true;
    }

    function bidSell(uint256 _price)
        public
        timedTransitions()
        atStage(Stages.AcceptingBids)
        onlySeller(msg.sender)
    {
        require(!bidderToBid[msg.sender].didBid, "You already bidded.");

        bidderToBid[msg.sender].price = _price;
        bidderToBid[msg.sender].amount = token.balanceOf(msg.sender);
        bidderToBid[msg.sender].didBid = true;
    }

    function beginAuction()
        public
        timedTransitions()
        atStage(Stages.AcceptingAuction)
        onlyOwner()
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

}
