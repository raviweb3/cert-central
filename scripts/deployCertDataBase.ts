import { ethers } from "hardhat";

async function main() {
 
  const CertDatabase = await ethers.getContractFactory("CertDatabase");
  const certDatabase = await CertDatabase.deploy();

  await certDatabase.deployed();

  console.log(`CertDatabase was deployed to ${certDatabase.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
