pragma solidity ^0.5.0;


contract MarketStateMachine {
    enum Stages {
        RegisteringBidders, // 0
        AcceptingBids,      // 1
        AcceptingAuction,   // 2
        WaitingAuction,     // 3
        Finished            // 4
    }

    uint256 public creationTime = now;
    uint256 public bidPeriod;
    Stages public stage = Stages.AcceptingBids;

    modifier atStage(Stages _stage) {
        require(stage == stage, "Function cannot be called at this time.");
        _;
    }

    modifier timedTransitions() {
        if (stage == Stages.AcceptingBids && now >= creationTime + bidPeriod)
            _nextStage();
        _;
    }

    constructor(uint256 _bidPeriod) internal {
        bidPeriod = _bidPeriod;
    }

    function _nextStage() internal {
        stage = Stages(uint256(stage) + 1);
    }
}
