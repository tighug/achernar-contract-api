// eslint-disable-next-line no-undef
const Migrations = artifacts.require("Migrations");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Migrations, {from: accounts[0], gas: 6721975});
};
