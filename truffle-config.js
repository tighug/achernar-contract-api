require("dotenv").config();

module.exports = {
  contracts_directory: "./contracts",
  migrations_directory: "./migrations",
  networks: {
    ganache: {
      host:
        process.env.CONTRACT_API_GANACHE_HOST ||
        process.env.GANACHE_HOST ||
        "localhost",
      port:
        process.env.CONTRACT_API_GANACHE_PORT ||
        process.env.GANACHE_PORT ||
        8545,
      network_id: "*"
    }
  },
  compilers: {
    solc: {
      version: "v0.5.14"
    }
  }
};
