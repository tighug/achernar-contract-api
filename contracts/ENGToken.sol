pragma solidity 0.5.13;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20Mintable.sol";
import "./CentralizedERC777.sol";

contract ENGToken is CentralizedERC777, ERC20Mintable {
    constructor(address[] memory defaultOperators)
        public
        CentralizedERC777("Energy", "ENG", defaultOperators)
    {}
}
