import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Admin", function () {
  async function deployCertContractsFixture() {
    // Contracts are deployed using the first signer/account by default
    console.log(await (await ethers.getSigners()).length);
    const [ownerAcc, verifier1Acc, verifier2Acc, certifier1Acc, certifier2Acc, profile1Acc, profile2Acc, profile3Acc ] = await ethers.getSigners();

    const CertifierNFT = await ethers.getContractFactory("CertifierNFT");
    const ProfileNFT = await ethers.getContractFactory("ProfileNFT");
    const CertificateNFT = await ethers.getContractFactory("CertificateNFT");
    const CertDatabase = await ethers.getContractFactory("CertDatabase");
    const CertCommon = await ethers.getContractFactory("CertCommon");
    const CertAdmin = await ethers.getContractFactory("CertAdmin");
    const Certifier = await ethers.getContractFactory("Certifier");
    const Profile = await ethers.getContractFactory("Profile");

    const certifierNFT = await CertifierNFT.deploy();
    const profileNFT = await ProfileNFT.deploy();
    const certificateNFT = await CertificateNFT.deploy();
    const certDatabase = await CertDatabase.deploy();
    const certCommon = await CertCommon.deploy(certDatabase.address);
    const certAdmin = await CertAdmin.deploy(certDatabase.address,certCommon.address,certifierNFT.address);
    const certifier = await Certifier.deploy(certDatabase.address,certCommon.address,profileNFT.address,certificateNFT.address);
    const profile = await Profile.deploy(certDatabase.address,certCommon.address);

    return { ownerAcc, verifier1Acc, verifier2Acc, certifier1Acc, certifier2Acc, profile1Acc, profile2Acc, profile3Acc, certifierNFT, certificateNFT, certDatabase, certCommon, certAdmin, certifier, profile };
  }

  describe("Deployment", function () {
   it("Should deploy contract suite", async function () {
      const { ownerAcc,verifier1Acc, certAdmin } = await loadFixture(deployCertContractsFixture);
      await certAdmin.connect(ownerAcc);
      console.log(verifier1Acc.address);
      await certAdmin.enableAsVerifier(verifier1Acc.address);
      console.log(await certAdmin.isVerifierRole(verifier1Acc.address));
    });

    it("Should be able to register as ceritifer", async function () {
      const { ownerAcc, certifier1Acc, certifier  } = await loadFixture(deployCertContractsFixture);
      await certifier.connect(certifier1Acc).registerCertifier("ABC Labs","Training","www.abclabs.com","ipfsDetailsUri");
     });

    it("Should Not be able to add a Course before KYC Verification", async function () {
      const { ownerAcc, certifier1Acc, certifier  } = await loadFixture(deployCertContractsFixture);
      await expect(certifier.connect(certifier1Acc).registerCourse("Blockchain training","complete training","www.abclabs.com/blockchain",
                                     ['Solidity','Javascript'],0,0,0)).to.be.revertedWith(
                                      "You must be a verified certifier"
                                    );
     
    });

    it("Should be able to verify the ceritifer and add course", async function () {
      const { ownerAcc, verifier1Acc, certifier1Acc, certAdmin, certifier } = await loadFixture(deployCertContractsFixture);
      console.log(verifier1Acc.address)
      await certAdmin.connect(ownerAcc);
      console.log(verifier1Acc.address);
      await certAdmin.enableAsVerifier(verifier1Acc.address);
      console.log(await certAdmin.isVerifierRole(verifier1Acc.address));
      console.log(await certAdmin.connect(verifier1Acc).verifyCertifier(certifier1Acc.address));
      certifier.connect(certifier1Acc).registerCourse("Blockchain training","complete training","www.abclabs.com/blockchain",
                                     ['Solidity','Javascript'],0,0,0);      
     });
  });
});
