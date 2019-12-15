pragma solidity ^0.5.0;


contract StateMachine {
    enum Stages {
        RegisteringBidders,
        AcceptingBids,
        AcceptingAuction,
        WaitingAuction,
        Finished
    }

    uint256 private _creationTime = now;
    uint256 private _bidPeriod;
    Stages private _stage = Stages.AcceptingBids;

    modifier atStage(Stages stage) {
        require(_stage == stage, "Function cannot be called at this time.");
        _;
    }

    modifier timedTransitions() {
        if (_stage == Stages.AcceptingBids && now >= _creationTime + _bidPeriod)
            _nextStage();
        _;
    }

    constructor(uint256 bidPeriod) public {
        _bidPeriod = bidPeriod;
    }

    function creationTime() external view returns (uint256) {
        return _creationTime;
    }

    function bidPeriod() external view returns (uint256) {
        return _bidPeriod;
    }

    function stage() external view returns (Stages) {
        return _stage;
    }

    function _nextStage() internal {
        _stage = Stages(uint256(_stage) + 1);
    }
}
