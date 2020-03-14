pragma solidity 0.5.14;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/PenaltyToken.sol";

contract TestPenaltyToken {
    function testInitialBalance() public {
        PenaltyToken token = PenaltyToken(DeployedAddresses.PenaltyToken());

        uint256 expected = 10000;

        Assert.equal(
            token.balanceOf(tx.origin),
            expected,
            "Owner should have"
        );
    }
}
