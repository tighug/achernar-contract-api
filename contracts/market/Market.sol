// SPDX-License-Identifier: MIT
pragma solidity 0.5.7;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "../user/UserMaster.sol";
import "../token/TokenMaster.sol";
import "../token/Token.sol";
import "./MarketStateMachine.sol";

contract Market is MarketStateMachine, Ownable {
  enum BidTypes {Buy, Sell}

  struct Bid {
    BidTypes bidType;
    uint256 price;
    uint256 amount;
    uint256 agreedAmount;
  }

  mapping(address => BidTypes) private userToBidTypes;
  mapping(address => Bid) private userToBid;
  mapping(address => bool) private userToDidBid;
  mapping(address => uint256) private userToPending;
  mapping(address => uint256) private userToBalance;

  TokenMaster public tokenMaster;
  UserMaster public userMaster;
  Token public token;
  Bid[] private bids;

  string public oracleUrl;
  string public name;
  uint256 public feederId;

  modifier onlyBuyer(address user) {
    (uint256 userFeederId, ) = userMaster.userToLocale(user);

    require(userFeederId == feederId, "You're not registered as a user.");
    require(userToBidTypes[user] == BidTypes.Buy, "You're not a buyer.");
    _;
  }

  modifier onlySeller(address user) {
    (uint256 userFeederId, ) = userMaster.userToLocale(user);

    require(userFeederId == feederId, "You're not registered as a user.");
    require(userToBidTypes[user] == BidTypes.Sell, "You're not a seller.");
    _;
  }

  constructor(
    address _userMaster,
    address _tokenMaster,
    string memory _name,
    uint256 _feederId,
    uint256 _bidPeriod,
    string memory _oracleUrl
  ) public payable MarketStateMachine(_bidPeriod) {
    userMaster = UserMaster(_userMaster);
    tokenMaster = TokenMaster(_tokenMaster);
    token = tokenMaster.create(_name);
    feederId = _feederId;
    oracleUrl = _oracleUrl;
  }

  function registerBuyer(address _user)
    external
    atStage(Stages.RegisteringBidders)
    onlyOwner
  {
    userToBidTypes[_user] = BidTypes.Buy;
  }

  function registerSeller(address _user, uint256 _surplus)
    external
    atStage(Stages.RegisteringBidders)
    onlyOwner
  {
    userToBidTypes[_user] = BidTypes.Sell;
    token.operatorMint(_user, _surplus, "", "");
  }

  function openMarket() external atStage(Stages.RegisteringBidders) onlyOwner {
    _nextStage();
  }

  function bidToBuy(uint256 _price, uint256 _amount)
    external
    payable
    timedTransitions()
    atStage(Stages.AcceptingBids)
    onlyBuyer(msg.sender)
  {
    require(!userToDidBid[msg.sender], "You already bidded.");
    require(msg.value >= _price * _amount, "You need to pay in advance.");

    Bid memory bid = Bid(BidTypes.Buy, _price, _amount, 0);
    bids.push(bid);
    userToBid[msg.sender] = bid;
    userToDidBid[msg.sender] = true;
    userToPending[msg.sender] = msg.value;
  }

  function bidToSell(uint256 _price)
    external
    timedTransitions()
    atStage(Stages.AcceptingBids)
    onlySeller(msg.sender)
  {
    require(!userToDidBid[msg.sender], "You already bidded.");

    Bid memory bid = Bid(BidTypes.Buy, _price, token.balanceOf(msg.sender), 0);
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
