// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import "../node_modules/hardhat/console.sol";

// Data models
interface CertDatabaseModel {
   enum KycStatus {
     Submitted,
     Verified,
     Rejected
   }

   enum CourseStatus {
     Created,
     Enroll,
     Started,
     Completed
   }

   struct Certifier {
     string  name;
     string  entityType;
     string  domain;
     address owner;
     string  detailsUri;
     KycStatus kycStatus; 
     address verifier;
     uint256 tokenId;
   } 

   struct Profile {
     string  name;
     string  email;
     address owner;
     string  detailsUri;
     KycStatus kycStatus; 
     string[]  skills;
     address verifier;
     uint256 tokenId;
   }

   struct Enroll {
    uint256 id;
    uint256 couseId;
    address profile;
    address certifier;
    CourseStatus status;
   }

   struct Course {
     uint256 courseId;
     address certifier;
     string name;
     string description;
     string detailsUri;
     string[] skills;
     uint256 fee;
     uint256 startedOn;
     uint256 completedOn;
     CourseStatus status;
   }

   struct Certificate {
    uint256 enrollId;
    address certifier;
    address profile;
    string  name;
    string  detailUri;
    uint256 certifiedOn;
    uint256 tokenId; 
   }
}