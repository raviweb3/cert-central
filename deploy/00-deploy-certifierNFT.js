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
    log("Deploying CertifierNFT and waiting for confirmations...")
    const certifierNFT = await deploy("CertifierNFT", {
        from: deployer,
        args: [],
        log: true,
        // we need to wait if on a live network so we can verify properly
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    log(`certifierNFT deployed at ${certifierNFT.address}`)

   /* if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(certifierNFT.address, [])
    }*/
}

module.exports.tags = ["all", "certifiernft"]