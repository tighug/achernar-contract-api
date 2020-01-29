pragma solidity 0.5.14;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "../user/IUserMaster.sol";
import "../token/IELECMaster.sol";
import "../token/ELEC.sol";
import "./MarketStateMachine.sol";
import "./MarketHelper.sol";


contract Market is MarketHelper, Ownable, MarketStateMachine {
    string public auctionApi;

    IUserMaster userMaster;
    IELECMaster elecMaster;
    ELEC token;
    Bid[] private bids;

    string name;
    uint256 feederId;
    uint256 baseAgreedPrice;

    mapping(address => BidTypes) userToBidTypes;
    mapping(address => Bid) userToBid;
    mapping(address => bool) userToDidBid;
    mapping(address => uint256) userToPending;
    mapping(address => uint256) userToBalance;

    modifier onlyBuyer(address user) {
        (, uint256 userFeederId, ) = userMaster.userInfo(user);

        require(userFeederId == feederId, "You're NOT registered as a user.");
        require(userToBidTypes[user] == BidTypes.Buy, "You're NOT a buyer.");
        _;
    }

    modifier onlySeller(address user) {
        (, uint256 userFeederId, ) = userMaster.userInfo(user);

        require(userFeederId == feederId, "You're NOT registered as a user.");
        require(userToBidTypes[user] == BidTypes.Sell, "You're NOT a seller.");
        _;
    }

    constructor(
        address _userMaster,
        address _elecMaster,
        string memory _name,
        uint256 _feederId,
        uint256 _bidPeriod,
        string memory _auctionApi
    ) public payable MarketStateMachine(_bidPeriod) {
        userMaster = IUserMaster(_userMaster);
        elecMaster = IELECMaster(_elecMaster);

        elecMaster.createELEC(_name);
        feederId = _feederId;
        auctionApi = _auctionApi;
    }

    function registerBuyer(address user)
        external
        onlyOwner
        atStage(Stages.RegisteringBidders)
    {
        userToBidTypes[user] = BidTypes.Buy;
    }

    function registerSeller(address user, uint256 surplus)
        external
        onlyOwner
        atStage(Stages.RegisteringBidders)
    {
        userToBidTypes[user] = BidTypes.Sell;
        token.mint(user, surplus);
    }

    function openMarket()
        external
        onlyOwner
        atStage(Stages.RegisteringBidders)
    {
        _nextStage();
    }

    function bidBuy(uint256 _price, uint256 _amount)
        external
        payable
        onlyBuyer(msg.sender)
        timedTransitions()
        atStage(Stages.AcceptingBids)
    {
        require(!userToDidBid[msg.sender], "You already bidded.");
        require(msg.value >= _price * _amount, "You need to pay in advance.");

        Bid memory bid = Bid(BidTypes.Buy, _price, _amount, 0);
        bids.push(bid);
        userToBid[msg.sender] = bid;
        userToDidBid[msg.sender] = true;

        userToPending[msg.sender] = msg.value;
    }

    function bidSell(uint256 _price)
        external
        onlySeller(msg.sender)
        timedTransitions()
        atStage(Stages.AcceptingBids)
    {
        require(!userToDidBid[msg.sender], "You already bidded.");

        Bid memory bid = Bid(
            BidTypes.Buy,
            _price,
            token.balanceOf(msg.sender),
            0
        );
        bids.push(bid);
        userToBid[msg.sender] = bid;
        userToDidBid[msg.sender] = true;
    }

    // function beginAuction()
    //     external
    //     onlyOwner
    //     timedTransitions()
    //     atStage(Stages.AcceptingAuction)
    // {
    //     if (provable_getPrice("URL") > address(this).balance) {
    //         emit LogInfo(
    //             "Provable query was NOT sent, please add some ETH to cover for the query fee"
    //         );
    //     } else {
    //         emit LogInfo(
    //             "Provable query was sent, standing by for the answer.."
    //         );
    //         provable_query("URL", PROVABLE_API);
    //     }
    //     _nextStage();
    // }

    // function __callback(bytes32 myid, string memory result) external {
    //     if (msg.sender != provable_cbAddress()) revert();

    // }

    function withdraw() external {
        require(userToBalance[msg.sender] > 0, "You have no balace.");

        uint256 amount = userToBalance[msg.sender];
        userToBalance[msg.sender] = 0;

        msg.sender.transfer(amount);
    }
}
