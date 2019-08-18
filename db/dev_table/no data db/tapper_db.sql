-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 18, 2019 at 09:35 PM
-- Server version: 10.1.36-MariaDB
-- PHP Version: 5.6.38

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tapper_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `applicant_family`
--

CREATE TABLE `applicant_family` (
  `personID` int(11) NOT NULL,
  `occupationM` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `occupationF` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `motherFirstName` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `motherLastName` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `motherContact` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fatherFirstName` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fatherLastName` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fatherContact` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `guardianFirstName` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `guardianLastName` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `guardianContact` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `guardianAddress` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `background_table`
--

CREATE TABLE `background_table` (
  `background_id` int(11) NOT NULL,
  `background_url` varchar(255) COLLATE utf8_bin NOT NULL,
  `created_by` varchar(100) COLLATE utf8_bin NOT NULL,
  `updated_by` varchar(100) COLLATE utf8_bin NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `bulknotification_activities`
--

CREATE TABLE `bulknotification_activities` (
  `id` int(11) NOT NULL,
  `sms_to` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `sms_status` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `createdon` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updatedon` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `contactlist`
--

CREATE TABLE `contactlist` (
  `contactlistid` int(11) NOT NULL,
  `contactlist_name` varchar(65) COLLATE utf8_unicode_ci NOT NULL,
  `isDisabled` tinyint(1) NOT NULL,
  `createdby` varchar(65) COLLATE utf8_unicode_ci NOT NULL,
  `createdon` datetime NOT NULL,
  `updatedby` varchar(65) COLLATE utf8_unicode_ci NOT NULL,
  `updatedon` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `contactlist_users`
--

CREATE TABLE `contactlist_users` (
  `contactlistuserid` int(11) NOT NULL,
  `contactlistid` int(11) NOT NULL,
  `personDetailId` varchar(65) COLLATE utf8_unicode_ci NOT NULL,
  `mobile_number` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `isDisabled` tinyint(1) NOT NULL,
  `createdby` varchar(65) COLLATE utf8_unicode_ci NOT NULL,
  `createdon` datetime NOT NULL,
  `updatedby` varchar(65) COLLATE utf8_unicode_ci NOT NULL,
  `updatedon` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `courseID` int(11) NOT NULL,
  `courseName` varchar(70) COLLATE utf8_unicode_ci DEFAULT NULL,
  `courseCode` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `courseType` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `departmentID` int(11) DEFAULT NULL,
  `schoolLevel` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `courseYears` int(2) DEFAULT NULL,
  `durationMonths` int(5) DEFAULT NULL,
  `dateAdded` date DEFAULT NULL,
  `dateModified` date DEFAULT NULL,
  `recordStatus` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gate_cardassignment`
--

CREATE TABLE `gate_cardassignment` (
  `assignmentId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `partyId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `card_id` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `categoryId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `createDate` datetime NOT NULL,
  `updateDate` datetime NOT NULL,
  `isDisabled` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gate_categorytype`
--

CREATE TABLE `gate_categorytype` (
  `categoryId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `categoryType` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `categoryName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `gateTimeInSetting` time DEFAULT NULL,
  `gateTimeSettingAbsent` time DEFAULT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `updateDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `gate_categorytype`
--

INSERT INTO `gate_categorytype` (`categoryId`, `categoryType`, `categoryName`, `gateTimeInSetting`, `gateTimeSettingAbsent`, `createdBy`, `updateDate`) VALUES
('77f9afea-c316-11e8-a587-ace2d3624318', 'STD', 'Student', '09:00:00', '12:00:00', 'Admin', '2018-09-28 14:03:10'),
('88591e2d-c316-11e8-a587-ace2d3624318', 'TCH', 'Teacher', '09:00:00', '13:00:00', 'Admin', '2018-09-28 14:03:37');

-- --------------------------------------------------------

--
-- Table structure for table `gate_coursetype`
--

CREATE TABLE `gate_coursetype` (
  `courseId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `courseName` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `courseType` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `updateDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gate_history`
--

CREATE TABLE `gate_history` (
  `transaction_id` int(255) NOT NULL,
  `card_id` varchar(55) COLLATE utf8_unicode_ci NOT NULL,
  `createDate` datetime NOT NULL,
  `gate_id` varchar(11) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gate_persondetails`
--

CREATE TABLE `gate_persondetails` (
  `personDetailId` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'UUID primary key for tables',
  `userGivenId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `familyname` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `givenname` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `middlename` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `suffix` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `civilStatus` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `gender` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `mobile_number` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dateOfBirth` date NOT NULL,
  `age` int(3) NOT NULL,
  `categoryId` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `updateDate` varchar(255) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gate_personphoto`
--

CREATE TABLE `gate_personphoto` (
  `photoId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `personDetailId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `image_url` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `createDate` datetime NOT NULL,
  `updateDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gate_personstatus`
--

CREATE TABLE `gate_personstatus` (
  `gate_personstatusid` int(11) NOT NULL,
  `card_id` varchar(65) COLLATE utf8_unicode_ci NOT NULL,
  `campus_status` tinyint(1) DEFAULT NULL,
  `gate_id` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updatedate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gate_usercategory`
--

CREATE TABLE `gate_usercategory` (
  `categoryId` int(11) NOT NULL,
  `userType` varchar(51) COLLATE utf8_unicode_ci NOT NULL,
  `userCatId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `userTimeSetting` time NOT NULL,
  `updateDate` datetime NOT NULL,
  `updatedBy` varchar(51) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gate_users`
--

CREATE TABLE `gate_users` (
  `id_user` int(50) NOT NULL,
  `username` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `createdDate` date NOT NULL,
  `createdBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updateDate` date NOT NULL,
  `updatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `gate_users`
--

INSERT INTO `gate_users` (`id_user`, `username`, `password`, `createdDate`, `createdBy`, `updateDate`, `updatedBy`) VALUES
(1, 'Admin', 'pass', '2017-09-28', 'Admin', '2017-09-28', 'Admin'),
(2, 'Gate', 'pass', '2017-09-28', 'Admin', '2017-09-28', 'Admin'),
(3, 'SmsAdmin', 'pass', '2017-09-28', 'Admin', '2017-09-28', 'Admin');

-- --------------------------------------------------------

--
-- Table structure for table `header_settings`
--

CREATE TABLE `header_settings` (
  `id` int(11) NOT NULL,
  `header_name` varchar(255) COLLATE utf8_bin NOT NULL,
  `updatedat` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updatedby` varchar(100) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `logo_table`
--

CREATE TABLE `logo_table` (
  `logoid` int(11) NOT NULL,
  `image_url` varchar(100) COLLATE utf8_bin NOT NULL,
  `created_by` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `msg_template`
--

CREATE TABLE `msg_template` (
  `messageId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `message_type` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `msg_text` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `createdBy` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `createDate` datetime NOT NULL,
  `updatedBy` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `updateDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `msg_template`
--

INSERT INTO `msg_template` (`messageId`, `message_type`, `msg_text`, `createdBy`, `createDate`, `updatedBy`, `updateDate`) VALUES
('75d5ca30-227f-11e9-8c97-ace2d3624318', '1', 'has walked in to the campus premises. This is a system generated message.', 'Admin', '2019-01-27 23:04:04', 'Admin', '2019-08-18 22:18:38'),
('9256ccc3-227f-11e9-8c97-ace2d3624318', '2', 'is now going outside of the campus premises. This is a system generated message.', 'Admin', '2019-01-27 23:04:52', 'Admin', '2019-01-27 23:04:52');

-- --------------------------------------------------------

--
-- Table structure for table `party_stdconnector`
--

CREATE TABLE `party_stdconnector` (
  `id` int(255) NOT NULL,
  `partyId` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `card_id` varchar(55) COLLATE utf8_unicode_ci NOT NULL,
  `userCatId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `createdBy` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `isDisabled` int(1) NOT NULL,
  `createDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `person`
--

CREATE TABLE `person` (
  `personID` int(11) NOT NULL,
  `lastName` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `firstName` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `middleName` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `suffix` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `personCivilStatus` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `personReligion` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `personNationality` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `personDOB` date DEFAULT NULL,
  `personGender` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `personAge` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `personFamilyIncome` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `personPlaceOfBirth` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `person_image`
--

CREATE TABLE `person_image` (
  `image_id` int(55) NOT NULL,
  `image_url` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `partyId` varchar(55) COLLATE utf8_unicode_ci NOT NULL,
  `updateDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sms_logs`
--

CREATE TABLE `sms_logs` (
  `smslogid` int(11) NOT NULL,
  `smsTo` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `message` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `createdby` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `createdon` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sms_settings`
--

CREATE TABLE `sms_settings` (
  `id` int(11) NOT NULL,
  `ipaddress` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `staffID` int(11) NOT NULL,
  `staffPositionId` int(11) DEFAULT NULL,
  `accountID` int(11) DEFAULT NULL,
  `lastName` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `firstName` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `middleName` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gender` varchar(7) COLLATE utf8_unicode_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `address` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact1` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact2` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `recordStatus` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `studentID` int(11) NOT NULL,
  `personID` int(11) DEFAULT NULL,
  `accountID` int(11) DEFAULT NULL,
  `studentNumber` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `yearLevel` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `courseID` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `semesterID` int(11) DEFAULT NULL,
  `applicationType` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sectionID` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `studentType` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `studentStatus` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `createdById` int(11) DEFAULT NULL,
  `createdDate` date DEFAULT NULL,
  `modifiedById` int(11) DEFAULT NULL,
  `modifiedDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_emergencycontact`
--

CREATE TABLE `user_emergencycontact` (
  `contactId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `contactName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contactRelationship` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contactNumber` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `createDate` datetime NOT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `updateDate` datetime NOT NULL,
  `personDetailId` varchar(255) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `applicant_family`
--
ALTER TABLE `applicant_family`
  ADD PRIMARY KEY (`personID`);

--
-- Indexes for table `background_table`
--
ALTER TABLE `background_table`
  ADD PRIMARY KEY (`background_id`);

--
-- Indexes for table `bulknotification_activities`
--
ALTER TABLE `bulknotification_activities`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `contactlist`
--
ALTER TABLE `contactlist`
  ADD PRIMARY KEY (`contactlistid`);

--
-- Indexes for table `contactlist_users`
--
ALTER TABLE `contactlist_users`
  ADD PRIMARY KEY (`contactlistuserid`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`courseID`),
  ADD KEY `fk_collegeID` (`departmentID`);

--
-- Indexes for table `gate_cardassignment`
--
ALTER TABLE `gate_cardassignment`
  ADD PRIMARY KEY (`assignmentId`),
  ADD UNIQUE KEY `assignmentId` (`assignmentId`);

--
-- Indexes for table `gate_categorytype`
--
ALTER TABLE `gate_categorytype`
  ADD PRIMARY KEY (`categoryId`),
  ADD UNIQUE KEY `categoryId` (`categoryId`);

--
-- Indexes for table `gate_coursetype`
--
ALTER TABLE `gate_coursetype`
  ADD PRIMARY KEY (`courseId`);

--
-- Indexes for table `gate_history`
--
ALTER TABLE `gate_history`
  ADD PRIMARY KEY (`transaction_id`);

--
-- Indexes for table `gate_persondetails`
--
ALTER TABLE `gate_persondetails`
  ADD PRIMARY KEY (`personDetailId`),
  ADD UNIQUE KEY `personDetailId` (`personDetailId`);

--
-- Indexes for table `gate_personphoto`
--
ALTER TABLE `gate_personphoto`
  ADD PRIMARY KEY (`photoId`);

--
-- Indexes for table `gate_personstatus`
--
ALTER TABLE `gate_personstatus`
  ADD PRIMARY KEY (`gate_personstatusid`);

--
-- Indexes for table `gate_usercategory`
--
ALTER TABLE `gate_usercategory`
  ADD PRIMARY KEY (`categoryId`);

--
-- Indexes for table `gate_users`
--
ALTER TABLE `gate_users`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `partyid` (`id_user`);

--
-- Indexes for table `header_settings`
--
ALTER TABLE `header_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logo_table`
--
ALTER TABLE `logo_table`
  ADD PRIMARY KEY (`logoid`);

--
-- Indexes for table `msg_template`
--
ALTER TABLE `msg_template`
  ADD PRIMARY KEY (`messageId`);

--
-- Indexes for table `party_stdconnector`
--
ALTER TABLE `party_stdconnector`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `person`
--
ALTER TABLE `person`
  ADD PRIMARY KEY (`personID`);

--
-- Indexes for table `person_image`
--
ALTER TABLE `person_image`
  ADD PRIMARY KEY (`image_id`);

--
-- Indexes for table `sms_logs`
--
ALTER TABLE `sms_logs`
  ADD PRIMARY KEY (`smslogid`);

--
-- Indexes for table `sms_settings`
--
ALTER TABLE `sms_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`staffID`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`studentID`),
  ADD KEY `fk_accountID2` (`accountID`),
  ADD KEY `fk_blockID_idx` (`sectionID`),
  ADD KEY `fk_degreeProgramID_idx` (`courseID`);

--
-- Indexes for table `user_emergencycontact`
--
ALTER TABLE `user_emergencycontact`
  ADD PRIMARY KEY (`contactId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bulknotification_activities`
--
ALTER TABLE `bulknotification_activities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `contactlist`
--
ALTER TABLE `contactlist`
  MODIFY `contactlistid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `contactlist_users`
--
ALTER TABLE `contactlist_users`
  MODIFY `contactlistuserid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gate_history`
--
ALTER TABLE `gate_history`
  MODIFY `transaction_id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gate_personstatus`
--
ALTER TABLE `gate_personstatus`
  MODIFY `gate_personstatusid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gate_usercategory`
--
ALTER TABLE `gate_usercategory`
  MODIFY `categoryId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gate_users`
--
ALTER TABLE `gate_users`
  MODIFY `id_user` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `header_settings`
--
ALTER TABLE `header_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `logo_table`
--
ALTER TABLE `logo_table`
  MODIFY `logoid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `party_stdconnector`
--
ALTER TABLE `party_stdconnector`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `person`
--
ALTER TABLE `person`
  MODIFY `personID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `person_image`
--
ALTER TABLE `person_image`
  MODIFY `image_id` int(55) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sms_logs`
--
ALTER TABLE `sms_logs`
  MODIFY `smslogid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sms_settings`
--
ALTER TABLE `sms_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
