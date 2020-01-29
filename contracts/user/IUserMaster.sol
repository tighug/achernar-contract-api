pragma solidity 0.5.14;

interface IUserMaster {
    function createUser(address addr, uint256 feederId, uint256 nodeId) external;
    function withdraw() external;
    function users() external view returns (address[] memory);
    function userInfo(address user) external view returns (uint256, uint256, uint256);
}