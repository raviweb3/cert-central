// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import "../node_modules/hardhat/console.sol";
import "./CertDatabaseModel.sol";

interface ICommonDB is CertDatabaseModel{
   /* Verifiers */ 
   function isVerifiers(address _address) external view returns(bool); 

   /* Certifiers */ 
   function getCertifiers()  external view returns (Certifier[] memory);
   function getCertifier(address _certifier) external view returns (Certifier memory);
 

   /* Courses */ 
   function getCourses() external view returns(Course[] memory);
   function getCourse(uint256 _courseId) external view returns(Course memory);
   function getCertifierCourses(address _certifier) external view returns(Course[] memory);
   function getProfileCourses(address _profile) external view returns(Course[] memory);
   
   /* GetEnrollments */
   function getEnrollments(uint256 _courseId) external view returns(Enroll[] memory); 
   function getEnrollment(uint256 _enrollId) external view returns(Enroll memory);             
  
   /* GetProfiles */
   function getProfiles() external view returns(Profile[] memory);
   function getProfile(address _profile) external view returns (Profile memory profile, Certificate[] memory certificates);
   function getProfileEnrollments(address _profile) external view returns(Enroll[] memory); 
  
   /* GetCertificates */
   function getIssuedCertificates(address _certifier) external view returns (Certificate[] memory);
   function getCertificates(address _profile) external view returns (Certificate[] memory);
   function getCertificate(uint256 _certificateId) external view returns(Certificate memory);
}