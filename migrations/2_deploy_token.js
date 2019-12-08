// eslint-disable-next-line no-undef
const ElectricityMarket = artifacts.require("./ElectricityMarket.sol");
// eslint-disable-next-line no-undef
const ENGToken = artifacts.require("./ENGToken.sol");
const fs = require("fs");

module.exports = function(deployer, network, accounts) {
  deployer.then(async () => {
    // await deployer
    //   .deploy(ENGToken, [accounts[0]], {
    //     from: accounts[0],
    //     gas: 6721975
    //   })
    //   .then(() => {
    //     try {
    //       fs.writeFileSync("token", ENGToken.address);
    //       console.log("write end");
    //     } catch (e) {
    //       console.log(e);
    //     }
    //   });
    await deployer
      .deploy(ElectricityMarket, {
        from: accounts[0],
        gas: 6721975,
        value: 50000000000000000
      })
      .then(() => {
        try {
          fs.writeFileSync("market", ElectricityMarket.address);
          console.log("write end");
        } catch (e) {
          console.log(e);
        }
      });
  });
};
