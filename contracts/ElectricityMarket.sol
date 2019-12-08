pragma solidity 0.5.13;

import "./JsmnSolLib.sol";
import "node_modules/@openzeppelin/contracts/ownership/Ownable.sol";
import "./provableAPI.sol";
import "./ENGToken.sol";
import "./StateMachine.sol";

contract ElectricityMarket is Ownable, usingProvable, StateMachine, JsmnSolLib {
    enum EBidType {Buy, Sell}

    struct Bid {
        EBidType bidType;
        uint256 price;
        uint256 amount;
        uint256 nodeNum;
        bool didBid;
    }

    string constant PROVABLE_API = "";
    ENGToken private token;
    Bid[] private bids;
    mapping(uint256 => address) private idToBidder;
    mapping(address => Bid) private bidderToBid;

    modifier onlyBuyer(address account) {
        require(
            bidderToBid[account].bidType == EBidType.Buy,
            "You doesn't have buyer role."
        );
        _;
    }

    modifier onlySeller(address account) {
        require(
            bidderToBid[account].bidType == EBidType.Sell,
            "You doesn't have seller role."
        );
        _;
    }

    event LogInfo(string message);

    constructor(
        address[] memory buyers,
        address[] memory sellers,
        uint256[] memory surplusEnergies,
        uint256[] memory buyersNodeNums,
        uint256[] memory sellerNodeNums,
        address ENGTokenAddress
    ) public {
        require(
            sellers.length == surplusEnergies.length,
            "Sellers length need to be same to surplusEnergies.length."
        );

        token = ENGToken(ENGTokenAddress);

        for (uint256 i = 0; i < buyers.length; i++) {
            Bid memory bid = Bid(EBidType.Buy, 0, 0, buyersNodeNums[i], false);
            uint256 id = bids.push(bid) - 1;
            idToBidder[id] = buyers[i];
            bidderToBid[buyers[i]] = bid;
        }

        for (uint256 i = 0; i < sellers.length; i++) {
            Bid memory bid = Bid(EBidType.Sell, 0, 0, sellerNodeNums[i], false);
            uint256 id = bids.push(bid) - 1;
            idToBidder[id] = sellers[i];
            bidderToBid[sellers[i]] = bid;
            token.mint(sellers[i], surplusEnergies[i]);
        }
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
        onlyOwner
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

    function __callback(bytes32 myid, string result) {
        if (msg.sender != provable_cbAddress()) revert();

        parse(result);
    }

}
