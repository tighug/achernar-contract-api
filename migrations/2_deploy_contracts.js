/* eslint-disable no-undef */
const UserMaster = artifacts.require("./user/UserMaster.sol");
const ELECMaster = artifacts.require("./token/ELECMaster.sol");
const MarketMaster = artifacts.require("./market/MarketMaster.sol");

const fs = require("fs");
const address = {
  UserMaster: "",
  ELECMaster: "",
  MarketMaster: ""
};

module.exports = function(deployer, network, accounts) {
  deployer.then(async () => {
    await deployer
      .deploy(UserMaster, {
        from: accounts[0],
        gas: 6721975
      })
      .then(() => {
        address.UserMaster = UserMaster.address;
      });

    await deployer
      .deploy(ELECMaster, {
        from: accounts[0],
        gas: 6721975
      })
      .then(() => {
        address.ELECMaster = ELECMaster.address;
      });

    await deployer
      .deploy(MarketMaster, {
        from: accounts[0],
        gas: 6721975
      })
      .then(() => {
        address.MarketMaster = MarketMaster.address;

        try {
          fs.writeFile("address.json", JSON.stringify(address, null, "    "));
          console.log("end");
        } catch (e) {
          console.log(e);
        }
      });
  });
};
