// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import "../node_modules/hardhat/console.sol";
import "./CertDatabaseModel.sol";
import "./ICertifierDB.sol";
import "./ICommonDB.sol";
import "./nfts/ProfileNFT.sol";
import "./nfts/CertificateNFT.sol";
import "./CertCommon.sol";

contract Certifier is CertDatabaseModel {
    ICertifierDB private certifierDb;
    ICommonDB private commonDb;
    ProfileNFT private profileNFT;
    CertificateNFT private certificateNFT;
    
    constructor(address _database, address _commonDb ,address _profileNFT, address _certificateNFT){
       // Database address 
       certifierDb = ICertifierDB(_database);
       commonDb = ICommonDB(_commonDb);
       profileNFT = ProfileNFT(_profileNFT);
       certificateNFT = CertificateNFT(_certificateNFT);
    }

    /* Certifier */
    function registerCertifier(string memory _name, string memory _entityType, string memory _domain,string memory _detailsUri) external{
        certifierDb.addCertifier(msg.sender,_name, _entityType, _domain,_detailsUri);
    }

    function getCertifier(address _certifier) external view returns (Certifier memory){
        return commonDb.getCertifier(_certifier);
    }

    function enrollProfile(uint256 _courseId, address _profile) external{
        certifierDb.enrollProfile(_courseId,_profile);
    }

    function getEnrollments(uint256 _courseId) external view returns(Enroll[] memory) {
        return commonDb.getEnrollments(_courseId);
    }

    function getEnrollment(uint256 _enrollId) external view returns(Enroll memory) {
        return commonDb.getEnrollment(_enrollId);
    }

    function issuedCertificates(address _certifier) external view returns (Certificate[] memory){
        return commonDb.getIssuedCertificates(_certifier);
    }

    function registerCourse(string memory _name,string memory _description,string memory _detailsUri, 
                            string[] memory _skills,uint256 _fee,uint256 _startedOn,uint256 _completedOn) external{
        certifierDb.addCourse(msg.sender,_name,_description,_detailsUri,_skills,_fee,_startedOn,_completedOn);
    }

    function updateCourse(uint256 _courseId, string memory _detailsUri,uint256 _fee,uint256 _startedOn,uint256 _completedOn) external{
        certifierDb.updateCourse(_courseId,_detailsUri,_fee,_startedOn,_completedOn);
    }

    function updateCourseStatus(uint256 _courseId, CourseStatus _status) external{
        certifierDb.updateCourseStatus(_courseId,_status);
    }

    function getCourses(address _certifier) external view returns(Course[] memory){
        return commonDb.getCertifierCourses(_certifier);
    }

    function issueProfileNFT(address _profile, string memory _tokenUri) external {
       uint256 tokeId = profileNFT.certify(_profile, _tokenUri);
       certifierDb.updateProfileTokenId(_profile,tokeId);
    }   

    function issueCourseNFT(address _profile,uint256 _courseId, string memory _tokenUri) external returns(bool){
        Course memory course = commonDb.getCourse(_courseId);
        console.log("in issueCourseNFT");
        console.log(course.courseId);
        console.log(course.name);
      
        // should be completed status
        require(course.status==CourseStatus.Completed,"Course is still ongoing");
        Enroll[] memory enrolls = commonDb.getEnrollments(_courseId);

        // Course enrolls are limited
        bool isCertified = false;
        uint256 certificateId = 0;
        console.log(enrolls.length);
        console.log(_profile);
        for(uint64 i = 0; i < enrolls.length; i++){
            console.log(enrolls[i].profile);
            if(enrolls[i].profile == _profile){
                Enroll memory enroll = enrolls[i];  
                console.log("enroll id");
                console.log(enroll.id);
                uint256 tokeId = certificateNFT.certify(_profile, _tokenUri);
                console.log("tokeId");
                console.log(tokeId);
                Certificate memory certificate = Certificate(enroll.id, tx.origin, _profile, course.name, _tokenUri, block.timestamp,tokeId);

                certificateId = certifierDb.addCertificate(certificate);
                console.log("certificateId");
                console.log(certificateId);
                isCertified = true;
            }
        }
        require(isCertified,"Profile should be enrolled to issue a certificate.");

        // fire event
        return isCertified;
    }

    function IssuedCertificate(uint256 _certificateId) external view returns(Certificate memory) {
        return commonDb.getCertificate(_certificateId);
    }
}