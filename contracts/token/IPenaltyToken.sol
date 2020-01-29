pragma solidity 0.5.14;

interface IPenaltyToken {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount)
        external
        returns (bool);
    function mint(address account, uint256 amount) external returns (bool);
    function burnFrom(address account, uint256 amount) external;

    event Transfer(address indexed from, address indexed to, uint256 value);
}
