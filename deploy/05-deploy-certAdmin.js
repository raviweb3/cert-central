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
    log("Deploying CertAdmin and waiting for confirmations...")

    const certDatabase = await deployments.get("CertDatabase");
    const certCommon = await deployments.get("CertCommon");
    const certifierNFT = await deployments.get("CertifierNFT");

    const certAdmin = await deploy("CertAdmin", {
        from: deployer,
        args: [certDatabase.address,certCommon.address,certifierNFT.address],
        log: true,
        // we need to wait if on a live network so we can verify properly
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    log(`CertAdmin deployed at ${certAdmin.address}`)

    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(certAdmin.address, [])
    }
}

module.exports.tags = ["all", "certadmin"]