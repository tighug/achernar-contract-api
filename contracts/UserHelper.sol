pragma solidity 0.5.14;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "./UserModel.sol";


contract UserHelper is Ownable, UserModel {
    mapping(address => UserInfo) internal _userToInfo;

    address[] internal _users;

    function withdraw() external {
        require(_userToInfo[msg.sender].balance > 0, "You have no balace.");

        uint256 amount = _userToInfo[msg.sender].balance;
        _userToInfo[msg.sender].balance = 0;

        msg.sender.transfer(amount);
    }

    function users() external view onlyOwner returns (address[] memory) {
        return _users;
    }

    function userInfo(address user)
        external
        view
        onlyOwner
        returns (uint256, uint256)
    {
        return (_userToInfo[user].balance, _userToInfo[user].nodeId);
    }
}
