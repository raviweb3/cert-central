// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "../node_modules/hardhat/console.sol";

import "./CertDatabaseModel.sol";
import "./ICertifierDB.sol";
import "./IProfileDB.sol";
import "./IAdminDB.sol";



contract CertDatabase is ICertifierDB, IProfileDB, IAdminDB {
    using Counters for Counters.Counter;

    address public s_owner;

    // Certifiers
    mapping(address => bool) public s_addressToVerifier;
    address[] public s_verifiers;
    // Certifiers
    mapping(address => Certifier) public s_addressToCertifier;
    Certifier[] public s_certifiers;

    // Profile
    mapping(address => Profile) public s_addressToProfile;
    Profile[] public s_profiles;

    // Course
    mapping(address => Course[]) public s_certifierToCourses;
    mapping(address => Course[]) public s_profileToCourses;
    Course[] public s_courses;
    
    mapping(uint256 => Course) public s_idToCourse;
    Counters.Counter public s_courseIds;

    // Enroll
    mapping(uint256 => Enroll) public s_idToEnroll;
    mapping(uint256 => Enroll[]) public s_courseIdToEnrolls;
    mapping(address => Enroll[]) public s_profileToEnrolls;

    Counters.Counter public s_enrollIds;
    
    // Certificate
    mapping(uint256 => Certificate) public s_idToCertificate;

    mapping(address => Certificate[]) public s_certifierToCertificates;

    mapping(address => Certificate[]) public s_profileToCertificates;
    Counters.Counter public s_certificateIds;

    modifier isOwner(){
        require(s_owner==tx.origin,"You must be a owner");
        _;
    }
    
    modifier isVerifier(){
       // console.log(s_verifiers[0]);
         console.log("in is verifier");
         console.log(tx.origin);
        console.log(s_addressToVerifier[tx.origin]);
        require(s_addressToVerifier[tx.origin],"You must be a verifier");
        _;
    }

    modifier isCeritiferOwner(){
         _;
    }

    modifier isVerifiedCertifer(){
        require(s_addressToCertifier[tx.origin].kycStatus==KycStatus.Verified,"You must be a verified certifier");
        _;
    }

    modifier isProfileOwner(){
         _;
    }

    modifier isVerifiedProfile(){
        require(s_addressToProfile[tx.origin].kycStatus==KycStatus.Verified,"You must be a verified profile");
        _;
    }

    constructor(){
       s_owner = msg.sender;
    }

    function getOwner() external view returns(address){
       return s_owner;
    }
  
    function isVerifierRole(address _verifier) external view returns(bool){
        bool flag = s_addressToVerifier[_verifier];
        console.log("isVerifierRole flag");
        console.log(flag);
        return flag;
    }

    /* Admin */
    function addVerifier(address _verifier) external isOwner {
        console.log("in add verifier");
        console.log(_verifier);
        s_addressToVerifier[_verifier] = true;
        s_verifiers.push(_verifier);
        console.log(s_addressToVerifier[_verifier]);
    }

    function removeVerifier(address _verifier) external isOwner {
        s_addressToVerifier[_verifier] = false;
    }


    function verifyCertifier(address _certifier) external isVerifier {
        console.log("in verifyCertifier");
        require(s_addressToCertifier[_certifier].owner!=address(0),"Certifier is not registered");
        Certifier storage certifier = s_addressToCertifier[_certifier];
        certifier.verifier = tx.origin;
        certifier.kycStatus = KycStatus.Verified;
    }

    function updateCertifierTokenId(address _certifier, uint256 _tokenId) external isVerifier {
        Certifier storage certifier = s_addressToCertifier[_certifier];
        require(certifier.kycStatus==KycStatus.Verified,"Only KYC verified certifier");
        require(certifier.verifier==tx.origin,"Only verifier who processed KYC");
        certifier.tokenId = _tokenId;
    }

    /* Certifier */
    function addCertifier(address _certifier, string memory _name, string memory _entityType, string memory _domain,string memory _detailsUri) external {
        Certifier storage certifier = s_addressToCertifier[_certifier];
        certifier.name = _name;
        certifier.entityType = _entityType;
        certifier.domain = _domain;
        certifier.detailsUri = _detailsUri;
        certifier.owner = _certifier;
        certifier.kycStatus = KycStatus.Submitted;

        s_addressToCertifier[_certifier] = certifier;
    }

    function addCourse(address _certifier, string memory _name,string memory _description,string memory _detailsUri, 
                  string[] memory _skills,uint256 _fee,uint256 _startedOn,uint256 _completedOn) external isVerifiedCertifer{
        uint256 courseId = s_courseIds.current();
        Course memory course =  Course(courseId,_certifier, _name,_description, _detailsUri,_skills,_fee,_startedOn,_completedOn,CourseStatus.Created);
        s_idToCourse[courseId] = course;
        s_certifierToCourses[_certifier].push(course);
        s_courseIds.increment();
    }

    function updateCourse(uint256 _courseId, string memory _detailsUri,uint256 _fee,
                       uint256 _startedOn,uint256 _completedOn) external isVerifiedCertifer {
        Course storage course =   s_idToCourse[_courseId];
        course.detailsUri = _detailsUri;
        course.fee = _fee;
        course.startedOn = _startedOn;
        course.completedOn = _completedOn;
    }

    function updateCourseStatus(uint256 _courseId, CourseStatus _status) external isVerifiedCertifer {
        Course storage course = s_idToCourse[_courseId];
        course.status = _status;
    }

    function enrollProfile(uint256 _courseId, address _profile) external isVerifiedCertifer {
        console.log("in enroll profile");
        console.log(_courseId);
        console.log(_profile);
        console.log(s_addressToProfile[_profile].owner);

        require(s_addressToProfile[_profile].owner!=address(0),"Profile should be registered");
        uint256 enrollId = s_enrollIds.current();
        Course memory course = s_idToCourse[_courseId];
        Enroll memory enroll = Enroll(enrollId, _courseId, _profile, course.certifier,  CourseStatus.Enroll);
        s_idToEnroll[enrollId] = enroll;
        s_profileToCourses[_profile].push(course);
        s_courseIdToEnrolls[_courseId].push(enroll);
        s_profileToEnrolls[_profile].push(enroll);
        s_enrollIds.increment();
    }

    function verifyProfile(address _profile) external isVerifiedCertifer{
        Profile storage profile = s_addressToProfile[_profile];
        profile.verifier = tx.origin;
        profile.kycStatus = KycStatus.Verified;
    }

    function updateProfileTokenId(address _profile, uint256 _tokenId) external isVerifiedCertifer {
        Profile storage profile = s_addressToProfile[_profile];
        require(profile.kycStatus==KycStatus.Verified,"Only KYC verified certifier");
        require(profile.verifier==tx.origin,"Only verifier who processed KYC");
        profile.tokenId = _tokenId;
    }

    function addCertificate(Certificate memory _certificate) external returns(uint256){
        uint256 certificateId = s_certificateIds.current();
        s_idToCertificate[certificateId] = _certificate;
        s_certifierToCertificates[_certificate.certifier].push(_certificate);
        s_profileToCertificates[_certificate.profile].push(_certificate);
        s_certificateIds.increment();
        return certificateId;
    }
            
    /* Profle */    
    function addProfile(address _profile, string memory _name, string memory _email,string memory _detailsUri) external{
        console.log("add profile");
        console.log(_profile);
        Profile memory profile = s_addressToProfile[_profile];
        profile.owner = _profile;
        profile.name = _name;
        profile.email = _email;
        profile.detailsUri = _detailsUri;
        profile.kycStatus = KycStatus.Submitted;
        s_addressToProfile[_profile] = profile;
    }

    function updateProfile(address _profile, string memory _detailsUri) external isProfileOwner{
        Profile storage profile = s_addressToProfile[_profile];
        profile.detailsUri = _detailsUri;
        profile.kycStatus = KycStatus.Submitted;
    }

    function enrollCourse(address _profile, uint256 _courseId) external isVerifiedProfile {
        uint256 enrollId = s_enrollIds.current();
        Course memory course = s_idToCourse[_courseId];
        Enroll memory enroll = Enroll(enrollId, _courseId, _profile, course.certifier,  CourseStatus.Enroll);
        s_idToEnroll[enrollId] = enroll;
        s_profileToCourses[_profile].push(course);
        s_profileToEnrolls[_profile].push(enroll);
        s_enrollIds.increment();
    }

    /* Common */

    /* Verifier */
    function isVerifiers(address _address) external view returns(bool){
        return s_addressToVerifier[_address];
    } 

    function getCertifiers()  external view returns (Certifier[] memory){
        return s_certifiers;
    }

    function getCertifier(address _certifier) external view returns (Certifier memory){
        return s_addressToCertifier[_certifier];
    }
    
    function getCourses() external view returns(Course[] memory){
        return s_courses;
    }

    function getCertifierCourses(address _certifier) external view returns(Course[] memory){
        return s_certifierToCourses[_certifier];
    }

     function getProfileCourses(address _profile) external view returns(Course[] memory){
      return s_profileToCourses[_profile];
    }
 
    function getCourse(uint256 _courseId) external view returns(Course memory) {
        return s_idToCourse[_courseId];
    }
    
    function getEnrollments(uint256 _courseId) external view returns(Enroll[] memory){
        return s_courseIdToEnrolls[_courseId];
    } 
    function getEnrollment(uint256 enrollId) external view returns(Enroll memory) {
        return s_idToEnroll[enrollId];
    }

    function getProfiles() external view returns(Profile[] memory) {
        return s_profiles;
    }            
    
    function getProfile(address _profile) external view returns (Profile memory ,Certificate[] memory) {
       Profile memory profile = s_addressToProfile[_profile];
       Certificate[] memory certificates = s_profileToCertificates[_profile];
       return (profile, certificates);
    }

    function getProfileEnrollments(address _profile) external view returns(Enroll[] memory){
       return s_profileToEnrolls[_profile];
    } 

    function getIssuedCertificates(address _certifier) external isVerifiedCertifer view returns (Certificate[] memory){
        return s_certifierToCertificates[_certifier];
    } 

    function getCertificates(address _profile) external view returns (Certificate[] memory){
        return s_profileToCertificates[_profile];
    }
        
    function getCertificate(uint256 _certificateId) external view returns(Certificate memory) {
        return s_idToCertificate[_certificateId];
    }
}
