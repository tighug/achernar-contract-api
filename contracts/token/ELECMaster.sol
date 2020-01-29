pragma solidity 0.5.14;

import "./IELECMaster.sol";
import "./ELEC.sol";


contract ELECMaster is IELECMaster {
    ELEC[] tokens;

    function createELEC(string calldata name) external returns (ELEC) {
        ELEC token = new ELEC(name);

        tokens.push(token);

        return token;
    }
}
