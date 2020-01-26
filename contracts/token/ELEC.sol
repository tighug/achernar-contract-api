pragma solidity 0.5.14;

import "./PenaltyToken.sol";


contract ELEC is PenaltyToken {
    constructor (string memory name)
        public
        PenaltyToken(name, "ELEC", 0)
    {}
}
