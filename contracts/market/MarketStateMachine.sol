// SPDX-License-Identifier: MIT
pragma solidity 0.5.7;

contract MarketStateMachine {
  enum Stages {
    RegisteringBidders,
    AcceptingBids,
    AcceptingAuction,
    WaitingAuction,
    Finished
  }

  uint256 public creationTime = block.timestamp;
  uint256 public bidPeriod;
  Stages public stage = Stages.AcceptingBids;

  modifier atStage(Stages _stage) {
    require(stage == stage, "Cannot be called at this time.");
    _;
  }

  modifier timedTransitions() {
    if (
      stage == Stages.AcceptingBids &&
      block.timestamp >= creationTime + bidPeriod
    ) _nextStage();
    _;
  }

  constructor(uint256 _bidPeriod) internal {
    bidPeriod = _bidPeriod;
  }

  function _nextStage() internal {
    stage = Stages(uint256(stage) + 1);
  }
}
