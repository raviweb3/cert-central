// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import "../node_modules/hardhat/console.sol";
import "./CertDatabaseModel.sol";

interface IProfileDB is CertDatabaseModel{
     function addProfile(string memory _name, string memory _email,string memory _detailsUri) external;
     function updateProfile(string memory _detailsUri) external ;
     function enrollCourse(uint256 _courseId) external;
}
