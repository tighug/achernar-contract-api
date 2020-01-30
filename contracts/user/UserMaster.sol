pragma solidity 0.5.14;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "./IUserMaster.sol";


contract UserMaster is Ownable, IUserMaster {
    struct UserInfo {
        uint256 feederId;
        uint256 nodeId;
    }

    mapping(address => UserInfo) private userToInfo;

    address[] users;

    function createUser(address addr, uint256 feederId, uint256 nodeId)
        external
        onlyOwner
    {
        UserInfo memory userInfo = UserInfo(feederId, nodeId);
        users.push(addr);
        userToInfo[addr] = userInfo;
    }

    function userInfo(address user)
        external
        view
        returns (uint256, uint256)
    {
        return (userToInfo[user].feederId, userToInfo[user].nodeId);
    }
}
