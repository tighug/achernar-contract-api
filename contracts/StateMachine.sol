pragma solidity ^0.5.0;

contract StateMachine {
    enum Stages {
        RegisteringBidders,
        AcceptingBids,
        AcceptingAuction,
        WaitingAuction,
        Finished
    }

    Stages public stage = Stages.AcceptingBids;

    uint256 public creationTime = now;
    uint256 public bidPeriod;

    modifier atStage(Stages _stage) {
        require(stage == _stage, "Function cannot be called at this time.");
        _;
    }

    modifier timedTransitions() {
        if (stage == Stages.AcceptingBids && now >= creationTime + bidPeriod)
            _nextStage();
        _;
    }

    constructor(uint256 _bidPeriod) public {
        bidPeriod = _bidPeriod;
    }

    function _nextStage() internal {
        stage = Stages(uint256(stage) + 1);
    }
}
