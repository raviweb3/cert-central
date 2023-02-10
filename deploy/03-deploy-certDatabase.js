const { network, ethers } = require("hardhat")
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
    log("Deploying CertDatabase and waiting for confirmations...")
    try {
    const certDatabase = await deploy("CertDatabase", {
        from: deployer,
        args: [],
        log: true,
        gasLimit: 3e7,
        // we need to wait if on a live network so we can verify properly
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    log(`CertDatabase deployed at ${certDatabase.address}`)
    }
    catch(ex){
        console.log(ex);
    }
    

    /*if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(certDatabase.address, [])
    }*/
}

module.exports.tags = ["all", "certdatabase"]