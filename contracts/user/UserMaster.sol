pragma solidity 0.5.14;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "./IUserMaster.sol";


contract UserMaster is Ownable, IUserMaster {
    struct UserInfo {
        uint256 feederId;
        uint256 nodeId;
    }

    mapping(address => UserInfo) private _userToInfo;

    address[] private _users;

    function createUser(address addr, uint256 feederId, uint256 nodeId)
        external
        onlyOwner
    {
        UserInfo memory userInfo = UserInfo(feederId, nodeId);
        _users.push(addr);
        _userToInfo[addr] = userInfo;
    }

    function users() external view returns (address[] memory) {
        return _users;
    }
}
