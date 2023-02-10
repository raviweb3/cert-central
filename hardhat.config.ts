import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';
require("hardhat-deploy");
import './tasks';
require('dotenv').config();

const config: HardhatUserConfig = {
  solidity: '0.8.17',
  defaultNetwork: 'hyperspace',
  networks: {
    hyperspace: {
      url: "https://api.hyperspace.node.glif.io/rpc/v1",
      accounts: [process.env.WALLET_PRIVATE_KEY ?? 'undefined'],
    },
    wallaby: {
      url: 'https://wallaby.node.glif.io/rpc/v0',
      chainId: 31415,
      accounts: [process.env.WALLET_PRIVATE_KEY ?? 'undefined'],
    },
  },
};


module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 31337,
      allowUnlimitedContractSize: true
    },
    localhost: {
      chainId: 31337,
      allowUnlimitedContractSize: true
    },
    goerli: {
      url: process.env.GOERLI_RPC_URL,
      accounts: [process.env.WALLET_PRIVATE_KEY],
      chainId: 5,
    },
    wallaby: {
      url: 'https://wallaby.node.glif.io/rpc/v0',
      chainId: 31415,
      accounts: [process.env.WALLET_PRIVATE_KEY ?? 'undefined'],
    },
    hyperspace: {
      url: "https://api.hyperspace.node.glif.io/rpc/v1",
      chainId: 3141,
      accounts: [process.env.WALLET_PRIVATE_KEY ?? 'undefined'],
    },
  },
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  namedAccounts: {
    deployer: {
      default: 0, // here this will by default take the first account as deployer
      1: 0, // similarly on mainnet it will take the first account as deployer. Note though that depending on how hardhat network are configured, the account 0 on one network can be different than on another
    },
  },
};

export default config
