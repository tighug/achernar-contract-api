module.exports = {
  networks: {
    ganachecli: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*"
    }
  },
  compilers: {
    solc: {
      version: "v0.5.13"
    }
  }
};
