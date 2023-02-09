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
    log("Deploying Certifier and waiting for confirmations...")

    const certDatabase = await deployments.get("CertDatabase");
    const certCommon = await deployments.get("CertCommon");
    const profileNFT = await deployments.get("ProfileNFT");
    const certificateNFT = await deployments.get("CertificateNFT");

    const certifier = await deploy("Certifier", {
        from: deployer,
        args: [certDatabase.address,certCommon.address,profileNFT.address,certificateNFT.address],
        log: true,
        // we need to wait if on a live network so we can verify properly
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    log(`Certifier deployed at ${certifier.address}`)

    /*if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(certifier.address, [])
    }*/
}

module.exports.tags = ["all", "certifier"]