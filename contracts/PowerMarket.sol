pragma solidity 0.5.13;

import "../node_modules/@openzeppelin/contracts/ownership/Ownable.sol";
import "./provableAPI.sol";

contract PowerMarket is Ownable, usingProvable {
    enum EOrderType {Buy, Sell}
    enum EMarketState {Open, Calc, Close}

    struct Order {
        address user;
        EOrderType orderType;
        uint256 amount;
        uint256 price;
    }

    // 取引手数料の分母と分子。0.10yen/kWh。(Solidityでは少数を扱えない)
    uint256 public constant TX_FEE_NUMERATOR = 1;
    uint256 public constant TX_FEE_DENOMINATOR = 10000;

    EMarketState marketState = EMarketState.Open;
    uint256 public deadline; // 入札の終了時間
    uint256 public counter; // 注文IDの割当用カウンタ
    uint256 public collateral; // コントラクトに保持される担保額
    string public result;
    string public apiurl = "https://green-chicken-82.localtunnel.me/";

    mapping(uint256 => Order) public orders; // 注文IDとOrderのマッピング
    mapping(address => uint256) public ids;
    mapping(uint256 => uint256) public successAmounts; // 注文IDのと約定量のマッピング
    mapping(address => uint256) public shares; // ユーザーのアドレスとユーザーが保持している株数
    mapping(address => uint256) public balances; // ユーザーのアドレスと内部残高（Wei）

    event OrderPlaced(
        uint256 orderId,
        address user,
        EOrderType orderType,
        uint256 amount,
        uint256 price
    );
    event TradeMatched(uint256 orderId, address user, uint256 amount);
    event OrderCanceled(uint256 orderId);
    event Payout(address user, uint256 amount);
    event LogInfo(string message);
    event LogResult(string result);

    constructor() public payable {
        require(msg.value > 0);
        // deadline = now + duration;
        collateral = msg.value;
        // OAR = OraclizeAddrResolverI(0x98d52C3C3959B35496477510920e2C99E6e9cAC0);
    }

    function orderBuy(uint256 price, uint256 amount) public payable {
        require(marketState == EMarketState.Open);
        require(price >= 1);
        require(price <= 19);
        require(msg.value > price * amount);

        counter++;
        ids[msg.sender] = counter;
        orders[counter] = Order(msg.sender, EOrderType.Buy, amount, price);
        emit OrderPlaced(counter, msg.sender, EOrderType.Buy, amount, price);
    }

    function orderSell(uint256 price, uint256 amount) public {
        require(marketState == EMarketState.Open);
        require(price >= 1);
        require(price <= 19);

        counter++;
        ids[msg.sender] = counter;
        orders[counter] = Order(msg.sender, EOrderType.Sell, amount, price);
        emit OrderPlaced(counter, msg.sender, EOrderType.Sell, amount, price);
    }

    /**
     * @dev 約定開始。サーバーにオラクル要求を送る。応答はコールバック関数に返る
     */
    function startContract() public payable onlyOwner {
        require(marketState == EMarketState.Open);

        if (provable_getPrice("URL") > address(this).balance) {
            emit LogInfo("ETH不足でオラクル要求を送れませんでした");
        } else {
            marketState = EMarketState.Calc;
            emit LogInfo("オラクル要求を送りました。応答を待っています...");
            provable_query("URL", apiurl);
        }
    }

    /**
     * @dev オラクル応答が返ってくるコールバック関数
     */
    function __callback(bytes32, string memory _result, bytes memory) public {
        require(msg.sender == provable_cbAddress());

        if (marketState == EMarketState.Open) {
            result = _result; // TODO: 複数のデータ情報を持つStringが返ってくるので、splitする
            emit LogResult(result);
            marketState = EMarketState.Close;
        } else if (marketState == EMarketState.Close) {
            // withdraw();
        }
    }

}
