pragma solidity ^0.5.0;

import "@openzeppelin/contracts/access/roles/MinterRole.sol";
import "./CentralizedERC777.sol";


contract ENGToken is CentralizedERC777, MinterRole {
    constructor(address[] memory defaultOperators)
        public
        CentralizedERC777("Energy", "ENG", defaultOperators)
    {}

    function mint(address _operator, address _account, uint256 _amount)
        public
        onlyMinter
        returns (bool)
    {
        _mint(_operator, _account, _amount, "", "");
        return true;
    }
}
