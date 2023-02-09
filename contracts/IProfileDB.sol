// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import "../node_modules/hardhat/console.sol";
import "./CertDatabaseModel.sol";

interface IProfileDB is CertDatabaseModel{
     function addProfile(address profile, string memory _name, string memory _email,string memory _detailsUri) external;
     function updateProfile(address profile, string memory _detailsUri) external ;
     function enrollCourse(address profile, uint256 _courseId) external;
}
