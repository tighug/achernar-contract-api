require("dotenv").config();

module.exports = {
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
      version: "v0.5.13"
    }
  }
};
