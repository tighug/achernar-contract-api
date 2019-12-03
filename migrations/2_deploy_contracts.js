// eslint-disable-next-line no-undef
const PowerMarket = artifacts.require("./PowerMarket.sol");
const fs = require("fs");

module.exports = function(deployer, network, accounts) {
  // Deploys the OraclizeTest contract and funds it with 0.5 ETH
  // The contract needs a balance > 0 to communicate with Oraclize
  deployer
    .deploy(PowerMarket, {
      from: accounts[0],
      gas: 6721975,
      value: 50000000000000000
    })
    .then(() => {
      try {
        fs.writeFileSync("power-market", PowerMarket.address);
        console.log("write end");
      } catch (e) {
        console.log(e);
      }
    });
};
