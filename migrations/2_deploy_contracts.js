/* eslint-disable no-undef */
const UserMaster = artifacts.require("./user/UserMaster.sol");
const TokenMaster = artifacts.require("./token/TokenMaster.sol");
const MarketMaster = artifacts.require("./market/MarketMaster.sol");

const fs = require("fs");
const addressData = {
  UserMaster: "",
  TokenMaster: "",
  MarketMaster: "",
};

module.exports = function (deployer, network, accounts) {
  deployer.then(async () => {
    await deployer
      .deploy(UserMaster, {
        from: accounts[0],
        gas: 6721975,
      })
      .then(() => {
        addressData.UserMaster = UserMaster.address;
      });

    await deployer
      .deploy(TokenMaster, {
        from: accounts[0],
        gas: 6721975,
      })
      .then(() => {
        addressData.TokenMaster = TokenMaster.address;
      });

    await deployer
      .deploy(MarketMaster, {
        from: accounts[0],
        gas: 6721975,
      })
      .then(() => {
        addressData.MarketMaster = MarketMaster.address;

        fs.writeFile(
          "address.json",
          JSON.stringify(addressData, null, 4),
          (err) => {
            if (err) console.log(err);

            console.log("end");
          }
        );
      });
  });
};
