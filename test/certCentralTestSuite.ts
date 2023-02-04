import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Admin", function () {
  async function deployCertContractsFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, verifier,verifier2, institute1, institute2, profile1, profile2, profile3 ] = await ethers.getSigners();

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


    return { owner, verifier,verifier2, institute1, institute2, profile1, profile2, profile3, certifierNFT, certificateNFT, certDatabase, certCommon, certAdmin, certifier, profile };
  }

  describe("Deployment", function () {
    it("Should deploy contract suite", async function () {
      const { owner,verifier, verifier2, certAdmin } = await loadFixture(deployCertContractsFixture);
      await certAdmin.connect(owner);
      console.log(await certAdmin.getOwner());
      console.log(owner.address);
      console.log(verifier.address);

      await certAdmin.enableAsVerifier(verifier.address);
    });
  });
});
