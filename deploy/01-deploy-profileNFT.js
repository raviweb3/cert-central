const { network } = require("hardhat")
const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { verify } = require("../helper-functions")
require("dotenv").config()

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    console.log("chainId:",chainId);
    console.log("deployer:",deployer);

    if (chainId == 31337) {
    } else {
    }
    log("----------------------------------------------------")
    log("Deploying ProfileNFT and waiting for confirmations...")
    const profileNFT = await deploy("ProfileNFT", {
        from: deployer,
        args: [],
        log: true,
        // we need to wait if on a live network so we can verify properly
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    log(`ProfileNFT deployed at ${profileNFT.address}`)

    /*if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(profileNFT.address, [])
    }*/
}

module.exports.tags = ["all", "profilenft"]