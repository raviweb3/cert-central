// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import "../node_modules/hardhat/console.sol";
import "./CertDatabaseModel.sol";

interface ICertifierDB is CertDatabaseModel {
     function addCertifier(string memory _name, string memory _entityType, string memory _domain,string memory _detailsUri) external;
    
     function addCourse(string memory _name,string memory _description,string memory _detailsUri, 
                  string[] memory _skills,uint256 _fee,uint256 _startedOn,uint256 _completedOn) external;

     function updateCourse(uint256 _courseId, string memory _detailsUri,uint256 _fee,
                       uint256 _startedOn,uint256 _completedOn) external;

     function updateCourseStatus(uint256 _courseId, CourseStatus _status) external;      

     function enrollProfile(uint256 _courseId, address _profile) external;
     function verifyProfile(address _profile) external;

     function updateProfileTokenId(address _profile, uint256 _tokenId) external;

     function addCertificate(Certificate memory _certificate) external returns(uint256);
}
