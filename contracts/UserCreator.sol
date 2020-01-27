pragma solidity 0.5.14;

import "./UserHelper.sol";


contract UserCreator is UserHelper {
    function createUser(address addr, uint256 nodeId) external onlyOwner {
        UserInfo memory userInfo = UserInfo(0, nodeId);
        _users.push(addr);
        _userToInfo[addr] = userInfo;
    }
}
