// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import "../node_modules/hardhat/console.sol";
import "./CertDatabaseModel.sol";

interface IAdminDB is CertDatabaseModel {
    function getOwner() external returns(address);
    function isVerifierRole(address _verifier) external returns(bool);
    function addVerifier(address _verifier) external;
    function removeVerifier(address _verifier) external;
    function verifyCertifier(address _certifier) external;
    function updateCertifierTokenId(address _certifier, uint256 _tokenId) external;
}