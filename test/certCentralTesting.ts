import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { CertAdmin } from "../typechain-types";

describe("CertCentral Testing Suite", function () {
  async function deployCertContractsFixture() {
    // Contracts are deployed using the first signer/account by default
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

  describe("Deploy Contracts and get references", function () {
    // Accounts
    // Contracts
    let references:any;

    this.beforeAll(async () => {
         references = await loadFixture(deployCertContractsFixture);
    });
   
    describe("Admin onboarding", function () {
      it("Should enable as verifier 1", async function () {
        const { certAdmin, ownerAcc, verifier1Acc } = references;
        await certAdmin.connect(ownerAcc);
        await certAdmin.enableAsVerifier(verifier1Acc.address);
        //expect(await certAdmin.isVerifierRole(verifier1Acc.address)).to.be.equals(true);
      });

      it("Should enable as verifier 2", async function () {
        const { certAdmin, ownerAcc, verifier2Acc } = references;
        await certAdmin.connect(ownerAcc);
        await certAdmin.enableAsVerifier(verifier2Acc.address);
        //expect(await certAdmin.isVerifierRole(verifier2Acc.address)).to.be.equals(true);
      });
    });

    describe("Certifier onboarding", function () {
      it("Should enable as verifier", async function () {
        const { certAdmin, ownerAcc, verifier1Acc } = references;
        const result = await certAdmin.isVerifierRole(verifier1Acc.address);
        // should be in verifier role
      });

      it("Register as Certifier", async function(){
        const { certifier, certifier1Acc, verifier1Acc } = references;
        await certifier.connect(certifier1Acc).registerCertifier("ABC Labs","Training","www.abclabs.com","ipfsDetailsUri");
      });

      it("Kyc verify Certifier", async function(){
        const { certAdmin, certifier1Acc, verifier1Acc } = references;
        await certAdmin.connect(verifier1Acc).verifyCertifier(certifier1Acc.address);
        // should be kyc verified
      });

      it("Add course for Certifier", async function(){
        const { certifier, certAdmin, certifier1Acc, verifier1Acc } = references;
        await certifier.connect(certifier1Acc).registerCourse("Blockchain training","complete training","www.abclabs.com/blockchain",
                                                               ['Solidity','Javascript'],0,0,0);
        // should be add course to certifier
        const courses = await certifier.connect(certifier1Acc).getCourses(certifier1Acc.address);
        expect(courses.length).to.be.equals(1);
        expect(courses[0].name).to.be.equals("Blockchain training");
        expect(courses[0].status).to.be.equals(0);
      });

      it("Enrolling started for Certifier Course", async function(){
        const { certifier, certAdmin, certifier1Acc, verifier1Acc } = references;
        let courses = await certifier.connect(certifier1Acc).getCourses(certifier1Acc.address);
        expect(courses[0].status).to.be.equals(0);
        await certifier.connect(certifier1Acc).updateCourseStatus(0, 1);
        let coursesAfterUpdate = await certifier.connect(certifier1Acc).getCourses(certifier1Acc.address);
        expect(coursesAfterUpdate[0].status).to.be.equals(1);
      });

      it("Starting Certifier Course", async function(){
        const { certifier, certAdmin, certifier1Acc, verifier1Acc } = references;
        let courses = await certifier.connect(certifier1Acc).getCourses(certifier1Acc.address);
        expect(courses[0].status).to.be.equals(1);
        await certifier.connect(certifier1Acc).updateCourseStatus(0, 2);
        let coursesAfterUpdate = await certifier.connect(certifier1Acc).getCourses(certifier1Acc.address);
        expect(coursesAfterUpdate[0].status).to.be.equals(2);
      });
    });

    describe("Profile 1 Onboarding", function () {
      it("Register a new user", async function(){
        const { certifier, certAdmin, certifier1Acc, verifier1Acc, profile, profile1Acc } = references;
        await profile.connect(profile1Acc).registerProfile("ravi kiran", "test@gmail.com", "www.linkedin.com/ravikiran");
      });

      it("Kyc profile", async function(){
        const { certifier, certAdmin, certifier1Acc, verifier1Acc, profile, profile1Acc } = references;
        await certifier.connect(certifier1Acc).enrollProfile(0,profile1Acc.address);

        const enrollments = await certifier.getEnrollments(0);
        expect(await enrollments[0].profile).to.be.equals(profile1Acc.address); 
      });

      it("Enroll profile in a course", async function(){
        const { certifier, certAdmin, certifier1Acc, verifier1Acc, profile, profile1Acc } = references;
        await certifier.connect(certifier1Acc).enrollProfile(0,profile1Acc.address);

        const enrollments = await certifier.getEnrollments(0);
        expect(await enrollments[0].profile).to.be.equals(profile1Acc.address); 
      });
    });

    describe("Certifier marking the course as completed", function () {
      it("Marking course Completion", async function(){
        const { certifier, certAdmin, certifier1Acc, verifier1Acc, profile, profile1Acc } = references;
        await certifier.connect(certifier1Acc).updateCourseStatus(0,3);
      });
    });

    describe("Certifier Issuing NFT certificates", function () {
      it("Enroll profile in a course", async function(){
        const { certifier, certAdmin, certifier1Acc, verifier1Acc, profile, profile1Acc } = references;
        await certifier.connect(certifier1Acc).issueCourseNFT(profile1Acc.address, 0,"www.nft.com");
      });
    });
  });
});
