pragma solidity 0.5.13;

import "../node_modules/@openzeppelin/contracts/ownership/Ownable.sol";
import "./CentralizedERC777.sol";

contract ENGToken is CentralizedERC777, Ownable {
    constructor(address[] memory defaultOperators)
        public
        CentralizedERC777("Energy", "ENG", defaultOperators)
    {}

    function mint(address operator, address account, uint256 amount)
        public
        returns (bool)
    {
        _mint(operator, account, amount, "", "");
        return true;
    }
}
