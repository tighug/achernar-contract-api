require("dotenv").config();

module.exports = {
  contracts_directory: "./contracts",
  migrations_directory: "./migrations",
  networks: {
    ganache: {
      host: process.env.GANACHE_HOST || "localhost",
      port: process.env.GANACHE_PORT || 8545,
      network_id: "*",
    },
  },
  compilers: {
    solc: {
      version: "0.5.7",
    },
  },
};
