pragma solidity 0.5.14;

import "./ELEC.sol";


interface IELECMaster {
  function createELEC(string calldata name) external returns(ELEC);
}