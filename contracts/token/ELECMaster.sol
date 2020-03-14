pragma solidity 0.5.14;

import "./IELECMaster.sol";
import "./ELEC.sol";


contract ELECMaster is IELECMaster {
    ELEC[] public tokens;

    function createELEC(string memory name) public returns (ELEC) {
        ELEC token = new ELEC(name);

        // tokens.push(token);

        return token;
    }
}
