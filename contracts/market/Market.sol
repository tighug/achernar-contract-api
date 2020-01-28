pragma solidity 0.5.14;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "../token/ELEC.sol";
import "./MarketStateMachine.sol";
import "./MarketHelper.sol";


contract Market is MarketHelper, Ownable, MarketStateMachine {
    string public constant PROVABLE_API = "http://localhost:3001";

    mapping(address => Bid) private _accountToBid;
    mapping(address => uint256) _balances;

    ELEC token;
    Bid[] private _bids;

    modifier onlyBuyer(address account) {
        require(
            _accountToBid[account].nodeNum == 0,
            "You're NOT registered as a bidder."
        );
        require(
            _accountToBid[account].bidType == BidTypes.Buy,
            "You're NOT a buyer."
        );
        _;
    }

    modifier onlySeller(address account) {
        require(
            _accountToBid[account].nodeNum == 0,
            "You're NOT registered as a bidder."
        );
        require(
            _accountToBid[account].bidType == BidTypes.Sell,
            "You're NOT a seller."
        );
        _;
    }

    constructor(
        string memory name,
        uint256 bidPeriod,
        address _userContract,
        string memory auctionApi
    ) public payable MarketStateMachine(bidPeriod) {
        token = new ELEC(name);
    }

    function registerBuyer(address buyer, uint256 nodeNum)
        external
        onlyOwner
        atStage(Stages.RegisteringBidders)
    {
        Bid memory bid = Bid(BidTypes.Buy, 0, 0, nodeNum, false);
        _bids.push(bid);
        _accountToBid[buyer] = bid;
    }

    function registerSeller(address seller, uint256 nodeNum, uint256 surplus)
        external
        onlyOwner
        atStage(Stages.RegisteringBidders)
    {
        Bid memory bid = Bid(BidTypes.Sell, 0, surplus, nodeNum, false);
        _bids.push(bid);
        _accountToBid[seller] = bid;
        token.mint(seller, surplus);
    }

    function openMarket()
        external
        onlyOwner
        timedTransitions()
        atStage(Stages.RegisteringBidders)
    {
        _nextStage();
    }

    function bidBuy(uint256 price, uint256 amount)
        external
        payable
        onlyBuyer(msg.sender)
        timedTransitions()
        atStage(Stages.AcceptingBids)
    {
        require(!_accountToBid[msg.sender].didBid, "You already bidded.");

        _accountToBid[msg.sender].price = price;
        _accountToBid[msg.sender].amount = amount;
        _accountToBid[msg.sender].didBid = true;
    }

    function bidSell(uint256 _price)
        external
        onlySeller(msg.sender)
        timedTransitions()
        atStage(Stages.AcceptingBids)
    {
        require(!_accountToBid[msg.sender].didBid, "You already bidded.");

        _accountToBid[msg.sender].price = _price;
        _accountToBid[msg.sender].didBid = true;
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

    // function __callback(bytes32 myid, string memory result) external {
    //     if (msg.sender != provable_cbAddress()) revert();

    // }

    function bidsLength() external view onlyOwner returns (uint256) {
        return _bids.length;
    }

    function bidByIndex(uint256 index)
        external
        view
        onlyOwner
        returns (BidTypes, uint256, uint256, uint256, bool)
    {
        require(
            _bids[index].nodeNum != 0,
            "This index is NOT registered as a bidder."
        );

        Bid memory bid = _bids[index];

        return _bidInfo(bid);
    }

    function bidByAccount(address account)
        external
        view
        onlyOwner
        returns (BidTypes, uint256, uint256, uint256, bool)
    {
        require(
            _accountToBid[account].nodeNum != 0,
            "This account is NOT registered as a bidder."
        );

        Bid memory bid = _accountToBid[account];

        return _bidInfo(bid);
    }

    function myBid()
        external
        view
        returns (BidTypes, uint256, uint256, uint256, bool)
    {
        require(
            _accountToBid[msg.sender].nodeNum != 0,
            "You're NOT registered as a bidder."
        );

        Bid memory bid = _accountToBid[msg.sender];

        return _bidInfo(bid);
    }

    function _bidInfo(Bid memory bid)
        private
        pure
        returns (BidTypes, uint256, uint256, uint256, bool)
    {
        return (bid.bidType, bid.price, bid.amount, bid.nodeNum, bid.didBid);
    }

    event LogInfo(string description);
}
