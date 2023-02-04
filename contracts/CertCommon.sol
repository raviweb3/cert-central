// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import "../node_modules/hardhat/console.sol";
import "./CertDatabaseModel.sol";
import "./ICommonDB.sol";

contract CertCommon is ICommonDB {
    ICommonDB private s_commonDb;

    constructor(address _database){
        s_commonDb = ICommonDB(_database);
    }

    /* Verifier */
    function isVerifiers(address _address) external view returns(bool){
        return s_commonDb.isVerifiers(_address);
    } 

    function getCertifiers()  external view returns (Certifier[] memory){
        return s_commonDb.getCertifiers();
    }

    function getCertifier(address _certifier) external view returns (Certifier memory){
        return s_commonDb.getCertifier(_certifier);
    }
    
    function getCourses() external view returns(Course[] memory){
        return s_commonDb.getCourses();
    }

    function getCertifierCourses(address _certifier) external view returns(Course[] memory){
        return s_commonDb.getCertifierCourses(_certifier);
    }

     function getProfileCourses(address _profile) external view returns(Course[] memory){
      return s_commonDb.getProfileCourses(_profile);
    }
 
    function getCourse(uint256 _courseId) external view returns(Course memory) {
        return s_commonDb.getCourse(_courseId);
    }
    
    function getEnrollments(uint256 _courseId) external view returns(Enroll[] memory){
        return s_commonDb.getEnrollments(_courseId);
    } 
    function getEnrollment(uint256 enrollId) external view returns(Enroll memory) {
        return s_commonDb.getEnrollment(enrollId);
    }

    function getProfiles() external view returns(Profile[] memory) {
        return s_commonDb.getProfiles();
    }            
    
    function getProfile(address _profile) external view returns (Profile memory ,Certificate[] memory) {
       return s_commonDb.getProfile(_profile);
    }

    function getProfileEnrollments(address _profile) external view returns(Enroll[] memory){
       return s_commonDb.getProfileEnrollments(_profile);
    } 

    function getIssuedCertificates(address _certifier) external view returns (Certificate[] memory){
        return s_commonDb.getIssuedCertificates(_certifier);
    } 

    function getCertificates(address _profile) external view returns (Certificate[] memory){
        return s_commonDb.getCertificates(_profile);
    }
        
    function getCertificate(uint256 _certificateId) external view returns(Certificate memory) {
        return s_commonDb.getCertificate(_certificateId);
    }
}