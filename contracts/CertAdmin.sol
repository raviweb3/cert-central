// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import "../node_modules/hardhat/console.sol";
import "./CertDatabaseModel.sol";
import "./ICommonDB.sol";
import "./IAdminDB.sol";
import "./nfts/CertifierNFT.sol";
// control access to functions in the framework

contract CertAdmin is CertDatabaseModel{
    IAdminDB private s_adminDb;
    ICommonDB private s_commonDb;
    CertifierNFT private s_certifierNFT;

    constructor(address _database, address _commonDB, address _certifierNFT){
        s_adminDb = IAdminDB(_database);
        s_commonDb = ICommonDB(_commonDB);
        s_certifierNFT = CertifierNFT(_certifierNFT);
    }

    function getOwner() external returns(address){
        return s_adminDb.getOwner();
    }

    function isVerifierRole(address _verifier) external returns(bool){
        return s_adminDb.isVerifierRole(_verifier);
    }

    function enableAsVerifier(address _verifier) external {
        s_adminDb.addVerifier(_verifier);
    }

    function RevokeVerifier(address _verifier) external {
        s_adminDb.removeVerifier(_verifier);
    }

    function  verifyCertifier(address _certifier) external { 
        s_adminDb.verifyCertifier(_certifier);
    }

    function getCertifier(address _certifier) external view returns(Certifier memory) {
        return s_commonDb.getCertifier(_certifier);
    }

    function issueCertifierNFT(address _certifier, string memory uri) external {
        uint256 tokeId = s_certifierNFT.certify(_certifier, uri);
        s_adminDb.updateCertifierTokenId(_certifier,tokeId);
    }
}