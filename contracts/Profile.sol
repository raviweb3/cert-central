// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import "../node_modules/hardhat/console.sol";
import "./CertDatabaseModel.sol";
import "./ICommonDB.sol";
import "./IProfileDB.sol";


contract Profile is CertDatabaseModel {
    IProfileDB private profileDb;
    ICommonDB private commonDb;

    constructor(address _database, address _commonDb){
        profileDb = IProfileDB(_database);
        commonDb = ICommonDB(_commonDb);
    }

    /* Profle */    
    function registerProfile(string memory _name, string memory _email,string memory _detailsUri) external{
        profileDb.addProfile(_name,_email,_detailsUri);
    }

    function updateProfile(string memory _detailsUri) external{
        profileDb.updateProfile(_detailsUri);
    }

    function getProfile() external view returns (Profile memory, Certificate[] memory){
        return commonDb.getProfile(tx.origin);
    }

    function enrollCourse(uint256 _courseId) external{
        profileDb.enrollCourse(_courseId);    
    }

    function getEnrollments() external view returns(Enroll[] memory){
        return commonDb.getProfileEnrollments(tx.origin);
    }

    function getCertificate(uint256 _certificateId) external view returns(Certificate memory) {
        return commonDb.getCertificate(_certificateId);
    }
}