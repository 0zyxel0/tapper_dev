-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 18, 2019 at 04:39 PM
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

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `fn_GateHistoryAbsentTimeline` ()  NO SQL
SELECT DISTINCT
gh.createdate AS 'Time_In',
gp.userGivenId AS 'Pid',
gc.card_id AS 'Id',
gp.familyname AS 'LastName',
gp.givenname as 'name',
gt.categoryName AS 'category',
gh.gate_Id as 'Gate'
from gate_history gh
Left JOIN gate_cardassignment gc on gc.card_id = gh.card_id
LEFT Join gate_persondetails gp on gp.persondetailid = gc.partyid 
LEFT JOIN gate_categoryType gt on gt.categoryId = gp.categoryid
where CAST(gh.createdate as time) >= gt.gateTimeSettingAbsent
Group By gc.card_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fn_GateHistoryEarlyTimeline` ()  NO SQL
select * from 
(SELECT DISTINCT
gh.createdate AS 'Time_In',
gp.userGivenId AS 'Pid',
gc.card_id AS 'Id',
gp.familyname AS 'LastName',
gp.givenname as 'name',
gt.categoryName AS 'category',
gh.gate_Id as 'Gate'
from gate_history gh
Left JOIN gate_cardassignment gc on gc.card_id = gh.card_id
LEFT Join gate_persondetails gp on gp.persondetailid = gc.partyid 
LEFT JOIN gate_categoryType gt on gt.categoryId = gp.categoryid
where CAST(gh.createdate as time) <= gt.gateTimeInSetting
ORDER BY gh.createDate DESC)X
Where CAST(x.Time_in as date) = CAST(now() as date)
Group BY x.ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fn_GateHistoryLateTimeline` ()  NO SQL
select * from (
SELECT DISTINCT
gh.createdate AS 'Time_In',
gp.userGivenId AS 'Pid',
gc.card_id AS 'Id',
gp.familyname AS 'LastName',
gp.givenname as 'name',
gt.categoryName AS 'category',
gh.gate_Id as 'Gate',
uc.contactName AS 'Cname',
uc.contactNumber as 'Number'               
from gate_history gh
Left JOIN gate_cardassignment gc on gc.card_id = gh.card_id
LEFT Join gate_persondetails gp on gp.persondetailid = gc.partyid 
LEFT JOIN gate_categoryType gt on gt.categoryId = gp.categoryid
LEFT JOIN user_emergencycontact uc on uc.personDetailId = gp.personDetailId               
where CAST(gh.createdate as time) >= gt.gateTimeInSetting
order by gh.createdate desc
)x 
where CAST(x.Time_In as date) = CAST(now() as date)
Group by x.id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fn_GateHistoryReport` ()  NO SQL
SELECT
gh.createdate AS 'Time_In',
gp.userGivenId AS 'Pid',
gc.card_id AS 'Id',
gp.familyname AS 'LastName',
gp.givenname as 'name',
gt.categoryName AS 'category',
gh.gate_Id as 'Gate'
from gate_history gh
Left JOIN gate_cardassignment gc on gc.card_id = gh.card_id
LEFT Join gate_persondetails gp on gp.persondetailid = gc.partyid 
LEFT JOIN gate_categoryType gt on gt.categoryId = gp.categoryid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fn_GateHistoryTimeline` ()  NO SQL
select 
gp.userGivenId AS 'Id', 
gh.card_id AS 'Card_id', 
gp.givenname AS 'Name', 
gp.familyname AS 'FamilyName',
gh.createDate AS 'Time_In',
gt.categoryName AS 'Type'
from gate_history gh
left join gate_cardassignment gc on gh.card_id = gc.card_id
left join gate_persondetails gp on gp.persondetailId = gc.partyId
left join gate_categoryType gt on gt.categoryId = gp.categoryId$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fn_GateScanningExtract` ()  NO SQL
select 
pp.image_url AS 'url',
ga.partyid AS 'ID',
gd.givenname as 'name',
gd.familyname as 'lastname',
gh.createDate as 'time_in',
gd.userGivenId as 'givenId'
from gate_history gh
left join gate_cardassignment ga on gh.card_id = ga.card_id
left join gate_persondetails gd on gd.persondetailId = ga.partyid
left join gate_personphoto pp on pp.persondetailId = gd.persondetailId
ORDER BY gh.transaction_id DESC
LIMIT 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fn_GateScanTopUp` ()  NO SQL
SELECT pi.image_url,ps.partyId,gh.createDate,ps.card_id,c.courseCode
FROM gate_history gh
JOIN party_stdconnector ps on ps.card_id = gh.card_id
JOIN person_image pi on pi.partyId = ps.partyId
JOIN student s on s.studentnumber = ps.partyid
LEFT JOIN course c on c.courseID = s.courseID
ORDER BY gh.transaction_id DESC
LIMIT 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fn_GenerateAllUsers` ()  NO SQL
select 
pic.image_url AS 'Image',
gp.personDetailId AS 'Student_ID',
gp.familyname AS 'Last_Name',
gp.givenname AS 'Given_Name',
gp.middlename AS 'Middle_Name',
gp.mobile_number AS 'Mobile_Number',
gp.suffix AS 'Suffix',
gp.civilStatus AS 'Status',
gp.gender AS 'Gender',
gp.dateOfBirth AS 'Birthday',
gp.age AS 'Age',
gp.categoryId AS 'Category_ID',
gt.categoryName,
gp.userGivenId,
gc.card_id AS 'Card',
pp.contactName AS 'Contact',
pp.contactNumber AS 'Number',
pp.contactRelationship AS 'Relationship',
case when pic.image_url is NULL then 'N' Else 'Y' END AS 'Option'



from gate_persondetails gp
LEFT JOIN gate_personphoto pic on gp.personDetailId = pic.personDetailId
LEFT JOIN gate_categorytype gt on gt.categoryID = gp.categoryId
LEFT JOIN gate_cardassignment gc on gc.partyId = gp.personDetailId
LEFT JOIN user_emergencycontact pp on gp.personDetailId = pp.personDetailId$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fn_GenerateStudentListReport` ()  NO SQL
SELECT distinct 
'<img src=<?php echo base_url()?>'+pi.image_url+'height="42" width="42">' as'image_url',
pi.image_url,s.studentNumber, p.lastname, p.firstname,s.studentType,s.studentstatus, case when pi.image_url is NULL then "N" Else "Y" END AS "Upload"
FROM student s 
left join person p on s.personID = p.personID
left join person_image pi on pi.partyId = s.studentNumber$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fn_GetAllUserCategory` ()  NO SQL
SELECT
categoryID AS 'ID',
categoryName AS 'Name',
categoryType AS 'Type',
gateTimeInSetting AS 'Time_Setting',
gateTimeSettingAbsent AS 'Absent_Setting',
createdBy AS 'Create',
updateDate AS 'Date',
case when gateTimeInSetting is not NULL then 'O' Else 'O' END AS 'Option'
FROM gate_categorytype$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fn_GetExistingCardUsers` ()  NO SQL
SELECT 
gp.personDetailId AS 'ID',
gc.card_Id AS 'Card_Number', 
gp.familyname AS 'Last_Name', 
gp.givenname AS 'Given_Name', 
gt.categoryName AS 'Category', 
gc.isDisabled AS 'Status' 
FROM gate_cardassignment gc 
LEFT JOIN gate_persondetails gp on gc.partyid = gp.personDetailId 
LEFT JOIN gate_categorytype gt on gt.categoryId = gc.categoryId$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fn_getGuardianList` ()  NO SQL
select
gp.personDetailId AS 'ID',
CONCAT(gp.familyname,' ', gp.givenname) AS 'User',
gc.categoryname AS 'Type',
ue.contactname AS 'Contact',
ue.contactRelationship AS'Rel',
ue.contactnumber AS 'num'
from user_emergencycontact ue
left join gate_persondetails gp on ue.persondetailid = gp.persondetailid
left join gate_categorytype gc on gc.categoryId = gp.categoryId$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fn_GuardianContactDetails` ()  NO SQL
SELECT 

p.firstName + ' ' + p.lastName as 'Student Name'
,af.guardianFirstName + ' ' + af.guardianLastName as 'Guardian Name'
,af.guardianContact 'Guardian Contact Details' 

FROM person p
left join applicant_family  af on p.personId = af.personId$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fn_ImageGateHistory` ()  NO SQL
select 
pp.image_url AS 'url'
,gh.createDate AS 'TimeIn'
from gate_history gh
left join gate_cardassignment ga on gh.card_id = ga.card_id
left join gate_persondetails gd on gd.persondetailId = ga.partyid
left join gate_personphoto pp on pp.persondetailId = gd.persondetailId
ORDER BY gh.transaction_id DESC
LIMIT 7$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fn_MsgTemplates` ()  NO SQL
select 
messageId AS 'Id',
message_type AS 'Type',
msg_text AS 'Text',
updatedBy As 'By',
updateDate as 'date'
from msg_template$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fn_StudentAbsentList` ()  NO SQL
    COMMENT 'Generate a List of Students that are absent'
select distinct card_id from gate_history
where cast(createdate as date) = cast(now() as date)$$

DELIMITER ;

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

--
-- Truncate table before insert `applicant_family`
--

TRUNCATE TABLE `applicant_family`;
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

--
-- Truncate table before insert `background_table`
--

TRUNCATE TABLE `background_table`;
--
-- Dumping data for table `background_table`
--

INSERT INTO `background_table` (`background_id`, `background_url`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(0, 'ui/photo_library/hd-wallpaper-8.jpg', 'Admin', 'Admin', '2019-08-18 14:37:40', '2019-08-18 20:28:20');

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

--
-- Truncate table before insert `bulknotification_activities`
--

TRUNCATE TABLE `bulknotification_activities`;
--
-- Dumping data for table `bulknotification_activities`
--

INSERT INTO `bulknotification_activities` (`id`, `sms_to`, `message`, `sms_status`, `createdon`, `updatedon`) VALUES
(1, '09072817452', '2019-02-12 08:28:10 , CRUZADO , MARIA ROMINA GARCIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-02-11 23:28:18', '2019-02-11 16:28:10'),
(2, '09072817452', '2019-02-12 08:28:11 , CRUZADO , MARIA ROMINA GARCIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-02-11 23:28:28', '2019-02-11 16:28:11'),
(3, '09072817452', '2019-02-12 08:28:12 , CRUZADO , MARIA ROMINA GARCIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-02-11 23:28:39', '2019-02-11 16:28:12'),
(4, '09072817452', '2019-02-12 08:28:13 , CRUZADO , MARIA ROMINA GARCIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-02-11 23:28:50', '2019-02-11 16:28:13'),
(5, '09072817452', '2019-02-12 08:33:22 , CRUZADO , MARIA ROMINA GARCIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-02-11 23:33:34', '2019-02-11 16:33:22'),
(6, '09072817452', '2019-02-12 08:33:27 , CRUZADO , MARIA ROMINA GARCIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-02-11 23:33:41', '2019-02-11 16:33:27'),
(7, '09072817452', '2019-02-12 08:35:05 , CRUZADO , MARIA ROMINA GARCIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-02-11 23:35:08', '2019-02-11 16:35:05'),
(8, '09072817452', '2019-02-12 08:35:06 , CRUZADO , MARIA ROMINA GARCIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-02-11 23:35:18', '2019-02-11 16:35:06'),
(9, '09175278188', '2019-03-01 15:39:57 , Last , First has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-02-28 23:40:04', '2019-02-28 23:39:57'),
(10, '09175278188', '2019-03-01 15:44:32 , Last , First is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-02-28 23:44:36', '2019-02-28 23:44:33'),
(11, '09175278188', '2019-03-01 15:45:03 , Last , First has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-02-28 23:45:06', '2019-02-28 23:45:03'),
(12, '09072817452', 'Test message', 'Sent', '2019-02-28 23:51:50', '0000-00-00 00:00:00'),
(13, '09175278188', 'Test message', 'Sent', '2019-02-28 23:52:02', '0000-00-00 00:00:00'),
(14, '09305005960', '2019-03-01 16:04:26 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-01 00:04:31', '2019-03-01 00:04:26'),
(15, '09501699196', '2019-03-01 16:06:55 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-01 00:07:04', '2019-03-01 00:06:55'),
(16, '09501699196', '2019-03-01 16:06:59 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-01 00:07:14', '2019-03-01 00:06:59'),
(17, '09072817452', 'HELLO PO! ROBIMAR AND JOMARK ', 'Sent', '2019-03-01 00:11:35', '0000-00-00 00:00:00'),
(18, '09175278188', 'HELLO PO! ROBIMAR AND JOMARK ', 'Sent', '2019-03-01 00:11:46', '0000-00-00 00:00:00'),
(19, '09305005960', 'HELLO PO! ROBIMAR AND JOMARK ', 'Sent', '2019-03-01 00:11:56', '0000-00-00 00:00:00'),
(20, '09501699196', '2019-03-02 08:54:24 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-01 16:54:50', '2019-03-01 16:54:25'),
(21, '09501699196', '2019-03-02 08:56:19 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-01 16:56:28', '2019-03-01 16:56:19'),
(22, '09501699196', '2019-03-02 08:58:48 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-01 16:58:51', '2019-03-01 16:58:48'),
(23, '09501699196', '2019-03-02 09:00:28 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-01 17:00:30', '2019-03-01 17:00:28'),
(24, '09501699196', '2019-03-04 14:01:36 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-03 22:01:38', '2019-03-03 22:01:36'),
(25, '09175278188', '2019-03-06 10:45:41 , Last , First is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 18:45:53', '2019-03-05 18:45:41'),
(26, '09088923007', '2019-03-06 10:55:34 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 18:55:38', '2019-03-05 18:55:34'),
(27, '09088923007', '2019-03-06 10:57:41 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 18:57:50', '2019-03-05 18:57:41'),
(28, '09088923007', '2019-03-06 10:58:22 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 18:58:29', '2019-03-05 18:58:22'),
(29, '09088923007', '2019-03-06 11:14:02 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:14:07', '2019-03-05 19:14:02'),
(30, '09088923007', '2019-03-06 11:20:53 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:20:55', '2019-03-05 19:20:53'),
(31, '09088923007', '2019-03-06 11:33:59 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:34:10', '2019-03-05 19:33:59'),
(32, '09088923007', '2019-03-06 11:34:51 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:34:54', '2019-03-05 19:34:51'),
(33, '09088923007', '2019-03-06 11:35:20 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:35:27', '2019-03-05 19:35:20'),
(34, '09088923007', '2019-03-06 11:35:29 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:35:38', '2019-03-05 19:35:29'),
(35, '09088923007', '2019-03-06 11:35:33 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:35:38', '2019-03-05 19:35:33'),
(36, '09088923007', '2019-03-06 11:35:36 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:35:49', '2019-03-05 19:35:36'),
(37, '09088923007', '2019-03-06 11:36:02 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:36:11', '2019-03-05 19:36:02'),
(38, '09088923007', '2019-03-06 11:36:10 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:36:11', '2019-03-05 19:36:10'),
(39, '09175278188', '2019-03-06 11:36:28 , Last , First has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:36:33', '2019-03-05 19:36:28'),
(40, '09175278188', '2019-03-06 11:37:27 , Last , First is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:37:28', '2019-03-05 19:37:28'),
(41, '09088923007', '2019-03-06 11:37:58 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:38:01', '2019-03-05 19:37:58'),
(42, '09088923007', '2019-03-06 11:38:17 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:38:23', '2019-03-05 19:38:17'),
(43, '09175278188', '2019-03-06 11:38:44 , Last , First has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:38:45', '2019-03-05 19:38:45'),
(44, '09175278188', '2019-03-06 11:40:39 , Last , First is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:40:46', '2019-03-05 19:40:39'),
(45, '09088923007', '2019-03-06 11:45:02 , CRUZADO , MARI ROMINA GARCIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:45:10', '2019-03-05 19:45:02'),
(46, '09088923007', '2019-03-06 11:45:06 , CRUZADO , MARI ROMINA GARCIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:45:10', '2019-03-05 19:45:06'),
(47, '09088923007', '2019-03-06 11:52:08 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:52:19', '2019-03-05 19:52:08'),
(48, '09088923007', '2019-03-06 11:52:11 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:52:19', '2019-03-05 19:52:11'),
(49, '09088923007', '2019-03-06 11:52:17 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:52:30', '2019-03-05 19:52:17'),
(50, '09088923007', '2019-03-06 11:52:19 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:52:30', '2019-03-05 19:52:19'),
(51, '09088923007', '2019-03-06 11:52:22 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:52:41', '2019-03-05 19:52:22'),
(52, '09088923007', '2019-03-06 11:52:39 , CRUZADO , MARI ROMINA GARCIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:52:41', '2019-03-05 19:52:39'),
(53, '09088923007', '2019-03-06 11:53:05 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:53:14', '2019-03-05 19:53:05'),
(54, '09088923007', '2019-03-06 11:53:07 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:53:14', '2019-03-05 19:53:07'),
(55, '09088923007', '2019-03-06 11:53:08 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:53:25', '2019-03-05 19:53:08'),
(56, '09088923007', '2019-03-06 11:53:09 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:53:25', '2019-03-05 19:53:09'),
(57, '09088923007', '2019-03-06 11:53:11 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:53:36', '2019-03-05 19:53:11'),
(58, '09088923007', '2019-03-06 11:53:12 , CRUZADO , MARI ROMINA GARCIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 19:53:36', '2019-03-05 19:53:12'),
(59, '09088923007', '2019-03-06 12:04:42 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-05 20:04:47', '2019-03-05 20:04:42'),
(60, '09088923007', '2019-03-06 12:04:48 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-05 20:04:58', '2019-03-05 20:04:48'),
(61, '09088923007', '2019-03-06 16:49:46 , GARCIA , ROWELL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-06 00:49:46', '2019-03-06 00:49:46'),
(62, '09088923007', '2019-03-06 16:49:51 , GARCIA , ROWELL is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-06 00:49:57', '2019-03-06 00:49:51'),
(63, '09088923007', '2019-03-07 07:51:00 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-06 15:51:06', '2019-03-06 15:51:00'),
(64, '09088923007', '2019-03-07 07:52:39 , GARCIA , ROWELL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-06 15:52:44', '2019-03-06 15:52:39'),
(65, '09088923007', '2019-03-07 07:55:53 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-06 15:56:02', '2019-03-06 15:55:53'),
(66, '09088923007', '2019-03-07 08:05:55 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-06 16:05:56', '2019-03-06 16:05:55'),
(67, '09088923007', '2019-03-07 08:18:50 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-06 16:18:57', '2019-03-06 16:18:50'),
(68, '09088923007', '2019-03-07 08:31:38 , CRUZADO , MARI ROMINA GARCIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-06 16:31:47', '2019-03-06 16:31:38'),
(69, '09088923007', '2019-03-07 08:37:19 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-06 16:37:28', '2019-03-06 16:37:19'),
(70, '09088923007', '2019-03-07 17:30:55 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-07 16:33:13', '2019-03-07 01:30:55'),
(71, '09088923007', '2019-03-07 17:31:08 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-07 16:33:34', '2019-03-07 01:31:09'),
(72, '09088923007', '2019-03-07 17:34:26 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-07 16:33:56', '2019-03-07 01:34:26'),
(73, '09088923007', '2019-03-07 17:48:51 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-07 16:33:59', '2019-03-07 01:48:51'),
(74, '09088923007', '2019-03-08 07:39:44 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-07 16:34:07', '2019-03-07 15:39:44'),
(75, '09088923007', '2019-03-08 07:41:05 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-07 16:34:27', '2019-03-07 15:41:05'),
(76, '09088923007', '2019-03-08 07:43:45 , GARCIA , ROWELL is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-07 16:34:28', '2019-03-07 15:43:45'),
(77, '09088923007', '2019-03-08 07:54:20 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-07 16:34:38', '2019-03-07 15:54:20'),
(78, '09088923007', '2019-03-08 08:01:37 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-07 16:34:48', '2019-03-07 16:01:37'),
(79, '09088923007', '2019-03-08 08:02:00 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-07 16:34:58', '2019-03-07 16:02:00'),
(80, '09088923007', '2019-03-08 08:20:00 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-07 16:35:08', '2019-03-07 16:20:00'),
(81, '09088923007', '2019-03-08 08:22:30 , CRUZADO , MARI ROMINA GARCIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-07 16:35:26', '2019-03-07 16:22:30'),
(82, '09088923007', '2019-03-08 08:58:58 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-07 16:59:13', '2019-03-07 16:58:58'),
(83, '09508491287', 'ANNOUNCEMENT FROM ECST-HR:\r\nThere will be having a General Meeting on March 13, 2019, 3:00 PM at the School Library.\r\nThis is a system generated message. Please do not reply.', 'Sent', '2019-03-07 17:04:09', '0000-00-00 00:00:00'),
(84, '09284842350', 'ANNOUNCEMENT FROM ECST-HR:\r\nThere will be having a General Meeting on March 13, 2019, 3:00 PM at the School Library.\r\nThis is a system generated message. Please do not reply.', 'Sent', '2019-03-07 17:04:18', '0000-00-00 00:00:00'),
(85, '090909090909', 'ANNOUNCEMENT FROM ECST-HR:\r\nThere will be having a General Meeting on March 13, 2019, 3:00 PM at the School Library.\r\nThis is a system generated message. Please do not reply.', 'Sent', '2019-03-07 17:04:28', '0000-00-00 00:00:00'),
(86, '09566237259', 'ANNOUNCEMENT FROM ECST-HR:\r\nThere will be having a General Meeting on March 13, 2019, 3:00 PM at the School Library.\r\nThis is a system generated message. Please do not reply.', 'Sent', '2019-03-07 17:04:39', '0000-00-00 00:00:00'),
(87, '09175278188', 'ANNOUNCEMENT FROM ECST-HR:\r\nThere will be having a General Meeting on March 13, 2019, 3:00 PM at the School Library.\r\nThis is a system generated message. Please do not reply.', 'Sent', '2019-03-07 17:04:48', '0000-00-00 00:00:00'),
(88, '09994050178', 'ANNOUNCEMENT FROM ECST-HR:\r\nThere will be having a General Meeting on March 13, 2019, 3:00 PM at the School Library.\r\nThis is a system generated message. Please do not reply.', 'Sent', '2019-03-07 17:04:58', '0000-00-00 00:00:00'),
(89, '09189428723', 'ANNOUNCEMENT FROM ECST-HR:\r\nThere will be having a General Meeting on March 13, 2019, 3:00 PM at the School Library.\r\nThis is a system generated message. Please do not reply.', 'Sent', '2019-03-07 17:05:08', '0000-00-00 00:00:00'),
(90, '09777811489', 'ANNOUNCEMENT FROM ECST-HR:\r\nThere will be having a General Meeting on March 13, 2019, 3:00 PM at the School Library.\r\nThis is a system generated message. Please do not reply.', 'Sent', '2019-03-07 17:05:19', '0000-00-00 00:00:00'),
(91, '09305005960', 'ANNOUNCEMENT FROM ECST-HR:\r\nThere will be having a General Meeting on March 13, 2019, 3:00 PM at the School Library.\r\nThis is a system generated message. Please do not reply.', 'Sent', '2019-03-07 17:05:29', '0000-00-00 00:00:00'),
(92, '09088923007', '2019-03-08 13:41:38 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-07 21:42:15', '2019-03-07 21:41:38'),
(93, '09088923007', '2019-03-08 15:02:35 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-07 23:02:45', '2019-03-07 23:02:35'),
(94, '09088923007', '2019-03-08 15:02:45 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-07 23:02:51', '2019-03-07 23:02:45'),
(95, '09088923007', '2019-03-08 17:07:01 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-08 01:07:15', '2019-03-08 01:07:02'),
(96, '09088923007', '2019-03-08 17:07:05 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-08 01:07:20', '2019-03-08 01:07:05'),
(97, '09494351323', '2019-03-08 17:07:40 , CRUZADO , MARIA ROMINA GRACIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-08 01:07:42', '2019-03-08 01:07:40'),
(98, '09088923007', '2019-03-08 17:07:47 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-08 01:07:53', '2019-03-08 01:07:47'),
(99, '09088923007', '2019-03-08 17:10:50 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-08 01:11:15', '2019-03-08 01:10:50'),
(100, '09088923007', '2019-03-08 17:21:43 , GARCIA , ROWELL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-08 01:22:01', '2019-03-08 01:21:43'),
(101, '09088923007', '2019-03-08 18:00:03 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-08 02:00:13', '2019-03-08 02:00:03'),
(102, '09088923007', '2019-03-08 18:37:50 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-08 02:38:02', '2019-03-08 02:37:50'),
(103, '09088923007', '2019-03-09 07:25:39 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-08 17:35:12', '2019-03-08 15:25:39'),
(104, '09088923007', '2019-03-09 07:51:05 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-08 17:35:23', '2019-03-08 15:51:05'),
(105, '09088923007', '2019-03-09 07:55:25 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-08 17:35:34', '2019-03-08 15:55:25'),
(106, '09088923007', '2019-03-09 07:55:30 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-08 17:35:45', '2019-03-08 15:55:30'),
(107, '09088923007', '2019-03-09 17:06:47 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-09 01:07:09', '2019-03-09 01:06:47'),
(108, '09088923007', '2019-03-09 18:01:39 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-09 02:02:08', '2019-03-09 02:01:40'),
(109, '09088923007', '2019-03-11 07:26:36 , GARCIA , ROWELL is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-10 15:27:02', '2019-03-10 15:26:36'),
(110, '09088923007', '2019-03-11 07:46:42 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-10 15:47:11', '2019-03-10 15:46:42'),
(111, '09088923007', '2019-03-11 07:50:08 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-10 15:50:39', '2019-03-10 15:50:08'),
(112, '09088923007', '2019-03-11 07:51:26 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-10 15:51:55', '2019-03-10 15:51:26'),
(113, '09088923007', '2019-03-11 07:58:53 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-10 15:59:25', '2019-03-10 15:58:53'),
(114, '09088923007', '2019-03-11 08:07:37 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-10 16:08:01', '2019-03-10 16:07:37'),
(115, '09088923007', '2019-03-11 08:11:08 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-10 16:11:40', '2019-03-10 16:11:08'),
(116, '09088923007', '2019-03-11 08:21:08 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-10 16:21:33', '2019-03-10 16:21:08'),
(117, '09088923007', '2019-03-11 08:37:41 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-10 16:37:52', '2019-03-10 16:37:41'),
(118, '09088923007', '2019-03-11 17:08:32 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-11 01:08:40', '2019-03-11 01:08:32'),
(119, '09494351323', '2019-03-11 17:10:05 , CRUZADO , MARIA ROMINA GRACIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-11 01:10:09', '2019-03-11 01:10:05'),
(120, '09088923007', '2019-03-11 17:10:07 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-11 01:10:18', '2019-03-11 01:10:07'),
(121, '09088923007', '2019-03-11 17:10:15 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-11 01:10:30', '2019-03-11 01:10:15'),
(122, '09088923007', '2019-03-11 17:12:01 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-11 01:12:18', '2019-03-11 01:12:01'),
(123, '09088923007', '2019-03-11 17:15:45 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-11 01:15:50', '2019-03-11 01:15:45'),
(124, '09088923007', '2019-03-11 17:17:07 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-11 01:17:17', '2019-03-11 01:17:07'),
(125, '09088923007', '2019-03-11 17:17:08 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-11 01:17:27', '2019-03-11 01:17:08'),
(126, '09088923007', '2019-03-11 17:53:24 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-11 01:53:35', '2019-03-11 01:53:24'),
(127, '09088923007', '2019-03-12 07:55:13 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-11 15:55:23', '2019-03-11 15:55:13'),
(128, '09088923007', '2019-03-12 07:56:20 , GARCIA , ROWELL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-11 15:56:29', '2019-03-11 15:56:20'),
(129, '09088923007', '2019-03-12 07:58:18 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-11 15:58:30', '2019-03-11 15:58:18'),
(130, '09494351323', '2019-03-12 08:00:48 , CRUZADO , MARIA ROMINA GRACIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-11 16:00:56', '2019-03-11 16:00:48'),
(131, '09088923007', '2019-03-12 08:03:32 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-11 16:03:41', '2019-03-11 16:03:32'),
(132, '09088923007', '2019-03-12 08:14:41 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-11 16:14:45', '2019-03-11 16:14:41'),
(133, '09088923007', '2019-03-12 08:18:35 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-11 16:18:40', '2019-03-11 16:18:35'),
(134, '09088923007', '2019-03-12 08:25:52 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-11 16:26:03', '2019-03-11 16:25:52'),
(135, '09088923007', '2019-03-12 08:32:55 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-11 16:33:05', '2019-03-11 16:32:55'),
(136, '09088923007', '2019-03-13 17:11:58 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:31:52', '2019-03-13 01:11:58'),
(137, '09088923007', '2019-03-13 17:21:52 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:32:02', '2019-03-13 01:21:52'),
(138, '09088923007', '2019-03-13 18:00:12 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:32:12', '2019-03-13 02:00:12'),
(139, '09088923007', '2019-03-13 18:04:43 , GARCIA , ROWELL is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:32:22', '2019-03-13 02:04:43'),
(140, '09088923007', '2019-03-13 18:04:55 , GARCIA , ROWELL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:32:32', '2019-03-13 02:04:55'),
(141, '09088923007', '2019-03-14 07:49:24 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:32:42', '2019-03-13 15:49:24'),
(142, '09088923007', '2019-03-14 07:52:08 , GARCIA , ROWELL is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:32:53', '2019-03-13 15:52:08'),
(143, '09088923007', '2019-03-14 08:35:25 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:33:03', '2019-03-13 16:35:25'),
(144, '09088923007', '2019-03-14 17:04:40 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:33:13', '2019-03-14 01:04:40'),
(145, '09088923007', '2019-03-14 17:04:52 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:33:23', '2019-03-14 01:04:52'),
(146, '09088923007', '2019-03-14 17:05:00 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:33:33', '2019-03-14 01:05:00'),
(147, '09088923007', '2019-03-14 17:05:01 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:33:43', '2019-03-14 01:05:01'),
(148, '09088923007', '2019-03-14 17:05:06 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:33:53', '2019-03-14 01:05:06'),
(149, '09088923007', '2019-03-14 17:05:12 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:34:03', '2019-03-14 01:05:12'),
(150, '09088923007', '2019-03-14 17:06:24 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:34:13', '2019-03-14 01:06:24'),
(151, '09088923007', '2019-03-14 17:06:40 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:34:24', '2019-03-14 01:06:40'),
(152, '09088923007', '2019-03-14 17:10:34 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:34:34', '2019-03-14 01:10:34'),
(153, '09088923007', '2019-03-14 17:23:12 , GARCIA , ROWELL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:34:44', '2019-03-14 01:23:12'),
(154, '09088923007', '2019-03-14 17:23:44 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:34:54', '2019-03-14 01:23:44'),
(155, '09088923007', '2019-03-15 07:56:00 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:35:04', '2019-03-14 15:56:00'),
(156, '09088923007', '2019-03-15 08:00:59 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:35:14', '2019-03-14 16:00:59'),
(157, '09088923007', '2019-03-15 08:03:22 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:35:24', '2019-03-14 16:03:22'),
(158, '09088923007', '2019-03-15 08:08:03 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:35:34', '2019-03-14 16:08:04'),
(159, '09088923007', '2019-03-15 08:18:50 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:35:44', '2019-03-14 16:18:50'),
(160, '09088923007', '2019-03-15 08:20:14 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:35:54', '2019-03-14 16:20:14'),
(161, '09494351323', '2019-03-15 08:28:53 , CRUZADO , MARIA ROMINA GRACIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-14 16:36:05', '2019-03-14 16:28:53'),
(162, '09494351323', '2019-03-15 17:06:46 , CRUZADO , MARIA ROMINA GRACIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-15 01:07:11', '2019-03-15 01:06:46'),
(163, '09088923007', '2019-03-15 17:07:11 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-15 01:07:42', '2019-03-15 01:07:11'),
(164, '09088923007', '2019-03-15 17:07:12 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-15 01:08:04', '2019-03-15 01:07:12'),
(165, '09088923007', '2019-03-15 17:07:14 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-15 01:08:25', '2019-03-15 01:07:14'),
(166, '09088923007', '2019-03-15 17:07:16 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-15 01:08:47', '2019-03-15 01:07:16'),
(167, '09088923007', '2019-03-15 17:07:32 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-15 01:09:08', '2019-03-15 01:07:32'),
(168, '09088923007', '2019-03-15 17:15:21 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-15 01:15:43', '2019-03-15 01:15:21'),
(169, '09088923007', '2019-03-15 17:36:31 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-15 01:37:00', '2019-03-15 01:36:31'),
(170, '09088923007', '2019-03-15 17:45:34 , GARCIA , ROWELL is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-15 01:45:56', '2019-03-15 01:45:34'),
(171, '09088923007', '2019-03-16 07:38:52 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-15 15:39:06', '2019-03-15 15:38:52'),
(172, '09088923007', '2019-03-16 07:49:04 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-15 15:49:07', '2019-03-15 15:49:04'),
(173, '09088923007', '2019-03-16 08:18:29 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-15 16:18:35', '2019-03-15 16:18:29'),
(174, '09088923007', '2019-03-16 08:19:40 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-15 16:19:53', '2019-03-15 16:19:41'),
(175, '09088923007', '2019-03-16 08:31:43 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-15 16:31:51', '2019-03-15 16:31:43'),
(176, '09088923007', '2019-03-18 07:40:33 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-17 16:51:19', '2019-03-17 15:40:33'),
(177, '09088923007', '2019-03-18 07:53:36 , GARCIA , ROWELL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-17 16:51:26', '2019-03-17 15:53:36'),
(178, '09088923007', '2019-03-18 08:07:05 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-17 16:51:39', '2019-03-17 16:07:05'),
(179, '09088923007', '2019-03-18 08:08:42 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-17 16:51:48', '2019-03-17 16:08:42'),
(180, '09088923007', '2019-03-18 08:21:26 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-17 16:51:59', '2019-03-17 16:21:26'),
(181, '09088923007', '2019-03-18 08:25:27 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-17 16:52:12', '2019-03-17 16:25:27'),
(182, '09088923007', '2019-03-18 08:25:29 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-17 16:52:17', '2019-03-17 16:25:29'),
(183, '09088923007', '2019-03-18 08:33:59 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-17 16:52:27', '2019-03-17 16:33:59'),
(184, '09494351323', '2019-03-18 08:35:10 , CRUZADO , MARIA ROMINA GRACIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-17 16:52:45', '2019-03-17 16:35:10'),
(185, '09088923007', '2019-03-18 08:41:37 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-17 16:52:50', '2019-03-17 16:41:37'),
(186, '09088923007', '2019-03-18 17:03:19 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-18 01:03:46', '2019-03-18 01:03:19'),
(187, '09494351323', '2019-03-18 17:06:20 , CRUZADO , MARIA ROMINA GRACIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-18 01:06:49', '2019-03-18 01:06:20'),
(188, '09088923007', '2019-03-18 17:06:46 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-18 01:07:11', '2019-03-18 01:06:46'),
(189, '09088923007', '2019-03-18 17:37:02 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-18 01:37:25', '2019-03-18 01:37:02'),
(190, '09088923007', '2019-03-18 17:46:55 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-18 01:47:22', '2019-03-18 01:46:56'),
(191, '09088923007', '2019-03-18 17:51:55 , GARCIA , ROWELL is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-18 01:52:26', '2019-03-18 01:51:55'),
(192, '09088923007', '2019-03-18 18:01:16 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-18 02:01:42', '2019-03-18 02:01:16'),
(193, '09088923007', '2019-03-19 07:30:15 , GARCIA , ROWELL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-18 15:30:22', '2019-03-18 15:30:15'),
(194, '09088923007', '2019-03-19 08:03:19 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-18 16:03:29', '2019-03-18 16:03:19'),
(195, '09088923007', '2019-03-19 08:04:50 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-18 16:05:00', '2019-03-18 16:04:50'),
(196, '09088923007', '2019-03-19 08:11:22 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-18 16:11:23', '2019-03-18 16:11:22'),
(197, '09088923007', '2019-03-19 08:23:48 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-18 16:23:50', '2019-03-18 16:23:48'),
(198, '09494351323', '2019-03-19 08:23:49 , CRUZADO , MARIA ROMINA GRACIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-18 16:24:00', '2019-03-18 16:23:49'),
(199, '09088923007', '2019-03-19 17:13:43 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-19 01:13:55', '2019-03-19 01:13:43'),
(200, '09088923007', '2019-03-20 08:19:44 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-19 16:20:17', '2019-03-19 16:19:44'),
(201, '09494351323', '2019-03-20 08:34:57 , CRUZADO , MARIA ROMINA GRACIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-19 16:35:06', '2019-03-19 16:34:57'),
(202, '09088923007', '2019-03-20 08:35:11 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-19 16:35:17', '2019-03-19 16:35:11'),
(203, '09088923007', '2019-03-20 08:47:55 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-19 16:48:04', '2019-03-19 16:47:55'),
(204, '09088923007', '2019-03-20 10:00:10 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-19 18:00:14', '2019-03-19 18:00:10'),
(205, '09088923007', '2019-03-20 12:24:52 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-19 20:25:13', '2019-03-19 20:24:52'),
(206, '09494351323', '2019-03-20 17:08:26 , CRUZADO , MARIA ROMINA GRACIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-20 01:08:36', '2019-03-20 01:08:26'),
(207, '09088923007', '2019-03-20 17:12:20 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-20 01:12:31', '2019-03-20 01:12:20'),
(208, '09088923007', '2019-03-20 17:31:30 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-20 01:31:39', '2019-03-20 01:31:30'),
(209, '09088923007', '2019-03-20 17:48:19 , GARCIA , ROWELL is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-20 01:48:29', '2019-03-20 01:48:19'),
(210, '09088923007', '2019-03-20 18:00:21 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-20 02:00:25', '2019-03-20 02:00:21'),
(211, '09088923007', '2019-03-20 18:20:57 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-20 02:21:29', '2019-03-20 02:20:57'),
(212, '09088923007', '2019-03-21 07:48:26 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-20 15:49:28', '2019-03-20 15:48:26'),
(213, '09088923007', '2019-03-21 07:49:54 , GARCIA , ROWELL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-20 15:49:59', '2019-03-20 15:49:54'),
(214, '09088923007', '2019-03-21 08:01:07 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-20 16:01:47', '2019-03-20 16:01:07'),
(215, '09088923007', '2019-03-21 08:03:13 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-20 16:03:19', '2019-03-20 16:03:13'),
(216, '09088923007', '2019-03-21 08:03:51 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-20 16:03:58', '2019-03-20 16:03:51'),
(217, '09088923007', '2019-03-21 08:15:15 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-20 16:15:16', '2019-03-20 16:15:15'),
(218, '09088923007', '2019-03-21 08:18:16 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-20 16:18:17', '2019-03-20 16:18:16'),
(219, '09088923007', '2019-03-21 08:35:57 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-20 16:36:07', '2019-03-20 16:35:57'),
(220, '09088923007', '2019-03-21 09:01:09 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-20 17:01:17', '2019-03-20 17:01:09'),
(221, '09088923007', '2019-03-21 17:10:43 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-21 01:10:55', '2019-03-21 01:10:43'),
(222, '09088923007', '2019-03-21 17:11:53 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-21 01:11:58', '2019-03-21 01:11:53'),
(223, '09088923007', '2019-03-21 17:53:31 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-21 01:53:51', '2019-03-21 01:53:31'),
(224, '09088923007', '2019-03-21 17:56:19 , GARCIA , ROWELL is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-21 01:56:25', '2019-03-21 01:56:19'),
(225, '09088923007', '2019-03-21 17:58:23 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-21 01:58:51', '2019-03-21 01:58:24'),
(226, '09088923007', '2019-03-21 18:51:17 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-21 02:51:51', '2019-03-21 02:51:17'),
(227, '09088923007', '2019-03-22 07:49:31 , GARCIA , ROWELL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-21 15:49:52', '2019-03-21 15:49:31'),
(228, '09088923007', '2019-03-22 08:03:54 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-21 16:04:23', '2019-03-21 16:03:54'),
(229, '09494351323', '2019-03-22 08:07:00 , CRUZADO , MARIA ROMINA GRACIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-21 16:07:05', '2019-03-21 16:07:00'),
(230, '09088923007', '2019-03-22 08:16:09 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-21 16:16:10', '2019-03-21 16:16:09'),
(231, '09088923007', '2019-03-22 08:24:59 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-21 16:25:23', '2019-03-21 16:24:59'),
(232, '09088923007', '2019-03-22 08:39:22 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-21 16:39:53', '2019-03-21 16:39:22'),
(233, '09088923007', '2019-03-25 07:43:10 , GARCIA , ROWELL is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-24 15:43:23', '2019-03-24 15:43:10'),
(234, '09088923007', '2019-03-25 08:10:44 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-24 16:10:54', '2019-03-24 16:10:44'),
(235, '09088923007', '2019-03-25 08:12:12 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-24 16:12:15', '2019-03-24 16:12:12'),
(236, '09088923007', '2019-03-25 08:24:52 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-24 16:24:54', '2019-03-24 16:24:52'),
(237, '09088923007', '2019-03-25 08:29:24 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-24 16:29:32', '2019-03-24 16:29:24'),
(238, '09088923007', '2019-03-25 08:29:39 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-24 16:29:42', '2019-03-24 16:29:39'),
(239, '09088923007', '2019-03-25 08:33:17 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-24 16:33:40', '2019-03-24 16:33:17'),
(240, '09088923007', '2019-03-25 17:05:23 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-25 01:05:32', '2019-03-25 01:05:23'),
(241, '09088923007', '2019-03-26 07:36:29 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-25 15:36:58', '2019-03-25 15:36:29'),
(242, '09088923007', '2019-03-26 07:48:53 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-25 15:49:25', '2019-03-25 15:48:53'),
(243, '09088923007', '2019-03-26 07:50:35 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-25 15:51:03', '2019-03-25 15:50:35'),
(244, '09088923007', '2019-03-26 08:20:53 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-25 16:21:16', '2019-03-25 16:20:53'),
(245, '09088923007', '2019-03-26 08:23:12 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-25 16:23:38', '2019-03-25 16:23:12'),
(246, '09088923007', '2019-03-26 08:38:02 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-25 16:38:28', '2019-03-25 16:38:02'),
(247, '09088923007', '2019-03-26 08:57:06 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-25 16:57:31', '2019-03-25 16:57:06'),
(248, '09088923007', '2019-03-26 10:06:29 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-25 18:06:30', '2019-03-25 18:06:29'),
(249, '09088923007', '2019-03-26 13:23:14 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-25 21:23:38', '2019-03-25 21:23:14'),
(250, '09088923007', '2019-03-26 19:11:17 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-26 03:11:40', '2019-03-26 03:11:17'),
(251, '09088923007', '2019-03-27 07:18:15 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-26 15:18:37', '2019-03-26 15:18:15'),
(252, '09088923007', '2019-03-27 07:46:11 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-26 15:46:33', '2019-03-26 15:46:11'),
(253, '09088923007', '2019-03-27 09:29:04 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-26 17:29:18', '2019-03-26 17:29:04'),
(254, '09508491287', 'Eastwoods ID System', 'Sent', '2019-03-27 01:16:59', '0000-00-00 00:00:00'),
(255, '09284842350', 'Eastwoods ID System', 'Sent', '2019-03-27 01:17:22', '0000-00-00 00:00:00'),
(256, '090909090909', 'Eastwoods ID System', 'Sent', '2019-03-27 01:17:43', '0000-00-00 00:00:00');
INSERT INTO `bulknotification_activities` (`id`, `sms_to`, `message`, `sms_status`, `createdon`, `updatedon`) VALUES
(257, '09566237259', 'Eastwoods ID System', 'Sent', '2019-03-27 01:18:04', '0000-00-00 00:00:00'),
(258, '09063002843', 'Eastwoods ID System', 'Sent', '2019-03-27 01:18:26', '0000-00-00 00:00:00'),
(259, '09994050178', 'Eastwoods ID System', 'Sent', '2019-03-27 01:18:47', '0000-00-00 00:00:00'),
(260, '09189428723', 'Eastwoods ID System', 'Sent', '2019-03-27 01:19:07', '0000-00-00 00:00:00'),
(261, '09328610556', 'Eastwoods ID System', 'Sent', '2019-03-27 01:19:17', '0000-00-00 00:00:00'),
(262, '09777811489', 'Eastwoods ID System', 'Sent', '2019-03-27 01:19:27', '0000-00-00 00:00:00'),
(263, '09072817452', 'Eastwoods ID System', 'Sent', '2019-03-27 01:19:37', '0000-00-00 00:00:00'),
(264, '09305005960', 'Eastwoods ID System', 'Sent', '2019-03-27 01:19:47', '0000-00-00 00:00:00'),
(265, '09088923007', '2019-03-28 08:13:01 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-27 16:13:24', '2019-03-27 16:13:01'),
(266, '09088923007', '2019-03-28 08:14:27 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-27 16:14:51', '2019-03-27 16:14:27'),
(267, '09088923007', '2019-03-28 08:25:01 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-27 16:25:28', '2019-03-27 16:25:01'),
(268, '09088923007', '2019-03-28 08:44:46 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-27 16:45:16', '2019-03-27 16:44:46'),
(269, '09088923007', '2019-03-28 08:44:48 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-27 16:45:37', '2019-03-27 16:44:48'),
(270, '09088923007', '2019-03-28 09:48:11 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-27 17:48:39', '2019-03-27 17:48:11'),
(271, '09088923007', '2019-03-28 18:50:17 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-28 02:50:28', '2019-03-28 02:50:17'),
(272, '09088923007', '2019-03-28 18:50:19 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-28 02:50:39', '2019-03-28 02:50:19'),
(273, '09088923007', '2019-03-29 08:15:48 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-28 16:15:54', '2019-03-28 16:15:49'),
(274, '09088923007', '2019-03-29 08:18:26 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-28 16:18:29', '2019-03-28 16:18:26'),
(275, '09088923007', '2019-03-29 08:30:30 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-28 16:30:35', '2019-03-28 16:30:31'),
(276, '09088923007', '2019-03-29 08:31:37 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-28 16:31:41', '2019-03-28 16:31:37'),
(277, '09088923007', '2019-03-29 17:57:52 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-29 01:58:00', '2019-03-29 01:57:52'),
(278, '09088923007', '2019-03-30 07:20:58 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-29 15:21:06', '2019-03-29 15:20:58'),
(279, '09088923007', '2019-04-01 08:08:59 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-31 16:09:31', '2019-03-31 16:08:59'),
(280, '09088923007', '2019-04-01 08:18:09 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-03-31 16:18:39', '2019-03-31 16:18:09'),
(281, '09088923007', '2019-04-01 08:25:11 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-31 16:25:36', '2019-03-31 16:25:11'),
(282, '09088923007', '2019-04-01 08:46:36 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-03-31 16:47:02', '2019-03-31 16:46:36'),
(283, '09088923007', '2019-04-01 17:08:30 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-01 01:08:55', '2019-04-01 01:08:30'),
(284, '09088923007', '2019-04-01 17:09:04 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-01 01:09:27', '2019-04-01 01:09:04'),
(285, '09088923007', '2019-04-01 17:09:13 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-01 01:09:48', '2019-04-01 01:09:14'),
(286, '09088923007', '2019-04-01 17:09:22 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-01 01:10:09', '2019-04-01 01:09:22'),
(287, '09088923007', '2019-04-01 17:09:26 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-01 01:10:31', '2019-04-01 01:09:26'),
(288, '09088923007', '2019-04-02 09:49:54 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-01 17:50:05', '2019-04-01 17:49:54'),
(289, '09088923007', '2019-04-03 08:08:30 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-02 16:08:56', '2019-04-02 16:08:30'),
(290, '09088923007', '2019-04-03 10:06:26 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-02 18:06:53', '2019-04-02 18:06:26'),
(291, '09088923007', '2019-04-04 07:46:53 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-03 15:47:19', '2019-04-03 15:46:53'),
(292, '09088923007', '2019-04-04 08:55:56 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-03 16:56:04', '2019-04-03 16:55:56'),
(293, '09088923007', '2019-04-04 10:23:02 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-03 18:23:06', '2019-04-03 18:23:02'),
(294, '09088923007', '2019-04-04 10:23:05 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-03 18:23:17', '2019-04-03 18:23:05'),
(295, '09088923007', '2019-04-04 12:08:12 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-03 20:08:17', '2019-04-03 20:08:12'),
(296, '09088923007', '2019-04-05 08:11:53 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-04 16:12:23', '2019-04-04 16:11:53'),
(297, '09088923007', '2019-04-08 15:41:26 , MACARAIG , MEMERTO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-11 17:40:03', '2019-04-07 23:41:26'),
(298, '09088923007', '2019-04-12 08:08:35 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-11 17:40:25', '2019-04-11 16:08:35'),
(299, '09088923007', '2019-04-12 08:18:26 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-11 17:40:38', '2019-04-11 16:18:26'),
(300, '09088923007', '2019-04-12 10:57:38 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-11 18:57:49', '2019-04-11 18:57:38'),
(301, '09088923007', '2019-04-16 08:04:22 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-15 16:04:31', '2019-04-15 16:04:22'),
(302, '09088923007', '2019-04-16 08:09:29 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-15 16:09:43', '2019-04-15 16:09:29'),
(303, '09088923007', '2019-04-16 13:46:42 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-15 21:46:45', '2019-04-15 21:46:42'),
(304, '09088923007', '2019-04-16 13:46:45 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-15 21:46:46', '2019-04-15 21:46:45'),
(305, '09088923007', '2019-04-16 13:46:55 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-15 21:46:57', '2019-04-15 21:46:55'),
(306, '09088923007', '2019-04-16 13:52:12 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-15 21:52:18', '2019-04-15 21:52:12'),
(307, '09088923007', '2019-04-16 13:53:26 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-15 21:53:33', '2019-04-15 21:53:26'),
(308, '09088923007', '2019-04-16 13:54:36 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-15 21:55:02', '2019-04-15 21:54:36'),
(309, '09088923007', '2019-04-16 13:56:13 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-15 21:56:13', '2019-04-15 21:56:13'),
(310, '09088923007', '2019-04-16 13:57:07 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-15 21:57:08', '2019-04-15 21:57:07'),
(311, '09088923007', '2019-04-16 14:04:18 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-15 22:04:29', '2019-04-15 22:04:18'),
(312, '09305005960', '2019-04-22 07:15:35 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-21 15:15:45', '2019-04-21 15:15:35'),
(313, '09088923007', '2019-04-22 08:08:10 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-21 16:08:37', '2019-04-21 16:08:10'),
(314, '09088923007', '2019-04-24 08:19:06 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-24 16:17:24', '2019-04-23 16:19:06'),
(315, '09305005960', '2019-04-25 07:19:59 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-24 16:17:34', '2019-04-24 15:19:59'),
(316, '09088923007', '2019-04-25 08:07:03 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-24 16:17:45', '2019-04-24 16:07:04'),
(317, '09088923007', '2019-04-25 08:14:47 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-24 16:17:56', '2019-04-24 16:14:47'),
(318, '09088923007', '2019-04-25 08:14:48 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-24 16:18:07', '2019-04-24 16:14:48'),
(319, '09088923007', '2019-04-25 08:23:04 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-24 16:23:36', '2019-04-24 16:23:04'),
(320, '09088923007', '2019-04-29 11:27:08 , MACARAIG , MEMERTO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-28 19:39:10', '2019-04-28 19:27:08'),
(321, '09088923007', '2019-04-29 11:27:28 , MACARAIG , MEMERTO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-28 19:39:20', '2019-04-28 19:27:28'),
(322, '09088923007', '2019-04-29 11:27:51 , MACARAIG , MEMERTO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-28 19:39:30', '2019-04-28 19:27:51'),
(323, '09088923007', '2019-04-29 11:30:52 , MACARAIG , MEMERTO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-28 19:39:40', '2019-04-28 19:30:52'),
(324, '09088923007', '2019-04-29 11:32:33 , MACARAIG , MEMERTO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-28 19:39:50', '2019-04-28 19:32:33'),
(325, '09088923007', '2019-04-29 11:33:17 , MACARAIG , MEMERTO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-28 19:40:00', '2019-04-28 19:33:17'),
(326, '09088923007', '2019-04-29 11:37:09 , MACARAIG , MEMERTO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-28 19:40:11', '2019-04-28 19:37:09'),
(327, '09088923007', '2019-04-29 11:44:05 , MACARAIG , MEMERTO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-29 16:47:00', '2019-04-28 19:44:05'),
(328, '09305005960', '2019-04-29 17:01:40 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-29 16:47:10', '2019-04-29 01:01:40'),
(329, '09088923007', '2019-04-29 17:04:04 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-29 16:47:21', '2019-04-29 01:04:04'),
(330, '09088923007', '2019-04-29 17:05:27 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-29 16:47:32', '2019-04-29 01:05:27'),
(331, '09305005960', '2019-04-30 08:47:33 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-04-29 16:47:43', '2019-04-29 16:47:33'),
(332, '09305005960', '2019-04-30 08:48:37 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-04-29 16:48:45', '2019-04-29 16:48:37'),
(333, '09088923007', '2019-05-02 09:09:36 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-01 17:09:58', '2019-05-01 17:09:36'),
(334, '09088923007', '2019-05-03 08:09:14 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-02 16:09:39', '2019-05-02 16:09:14'),
(335, '09088923007', '2019-05-03 08:15:08 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-02 16:15:33', '2019-05-02 16:15:08'),
(336, '09088923007', '2019-05-06 08:05:43 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-05 16:06:07', '2019-05-05 16:05:43'),
(337, '09088923007', '2019-05-06 08:08:37 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-05 16:09:00', '2019-05-05 16:08:37'),
(338, '09305005960', '2019-05-07 07:13:31 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-06 15:13:58', '2019-05-06 15:13:31'),
(339, '09088923007', '2019-05-07 08:14:24 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-06 16:14:52', '2019-05-06 16:14:24'),
(340, '09305005960', '2019-05-08 08:34:54 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-07 16:35:17', '2019-05-07 16:34:54'),
(341, '09088923007', '2019-05-08 10:20:35 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-07 18:20:59', '2019-05-07 18:20:35'),
(342, '09305005960', '2019-05-09 07:31:01 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-08 15:31:28', '2019-05-08 15:31:01'),
(343, '09088923007', '2019-05-09 08:07:39 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-08 16:08:07', '2019-05-08 16:07:39'),
(344, '09088923007', '2019-05-09 08:13:12 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-08 16:13:36', '2019-05-08 16:13:12'),
(345, '09088923007', '2019-05-09 11:08:37 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-08 19:09:07', '2019-05-08 19:08:37'),
(346, '09088923007', '2019-05-09 17:05:07 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-09 01:05:31', '2019-05-09 01:05:07'),
(347, '09305005960', '2019-05-10 07:31:29 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-09 15:31:55', '2019-05-09 15:31:29'),
(348, '09088923007', '2019-05-10 08:12:34 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-09 16:12:58', '2019-05-09 16:12:34'),
(349, '09088923007', '2019-05-10 08:17:37 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-09 16:18:05', '2019-05-09 16:17:37'),
(350, '09088923007', '2019-05-10 08:38:53 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-09 16:39:15', '2019-05-09 16:38:53'),
(351, '09088923007', '2019-05-10 08:40:08 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-09 16:40:34', '2019-05-09 16:40:08'),
(352, '09305005960', '2019-05-14 07:25:34 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-13 15:26:03', '2019-05-13 15:25:35'),
(353, '09088923007', '2019-05-14 07:31:47 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-13 15:32:17', '2019-05-13 15:31:47'),
(354, '09088923007', '2019-05-14 08:29:47 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-13 16:30:12', '2019-05-13 16:29:47'),
(355, '09088923007', '2019-05-15 07:30:00 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-14 15:30:26', '2019-05-14 15:30:01'),
(356, '09305005960', '2019-05-15 07:37:01 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-14 15:37:30', '2019-05-14 15:37:01'),
(357, '09088923007', '2019-05-15 08:29:23 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-14 16:29:51', '2019-05-14 16:29:23'),
(358, '09088923007', '2019-05-15 08:40:14 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-14 16:40:25', '2019-05-14 16:40:14'),
(359, '09088923007', '2019-05-15 08:45:41 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-14 16:45:44', '2019-05-14 16:45:41'),
(360, '09088923007', '2019-05-16 08:32:26 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-16 00:32:28', '2019-05-16 00:32:26'),
(361, '09088923007', '2019-05-16 08:34:00 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-16 00:34:09', '2019-05-16 00:34:00'),
(362, '09088923007', '2019-05-16 08:34:14 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-16 00:34:19', '2019-05-16 00:34:14'),
(363, '09088923007', '2019-05-16 12:54:15 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-16 04:54:21', '2019-05-16 04:54:16'),
(364, '09088923007', '2019-05-20 07:32:35 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-19 23:33:06', '2019-05-19 23:32:35'),
(365, '09088923007', '2019-05-20 08:05:22 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-20 00:05:45', '2019-05-20 00:05:22'),
(366, '09088923007', '2019-05-20 13:25:35 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-20 05:25:39', '2019-05-20 05:25:36'),
(367, '09088923007', '2019-05-20 13:26:07 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-20 05:26:11', '2019-05-20 05:26:07'),
(368, '09175573914', '2019-05-20 13:27:38 , LastTest , FirstTest has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-20 05:27:40', '2019-05-20 05:27:38'),
(369, '09175573914', '2019-05-20 13:27:53 , LastTest , FirstTest is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-20 05:28:00', '2019-05-20 05:27:53'),
(370, '09175573914', '2019-05-20 13:28:10 , LastTest , FirstTest has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-20 05:28:20', '2019-05-20 05:28:10'),
(371, '09175573914', '2019-05-20 13:44:40 , LastTest , FirstTest is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-20 05:44:45', '2019-05-20 05:44:40'),
(372, '09175573914', '2019-05-20 14:26:34 , LastTest , FirstTest has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-20 06:26:38', '2019-05-20 06:26:34'),
(373, '09175573914', '2019-05-20 14:26:58 , LastTest , FirstTest is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-20 06:27:07', '2019-05-20 06:26:58'),
(374, '09175573914', '2019-05-20 14:27:13 , LastTest , FirstTest has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-20 06:27:17', '2019-05-20 06:27:13'),
(375, '09175573914', '2019-05-20 14:28:08 , LastTest , FirstTest is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-20 06:28:18', '2019-05-20 06:28:08'),
(376, '09175573914', '2019-05-20 14:28:49 , LastTest , FirstTest has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-20 06:28:58', '2019-05-20 06:28:49'),
(377, '09175573914', '2019-05-20 14:29:33 , LastTest , FirstTest is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-20 06:29:39', '2019-05-20 06:29:33'),
(378, '09175573914', '2019-05-20 14:34:25 , LastTest , FirstTest has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-20 06:34:32', '2019-05-20 06:34:25'),
(379, '09175573914', '2019-05-20 14:54:19 , LastTest , FirstTest is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-20 06:54:22', '2019-05-20 06:54:19'),
(380, '09175573914', '2019-05-20 14:54:31 , LastTest , FirstTest has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-20 06:54:33', '2019-05-20 06:54:31'),
(381, '09175573914', '2019-05-20 14:55:00 , LastTest , FirstTest is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-20 06:55:06', '2019-05-20 06:55:00'),
(382, '09305005960', '2019-05-21 07:25:13 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-20 23:25:43', '2019-05-20 23:25:13'),
(383, '09088923007', '2019-05-21 08:13:37 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-21 00:13:49', '2019-05-21 00:13:37'),
(384, '09088923007', '2019-05-21 09:01:16 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-21 01:01:46', '2019-05-21 01:01:17'),
(385, '09088923007', '2019-05-21 17:00:18 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-21 09:00:49', '2019-05-21 09:00:18'),
(386, '09088923007', '2019-05-21 17:00:33 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-21 09:01:10', '2019-05-21 09:00:33'),
(387, '09088923007', '2019-05-21 17:00:37 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-21 09:01:32', '2019-05-21 09:00:37'),
(388, '09088923007', '2019-05-21 17:00:44 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-21 09:01:53', '2019-05-21 09:00:44'),
(389, '09088923007', '2019-05-22 17:02:14 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-30 06:50:46', '2019-05-22 09:02:14'),
(390, '09305005960', '2019-05-22 17:02:34 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-30 06:50:55', '2019-05-22 09:02:34'),
(391, '09305005960', '2019-05-23 07:22:43 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-30 06:51:05', '2019-05-22 23:22:43'),
(392, '09088923007', '2019-05-23 08:00:00 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-30 06:51:15', '2019-05-23 00:00:00'),
(393, '09088923007', '2019-05-23 17:04:56 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-30 06:51:26', '2019-05-23 09:04:56'),
(394, '09088923007', '2019-05-27 10:25:34 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-30 06:51:36', '2019-05-27 02:25:34'),
(395, '09088923007', '2019-05-28 07:56:38 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-30 06:51:46', '2019-05-27 23:56:38'),
(396, '09088923007', '2019-05-28 08:01:35 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-30 06:51:56', '2019-05-28 00:01:35'),
(397, '09088923007', '2019-05-28 10:08:31 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-30 06:52:06', '2019-05-28 02:08:31'),
(398, '09088923007', '2019-05-28 12:30:56 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-30 06:52:16', '2019-05-28 04:30:56'),
(399, '09088923007', '2019-05-29 08:03:49 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-30 06:52:26', '2019-05-29 00:03:49'),
(400, '09088923007', '2019-05-29 08:38:52 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-30 06:52:36', '2019-05-29 00:38:52'),
(401, '09088923007', '2019-05-30 08:08:22 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-30 06:52:46', '2019-05-30 00:08:23'),
(402, '09088923007', '2019-05-30 08:12:19 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-30 06:52:57', '2019-05-30 00:12:19'),
(403, '09088923007', '2019-05-30 08:41:54 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-30 06:53:07', '2019-05-30 00:41:54'),
(404, '09088923007', '2019-05-30 15:04:56 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-30 07:04:56', '2019-05-30 07:04:56'),
(405, '09088923007', '2019-05-31 07:42:50 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-30 23:43:15', '2019-05-30 23:42:50'),
(406, '09088923007', '2019-05-31 08:13:19 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-31 00:13:47', '2019-05-31 00:13:19'),
(407, '09088923007', '2019-05-31 08:28:02 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-05-31 00:28:05', '2019-05-31 00:28:02'),
(408, '09088923007', '2019-05-31 08:37:49 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-31 00:37:51', '2019-05-31 00:37:49'),
(409, '09088923007', '2019-05-31 17:29:00 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-05-31 09:29:23', '2019-05-31 09:29:00'),
(410, '09088923007', '2019-06-03 08:03:16 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-03 00:03:42', '2019-06-03 00:03:16'),
(411, '09088923007', '2019-06-03 08:18:44 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-03 00:19:12', '2019-06-03 00:18:44'),
(412, '09088923007', '2019-06-03 08:19:17 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-03 00:19:43', '2019-06-03 00:19:17'),
(413, '09088923007', '2019-06-06 07:52:42 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-05 23:53:05', '2019-06-05 23:52:42'),
(414, '09088923007', '2019-06-06 08:26:53 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-06 00:27:16', '2019-06-06 00:26:53'),
(415, '09088923007', '2019-06-06 17:14:50 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-06 09:15:17', '2019-06-06 09:14:50'),
(416, '09088923007', '2019-06-06 17:14:57 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-06 09:16:21', '2019-06-06 09:14:57'),
(417, '09088923007', '2019-06-06 17:15:08 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-06 09:17:46', '2019-06-06 09:15:08'),
(418, '09088923007', '2019-06-07 08:09:27 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-07 00:09:52', '2019-06-07 00:09:27'),
(419, '09088923007', '2019-06-10 07:55:17 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-09 23:55:46', '2019-06-09 23:55:17'),
(420, '09088923007', '2019-06-10 08:00:38 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-10 00:01:00', '2019-06-10 00:00:38'),
(421, '09305005960', '2019-06-13 17:15:34 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-13 09:15:40', '2019-06-13 09:15:34'),
(422, '09305005960', '2019-06-17 07:26:40 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-18 00:20:43', '2019-06-16 23:26:40'),
(423, '09088923007', '2019-06-17 07:36:24 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-18 00:20:49', '2019-06-16 23:36:24'),
(424, '09088923007', '2019-06-17 08:00:04 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-18 00:20:49', '2019-06-17 00:00:04'),
(425, '09088923007', '2019-06-17 08:09:35 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-18 00:20:53', '2019-06-17 00:09:35'),
(426, '09494351323', '2019-06-17 08:42:55 , CRUZADO , MARIA ROMINA GRACIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-18 00:20:59', '2019-06-17 00:42:55'),
(427, '09088923007', '2019-06-17 08:47:55 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-18 00:21:00', '2019-06-17 00:47:55'),
(428, '09088923007', '2019-06-17 17:05:55 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-18 00:21:03', '2019-06-17 09:05:55'),
(429, '09088923007', '2019-06-17 17:07:51 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-18 00:21:09', '2019-06-17 09:07:51'),
(430, '09088923007', '2019-06-17 17:13:33 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-18 00:21:10', '2019-06-17 09:13:33'),
(431, '09494351323', '2019-06-17 17:14:26 , CRUZADO , MARIA ROMINA GRACIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-18 00:21:13', '2019-06-17 09:14:26'),
(432, '09088923007', '2019-06-18 07:50:19 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-18 00:21:19', '2019-06-17 23:50:19'),
(433, '09088923007', '2019-06-18 07:57:20 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-18 00:21:20', '2019-06-17 23:57:20'),
(434, '09088923007', '2019-06-18 08:03:19 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-18 00:21:23', '2019-06-18 00:03:19'),
(435, '09088923007', '2019-06-18 08:22:45 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-18 00:22:51', '2019-06-18 00:22:45'),
(436, '09494351323', '2019-06-18 08:36:35 , CRUZADO , MARIA ROMINA GRACIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-18 00:36:38', '2019-06-18 00:36:35'),
(437, '09088923007', '2019-06-19 07:29:27 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-18 23:29:30', '2019-06-18 23:29:27'),
(438, '09088923007', '2019-06-19 07:45:54 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-18 23:45:58', '2019-06-18 23:45:54'),
(439, '09088923007', '2019-06-19 08:14:48 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-19 00:15:04', '2019-06-19 00:14:48'),
(440, '09088923007', '2019-06-19 08:35:31 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-19 00:35:37', '2019-06-19 00:35:31'),
(441, '09088923007', '2019-06-19 08:39:47 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-19 00:39:51', '2019-06-19 00:39:47'),
(442, '09494351323', '2019-06-19 08:59:26 , CRUZADO , MARIA ROMINA GRACIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-19 00:59:36', '2019-06-19 00:59:26'),
(443, '09494351323', '2019-06-19 17:06:35 , CRUZADO , MARIA ROMINA GRACIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-19 09:06:44', '2019-06-19 09:06:35'),
(444, '09088923007', '2019-06-19 17:06:51 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-19 09:06:54', '2019-06-19 09:06:51'),
(445, '09088923007', '2019-06-19 17:07:30 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-19 09:07:34', '2019-06-19 09:07:30'),
(446, '09088923007', '2019-06-19 17:20:34 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-19 09:20:44', '2019-06-19 09:20:34'),
(447, '09088923007', '2019-06-20 07:42:10 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-19 23:42:32', '2019-06-19 23:42:10'),
(448, '09088923007', '2019-06-20 07:51:36 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-19 23:51:58', '2019-06-19 23:51:36'),
(449, '09088923007', '2019-06-20 07:52:49 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-19 23:53:10', '2019-06-19 23:52:49'),
(450, '09088923007', '2019-06-20 07:54:18 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-19 23:54:42', '2019-06-19 23:54:18'),
(451, '09088923007', '2019-06-20 08:14:40 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-20 00:15:07', '2019-06-20 00:14:40'),
(452, '09088923007', '2019-06-20 08:24:45 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-20 00:25:14', '2019-06-20 00:24:45'),
(453, '09494351323', '2019-06-20 08:47:05 , CRUZADO , MARIA ROMINA GRACIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-20 00:47:28', '2019-06-20 00:47:05'),
(454, '09996631346', '2019-06-20 12:51:22 , DEL ROSARIO, , FRANCIS has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-20 04:51:29', '2019-06-20 04:51:22'),
(455, '09996631346', '2019-06-20 12:52:35 , DEL ROSARIO, , FRANCIS is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-20 04:52:46', '2019-06-20 04:52:35'),
(456, '09996631346', '2019-06-20 12:52:42 , DEL ROSARIO, , FRANCIS has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-20 04:52:57', '2019-06-20 04:52:42'),
(457, '09494351323', '2019-06-20 17:05:07 , CRUZADO , MARIA ROMINA GRACIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-20 09:05:30', '2019-06-20 09:05:07'),
(458, '09088923007', '2019-06-20 17:05:13 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-20 09:05:51', '2019-06-20 09:05:13'),
(459, '09088923007', '2019-06-20 18:10:18 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-20 10:10:40', '2019-06-20 10:10:18'),
(460, '09088923007', '2019-06-21 07:42:46 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-20 23:43:07', '2019-06-20 23:42:46'),
(461, '09088923007', '2019-06-21 07:47:43 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-20 23:47:52', '2019-06-20 23:47:43'),
(462, '09996631346', '2019-06-21 08:25:05 , DEL ROSARIO, , FRANCIS is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:25:08', '2019-06-21 00:25:05'),
(463, '09972148541', '2019-06-21 08:31:31 , TUMANGUIL , RENZ PAULO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:31:31', '2019-06-21 00:31:31'),
(464, '09432830941', '2019-06-21 08:37:42 , PINEDA , KYLA KATHREEN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:37:47', '2019-06-21 00:37:42'),
(465, '09484224225', '2019-06-21 08:38:15 , VALENCIA , RUSSEL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:38:22', '2019-06-21 00:38:15'),
(466, '09475442728', '2019-06-21 08:38:35 , PEREZ , ANNA MARIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:38:41', '2019-06-21 00:38:35'),
(467, '09389713892', '2019-06-21 08:38:45 , PANES , JIANNE CAMILLE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:38:52', '2019-06-21 00:38:45'),
(468, '09503495846', '2019-06-21 08:38:49 , MALLARI , LAURENCE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:38:55', '2019-06-21 00:38:49'),
(469, '09385810473', '2019-06-21 08:39:05 , PAJARILLO , JEAMAY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:39:05', '2019-06-21 00:39:05'),
(470, '09463035238', '2019-06-21 08:42:30 , DURAN , EVANGELYN  has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:42:34', '2019-06-21 00:42:30'),
(471, '09070582755', '2019-06-21 08:42:36 , TAMAYO , SALLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:42:37', '2019-06-21 00:42:36'),
(472, '09291080952', '2019-06-21 08:42:40 , CATLI , RAYMOND has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:42:44', '2019-06-21 00:42:41'),
(473, '09207118329', '2019-06-21 08:42:43 , CARAIG , MAMERTO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:42:47', '2019-06-21 00:42:43'),
(474, '09103918386', '2019-06-21 08:42:46 , DELOS REYES , ALEXANDER JOHN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:42:54', '2019-06-21 00:42:46'),
(475, '09479465940', '2019-06-21 08:42:49 , BERNAL , JENNIFER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:42:57', '2019-06-21 00:42:49'),
(476, '09397901308', '2019-06-21 08:42:51 , PAMESA , GILBIRT has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:43:04', '2019-06-21 00:42:52'),
(477, '09471415265', '2019-06-21 08:42:54 , SALAZAR , MARK JONES has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:43:07', '2019-06-21 00:42:54'),
(478, '09106883038', '2019-06-21 08:42:57 , GARCIA , KAYCEE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:43:14', '2019-06-21 00:42:57'),
(479, '09277125797', '2019-06-21 08:43:00 , GIGANTE , ANGELICA GRACE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:43:17', '2019-06-21 00:43:00'),
(480, '09183767872', '2019-06-21 08:43:01 , PAGUIO , JHERVIN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:43:24', '2019-06-21 00:43:01'),
(481, '09473251552', '2019-06-21 08:43:03 , PEÑA , MARCK CHRISTIAN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:43:27', '2019-06-21 00:43:03'),
(482, '09053382997', '2019-06-21 08:43:05 , FLORRES , KENNETH CHRISTIAN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:43:34', '2019-06-21 00:43:05'),
(483, '09127624971', '2019-06-21 08:43:06 , ELEN , JONAH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:43:37', '2019-06-21 00:43:06'),
(484, '09213190434', '2019-06-21 08:43:08 , TORRES , JOEMEL ROY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:43:44', '2019-06-21 00:43:08'),
(485, '09071246251', '2019-06-21 08:43:37 , PANTIG , JOSEPH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:43:47', '2019-06-21 00:43:37'),
(486, '09306044042', '2019-06-21 08:43:39 , MARTIN , CAMILLE FRANCE  has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:43:54', '2019-06-21 00:43:39'),
(487, '09121332580', '2019-06-21 08:43:41 , PONCE , NIKKI PAULINE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:43:57', '2019-06-21 00:43:41'),
(488, '09127340912', '2019-06-21 08:44:08 , PARAIS , VERONICA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:44:15', '2019-06-21 00:44:08'),
(489, '09301641464', '2019-06-21 08:44:10 , MAYUYO , ELENA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:44:18', '2019-06-21 00:44:11'),
(490, '09479640918', '2019-06-21 08:44:13 , NAGUIAT , MA. CARMINA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:44:25', '2019-06-21 00:44:13'),
(491, '09565885798', '2019-06-21 08:44:15 , PANLAQUI , HAROLD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:44:27', '2019-06-21 00:44:15'),
(492, '09565885798', '2019-06-21 08:45:17 , PANLAQUI , HAROLD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:45:18', '2019-06-21 00:45:17'),
(493, '09565885798', '2019-06-21 08:45:39 , PANLAQUI , HAROLD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:45:45', '2019-06-21 00:45:39'),
(494, '09565885798', '2019-06-21 08:48:59 , PANLAQUI , HAROLD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:49:04', '2019-06-21 00:49:00'),
(495, '09565885798', '2019-06-21 08:49:14 , PANLAQUI , HAROLD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:49:15', '2019-06-21 00:49:14'),
(496, '09565885798', '2019-06-21 08:49:27 , PANLAQUI , HAROLD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:49:37', '2019-06-21 00:49:27'),
(497, '09479640918', '2019-06-21 08:49:42 , NAGUIAT , MA. CARMINA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:49:48', '2019-06-21 00:49:42'),
(498, '09301641464', '2019-06-21 08:49:59 , MAYUYO , ELENA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:50:10', '2019-06-21 00:49:59'),
(499, '09127340912', '2019-06-21 08:50:17 , PARAIS , VERONICA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:50:21', '2019-06-21 00:50:17'),
(500, '09121332580', '2019-06-21 08:50:20 , PONCE , NIKKI PAULINE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:50:32', '2019-06-21 00:50:20'),
(501, '09306044042', '2019-06-21 08:50:21 , MARTIN , CAMILLE FRANCE  is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:50:43', '2019-06-21 00:50:21'),
(502, '09071246251', '2019-06-21 08:50:23 , PANTIG , JOSEPH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:50:54', '2019-06-21 00:50:23'),
(503, '09213190434', '2019-06-21 08:50:24 , TORRES , JOEMEL ROY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:51:05', '2019-06-21 00:50:24'),
(504, '09127624971', '2019-06-21 08:50:25 , ELEN , JONAH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:51:16', '2019-06-21 00:50:25'),
(505, '09053382997', '2019-06-21 08:50:26 , FLORRES , KENNETH CHRISTIAN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:51:27', '2019-06-21 00:50:26'),
(506, '09473251552', '2019-06-21 08:50:27 , PEÑA , MARCK CHRISTIAN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:51:38', '2019-06-21 00:50:27'),
(507, '09183767872', '2019-06-21 08:50:28 , PAGUIO , JHERVIN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:51:49', '2019-06-21 00:50:28'),
(508, '09277125797', '2019-06-21 08:50:29 , GIGANTE , ANGELICA GRACE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:52:00', '2019-06-21 00:50:29'),
(509, '09106883038', '2019-06-21 08:50:31 , GARCIA , KAYCEE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:52:11', '2019-06-21 00:50:31'),
(510, '09471415265', '2019-06-21 08:50:32 , SALAZAR , MARK JONES is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:52:22', '2019-06-21 00:50:32'),
(511, '09397901308', '2019-06-21 08:50:33 , PAMESA , GILBIRT is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:52:33', '2019-06-21 00:50:33'),
(512, '09479465940', '2019-06-21 08:50:34 , BERNAL , JENNIFER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:52:44', '2019-06-21 00:50:34'),
(513, '09103918386', '2019-06-21 08:50:36 , DELOS REYES , ALEXANDER JOHN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:52:55', '2019-06-21 00:50:36'),
(514, '09207118329', '2019-06-21 08:50:37 , CARAIG , MAMERTO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:53:06', '2019-06-21 00:50:37'),
(515, '09291080952', '2019-06-21 08:50:38 , CATLI , RAYMOND is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:53:17', '2019-06-21 00:50:38');
INSERT INTO `bulknotification_activities` (`id`, `sms_to`, `message`, `sms_status`, `createdon`, `updatedon`) VALUES
(516, '09070582755', '2019-06-21 08:50:39 , TAMAYO , SALLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:53:28', '2019-06-21 00:50:40'),
(517, '09463035238', '2019-06-21 08:50:41 , DURAN , EVANGELYN  is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:53:39', '2019-06-21 00:50:41'),
(518, '09389713892', '2019-06-21 08:50:42 , PANES , JIANNE CAMILLE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:53:50', '2019-06-21 00:50:42'),
(519, '09972148541', '2019-06-21 08:50:43 , TUMANGUIL , RENZ PAULO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:54:01', '2019-06-21 00:50:43'),
(520, '09976733443', '2019-06-21 08:50:44 , MALLARI , LAURENCE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:54:12', '2019-06-21 00:50:45'),
(521, '09385810473', '2019-06-21 08:50:46 , PAJARILLO , JEAMAY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:54:23', '2019-06-21 00:50:46'),
(522, '09475442728', '2019-06-21 08:50:47 , PEREZ , ANNA MARIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:54:34', '2019-06-21 00:50:47'),
(523, '09484224225', '2019-06-21 08:50:48 , VALENCIA , RUSSEL is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:54:45', '2019-06-21 00:50:48'),
(524, '09432830941', '2019-06-21 08:50:50 , PINEDA , KYLA KATHREEN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:54:56', '2019-06-21 00:50:50'),
(525, '09996631346', '2019-06-21 08:50:51 , DEL ROSARIO, , FRANCIS has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-21 00:55:07', '2019-06-21 00:50:51'),
(526, '09305005960', '2019-06-25 07:06:25 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:06:13', '2019-06-24 23:06:26'),
(527, '09207118329', '2019-06-25 07:20:27 , CARAIG , MAMERTO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:06:23', '2019-06-24 23:20:27'),
(528, '09306044042', '2019-06-25 07:26:29 , MARTIN , CAMILLE FRANCE  has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:06:34', '2019-06-24 23:26:29'),
(529, '09565885798', '2019-06-25 07:29:05 , PANLAQUI , HAROLD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:06:45', '2019-06-24 23:29:05'),
(530, '09996631346', '2019-06-25 07:29:27 , DEL ROSARIO, , FRANCIS is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:06:56', '2019-06-24 23:29:27'),
(531, '09088923007', '2019-06-25 07:30:03 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:07:07', '2019-06-24 23:30:03'),
(532, '09121332580', '2019-06-25 07:35:14 , PONCE , NIKKI PAULINE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:07:18', '2019-06-24 23:35:14'),
(533, '09432830941', '2019-06-25 07:38:50 , PINEDA , KYLA KATHREEN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:07:29', '2019-06-24 23:38:50'),
(534, '09471415265', '2019-06-25 07:39:21 , SALAZAR , MARK JONES has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:07:40', '2019-06-24 23:39:21'),
(535, '09976733443', '2019-06-25 07:39:43 , MALLARI , LAURENCE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:07:51', '2019-06-24 23:39:43'),
(536, '09213190434', '2019-06-25 07:39:53 , TORRES , JOEMEL ROY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:08:03', '2019-06-24 23:39:53'),
(537, '09389713892', '2019-06-25 07:41:58 , PANES , JIANNE CAMILLE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:08:17', '2019-06-24 23:41:58'),
(538, '09088923007', '2019-06-25 07:42:39 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:08:25', '2019-06-24 23:42:39'),
(539, '09473251552', '2019-06-25 07:45:16 , PEÑA , MARCK CHRISTIAN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:08:36', '2019-06-24 23:45:16'),
(540, '09127340912', '2019-06-25 07:47:44 , PARAIS , VERONICA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:08:47', '2019-06-24 23:47:44'),
(541, '09070582755', '2019-06-25 07:52:30 , TAMAYO , SALLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:08:58', '2019-06-24 23:52:30'),
(542, '09475442728', '2019-06-25 07:52:39 , PEREZ , ANNA MARIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:09:09', '2019-06-24 23:52:40'),
(543, '09972148541', '2019-06-25 07:56:04 , TUMANGUIL , RENZ PAULO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:09:20', '2019-06-24 23:56:04'),
(544, '09053382997', '2019-06-25 07:56:52 , FLORRES , KENNETH CHRISTIAN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:09:31', '2019-06-24 23:56:52'),
(545, '09088923007', '2019-06-25 07:59:29 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:09:42', '2019-06-24 23:59:29'),
(546, '09277125797', '2019-06-25 08:04:28 , GIGANTE , ANGELICA GRACE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:09:53', '2019-06-25 00:04:28'),
(547, '09291080952', '2019-06-25 08:10:48 , CATLI , RAYMOND has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:10:03', '2019-06-25 00:10:48'),
(548, '09088923007', '2019-06-25 08:11:03 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:10:14', '2019-06-25 00:11:03'),
(549, '09088923007', '2019-06-25 08:39:02 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:10:25', '2019-06-25 00:39:02'),
(550, '09088923007', '2019-06-25 08:39:38 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:10:36', '2019-06-25 00:39:38'),
(551, '09103918386', '2019-06-25 08:44:26 , DELOS REYES , ALEXANDER JOHN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:10:47', '2019-06-25 00:44:26'),
(552, '09183767872', '2019-06-25 08:54:32 , PAGUIO , JHERVIN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:10:58', '2019-06-25 00:54:32'),
(553, '09494351323', '2019-06-25 08:55:22 , CRUZADO , MARIA ROMINA GRACIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:11:09', '2019-06-25 00:55:22'),
(554, '09385810473', '2019-06-25 09:49:41 , PAJARILLO , JEAMAY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:11:21', '2019-06-25 01:49:41'),
(555, '09071246251', '2019-06-25 10:29:50 , PANTIG , JOSEPH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:11:32', '2019-06-25 02:29:50'),
(556, '09207118329', '2019-06-25 16:32:00 , CARAIG , MAMERTO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:11:43', '2019-06-25 08:32:00'),
(557, '09070582755', '2019-06-25 17:02:06 , TAMAYO , SALLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:11:53', '2019-06-25 09:02:06'),
(558, '09389713892', '2019-06-25 17:04:37 , PANES , JIANNE CAMILLE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:12:04', '2019-06-25 09:04:37'),
(559, '09471415265', '2019-06-25 17:04:55 , SALAZAR , MARK JONES is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:12:15', '2019-06-25 09:04:55'),
(560, '09088923007', '2019-06-25 17:04:58 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:12:26', '2019-06-25 09:04:58'),
(561, '09473251552', '2019-06-25 17:05:03 , PEÑA , MARCK CHRISTIAN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:12:37', '2019-06-25 09:05:03'),
(562, '09494351323', '2019-06-25 17:05:42 , CRUZADO , MARIA ROMINA GRACIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:12:48', '2019-06-25 09:05:42'),
(563, '09291080952', '2019-06-25 17:06:00 , CATLI , RAYMOND is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:12:59', '2019-06-25 09:06:00'),
(564, '09053382997', '2019-06-25 17:07:40 , FLORRES , KENNETH CHRISTIAN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:13:11', '2019-06-25 09:07:40'),
(565, '09565885798', '2019-06-25 17:11:26 , PANLAQUI , HAROLD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:13:22', '2019-06-25 09:11:26'),
(566, '09996631346', '2019-06-25 17:16:39 , DEL ROSARIO, , FRANCIS has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:13:32', '2019-06-25 09:16:39'),
(567, '09306044042', '2019-06-25 17:17:30 , MARTIN , CAMILLE FRANCE  is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:13:43', '2019-06-25 09:17:30'),
(568, '09088923007', '2019-06-25 17:22:13 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:13:54', '2019-06-25 09:22:13'),
(569, '09277125797', '2019-06-25 17:22:52 , GIGANTE , ANGELICA GRACE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:14:05', '2019-06-25 09:22:52'),
(570, '09106883038', '2019-06-25 17:23:01 , GARCIA , KAYCEE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:14:17', '2019-06-25 09:23:01'),
(571, '09475442728', '2019-06-25 17:23:20 , PEREZ , ANNA MARIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:14:28', '2019-06-25 09:23:20'),
(572, '09088923007', '2019-06-25 17:24:20 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:14:39', '2019-06-25 09:24:20'),
(573, '09121332580', '2019-06-25 17:24:24 , PONCE , NIKKI PAULINE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:14:49', '2019-06-25 09:24:24'),
(574, '09432830941', '2019-06-25 17:24:27 , PINEDA , KYLA KATHREEN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:15:00', '2019-06-25 09:24:27'),
(575, '09213190434', '2019-06-25 17:52:39 , TORRES , JOEMEL ROY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:15:12', '2019-06-25 09:52:39'),
(576, '09976733443', '2019-06-25 17:54:49 , MALLARI , LAURENCE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:15:23', '2019-06-25 09:54:49'),
(577, '09103918386', '2019-06-25 17:55:50 , DELOS REYES , ALEXANDER JOHN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:15:34', '2019-06-25 09:55:50'),
(578, '09183767872', '2019-06-25 18:03:22 , PAGUIO , JHERVIN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:15:45', '2019-06-25 10:03:22'),
(579, '09127340912', '2019-06-25 18:08:40 , PARAIS , VERONICA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:15:55', '2019-06-25 10:08:40'),
(580, '09463035238', '2019-06-25 18:09:02 , DURAN , EVANGELYN  has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:16:06', '2019-06-25 10:09:02'),
(581, '09972148541', '2019-06-25 18:55:42 , TUMANGUIL , RENZ PAULO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:16:18', '2019-06-25 10:55:42'),
(582, '09385810473', '2019-06-25 19:06:09 , PAJARILLO , JEAMAY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:16:29', '2019-06-25 11:06:09'),
(583, '09088923007', '2019-06-25 19:43:49 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:16:40', '2019-06-25 11:43:49'),
(584, '09088923007', '2019-06-25 20:01:06 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:16:51', '2019-06-25 12:01:06'),
(585, '09071246251', '2019-06-25 20:12:41 , PANTIG , JOSEPH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:17:01', '2019-06-25 12:12:41'),
(586, '09305005960', '2019-06-26 07:10:55 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:17:12', '2019-06-25 23:10:55'),
(587, '09306044042', '2019-06-26 07:17:10 , MARTIN , CAMILLE FRANCE  has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:17:23', '2019-06-25 23:17:10'),
(588, '09479465940', '2019-06-26 07:19:17 , BERNAL , JENNIFER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:17:34', '2019-06-25 23:19:17'),
(589, '09207118329', '2019-06-26 07:19:30 , CARAIG , MAMERTO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:17:45', '2019-06-25 23:19:30'),
(590, '09565885798', '2019-06-26 07:25:44 , PANLAQUI , HAROLD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:17:56', '2019-06-25 23:25:44'),
(591, '09479640918', '2019-06-26 07:30:20 , NAGUIAT , MA. CARMINA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:18:07', '2019-06-25 23:30:21'),
(592, '09471415265', '2019-06-26 07:34:01 , SALAZAR , MARK JONES has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:18:19', '2019-06-25 23:34:01'),
(593, '09127340912', '2019-06-26 07:34:07 , PARAIS , VERONICA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:18:30', '2019-06-25 23:34:07'),
(594, '09127624971', '2019-06-26 07:34:16 , ELEN , JONAH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:18:40', '2019-06-25 23:34:16'),
(595, '09432830941', '2019-06-26 07:35:33 , PINEDA , KYLA KATHREEN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:18:51', '2019-06-25 23:35:33'),
(596, '09389713892', '2019-06-26 07:39:56 , PANES , JIANNE CAMILLE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:19:02', '2019-06-25 23:39:56'),
(597, '09484224225', '2019-06-26 07:40:00 , VALENCIA , RUSSEL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:19:13', '2019-06-25 23:40:00'),
(598, '09996631346', '2019-06-26 07:42:56 , DEL ROSARIO, , FRANCIS is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:19:24', '2019-06-25 23:42:56'),
(599, '09121332580', '2019-06-26 07:45:20 , PONCE , NIKKI PAULINE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:19:35', '2019-06-25 23:45:20'),
(600, '09088923007', '2019-06-26 07:47:52 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:19:47', '2019-06-25 23:47:52'),
(601, '09473251552', '2019-06-26 07:47:57 , PEÑA , MARCK CHRISTIAN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:19:58', '2019-06-25 23:47:57'),
(602, '09213190434', '2019-06-26 07:48:53 , TORRES , JOEMEL ROY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:20:09', '2019-06-25 23:48:53'),
(603, '09070582755', '2019-06-26 07:53:31 , TAMAYO , SALLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:20:19', '2019-06-25 23:53:31'),
(604, '09976733443', '2019-06-26 07:53:36 , MALLARI , LAURENCE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:20:30', '2019-06-25 23:53:36'),
(605, '09053382997', '2019-06-26 07:54:28 , FLORRES , KENNETH CHRISTIAN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:20:41', '2019-06-25 23:54:28'),
(606, '09475442728', '2019-06-26 07:56:17 , PEREZ , ANNA MARIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:20:53', '2019-06-25 23:56:17'),
(607, '09088923007', '2019-06-26 07:57:05 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:21:04', '2019-06-25 23:57:05'),
(608, '09088923007', '2019-06-26 07:57:38 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:21:15', '2019-06-25 23:57:38'),
(609, '09088923007', '2019-06-26 08:00:27 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:21:26', '2019-06-26 00:00:27'),
(610, '09106883038', '2019-06-26 08:02:45 , GARCIA , KAYCEE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:21:37', '2019-06-26 00:02:45'),
(611, '09277125797', '2019-06-26 08:08:16 , GIGANTE , ANGELICA GRACE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:21:47', '2019-06-26 00:08:16'),
(612, '09291080952', '2019-06-26 08:22:34 , CATLI , RAYMOND has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:22:42', '2019-06-26 00:22:34'),
(613, '09088923007', '2019-06-26 08:22:46 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:22:53', '2019-06-26 00:22:46'),
(614, '09972148541', '2019-06-26 08:34:14 , TUMANGUIL , RENZ PAULO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:34:17', '2019-06-26 00:34:14'),
(615, '09088923007', '2019-06-26 08:40:27 , SERRANO , BEVERLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:40:31', '2019-06-26 00:40:27'),
(616, '09183767872', '2019-06-26 08:41:33 , PAGUIO , JHERVIN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:41:36', '2019-06-26 00:41:33'),
(617, '09088923007', '2019-06-26 08:42:00 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:42:09', '2019-06-26 00:42:00'),
(618, '09463035238', '2019-06-26 08:45:43 , DURAN , EVANGELYN  is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:45:50', '2019-06-26 00:45:43'),
(619, '09494351323', '2019-06-26 08:57:50 , CRUZADO , MARIA ROMINA GRACIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 00:57:56', '2019-06-26 00:57:50'),
(620, '09385810473', '2019-06-26 09:40:42 , PAJARILLO , JEAMAY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 01:40:52', '2019-06-26 01:40:42'),
(621, '09301641464', '2019-06-26 09:53:15 , MAYUYO , ELENA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 01:53:20', '2019-06-26 01:53:15'),
(622, '09088923007', '2019-06-26 10:16:27 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 02:16:34', '2019-06-26 02:16:27'),
(623, '09071246251', '2019-06-26 10:45:05 , PANTIG , JOSEPH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 02:45:10', '2019-06-26 02:45:05'),
(624, '09463035238', '2019-06-26 12:14:42 , DURAN , EVANGELYN  has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 04:14:46', '2019-06-26 04:14:42'),
(625, '09463035238', '2019-06-26 12:47:23 , DURAN , EVANGELYN  is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 04:47:23', '2019-06-26 04:47:23'),
(626, '09207118329', '2019-06-26 16:29:56 , CARAIG , MAMERTO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 08:30:18', '2019-06-26 08:29:56'),
(627, '09070582755', '2019-06-26 17:02:54 , TAMAYO , SALLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 09:03:17', '2019-06-26 09:02:54'),
(628, '09494351323', '2019-06-26 17:08:34 , CRUZADO , MARIA ROMINA GRACIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 09:08:57', '2019-06-26 09:08:34'),
(629, '09053382997', '2019-06-26 17:10:48 , FLORRES , KENNETH CHRISTIAN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 09:11:19', '2019-06-26 09:10:48'),
(630, '09473251552', '2019-06-26 17:10:51 , PEÑA , MARCK CHRISTIAN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 09:11:41', '2019-06-26 09:10:52'),
(631, '09471415265', '2019-06-26 17:12:28 , SALAZAR , MARK JONES is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 09:12:56', '2019-06-26 09:12:28'),
(632, '09397901308', '2019-06-26 17:13:42 , PAMESA , GILBIRT has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 09:14:12', '2019-06-26 09:13:42'),
(633, '09088923007', '2019-06-26 17:17:09 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 09:17:40', '2019-06-26 09:17:09'),
(634, '09088923007', '2019-06-26 17:37:23 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 09:37:49', '2019-06-26 09:37:23'),
(635, '09565885798', '2019-06-26 17:41:16 , PANLAQUI , HAROLD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 09:41:39', '2019-06-26 09:41:16'),
(636, '09479640918', '2019-06-26 17:41:26 , NAGUIAT , MA. CARMINA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 09:42:01', '2019-06-26 09:41:26'),
(637, '09088923007', '2019-06-26 17:56:02 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 09:56:28', '2019-06-26 09:56:02'),
(638, '09479465940', '2019-06-26 17:56:33 , BERNAL , JENNIFER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 09:57:00', '2019-06-26 09:56:33'),
(639, '09996631346', '2019-06-26 18:07:47 , DEL ROSARIO, , FRANCIS has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 10:08:10', '2019-06-26 10:07:47'),
(640, '09291080952', '2019-06-26 18:21:58 , CATLI , RAYMOND is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 10:22:27', '2019-06-26 10:21:58'),
(641, '09106883038', '2019-06-26 18:48:54 , GARCIA , KAYCEE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 10:49:23', '2019-06-26 10:48:54'),
(642, '09475442728', '2019-06-26 18:49:02 , PEREZ , ANNA MARIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 10:49:45', '2019-06-26 10:49:02'),
(643, '09389713892', '2019-06-26 19:13:21 , PANES , JIANNE CAMILLE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 11:13:44', '2019-06-26 11:13:21'),
(644, '09183767872', '2019-06-26 19:13:25 , PAGUIO , JHERVIN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 11:14:06', '2019-06-26 11:13:25'),
(645, '09306044042', '2019-06-26 20:01:14 , MARTIN , CAMILLE FRANCE  is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 12:01:44', '2019-06-26 12:01:14'),
(646, '09976733443', '2019-06-26 20:01:21 , MALLARI , LAURENCE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 12:02:06', '2019-06-26 12:01:21'),
(647, '09277125797', '2019-06-26 20:01:29 , GIGANTE , ANGELICA GRACE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 12:02:27', '2019-06-26 12:01:29'),
(648, '09127624971', '2019-06-26 20:01:33 , ELEN , JONAH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 12:02:48', '2019-06-26 12:01:33'),
(649, '09127624971', '2019-06-26 20:01:34 , ELEN , JONAH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 12:03:10', '2019-06-26 12:01:34'),
(650, '09301641464', '2019-06-26 20:01:48 , MAYUYO , ELENA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 12:03:31', '2019-06-26 12:01:48'),
(651, '09972148541', '2019-06-26 20:02:11 , TUMANGUIL , RENZ PAULO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 12:03:52', '2019-06-26 12:02:11'),
(652, '09432830941', '2019-06-26 20:02:18 , PINEDA , KYLA KATHREEN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 12:04:14', '2019-06-26 12:02:18'),
(653, '09121332580', '2019-06-26 20:02:29 , PONCE , NIKKI PAULINE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 12:04:35', '2019-06-26 12:02:29'),
(654, '09127340912', '2019-06-26 20:04:01 , PARAIS , VERONICA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 12:04:56', '2019-06-26 12:04:01'),
(655, '09463035238', '2019-06-26 20:04:12 , DURAN , EVANGELYN  has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 12:05:18', '2019-06-26 12:04:12'),
(656, '09213190434', '2019-06-26 20:04:37 , TORRES , JOEMEL ROY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 12:05:39', '2019-06-26 12:04:37'),
(657, '09071246251', '2019-06-26 20:09:27 , PANTIG , JOSEPH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 12:09:51', '2019-06-26 12:09:27'),
(658, '09207118329', '2019-06-27 07:24:41 , CARAIG , MAMERTO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:25:07', '2019-06-26 23:24:41'),
(659, '09479465940', '2019-06-27 07:25:27 , BERNAL , JENNIFER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:25:50', '2019-06-26 23:25:27'),
(660, '09996631346', '2019-06-27 07:28:03 , DEL ROSARIO, , FRANCIS is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:28:34', '2019-06-26 23:28:03'),
(661, '09088923007', '2019-06-27 07:31:13 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:31:40', '2019-06-26 23:31:13'),
(662, '09471415265', '2019-06-27 07:32:46 , SALAZAR , MARK JONES has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:33:18', '2019-06-26 23:32:46'),
(663, '09213190434', '2019-06-27 07:33:58 , TORRES , JOEMEL ROY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:34:23', '2019-06-26 23:33:58'),
(664, '09127624971', '2019-06-27 07:36:20 , ELEN , JONAH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:36:45', '2019-06-26 23:36:20'),
(665, '09385810473', '2019-06-27 07:39:53 , PAJARILLO , JEAMAY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:40:24', '2019-06-26 23:39:53'),
(666, '09088923007', '2019-06-27 07:40:02 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:40:46', '2019-06-26 23:40:02'),
(667, '09070582755', '2019-06-27 07:40:19 , TAMAYO , SALLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:41:07', '2019-06-26 23:40:19'),
(668, '09432830941', '2019-06-27 07:41:34 , PINEDA , KYLA KATHREEN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:42:01', '2019-06-26 23:41:34'),
(669, '09389713892', '2019-06-27 07:46:00 , PANES , JIANNE CAMILLE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:46:05', '2019-06-26 23:46:00'),
(670, '09106883038', '2019-06-27 07:46:28 , GARCIA , KAYCEE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:46:38', '2019-06-26 23:46:28'),
(671, '09088923007', '2019-06-27 07:49:09 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:49:12', '2019-06-26 23:49:09'),
(672, '09053382997', '2019-06-27 07:50:11 , FLORRES , KENNETH CHRISTIAN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:50:18', '2019-06-26 23:50:11'),
(673, '09484224225', '2019-06-27 07:50:51 , VALENCIA , RUSSEL is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:51:04', '2019-06-26 23:50:51'),
(674, '09088923007', '2019-06-27 07:53:11 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:53:16', '2019-06-26 23:53:11'),
(675, '09127340912', '2019-06-27 07:53:27 , PARAIS , VERONICA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:53:37', '2019-06-26 23:53:28'),
(676, '09475442728', '2019-06-27 07:55:55 , PEREZ , ANNA MARIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-26 23:55:59', '2019-06-26 23:55:55'),
(677, '09565885798', '2019-06-27 08:00:47 , PANLAQUI , HAROLD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 00:01:00', '2019-06-27 00:00:47'),
(678, '09976733443', '2019-06-27 08:01:11 , MALLARI , LAURENCE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 00:01:18', '2019-06-27 00:01:11'),
(679, '09473251552', '2019-06-27 08:01:45 , PEÑA , MARCK CHRISTIAN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 00:01:51', '2019-06-27 00:01:45'),
(680, '09494351323', '2019-06-27 08:15:37 , CRUZADO , MARIA ROMINA GRACIA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 00:15:47', '2019-06-27 00:15:37'),
(681, '09291080952', '2019-06-27 08:18:25 , CATLI , RAYMOND has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 00:18:30', '2019-06-27 00:18:25'),
(682, '09088923007', '2019-06-27 08:18:53 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 00:19:03', '2019-06-27 00:18:53'),
(683, '09088923007', '2019-06-27 08:18:55 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 00:19:14', '2019-06-27 00:18:55'),
(684, '09463035238', '2019-06-27 08:22:19 , DURAN , EVANGELYN  is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 00:22:23', '2019-06-27 00:22:19'),
(685, '09088923007', '2019-06-27 08:34:48 , SERRANO , BEVERLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 00:35:19', '2019-06-27 00:34:48'),
(686, '09183767872', '2019-06-27 08:45:23 , PAGUIO , JHERVIN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 00:45:26', '2019-06-27 00:45:23'),
(687, '09972148541', '2019-06-27 08:54:15 , TUMANGUIL , RENZ PAULO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 00:54:44', '2019-06-27 00:54:15'),
(688, '09277125797', '2019-06-27 09:05:00 , GIGANTE , ANGELICA GRACE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 01:05:31', '2019-06-27 01:05:00'),
(689, '09103918386', '2019-06-27 09:09:00 , DELOS REYES , ALEXANDER JOHN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 01:09:21', '2019-06-27 01:09:00'),
(690, '09301641464', '2019-06-27 10:02:50 , MAYUYO , ELENA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 02:03:12', '2019-06-27 02:02:50'),
(691, '09397901308', '2019-06-27 10:06:38 , PAMESA , GILBIRT is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 02:07:02', '2019-06-27 02:06:38'),
(692, '09463035238', '2019-06-27 12:54:39 , DURAN , EVANGELYN  has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 04:55:10', '2019-06-27 04:54:39'),
(693, '09207118329', '2019-06-27 16:30:33 , CARAIG , MAMERTO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 08:31:02', '2019-06-27 08:30:33'),
(694, '09053382997', '2019-06-27 17:00:48 , FLORRES , KENNETH CHRISTIAN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 09:01:11', '2019-06-27 09:00:48'),
(695, '09471415265', '2019-06-27 17:00:49 , SALAZAR , MARK JONES is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 09:01:32', '2019-06-27 09:00:50'),
(696, '09070582755', '2019-06-27 17:03:41 , TAMAYO , SALLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 09:04:05', '2019-06-27 09:03:41'),
(697, '09306044042', '2019-06-27 17:03:59 , MARTIN , CAMILLE FRANCE  has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 09:04:26', '2019-06-27 09:03:59'),
(698, '09494351323', '2019-06-27 17:05:22 , CRUZADO , MARIA ROMINA GRACIA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 09:05:53', '2019-06-27 09:05:22'),
(699, '09473251552', '2019-06-27 17:06:45 , PEÑA , MARCK CHRISTIAN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 09:07:09', '2019-06-27 09:06:45'),
(700, '09291080952', '2019-06-27 17:07:07 , CATLI , RAYMOND is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 09:07:30', '2019-06-27 09:07:07'),
(701, '09088923007', '2019-06-27 17:10:06 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 09:10:36', '2019-06-27 09:10:06'),
(702, '09088923007', '2019-06-27 17:14:51 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 09:15:21', '2019-06-27 09:14:51'),
(703, '09479465940', '2019-06-27 17:17:02 , BERNAL , JENNIFER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 09:17:32', '2019-06-27 09:17:02'),
(704, '09475442728', '2019-06-27 17:25:33 , PEREZ , ANNA MARIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 09:25:57', '2019-06-27 09:25:33'),
(705, '09106883038', '2019-06-27 17:25:37 , GARCIA , KAYCEE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 09:26:18', '2019-06-27 09:25:37'),
(706, '09432830941', '2019-06-27 17:33:24 , PINEDA , KYLA KATHREEN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 09:33:48', '2019-06-27 09:33:24'),
(707, '09996631346', '2019-06-27 17:33:30 , DEL ROSARIO, , FRANCIS has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 09:34:09', '2019-06-27 09:33:30'),
(708, '09127340912', '2019-06-27 18:00:53 , PARAIS , VERONICA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 10:01:16', '2019-06-27 10:00:53'),
(709, '09088923007', '2019-06-27 18:02:23 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 10:02:54', '2019-06-27 10:02:23'),
(710, '09389713892', '2019-06-27 18:09:20 , PANES , JIANNE CAMILLE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 10:09:51', '2019-06-27 10:09:20'),
(711, '09183767872', '2019-06-27 18:09:45 , PAGUIO , JHERVIN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 10:10:12', '2019-06-27 10:09:45'),
(712, '09484224225', '2019-06-27 18:16:31 , VALENCIA , RUSSEL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 10:16:58', '2019-06-27 10:16:31'),
(713, '09103918386', '2019-06-27 18:23:50 , DELOS REYES , ALEXANDER JOHN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 10:24:15', '2019-06-27 10:23:50'),
(714, '09127624971', '2019-06-27 18:23:54 , ELEN , JONAH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 10:24:36', '2019-06-27 10:23:54'),
(715, '09976733443', '2019-06-27 18:24:03 , MALLARI , LAURENCE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 10:24:58', '2019-06-27 10:24:03'),
(716, '09463035238', '2019-06-27 18:25:02 , DURAN , EVANGELYN  is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 10:25:30', '2019-06-27 10:25:02'),
(717, '09213190434', '2019-06-27 18:25:46 , TORRES , JOEMEL ROY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 10:26:13', '2019-06-27 10:25:46'),
(718, '09385810473', '2019-06-27 19:07:06 , PAJARILLO , JEAMAY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 11:07:38', '2019-06-27 11:07:06'),
(719, '09565885798', '2019-06-27 20:01:07 , PANLAQUI , HAROLD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 12:01:31', '2019-06-27 12:01:07'),
(720, '09972148541', '2019-06-27 20:03:39 , TUMANGUIL , RENZ PAULO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 12:04:04', '2019-06-27 12:03:39'),
(721, '09397901308', '2019-06-27 20:06:37 , PAMESA , GILBIRT has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 12:06:59', '2019-06-27 12:06:37'),
(722, '09301641464', '2019-06-27 20:08:36 , MAYUYO , ELENA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 12:08:59', '2019-06-27 12:08:36'),
(723, '09277125797', '2019-06-27 20:08:45 , GIGANTE , ANGELICA GRACE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 12:09:20', '2019-06-27 12:08:45'),
(724, '09071246251', '2019-06-27 20:12:37 , PANTIG , JOSEPH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 12:12:59', '2019-06-27 12:12:37'),
(725, '09471415265', '2019-06-28 06:58:08 , SALAZAR , MARK JONES has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 22:58:38', '2019-06-27 22:58:08'),
(726, '09213190434', '2019-06-28 06:59:55 , TORRES , JOEMEL ROY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:00:27', '2019-06-27 22:59:55'),
(727, '09306044042', '2019-06-28 07:03:52 , MARTIN , CAMILLE FRANCE  is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:04:17', '2019-06-27 23:03:52'),
(728, '09127340912', '2019-06-28 07:17:47 , PARAIS , VERONICA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:18:12', '2019-06-27 23:17:47'),
(729, '09207118329', '2019-06-28 07:26:41 , CARAIG , MAMERTO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:27:10', '2019-06-27 23:26:41'),
(730, '09207118329', '2019-06-28 07:26:42 , CARAIG , MAMERTO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:27:31', '2019-06-27 23:26:42'),
(731, '09305005960', '2019-06-28 07:27:14 , PEREZ , JOMARK has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:27:53', '2019-06-27 23:27:14'),
(732, '09479640918', '2019-06-28 07:31:49 , NAGUIAT , MA. CARMINA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:32:16', '2019-06-27 23:31:49'),
(733, '09432830941', '2019-06-28 07:37:27 , PINEDA , KYLA KATHREEN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:37:56', '2019-06-27 23:37:27'),
(734, '09996631346', '2019-06-28 07:45:09 , DEL ROSARIO, , FRANCIS is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:45:37', '2019-06-27 23:45:09'),
(735, '09127624971', '2019-06-28 07:45:32 , ELEN , JONAH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:45:58', '2019-06-27 23:45:32'),
(736, '09479465940', '2019-06-28 07:48:43 , BERNAL , JENNIFER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:49:15', '2019-06-27 23:48:43'),
(737, '09088923007', '2019-06-28 07:49:40 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:50:09', '2019-06-27 23:49:40'),
(738, '09301641464', '2019-06-28 07:53:24 , MAYUYO , ELENA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:53:48', '2019-06-27 23:53:24'),
(739, '09088923007', '2019-06-28 07:53:46 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:54:09', '2019-06-27 23:53:46'),
(740, '09070582755', '2019-06-28 07:54:42 , TAMAYO , SALLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:55:14', '2019-06-27 23:54:42'),
(741, '09053382997', '2019-06-28 07:56:28 , FLORRES , KENNETH CHRISTIAN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:56:52', '2019-06-27 23:56:28'),
(742, '09473251552', '2019-06-28 07:57:35 , PEÑA , MARCK CHRISTIAN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-27 23:57:57', '2019-06-27 23:57:35'),
(743, '09463035238', '2019-06-28 07:59:52 , DURAN , EVANGELYN  has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 00:00:19', '2019-06-27 23:59:52'),
(744, '09972148541', '2019-06-28 08:02:20 , TUMANGUIL , RENZ PAULO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 00:02:52', '2019-06-28 00:02:21'),
(745, '09484224225', '2019-06-28 08:02:51 , VALENCIA , RUSSEL is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 00:03:13', '2019-06-28 00:02:51'),
(746, '09976733443', '2019-06-28 08:03:41 , MALLARI , LAURENCE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 00:04:07', '2019-06-28 00:03:41'),
(747, '09565885798', '2019-06-28 08:08:35 , PANLAQUI , HAROLD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 00:09:03', '2019-06-28 00:08:35'),
(748, '09088923007', '2019-06-28 08:11:35 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 00:11:58', '2019-06-28 00:11:35'),
(749, '09106883038', '2019-06-28 08:12:34 , GARCIA , KAYCEE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 00:13:03', '2019-06-28 00:12:34'),
(750, '09475442728', '2019-06-28 08:22:19 , PEREZ , ANNA MARIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 00:22:45', '2019-06-28 00:22:19'),
(751, '09121332580', '2019-06-28 08:22:33 , PONCE , NIKKI PAULINE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 00:23:06', '2019-06-28 00:22:33'),
(752, '09397901308', '2019-06-28 08:23:42 , PAMESA , GILBIRT is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 00:24:11', '2019-06-28 00:23:42'),
(753, '09103918386', '2019-06-28 08:29:58 , DELOS REYES , ALEXANDER JOHN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 00:30:24', '2019-06-28 00:29:58'),
(754, '09088923007', '2019-06-28 08:30:58 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 00:31:29', '2019-06-28 00:30:58'),
(755, '09088923007', '2019-06-28 08:35:35 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 00:36:03', '2019-06-28 00:35:35'),
(756, '09183767872', '2019-06-28 08:42:58 , PAGUIO , JHERVIN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 00:43:22', '2019-06-28 00:42:58'),
(757, '09277125797', '2019-06-28 09:02:53 , GIGANTE , ANGELICA GRACE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 01:03:20', '2019-06-28 01:02:53'),
(758, '09088923007', '2019-06-28 09:51:30 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 01:51:54', '2019-06-28 01:51:30'),
(759, '09385810473', '2019-06-28 09:57:18 , PAJARILLO , JEAMAY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 01:57:45', '2019-06-28 01:57:18'),
(760, '09071246251', '2019-06-28 11:01:05 , PANTIG , JOSEPH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 03:01:32', '2019-06-28 03:01:05'),
(761, '09088923007', '2019-06-28 12:33:53 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 04:34:15', '2019-06-28 04:33:53'),
(762, '09305005960', '2019-06-28 17:16:40 , PEREZ , JOMARK is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:17:11', '2019-06-28 09:16:40'),
(763, '09484224225', '2019-06-28 17:22:26 , VALENCIA , RUSSEL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:22:51', '2019-06-28 09:22:27'),
(764, '09088923007', '2019-06-28 17:24:36 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:25:02', '2019-06-28 09:24:36'),
(765, '09972148541', '2019-06-28 17:26:39 , TUMANGUIL , RENZ PAULO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:27:02', '2019-06-28 09:26:39'),
(766, '09471415265', '2019-06-28 17:27:00 , SALAZAR , MARK JONES is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:27:23', '2019-06-28 09:27:00'),
(767, '09053382997', '2019-06-28 17:35:03 , FLORRES , KENNETH CHRISTIAN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:35:25', '2019-06-28 09:35:03'),
(768, '09473251552', '2019-06-28 17:35:47 , PEÑA , MARCK CHRISTIAN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:36:19', '2019-06-28 09:35:47'),
(769, '09106883038', '2019-06-28 17:38:28 , GARCIA , KAYCEE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:38:52', '2019-06-28 09:38:28');
INSERT INTO `bulknotification_activities` (`id`, `sms_to`, `message`, `sms_status`, `createdon`, `updatedon`) VALUES
(770, '09475442728', '2019-06-28 17:38:42 , PEREZ , ANNA MARIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:39:13', '2019-06-28 09:38:42'),
(771, '09976733443', '2019-06-28 17:39:09 , MALLARI , LAURENCE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:39:34', '2019-06-28 09:39:09'),
(772, '09070582755', '2019-06-28 17:39:17 , TAMAYO , SALLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:39:56', '2019-06-28 09:39:17'),
(773, '09088923007', '2019-06-28 17:39:26 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:40:17', '2019-06-28 09:39:26'),
(774, '09088923007', '2019-06-28 17:43:29 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:43:56', '2019-06-28 09:43:29'),
(775, '09207118329', '2019-06-28 17:50:07 , CARAIG , MAMERTO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:50:31', '2019-06-28 09:50:07'),
(776, '09127624971', '2019-06-28 17:51:19 , ELEN , JONAH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:51:47', '2019-06-28 09:51:19'),
(777, '09479640918', '2019-06-28 17:52:48 , NAGUIAT , MA. CARMINA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:53:14', '2019-06-28 09:52:48'),
(778, '09479465940', '2019-06-28 17:53:31 , BERNAL , JENNIFER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:53:57', '2019-06-28 09:53:31'),
(779, '09121332580', '2019-06-28 17:58:07 , PONCE , NIKKI PAULINE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:58:31', '2019-06-28 09:58:07'),
(780, '09306044042', '2019-06-28 17:58:15 , MARTIN , CAMILLE FRANCE  has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:58:52', '2019-06-28 09:58:15'),
(781, '09432830941', '2019-06-28 17:58:31 , PINEDA , KYLA KATHREEN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:59:13', '2019-06-28 09:58:31'),
(782, '09389713892', '2019-06-28 17:58:56 , PANES , JIANNE CAMILLE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:59:35', '2019-06-28 09:58:56'),
(783, '09996631346', '2019-06-28 17:59:31 , DEL ROSARIO, , FRANCIS has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 09:59:56', '2019-06-28 09:59:31'),
(784, '09183767872', '2019-06-28 17:59:43 , PAGUIO , JHERVIN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 10:00:17', '2019-06-28 09:59:43'),
(785, '09213190434', '2019-06-28 18:04:23 , TORRES , JOEMEL ROY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 10:04:52', '2019-06-28 10:04:23'),
(786, '09277125797', '2019-06-28 18:16:01 , GIGANTE , ANGELICA GRACE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 10:16:24', '2019-06-28 10:16:01'),
(787, '09301641464', '2019-06-28 18:16:09 , MAYUYO , ELENA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 10:16:45', '2019-06-28 10:16:09'),
(788, '09397901308', '2019-06-28 18:23:50 , PAMESA , GILBIRT has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 10:24:15', '2019-06-28 10:23:50'),
(789, '09088923007', '2019-06-28 18:30:22 , CATAPANG  , RUTH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 10:30:50', '2019-06-28 10:30:22'),
(790, '09103918386', '2019-06-28 18:47:42 , DELOS REYES , ALEXANDER JOHN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 10:48:14', '2019-06-28 10:47:42'),
(791, '09127340912', '2019-06-28 19:10:16 , PARAIS , VERONICA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 11:10:46', '2019-06-28 11:10:16'),
(792, '09385810473', '2019-06-28 19:12:02 , PAJARILLO , JEAMAY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 11:12:35', '2019-06-28 11:12:02'),
(793, '09565885798', '2019-06-28 19:12:16 , PANLAQUI , HAROLD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 11:12:56', '2019-06-28 11:12:16'),
(794, '09463035238', '2019-06-28 19:12:19 , DURAN , EVANGELYN  is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 11:13:17', '2019-06-28 11:12:19'),
(795, '09071246251', '2019-06-28 20:00:14 , PANTIG , JOSEPH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 12:00:46', '2019-06-28 12:00:14'),
(796, '09088923007', '2019-06-29 07:46:55 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 23:47:17', '2019-06-28 23:46:55'),
(797, '09972148541', '2019-06-29 07:50:55 , TUMANGUIL , RENZ PAULO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-28 23:51:18', '2019-06-28 23:50:55'),
(798, '09183767872', '2019-06-29 07:54:38 , PAGUIO , JHERVIN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-28 23:55:08', '2019-06-28 23:54:38'),
(799, '09479465940', '2019-06-29 07:59:43 , BERNAL , JENNIFER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-29 00:00:15', '2019-06-28 23:59:43'),
(800, '09088923007', '2019-06-29 08:07:59 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-29 00:08:29', '2019-06-29 00:07:59'),
(801, '09207118329', '2019-06-29 08:09:50 , CARAIG , MAMERTO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-29 00:10:18', '2019-06-29 00:09:50'),
(802, '09088923007', '2019-06-29 08:11:58 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-29 00:12:29', '2019-06-29 00:11:58'),
(803, '09071246251', '2019-06-29 08:16:16 , PANTIG , JOSEPH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-29 00:16:41', '2019-06-29 00:16:16'),
(804, '09484224225', '2019-06-29 08:29:46 , VALENCIA , RUSSEL is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-29 00:30:14', '2019-06-29 00:29:46'),
(805, '09397901308', '2019-06-29 09:23:43 , PAMESA , GILBIRT is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-29 01:24:06', '2019-06-29 01:23:43'),
(806, '09397901308', '2019-06-29 11:59:04 , PAMESA , GILBIRT has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-29 03:59:34', '2019-06-29 03:59:04'),
(807, '09088923007', '2019-06-29 12:00:04 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-06-29 04:00:28', '2019-06-29 04:00:04'),
(808, '09207118329', '2019-06-29 12:15:18 , CARAIG , MAMERTO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-06-29 04:15:40', '2019-06-29 04:15:18'),
(809, '09385810473', '2019-07-03 09:25:15 , PAJARILLO , JEAMAY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-03 01:25:39', '2019-07-03 01:25:15'),
(810, '09071246251', '2019-07-03 10:54:30 , PANTIG , JOSEPH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-03 02:55:01', '2019-07-03 02:54:30'),
(811, '09463035238', '2019-07-03 12:04:38 , DURAN , EVANGELYN  has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-03 04:05:02', '2019-07-03 04:04:38'),
(812, '09106883038', '2019-07-03 12:09:27 , GARCIA , KAYCEE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-03 04:09:58', '2019-07-03 04:09:27'),
(813, '09106883038', '2019-07-03 12:16:02 , GARCIA , KAYCEE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-03 04:16:33', '2019-07-03 04:16:02'),
(814, '09463035238', '2019-07-03 12:55:25 , DURAN , EVANGELYN  is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-03 04:55:56', '2019-07-03 04:55:25'),
(815, '09976733443', '2019-07-03 13:13:37 , MALLARI , LAURENCE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-03 05:14:04', '2019-07-03 05:13:37'),
(816, '09103918386', '2019-07-03 13:14:53 , DELOS REYES , ALEXANDER JOHN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-03 05:15:20', '2019-07-03 05:14:54'),
(817, '09976733443', '2019-07-03 13:52:29 , MALLARI , LAURENCE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-03 05:52:54', '2019-07-03 05:52:29'),
(818, '09207118329', '2019-07-03 16:30:40 , CARAIG , MAMERTO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-03 08:31:02', '2019-07-03 08:30:40'),
(819, '09124064913', '2019-07-03 16:32:40 , MANGALINDAN , MELVIN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-03 08:33:04', '2019-07-03 08:32:40'),
(820, '09185207603', '2019-07-03 16:32:42 , VALENCIA , ARJAY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-03 08:33:25', '2019-07-03 08:32:42'),
(821, '09482774775', '2019-07-03 16:33:04 , SINGIAN , ANGELO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-03 08:33:47', '2019-07-03 08:33:04'),
(822, '09482774775', '2019-07-03 16:33:26 , SINGIAN , ANGELO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-03 08:34:08', '2019-07-03 08:33:26'),
(823, '09053382997', '2019-07-03 17:02:57 , FLORRES , KENNETH CHRISTIAN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-03 09:03:25', '2019-07-03 09:02:57'),
(824, '09088923007', '2019-07-03 17:06:10 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-03 09:06:38', '2019-07-03 09:06:10'),
(825, '09397901308', '2019-07-03 17:06:39 , PAMESA , GILBIRT is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-03 09:07:09', '2019-07-03 09:06:39'),
(826, '09565885798', '2019-07-03 17:06:43 , PANLAQUI , HAROLD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-03 09:07:31', '2019-07-03 09:06:43'),
(827, '09432830941', '2019-07-03 17:07:13 , PINEDA , KYLA KATHREEN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-03 09:07:52', '2019-07-03 09:07:13'),
(828, '09121332580', '2019-07-03 17:07:51 , PONCE , NIKKI PAULINE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-03 09:08:13', '2019-07-03 09:07:51'),
(829, '09473251552', '2019-07-03 17:07:56 , PEÑA , MARCK CHRISTIAN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-03 09:08:35', '2019-07-03 09:07:56'),
(830, '09301641464', '2019-07-04 07:55:31 , MAYUYO , ELENA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-03 23:55:57', '2019-07-03 23:55:31'),
(831, '09088923007', '2019-07-04 07:58:54 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-03 23:59:21', '2019-07-03 23:58:54'),
(832, '09565885798', '2019-07-04 08:00:50 , PANLAQUI , HAROLD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 00:01:13', '2019-07-04 00:00:51'),
(833, '09277125797', '2019-07-04 08:02:57 , GIGANTE , ANGELICA GRACE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 00:03:26', '2019-07-04 00:02:57'),
(834, '09088923007', '2019-07-04 08:07:03 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 00:07:30', '2019-07-04 00:07:03'),
(835, '09475442728', '2019-07-04 08:15:44 , PEREZ , ANNA MARIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 00:16:07', '2019-07-04 00:15:44'),
(836, '09088923007', '2019-07-04 08:35:55 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 00:36:22', '2019-07-04 00:35:55'),
(837, '09291080952', '2019-07-04 08:36:41 , CATLI , RAYMOND has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 00:37:03', '2019-07-04 00:36:41'),
(838, '09463035238', '2019-07-04 08:40:18 , DURAN , EVANGELYN  has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 00:40:46', '2019-07-04 00:40:19'),
(839, '09183767872', '2019-07-04 08:45:32 , PAGUIO , JHERVIN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 00:46:00', '2019-07-04 00:45:32'),
(840, '09088923007', '2019-07-04 08:54:13 , RIGUER , HANS CHRISTIAN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 00:54:36', '2019-07-04 00:54:13'),
(841, '09103918386', '2019-07-04 08:58:03 , DELOS REYES , ALEXANDER JOHN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 00:58:29', '2019-07-04 00:58:04'),
(842, '09071246251', '2019-07-04 10:38:01 , PANTIG , JOSEPH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 02:38:31', '2019-07-04 02:38:01'),
(843, '09207118329', '2019-07-04 16:35:32 , CARAIG , MAMERTO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 08:35:39', '2019-07-04 08:35:32'),
(844, '09306044042', '2019-07-04 16:48:17 , MARTIN , CAMILLE FRANCE  is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 08:48:25', '2019-07-04 08:48:18'),
(845, '09471415265', '2019-07-04 17:01:38 , SALAZAR , MARK JONES has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 09:01:42', '2019-07-04 09:01:38'),
(846, '09053382997', '2019-07-04 17:01:39 , FLORRES , KENNETH CHRISTIAN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 09:01:51', '2019-07-04 09:01:39'),
(847, '09473251552', '2019-07-04 17:04:58 , PEÑA , MARCK CHRISTIAN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 09:05:02', '2019-07-04 09:04:58'),
(848, '09088923007', '2019-07-04 17:10:41 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 09:11:00', '2019-07-04 09:10:41'),
(849, '09088923007', '2019-07-04 17:12:31 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 09:12:53', '2019-07-04 09:12:31'),
(850, '09291080952', '2019-07-04 17:12:34 , CATLI , RAYMOND is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 09:13:14', '2019-07-04 09:12:34'),
(851, '09389713892', '2019-07-04 17:24:23 , PANES , JIANNE CAMILLE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 09:24:51', '2019-07-04 09:24:23'),
(852, '09996631346', '2019-07-04 17:25:11 , DEL ROSARIO, , FRANCIS is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 09:25:33', '2019-07-04 09:25:11'),
(853, '09106883038', '2019-07-04 17:26:02 , GARCIA , KAYCEE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 09:26:25', '2019-07-04 09:26:02'),
(854, '09475442728', '2019-07-04 17:26:28 , PEREZ , ANNA MARIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 09:26:56', '2019-07-04 09:26:28'),
(855, '09121332580', '2019-07-04 17:29:32 , PONCE , NIKKI PAULINE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 09:29:59', '2019-07-04 09:29:32'),
(856, '09432830941', '2019-07-04 17:30:08 , PINEDA , KYLA KATHREEN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 09:30:31', '2019-07-04 09:30:08'),
(857, '09484224225', '2019-07-04 17:35:49 , VALENCIA , RUSSEL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 09:36:15', '2019-07-04 09:35:49'),
(858, '09088923007', '2019-07-04 17:44:20 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 09:44:51', '2019-07-04 09:44:20'),
(859, '09479465940', '2019-07-04 17:54:12 , BERNAL , JENNIFER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 09:54:43', '2019-07-04 09:54:12'),
(860, '09213190434', '2019-07-04 17:56:21 , TORRES , JOEMEL ROY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 09:56:45', '2019-07-04 09:56:21'),
(861, '09127624971', '2019-07-04 17:59:42 , ELEN , JONAH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 10:00:08', '2019-07-04 09:59:42'),
(862, '09127340912', '2019-07-04 18:01:29 , PARAIS , VERONICA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 10:02:00', '2019-07-04 10:01:29'),
(863, '09103918386', '2019-07-04 18:03:44 , DELOS REYES , ALEXANDER JOHN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 10:04:13', '2019-07-04 10:03:45'),
(864, '09479640918', '2019-07-04 18:16:17 , NAGUIAT , MA. CARMINA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 10:16:40', '2019-07-04 10:16:17'),
(865, '09976733443', '2019-07-04 18:17:55 , MALLARI , LAURENCE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 10:18:22', '2019-07-04 10:17:55'),
(866, '09088923007', '2019-07-04 18:36:43 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 10:37:13', '2019-07-04 10:36:43'),
(867, '09183767872', '2019-07-04 18:43:24 , PAGUIO , JHERVIN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 10:43:48', '2019-07-04 10:43:24'),
(868, '09463035238', '2019-07-04 19:16:39 , DURAN , EVANGELYN  is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 11:17:07', '2019-07-04 11:16:39'),
(869, '09385810473', '2019-07-04 19:16:48 , PAJARILLO , JEAMAY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 11:17:29', '2019-07-04 11:16:48'),
(870, '09565885798', '2019-07-04 20:00:09 , PANLAQUI , HAROLD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 12:00:40', '2019-07-04 12:00:09'),
(871, '09277125797', '2019-07-04 20:01:13 , GIGANTE , ANGELICA GRACE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 12:01:42', '2019-07-04 12:01:13'),
(872, '09301641464', '2019-07-04 20:01:15 , MAYUYO , ELENA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 12:02:04', '2019-07-04 12:01:15'),
(873, '09397901308', '2019-07-04 20:01:49 , PAMESA , GILBIRT has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 12:02:25', '2019-07-04 12:01:49'),
(874, '09972148541', '2019-07-04 20:03:32 , TUMANGUIL , RENZ PAULO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 12:03:57', '2019-07-04 12:03:32'),
(875, '09071246251', '2019-07-04 20:04:36 , PANTIG , JOSEPH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 12:04:59', '2019-07-04 12:04:36'),
(876, '09213190434', '2019-07-05 07:05:22 , TORRES , JOEMEL ROY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:05:49', '2019-07-04 23:05:22'),
(877, '09306044042', '2019-07-05 07:07:15 , MARTIN , CAMILLE FRANCE  has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:07:41', '2019-07-04 23:07:15'),
(878, '09207118329', '2019-07-05 07:19:52 , CARAIG , MAMERTO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:20:19', '2019-07-04 23:19:52'),
(879, '09127340912', '2019-07-05 07:25:46 , PARAIS , VERONICA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:26:13', '2019-07-04 23:25:46'),
(880, '09972148541', '2019-07-05 07:26:18 , TUMANGUIL , RENZ PAULO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:26:44', '2019-07-04 23:26:18'),
(881, '09479465940', '2019-07-05 07:28:46 , BERNAL , JENNIFER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:29:17', '2019-07-04 23:28:46'),
(882, '09996631346', '2019-07-05 07:35:41 , DEL ROSARIO, , FRANCIS has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:36:12', '2019-07-04 23:35:41'),
(883, '09479640918', '2019-07-05 07:35:52 , NAGUIAT , MA. CARMINA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:36:33', '2019-07-04 23:35:52'),
(884, '09389713892', '2019-07-05 07:37:52 , PANES , JIANNE CAMILLE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:38:15', '2019-07-04 23:37:52'),
(885, '09432830941', '2019-07-05 07:38:51 , PINEDA , KYLA KATHREEN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:39:17', '2019-07-04 23:38:51'),
(886, '09053382997', '2019-07-05 07:39:59 , FLORRES , KENNETH CHRISTIAN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:40:29', '2019-07-04 23:39:59'),
(887, '09088923007', '2019-07-05 07:40:59 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:41:21', '2019-07-04 23:40:59'),
(888, '09106883038', '2019-07-05 07:47:05 , GARCIA , KAYCEE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:47:35', '2019-07-04 23:47:05'),
(889, '09473251552', '2019-07-05 07:47:59 , PEÑA , MARCK CHRISTIAN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:48:27', '2019-07-04 23:47:59'),
(890, '09976733443', '2019-07-05 07:52:25 , MALLARI , LAURENCE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:52:51', '2019-07-04 23:52:25'),
(891, '09484224225', '2019-07-05 07:52:41 , VALENCIA , RUSSEL is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:53:12', '2019-07-04 23:52:41'),
(892, '09301641464', '2019-07-05 07:53:22 , MAYUYO , ELENA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:53:54', '2019-07-04 23:53:22'),
(893, '09121332580', '2019-07-05 07:53:46 , PONCE , NIKKI PAULINE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:54:15', '2019-07-04 23:53:46'),
(894, '09088923007', '2019-07-05 07:53:49 , QUITO , ROSMIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:54:37', '2019-07-04 23:53:49'),
(895, '09397901308', '2019-07-05 07:57:48 , PAMESA , GILBIRT is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:58:10', '2019-07-04 23:57:48'),
(896, '09463035238', '2019-07-05 07:57:54 , DURAN , EVANGELYN  has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:58:32', '2019-07-04 23:57:55'),
(897, '09088923007', '2019-07-05 07:58:29 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-04 23:58:53', '2019-07-04 23:58:29'),
(898, '09475442728', '2019-07-05 08:00:07 , PEREZ , ANNA MARIE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 00:00:35', '2019-07-05 00:00:07'),
(899, '09088923007', '2019-07-05 08:00:21 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 00:00:57', '2019-07-05 00:00:21'),
(900, '09127624971', '2019-07-05 08:00:36 , ELEN , JONAH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 00:01:18', '2019-07-05 00:00:36'),
(901, '09565885798', '2019-07-05 08:11:07 , PANLAQUI , HAROLD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 00:11:35', '2019-07-05 00:11:07'),
(902, '09291080952', '2019-07-05 08:15:29 , CATLI , RAYMOND has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 00:15:58', '2019-07-05 00:15:29'),
(903, '09088923007', '2019-07-05 08:15:39 , PANGILINAN , JOAHNNA LENE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 00:16:20', '2019-07-05 00:15:39'),
(904, '09277125797', '2019-07-05 08:19:44 , GIGANTE , ANGELICA GRACE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 00:20:13', '2019-07-05 00:19:44'),
(905, '09088923007', '2019-07-05 08:47:35 , CATAPANG  , RUTH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 00:47:58', '2019-07-05 00:47:35'),
(906, '09103918386', '2019-07-05 08:48:18 , DELOS REYES , ALEXANDER JOHN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 00:48:40', '2019-07-05 00:48:18'),
(907, '09183767872', '2019-07-05 09:03:30 , PAGUIO , JHERVIN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 01:03:56', '2019-07-05 01:03:30'),
(908, '09385810473', '2019-07-05 09:21:28 , PAJARILLO , JEAMAY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 01:21:58', '2019-07-05 01:21:28'),
(909, '09088923007', '2019-07-05 09:35:26 , RIGUER , HANS CHRISTIAN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 01:35:56', '2019-07-05 01:35:26'),
(910, '09071246251', '2019-07-05 10:52:02 , PANTIG , JOSEPH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 02:52:26', '2019-07-05 02:52:02'),
(911, '09106883038', '2019-07-05 12:14:33 , GARCIA , KAYCEE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 04:15:01', '2019-07-05 04:14:33'),
(912, '09277125797', '2019-07-05 12:14:37 , GIGANTE , ANGELICA GRACE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 04:15:22', '2019-07-05 04:14:37'),
(913, '09463035238', '2019-07-05 12:49:39 , DURAN , EVANGELYN  is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 04:50:01', '2019-07-05 04:49:39'),
(914, '09277125797', '2019-07-05 16:15:05 , GIGANTE , ANGELICA GRACE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 08:15:17', '2019-07-05 08:15:05'),
(915, '09207118329', '2019-07-05 16:35:30 , CARAIG , MAMERTO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 08:35:36', '2019-07-05 08:35:31'),
(916, '09306044042', '2019-07-05 16:37:06 , MARTIN , CAMILLE FRANCE  is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 08:37:13', '2019-07-05 08:37:06'),
(917, '09070582755', '2019-07-05 16:55:00 , TAMAYO , SALLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 08:55:05', '2019-07-05 08:55:00'),
(918, '09088923007', '2019-07-05 17:02:52 , PANGILINAN , JOAHNNA LENE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:03:17', '2019-07-05 09:02:52'),
(919, '09053382997', '2019-07-05 17:02:54 , FLORRES , KENNETH CHRISTIAN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:03:39', '2019-07-05 09:02:54'),
(920, '09127624971', '2019-07-05 17:05:43 , ELEN , JONAH is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:06:11', '2019-07-05 09:05:43'),
(921, '09473251552', '2019-07-05 17:06:44 , PEÑA , MARCK CHRISTIAN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:07:13', '2019-07-05 09:06:44'),
(922, '09088923007', '2019-07-05 17:09:11 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:09:35', '2019-07-05 09:09:11'),
(923, '09475442728', '2019-07-05 17:11:18 , PEREZ , ANNA MARIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:11:48', '2019-07-05 09:11:18'),
(924, '09479640918', '2019-07-05 17:11:20 , NAGUIAT , MA. CARMINA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:12:09', '2019-07-05 09:11:20'),
(925, '09106883038', '2019-07-05 17:11:27 , GARCIA , KAYCEE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:12:31', '2019-07-05 09:11:27'),
(926, '09976733443', '2019-07-05 17:12:40 , MALLARI , LAURENCE has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:13:02', '2019-07-05 09:12:40'),
(927, '09484224225', '2019-07-05 17:12:44 , VALENCIA , RUSSEL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:13:24', '2019-07-05 09:12:44'),
(928, '09996631346', '2019-07-05 17:14:21 , DEL ROSARIO, , FRANCIS is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:14:46', '2019-07-05 09:14:21'),
(929, '09088923007', '2019-07-05 17:21:49 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:22:11', '2019-07-05 09:21:49'),
(930, '09088923007', '2019-07-05 17:26:28 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:26:55', '2019-07-05 09:26:28'),
(931, '09972148541', '2019-07-05 17:32:17 , TUMANGUIL , RENZ PAULO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:32:47', '2019-07-05 09:32:17'),
(932, '09479465940', '2019-07-05 17:36:32 , BERNAL , JENNIFER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:37:01', '2019-07-05 09:36:32'),
(933, '09432830941', '2019-07-05 17:54:26 , PINEDA , KYLA KATHREEN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:54:51', '2019-07-05 09:54:26'),
(934, '09389713892', '2019-07-05 17:54:46 , PANES , JIANNE CAMILLE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:55:12', '2019-07-05 09:54:46'),
(935, '09121332580', '2019-07-05 17:54:57 , PONCE , NIKKI PAULINE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 09:55:34', '2019-07-05 09:54:57'),
(936, '09183767872', '2019-07-05 17:59:49 , PAGUIO , JHERVIN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 10:00:18', '2019-07-05 09:59:49'),
(937, '09088923007', '2019-07-05 18:01:10 , RIGUER , HANS CHRISTIAN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 10:01:40', '2019-07-05 10:01:10'),
(938, '09301641464', '2019-07-05 18:07:43 , MAYUYO , ELENA is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 10:08:05', '2019-07-05 10:07:43'),
(939, '09127340912', '2019-07-05 18:09:16 , PARAIS , VERONICA has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 10:09:47', '2019-07-05 10:09:17'),
(940, '09213190434', '2019-07-05 18:11:35 , TORRES , JOEMEL ROY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 10:12:00', '2019-07-05 10:11:35'),
(941, '09385810473', '2019-07-05 19:01:47 , PAJARILLO , JEAMAY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 11:02:11', '2019-07-05 11:01:47'),
(942, '09103918386', '2019-07-05 19:15:09 , DELOS REYES , ALEXANDER JOHN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 11:15:39', '2019-07-05 11:15:09'),
(943, '09397901308', '2019-07-05 19:29:12 , PAMESA , GILBIRT has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 11:29:38', '2019-07-05 11:29:12'),
(944, '09463035238', '2019-07-05 20:00:23 , DURAN , EVANGELYN  has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 12:00:45', '2019-07-05 12:00:23'),
(945, '09565885798', '2019-07-05 20:00:38 , PANLAQUI , HAROLD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 12:01:06', '2019-07-05 12:00:38'),
(946, '09071246251', '2019-07-05 20:04:05 , PANTIG , JOSEPH has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-05 12:04:29', '2019-07-05 12:04:05'),
(947, '09291080952', '2019-07-05 20:08:58 , CATLI , RAYMOND is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 12:09:23', '2019-07-05 12:08:58'),
(948, '09471415265', '2019-07-06 07:15:34 , SALAZAR , MARK JONES is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 23:15:59', '2019-07-05 23:15:34'),
(949, '09972148541', '2019-07-06 07:29:36 , TUMANGUIL , RENZ PAULO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 23:29:57', '2019-07-05 23:29:36'),
(950, '09088923007', '2019-07-06 07:29:41 , ARANETA , CHRISTOPHER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 23:30:19', '2019-07-05 23:29:41'),
(951, '09070582755', '2019-07-06 07:41:14 , TAMAYO , SALLY is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 23:41:36', '2019-07-05 23:41:14'),
(952, '09088923007', '2019-07-06 07:51:13 , QUITO , ROSMIE is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 23:51:42', '2019-07-05 23:51:13'),
(953, '09484224225', '2019-07-06 07:57:38 , VALENCIA , RUSSEL is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 23:58:07', '2019-07-05 23:57:38'),
(954, '09088923007', '2019-07-06 07:58:36 , PASCUAL , EMERALD is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 23:58:59', '2019-07-05 23:58:36'),
(955, '09183767872', '2019-07-06 07:58:58 , PAGUIO , JHERVIN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-05 23:59:20', '2019-07-05 23:58:58'),
(956, '09479465940', '2019-07-06 08:08:48 , BERNAL , JENNIFER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-06 00:09:17', '2019-07-06 00:08:48'),
(957, '09088923007', '2019-07-06 08:08:52 , VALENCIA , RAMON is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-06 00:09:39', '2019-07-06 00:08:52'),
(958, '09207118329', '2019-07-06 08:11:11 , CARAIG , MAMERTO is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-06 00:11:41', '2019-07-06 00:11:11'),
(959, '09103918386', '2019-07-06 08:52:43 , DELOS REYES , ALEXANDER JOHN is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-06 00:53:14', '2019-07-06 00:52:43'),
(960, '09397901308', '2019-07-06 09:38:01 , PAMESA , GILBIRT is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-06 01:38:29', '2019-07-06 01:38:01'),
(961, '09996631346', '2019-07-06 12:09:11 , DEL ROSARIO, , FRANCIS has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-06 04:09:40', '2019-07-06 04:09:11'),
(962, '09088923007', '2019-07-06 14:24:14 , ARANETA , CHRISTOPHER has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-06 06:24:42', '2019-07-06 06:24:14'),
(963, '09088923007', '2019-07-06 15:54:10 , VALENCIA , RAMON has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-06 07:54:40', '2019-07-06 07:54:10'),
(964, '09996631346', '2019-07-06 16:06:18 , DEL ROSARIO, , FRANCIS is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-06 08:06:48', '2019-07-06 08:06:18'),
(965, '09484224225', '2019-07-06 16:44:51 , VALENCIA , RUSSEL has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-06 08:45:19', '2019-07-06 08:44:51'),
(966, '09397901308', '2019-07-06 16:49:51 , PAMESA , GILBIRT has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-06 08:50:13', '2019-07-06 08:49:51'),
(967, '09207118329', '2019-07-06 17:00:36 , CARAIG , MAMERTO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-06 09:01:01', '2019-07-06 09:00:36'),
(968, '09070582755', '2019-07-06 17:02:22 , TAMAYO , SALLY has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-06 09:02:53', '2019-07-06 09:02:22'),
(969, '09471415265', '2019-07-06 17:03:02 , SALAZAR , MARK JONES has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-06 09:03:25', '2019-07-06 09:03:02'),
(970, '09972148541', '2019-07-06 17:03:11 , TUMANGUIL , RENZ PAULO has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-06 09:03:46', '2019-07-06 09:03:11'),
(971, '09183767872', '2019-07-06 17:09:57 , PAGUIO , JHERVIN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-06 09:10:21', '2019-07-06 09:09:57'),
(972, '09088923007', '2019-07-06 17:33:14 , PASCUAL , EMERALD has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-06 09:33:44', '2019-07-06 09:33:14'),
(973, '09479465940', '2019-07-06 17:36:10 , BERNAL , JENNIFER is now going outside of the campus premises. This is a system generated message.', 'Sent', '2019-07-06 09:36:37', '2019-07-06 09:36:10'),
(974, '09103918386', '2019-07-06 17:43:15 , DELOS REYES , ALEXANDER JOHN has walked in to the campus premises. This is a system generated message.', 'Sent', '2019-07-06 09:43:42', '2019-07-06 09:43:15');

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

--
-- Truncate table before insert `contactlist`
--

TRUNCATE TABLE `contactlist`;
--
-- Dumping data for table `contactlist`
--

INSERT INTO `contactlist` (`contactlistid`, `contactlist_name`, `isDisabled`, `createdby`, `createdon`, `updatedby`, `updatedon`) VALUES
(1, 'ABM201', 0, 'Admin', '2019-05-20 13:46:09', 'Admin', '2019-05-20 13:46:09');

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

--
-- Truncate table before insert `contactlist_users`
--

TRUNCATE TABLE `contactlist_users`;
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

--
-- Truncate table before insert `course`
--

TRUNCATE TABLE `course`;
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

--
-- Truncate table before insert `gate_cardassignment`
--

TRUNCATE TABLE `gate_cardassignment`;
--
-- Dumping data for table `gate_cardassignment`
--

INSERT INTO `gate_cardassignment` (`assignmentId`, `partyId`, `card_id`, `categoryId`, `createdBy`, `createDate`, `updateDate`, `isDisabled`) VALUES
('08e7bc37-6a2f-11e9-850d-6045cb6ad5d4', '29642907-3fc0-11e9-8886-6045cb6ad5d4', '', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-04-29 11:29:45', '2019-04-29 11:30:12', 0),
('0b6962ce-9d6b-11e9-9a38-6045cb6ad5d4', '03294b0d-9d6b-11e9-9a38-6045cb6ad5d4', '0000877136', '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:17:34', '2019-07-03 16:17:34', 0),
('0c4568fc-9d6d-11e9-9a38-6045cb6ad5d4', '07b80f22-9d6d-11e9-9a38-6045cb6ad5d4', '0000368816', '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:31:54', '2019-07-03 16:31:54', 0),
('0e0789d0-97ef-11e9-9a38-6045cb6ad5d4', '042e1772-97ef-11e9-9a38-6045cb6ad5d4', '0000369714', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-26 16:47:35', '2019-06-26 16:47:35', 0),
('0ff5ce77-932a-11e9-99a7-6045cb6ad5d4', '0bf9498e-932a-11e9-99a7-6045cb6ad5d4', '0015070249', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 15:07:27', '2019-06-20 15:07:27', 0),
('18df18cb-931c-11e9-9281-6045cb6ad5d4', 'f6a84e73-931b-11e9-9281-6045cb6ad5d4', '0000880997', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:27:20', '2019-06-20 13:27:20', 0),
('23f39ea2-6a2f-11e9-850d-6045cb6ad5d4', '2a021b22-3fc0-11e9-8886-6045cb6ad5d4', '', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-04-29 11:30:31', '2019-04-29 11:30:49', 0),
('25944f4e-93bc-11e9-99a7-6045cb6ad5d4', '20572fe1-93bc-11e9-99a7-6045cb6ad5d4', '0015112176', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-21 08:33:10', '2019-06-21 08:33:10', 0),
('3013e0dc-9327-11e9-99a7-6045cb6ad5d4', '18235d66-9327-11e9-99a7-6045cb6ad5d4', '0000378453', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:46:52', '2019-06-20 14:46:52', 0),
('31b388bd-9328-11e9-99a7-6045cb6ad5d4', '1d933f23-9328-11e9-99a7-6045cb6ad5d4', '0000880934', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:54:05', '2019-06-20 14:54:05', 0),
('32ce75f7-9d6c-11e9-9a38-6045cb6ad5d4', '25bbc0fe-9d6c-11e9-9a38-6045cb6ad5d4', '0000370242', '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:25:49', '2019-07-03 16:25:49', 0),
('36daf1f8-9d6a-11e9-9a38-6045cb6ad5d4', '2e3292cb-9d6a-11e9-9a38-6045cb6ad5d4', '0012863079', '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:11:37', '2019-07-03 16:11:37', 0),
('38b87c79-3fbf-11e9-8886-6045cb6ad5d4', '106e504f-3fbf-11e9-8886-6045cb6ad5d4', '0000370381', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-06 11:23:26', '2019-03-06 11:23:26', 0),
('3ae56fe6-9329-11e9-99a7-6045cb6ad5d4', '1e9c64e5-9329-11e9-99a7-6045cb6ad5d4', '0000378592', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 15:01:29', '2019-06-20 15:01:29', 0),
('407d53e9-931a-11e9-9281-6045cb6ad5d4', '1c9cd091-931a-11e9-9281-6045cb6ad5d4', '0000369666', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:14:07', '2019-06-20 13:14:07', 0),
('42c972fc-931d-11e9-9281-6045cb6ad5d4', '26a8380c-931d-11e9-9281-6045cb6ad5d4', '0000368796', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:35:40', '2019-06-20 13:35:40', 0),
('4d9b27c7-3fc0-11e9-8886-6045cb6ad5d4', '2958f0c0-3fc0-11e9-8886-6045cb6ad5d4', '0015511656', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-06 11:31:10', '2019-04-08 15:37:18', 0),
('4f554b36-931b-11e9-9281-6045cb6ad5d4', '1ae4ff53-931b-11e9-9281-6045cb6ad5d4', '0000368797', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:21:42', '2019-06-20 13:21:42', 0),
('59e0dfc4-2e97-11e9-918d-6045cb6ad5d4', '539a33c2-2e97-11e9-918d-6045cb6ad5d4', '0016069034', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-02-12 08:25:32', '2019-02-12 08:25:32', 0),
('642adb67-9329-11e9-99a7-6045cb6ad5d4', '5e9dd2e6-9329-11e9-99a7-6045cb6ad5d4', '0015070280', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 15:02:39', '2019-06-20 15:02:39', 0),
('684dab9a-9d6c-11e9-9a38-6045cb6ad5d4', '641091d1-9d6c-11e9-9a38-6045cb6ad5d4', '0000877103', '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:27:19', '2019-07-03 16:27:19', 0),
('68a3da10-93bc-11e9-99a7-6045cb6ad5d4', '63753b67-93bc-11e9-99a7-6045cb6ad5d4', '0015069576', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-21 08:35:02', '2019-06-21 08:35:02', 0),
('6b4d9efa-932a-11e9-99a7-6045cb6ad5d4', '49a09405-932a-11e9-99a7-6045cb6ad5d4', '0014771794', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 15:10:00', '2019-06-20 15:10:00', 0),
('703b5e32-9328-11e9-99a7-6045cb6ad5d4', '5d7164af-9328-11e9-99a7-6045cb6ad5d4', '0000369628', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:55:49', '2019-06-20 14:55:49', 0),
('7c11e633-931d-11e9-9281-6045cb6ad5d4', '6648a251-931d-11e9-9281-6045cb6ad5d4', '0000378465', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:37:16', '2019-06-20 13:37:16', 0),
('82988cf7-931a-11e9-9281-6045cb6ad5d4', '69d6ea04-931a-11e9-9281-6045cb6ad5d4', '0000378573', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:15:58', '2019-06-20 13:15:58', 0),
('88787d25-9327-11e9-99a7-6045cb6ad5d4', '77b84e8e-9327-11e9-99a7-6045cb6ad5d4', '0000378472', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:49:21', '2019-06-20 14:49:21', 0),
('88fca30d-9d6a-11e9-9a38-6045cb6ad5d4', '8351fcca-9d6a-11e9-9a38-6045cb6ad5d4', '0012862066', '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:13:55', '2019-07-03 16:13:55', 0),
('8b7c6526-59d1-11e9-97d9-6045cb6ad5d4', '6a4c4366-59d1-11e9-97d9-6045cb6ad5d4', '', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-04-08 15:40:15', '2019-06-20 13:20:57', 0),
('8ecebc2b-3fba-11e9-8886-6045cb6ad5d4', '646abb14-3fba-11e9-8886-6045cb6ad5d4', '0015511669', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-06 10:50:03', '2019-04-16 14:04:43', 0),
('9d75803e-3bf8-11e9-8886-6045cb6ad5d4', '825d1f20-3bf8-11e9-8886-6045cb6ad5d4', '0015704390', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-01 16:04:13', '2019-03-01 16:04:13', 0),
('a33975cb-93bc-11e9-99a7-6045cb6ad5d4', '9ec97cd8-93bc-11e9-99a7-6045cb6ad5d4', '0000378575', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-21 08:36:41', '2019-06-21 08:36:41', 0),
('a60d5437-3fbc-11e9-8886-6045cb6ad5d4', '9e210acd-3fbc-11e9-8886-6045cb6ad5d4', '0000369343', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-06 11:05:01', '2019-03-06 11:05:01', 0),
('ae99dece-9329-11e9-99a7-6045cb6ad5d4', '999e8f31-9329-11e9-99a7-6045cb6ad5d4', '0015070191', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 15:04:44', '2019-06-20 15:04:44', 0),
('aeb6b618-3fbf-11e9-8886-6045cb6ad5d4', 'a809fd68-3fbf-11e9-8886-6045cb6ad5d4', '0012863058', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-06 11:26:44', '2019-03-06 11:26:44', 0),
('b101c094-9316-11e9-9281-6045cb6ad5d4', '90dc0ff5-9316-11e9-9281-6045cb6ad5d4', '0000368593', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 12:48:38', '2019-06-20 12:48:38', 0),
('b4310696-9d6c-11e9-9a38-6045cb6ad5d4', 'acb782cd-9d6c-11e9-9a38-6045cb6ad5d4', '0000378477', '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:29:26', '2019-07-03 16:29:26', 0),
('b55fdd20-9d6b-11e9-9a38-6045cb6ad5d4', 'ae905ca1-9d6b-11e9-9a38-6045cb6ad5d4', '0000369557', '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:22:19', '2019-07-03 16:22:19', 0),
('b5977b24-9328-11e9-99a7-6045cb6ad5d4', 'a131f3f4-9328-11e9-99a7-6045cb6ad5d4', '0000880942', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:57:46', '2019-06-20 14:57:46', 0),
('bcb31799-93bb-11e9-99a7-6045cb6ad5d4', 'af0389a4-93bb-11e9-99a7-6045cb6ad5d4', '0000378553', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-21 08:30:14', '2019-06-21 08:30:14', 0),
('bd4502f1-4164-11e9-8886-6045cb6ad5d4', 'ad684a81-4164-11e9-8886-6045cb6ad5d4', '0015704523', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-08 13:40:42', '2019-03-08 13:40:42', 0),
('cb0ce7f5-3fec-11e9-8886-6045cb6ad5d4', '99dd3381-3fec-11e9-8886-6045cb6ad5d4', '0015492140', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-06 16:49:38', '2019-03-06 16:49:38', 0),
('cbd07cfb-931d-11e9-9281-6045cb6ad5d4', 'a5403234-931d-11e9-9281-6045cb6ad5d4', '0000880884', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:39:29', '2019-06-20 13:39:29', 0),
('cc23ce35-931b-11e9-9281-6045cb6ad5d4', 'b10bd7ba-931b-11e9-9281-6045cb6ad5d4', '0015706324', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:25:11', '2019-06-20 13:25:11', 0),
('ccd738e7-9d6a-11e9-9a38-6045cb6ad5d4', 'c3fb3e2c-9d6a-11e9-9a38-6045cb6ad5d4', '0012862077', '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:15:49', '2019-07-03 16:15:49', 0),
('cdbce759-9327-11e9-99a7-6045cb6ad5d4', 'adf17405-9327-11e9-99a7-6045cb6ad5d4', '0000880939', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:51:17', '2019-06-20 14:51:17', 0),
('d5af9faf-931a-11e9-9281-6045cb6ad5d4', 'b6a81760-931a-11e9-9281-6045cb6ad5d4', '0000369680', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:18:17', '2019-06-20 13:18:17', 0),
('db38c830-931c-11e9-9281-6045cb6ad5d4', 'c36d570d-931c-11e9-9281-6045cb6ad5d4', '0000368574', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:32:46', '2019-06-21 08:39:57', 0),
('e8c0b650-9326-11e9-99a7-6045cb6ad5d4', 'd2da8a77-9326-11e9-99a7-6045cb6ad5d4', '0000880928', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:44:53', '2019-06-20 14:44:53', 0),
('eb6e35b8-9329-11e9-99a7-6045cb6ad5d4', 'd4b8c6b4-9329-11e9-99a7-6045cb6ad5d4', '0015069609', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 15:06:26', '2019-06-20 15:06:26', 0),
('ede6de71-9328-11e9-99a7-6045cb6ad5d4', 'da6fca34-9328-11e9-99a7-6045cb6ad5d4', '0000368605', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:59:20', '2019-06-20 14:59:20', 0),
('f100e448-3bf3-11e9-8886-6045cb6ad5d4', 'de78ba06-3bf3-11e9-8886-6045cb6ad5d4', '0015704381', '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-01 15:30:45', '2019-03-01 15:30:45', 0),
('f633f6fc-9327-11e9-99a7-6045cb6ad5d4', 'f129a2b7-9327-11e9-99a7-6045cb6ad5d4', '0000369608', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:52:25', '2019-06-20 14:52:25', 0),
('f67b3dc9-9d6b-11e9-9a38-6045cb6ad5d4', 'f14fc0ba-9d6b-11e9-9a38-6045cb6ad5d4', '0000370640', '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:24:08', '2019-07-03 16:24:08', 0),
('f9b7f6ce-7abf-11e9-90b1-6045cb6ad5d4', '7b256e4f-7abf-11e9-90b1-6045cb6ad5d4', '0016214400', '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-05-20 13:27:33', '2019-05-20 14:26:29', 0),
('fa18457d-3bf8-11e9-8886-6045cb6ad5d4', 'e0d43f9c-3bf8-11e9-8886-6045cb6ad5d4', '0012890960', '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-01 16:06:48', '2019-04-22 07:15:25', 0);

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
-- Truncate table before insert `gate_categorytype`
--

TRUNCATE TABLE `gate_categorytype`;
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

--
-- Truncate table before insert `gate_coursetype`
--

TRUNCATE TABLE `gate_coursetype`;
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

--
-- Truncate table before insert `gate_history`
--

TRUNCATE TABLE `gate_history`;
--
-- Dumping data for table `gate_history`
--

INSERT INTO `gate_history` (`transaction_id`, `card_id`, `createDate`, `gate_id`) VALUES
(1, '0016069034', '2019-02-12 08:27:03', 'GTONE'),
(2, '0016069034', '2019-02-12 08:28:10', 'GTONE'),
(3, '0016069034', '2019-02-12 08:28:11', 'GTONE'),
(4, '0016069034', '2019-02-12 08:28:12', 'GTONE'),
(5, '0016069034', '2019-02-12 08:28:13', 'GTONE'),
(6, '0016069034', '2019-02-12 08:33:22', 'GTONE'),
(7, '0016069034', '2019-02-12 08:33:27', 'GTONE'),
(8, '0016069034', '2019-02-12 08:35:05', 'GTONE'),
(9, '0016069034', '2019-02-12 08:35:06', 'GTONE'),
(10, '0015704381', '2019-03-01 15:36:04', 'GTONE'),
(11, '0015704381', '2019-03-01 15:36:46', 'GTONE'),
(12, '0015704381', '2019-03-01 15:39:57', 'GTONE'),
(13, '0015704381', '2019-03-01 15:44:32', 'GTONE'),
(14, '0015704381', '2019-03-01 15:45:03', 'GTONE'),
(15, '0015704390', '2019-03-01 16:04:26', 'GTONE'),
(16, '0012890960', '2019-03-01 16:06:55', 'GTONE'),
(17, '0012890960', '2019-03-01 16:06:59', 'GTONE'),
(18, '0012890960', '2019-03-02 08:54:24', 'GTONE'),
(19, '0012890960', '2019-03-02 08:56:19', 'GTONE'),
(20, '0012890960', '2019-03-02 08:58:48', 'GTONE'),
(21, '0012890960', '2019-03-02 09:00:27', 'GTONE'),
(22, '0012890960', '2019-03-04 14:01:36', 'GTONE'),
(23, '0015704381', '2019-03-06 10:45:41', 'GTONE'),
(24, '0015511669', '2019-03-06 10:52:20', 'GTONE'),
(25, '0015511669', '2019-03-06 10:55:34', 'GTONE'),
(26, '0015511669', '2019-03-06 10:57:41', 'GTONE'),
(27, '0015704390', '2019-03-06 10:58:22', 'GTONE'),
(28, '0000369343', '2019-03-06 11:14:01', 'GTONE'),
(29, '0000369343', '2019-03-06 11:20:52', 'GTONE'),
(30, '0012863058', '2019-03-06 11:23:45', 'GTONE'),
(31, '0015704390', '2019-03-06 11:33:59', 'GTONE'),
(32, '0015704390', '2019-03-06 11:34:51', 'GTONE'),
(33, '0015511656', '2019-03-06 11:35:20', 'GTONE'),
(34, '0012863058', '2019-03-06 11:35:29', 'GTONE'),
(35, '0000370381', '2019-03-06 11:35:33', 'GTONE'),
(36, '0000369343', '2019-03-06 11:35:36', 'GTONE'),
(37, '0015511656', '2019-03-06 11:36:02', 'GTONE'),
(38, '0000370381', '2019-03-06 11:36:10', 'GTONE'),
(39, '0015704381', '2019-03-06 11:36:28', 'GTONE'),
(40, '0015704381', '2019-03-06 11:37:27', 'GTONE'),
(41, '0012863058', '2019-03-06 11:37:58', 'GTONE'),
(42, '0000369343', '2019-03-06 11:38:17', 'GTONE'),
(43, '0015704523', '2019-03-06 11:38:40', 'GTONE'),
(44, '0015492140', '2019-03-06 11:38:41', 'GTONE'),
(45, '0015704381', '2019-03-06 11:38:44', 'GTONE'),
(46, '0015704381', '2019-03-06 11:40:39', 'GTONE'),
(47, '0015704381', '2019-03-06 11:45:02', 'GTONE'),
(48, '0015704381', '2019-03-06 11:45:06', 'GTONE'),
(49, '0015704390', '2019-03-06 11:52:08', 'GTONE'),
(50, '0015511656', '2019-03-06 11:52:11', 'GTONE'),
(51, '0000370381', '2019-03-06 11:52:17', 'GTONE'),
(52, '0012863058', '2019-03-06 11:52:19', 'GTONE'),
(53, '0000369343', '2019-03-06 11:52:22', 'GTONE'),
(54, '0015704381', '2019-03-06 11:52:38', 'GTONE'),
(55, '0015704390', '2019-03-06 11:53:05', 'GTONE'),
(56, '0015511656', '2019-03-06 11:53:06', 'GTONE'),
(57, '0000370381', '2019-03-06 11:53:08', 'GTONE'),
(58, '0012863058', '2019-03-06 11:53:09', 'GTONE'),
(59, '0000369343', '2019-03-06 11:53:11', 'GTONE'),
(60, '0015704381', '2019-03-06 11:53:12', 'GTONE'),
(61, '0012863058', '2019-03-06 12:04:41', 'GTONE'),
(62, '0012863058', '2019-03-06 12:04:48', 'GTONE'),
(63, '0015492140', '2019-03-06 15:56:47', 'GTONE'),
(64, '0015492140', '2019-03-06 15:56:51', 'GTONE'),
(65, '0015492140', '2019-03-06 15:56:55', 'GTONE'),
(66, '0015492140', '2019-03-06 16:49:45', 'GTONE'),
(67, '0015492140', '2019-03-06 16:49:51', 'GTONE'),
(68, '0012890960', '2019-03-07 07:51:00', 'GTONE'),
(69, '0015492140', '2019-03-07 07:52:39', 'GTONE'),
(70, '0000370381', '2019-03-07 07:55:52', 'GTONE'),
(71, '0015704390', '2019-03-07 08:05:55', 'GTONE'),
(72, '0015511656', '2019-03-07 08:18:50', 'GTONE'),
(73, '0015704381', '2019-03-07 08:31:38', 'GTONE'),
(74, '0000369343', '2019-03-07 08:37:18', 'GTONE'),
(75, '0012890960', '2019-03-07 17:30:55', 'GTONE'),
(76, '0015511669', '2019-03-07 17:31:08', 'GTONE'),
(77, '0015511656', '2019-03-07 17:34:26', 'GTONE'),
(78, '0015704390', '2019-03-07 17:48:51', 'GTONE'),
(79, ' 001551166', '2019-03-08 07:34:38', 'GTONE'),
(80, '0015511669', '2019-03-08 07:39:44', 'GTONE'),
(81, '0012890960', '2019-03-08 07:41:05', 'GTONE'),
(82, '0015492140', '2019-03-08 07:43:44', 'GTONE'),
(83, '0000370381', '2019-03-08 07:54:20', 'GTONE'),
(84, '0015704390', '2019-03-08 08:01:37', 'GTONE'),
(85, '0015704390', '2019-03-08 08:02:00', 'GTONE'),
(86, '0015511656', '2019-03-08 08:19:59', 'GTONE'),
(87, '0015704381', '2019-03-08 08:22:29', 'GTONE'),
(88, '0012863058', '2019-03-08 08:58:58', 'GTONE'),
(89, '0015704523', '2019-03-08 13:41:38', 'GTONE'),
(90, '0015511669', '2019-03-08 15:02:35', 'GTONE'),
(91, '0015511669', '2019-03-08 15:02:45', 'GTONE'),
(92, '0012890960', '2019-03-08 17:07:01', 'GTONE'),
(93, '0015704390', '2019-03-08 17:07:05', 'GTONE'),
(94, '0015704381', '2019-03-08 17:07:40', 'GTONE'),
(95, '0015511669', '2019-03-08 17:07:47', 'GTONE'),
(96, '0000370381', '2019-03-08 17:10:49', 'GTONE'),
(97, '0015492140', '2019-03-08 17:21:43', 'GTONE'),
(98, '0015511656', '2019-03-08 18:00:03', 'GTONE'),
(99, '0015704523', '2019-03-08 18:37:50', 'GTONE'),
(100, '0012890960', '2019-03-09 07:25:39', 'GTONE'),
(101, '0000370381', '2019-03-09 07:51:05', 'GTONE'),
(102, '0015704390', '2019-03-09 07:55:25', 'GTONE'),
(103, '0015511656', '2019-03-09 07:55:30', 'GTONE'),
(104, '0015704390', '2019-03-09 17:06:47', 'GTONE'),
(105, '0015511656', '2019-03-09 18:01:39', 'GTONE'),
(106, '0015492140', '2019-03-11 07:26:36', 'GTONE'),
(107, '0015511669', '2019-03-11 07:46:42', 'GTONE'),
(108, '0000370381', '2019-03-11 07:50:08', 'GTONE'),
(109, '0015704523', '2019-03-11 07:51:26', 'GTONE'),
(110, '0012890960', '2019-03-11 07:58:53', 'GTONE'),
(111, '0012863058', '2019-03-11 08:07:37', 'GTONE'),
(112, '0015704390', '2019-03-11 08:11:07', 'GTONE'),
(113, '0001389725', '2019-03-11 08:12:06', 'GTONE'),
(114, '0015511656', '2019-03-11 08:21:08', 'GTONE'),
(115, '0000369343', '2019-03-11 08:37:41', 'GTONE'),
(116, '0012890960', '2019-03-11 17:08:32', 'GTONE'),
(117, '0015704381', '2019-03-11 17:10:05', 'GTONE'),
(118, '0015511656', '2019-03-11 17:10:07', 'GTONE'),
(119, '0000369343', '2019-03-11 17:10:15', 'GTONE'),
(120, '0015511669', '2019-03-11 17:12:01', 'GTONE'),
(121, '0012863058', '2019-03-11 17:15:45', 'GTONE'),
(122, '0015704390', '2019-03-11 17:17:07', 'GTONE'),
(123, '0015704390', '2019-03-11 17:17:08', 'GTONE'),
(124, '0015704523', '2019-03-11 17:53:23', 'GTONE'),
(125, '0012890960', '2019-03-12 07:55:13', 'GTONE'),
(126, '0015492140', '2019-03-12 07:56:20', 'GTONE'),
(127, '0000370381', '2019-03-12 07:58:18', 'GTONE'),
(128, '0015704381', '2019-03-12 08:00:48', 'GTONE'),
(129, '0015704390', '2019-03-12 08:03:32', 'GTONE'),
(130, '0015704523', '2019-03-12 08:14:41', 'GTONE'),
(131, '0015511669', '2019-03-12 08:18:35', 'GTONE'),
(132, '0000369343', '2019-03-12 08:25:52', 'GTONE'),
(133, '0015511656', '2019-03-12 08:32:55', 'GTONE'),
(134, '0012890960', '2019-03-13 17:11:58', 'GTONE'),
(135, '0015511656', '2019-03-13 17:21:51', 'GTONE'),
(136, '0015704523', '2019-03-13 18:00:12', 'GTONE'),
(137, '0015492140', '2019-03-13 18:04:43', 'GTONE'),
(138, '0015492140', '2019-03-13 18:04:55', 'GTONE'),
(139, '0000370381', '2019-03-14 07:49:24', 'GTONE'),
(140, '0015492140', '2019-03-14 07:52:08', 'GTONE'),
(141, '0000369343', '2019-03-14 08:35:24', 'GTONE'),
(142, '0015511656', '2019-03-14 17:04:40', 'GTONE'),
(143, '0000370381', '2019-03-14 17:04:52', 'GTONE'),
(144, '0000370381', '2019-03-14 17:05:00', 'GTONE'),
(145, '0000369343', '2019-03-14 17:05:01', 'GTONE'),
(146, '0000369343', '2019-03-14 17:05:05', 'GTONE'),
(147, '0000370381', '2019-03-14 17:05:12', 'GTONE'),
(148, '0015511669', '2019-03-14 17:06:23', 'GTONE'),
(149, '0015704390', '2019-03-14 17:06:40', 'GTONE'),
(150, '0012890960', '2019-03-14 17:10:34', 'GTONE'),
(151, '0015492140', '2019-03-14 17:23:12', 'GTONE'),
(152, '0015704523', '2019-03-14 17:23:44', 'GTONE'),
(153, '0000370381', '2019-03-15 07:56:00', 'GTONE'),
(154, '0000369343', '2019-03-15 08:00:59', 'GTONE'),
(155, '0015704390', '2019-03-15 08:03:21', 'GTONE'),
(156, '0015704523', '2019-03-15 08:08:03', 'GTONE'),
(157, '0015511669', '2019-03-15 08:18:50', 'GTONE'),
(158, '0015511656', '2019-03-15 08:20:14', 'GTONE'),
(159, '0015704381', '2019-03-15 08:28:53', 'GTONE'),
(160, '0015704381', '2019-03-15 17:06:46', 'GTONE'),
(161, '0000370381', '2019-03-15 17:07:11', 'GTONE'),
(162, '0000370381', '2019-03-15 17:07:12', 'GTONE'),
(163, '0000370381', '2019-03-15 17:07:13', 'GTONE'),
(164, '0015511656', '2019-03-15 17:07:16', 'GTONE'),
(165, '0000369343', '2019-03-15 17:07:31', 'GTONE'),
(166, '0012890960', '2019-03-15 17:15:20', 'GTONE'),
(167, '0015704523', '2019-03-15 17:36:31', 'GTONE'),
(168, '0015492140', '2019-03-15 17:45:33', 'GTONE'),
(169, '0012890960', '2019-03-16 07:38:52', 'GTONE'),
(170, '0000370381', '2019-03-16 07:49:04', 'GTONE'),
(171, '0015511669', '2019-03-16 08:18:29', 'GTONE'),
(172, '0000369343', '2019-03-16 08:19:40', 'GTONE'),
(173, '0015511656', '2019-03-16 08:31:43', 'GTONE'),
(174, '0012890960', '2019-03-18 07:40:33', 'GTONE'),
(175, '0015492140', '2019-03-18 07:53:36', 'GTONE'),
(176, '0015704390', '2019-03-18 08:07:05', 'GTONE'),
(177, '0000370381', '2019-03-18 08:08:42', 'GTONE'),
(178, '0015511656', '2019-03-18 08:21:26', 'GTONE'),
(179, '0012863058', '2019-03-18 08:25:27', 'GTONE'),
(180, '0012863058', '2019-03-18 08:25:29', 'GTONE'),
(181, '0000369343', '2019-03-18 08:33:59', 'GTONE'),
(182, '0015704381', '2019-03-18 08:35:10', 'GTONE'),
(183, '0015704523', '2019-03-18 08:41:36', 'GTONE'),
(184, 'K001286305', '2019-03-18 13:26:18', 'GTONE'),
(185, '0015511656', '2019-03-18 17:03:18', 'GTONE'),
(186, '0015704381', '2019-03-18 17:06:19', 'GTONE'),
(187, '0000369343', '2019-03-18 17:06:45', 'GTONE'),
(188, '0015704390', '2019-03-18 17:37:02', 'GTONE'),
(189, '0015704523', '2019-03-18 17:46:55', 'GTONE'),
(190, '0015492140', '2019-03-18 17:51:55', 'GTONE'),
(191, '0012890960', '2019-03-18 18:01:16', 'GTONE'),
(192, '0015492140', '2019-03-19 07:30:14', 'GTONE'),
(193, '0015704390', '2019-03-19 08:03:19', 'GTONE'),
(194, '0000370381', '2019-03-19 08:04:50', 'GTONE'),
(195, '0015511656', '2019-03-19 08:11:21', 'GTONE'),
(196, '0000369343', '2019-03-19 08:23:47', 'GTONE'),
(197, '0015704381', '2019-03-19 08:23:48', 'GTONE'),
(198, '0012890960', '2019-03-19 17:13:43', 'GTONE'),
(199, '0015511656', '2019-03-20 08:19:44', 'GTONE'),
(200, '0015704381', '2019-03-20 08:34:56', 'GTONE'),
(201, '0000369343', '2019-03-20 08:35:11', 'GTONE'),
(202, '0015704523', '2019-03-20 08:47:55', 'GTONE'),
(203, '0012863058', '2019-03-20 10:00:09', 'GTONE'),
(204, '0012863058', '2019-03-20 12:24:52', 'GTONE'),
(205, '0015704381', '2019-03-20 17:08:25', 'GTONE'),
(206, '0015511656', '2019-03-20 17:12:19', 'GTONE'),
(207, '0012890960', '2019-03-20 17:31:30', 'GTONE'),
(208, '0015492140', '2019-03-20 17:48:19', 'GTONE'),
(209, '0015704523', '2019-03-20 18:00:21', 'GTONE'),
(210, '0015511669', '2019-03-20 18:20:57', 'GTONE'),
(211, '0012890960', '2019-03-21 07:48:26', 'GTONE'),
(212, '0015492140', '2019-03-21 07:49:54', 'GTONE'),
(213, '0000370381', '2019-03-21 08:01:07', 'GTONE'),
(214, '0015704523', '2019-03-21 08:03:13', 'GTONE'),
(215, '0015704390', '2019-03-21 08:03:51', 'GTONE'),
(216, '0015511656', '2019-03-21 08:15:14', 'GTONE'),
(217, '0000369343', '2019-03-21 08:18:15', 'GTONE'),
(218, '0015511669', '2019-03-21 08:35:56', 'GTONE'),
(219, '0012863058', '2019-03-21 09:01:09', 'GTONE'),
(220, '0000370381', '2019-03-21 17:10:42', 'GTONE'),
(221, '0015511656', '2019-03-21 17:11:53', 'GTONE'),
(222, '0012890960', '2019-03-21 17:53:31', 'GTONE'),
(223, '0015492140', '2019-03-21 17:56:19', 'GTONE'),
(224, '0015704523', '2019-03-21 17:58:23', 'GTONE'),
(225, '0015511669', '2019-03-21 18:51:17', 'GTONE'),
(226, '0015704390', '2019-03-22 08:03:53', 'GTONE'),
(227, '0015704381', '2019-03-22 08:07:00', 'GTONE'),
(228, '0015704523', '2019-03-22 08:16:08', 'GTONE'),
(229, '0015511656', '2019-03-22 08:24:59', 'GTONE'),
(230, '0000369343', '2019-03-22 08:39:22', 'GTONE'),
(231, '0015492140', '2019-03-25 07:43:09', 'GTONE'),
(232, '0000370381', '2019-03-25 08:10:44', 'GTONE'),
(233, '0012863058', '2019-03-25 08:12:11', 'GTONE'),
(234, '0015704523', '2019-03-25 08:24:52', 'GTONE'),
(235, '0015511669', '2019-03-25 08:29:24', 'GTONE'),
(236, '0015511656', '2019-03-25 08:29:39', 'GTONE'),
(237, '0000369343', '2019-03-25 08:33:16', 'GTONE'),
(238, '0000369343', '2019-03-25 17:05:23', 'GTONE'),
(239, '0015704390', '2019-03-26 07:36:29', 'GTONE'),
(240, '0000370381', '2019-03-26 07:48:53', 'GTONE'),
(241, '0015704523', '2019-03-26 07:50:34', 'GTONE'),
(242, '0000369343', '2019-03-26 08:20:53', 'GTONE'),
(243, '0015511656', '2019-03-26 08:23:12', 'GTONE'),
(244, '0015511669', '2019-03-26 08:38:02', 'GTONE'),
(245, '0012863058', '2019-03-26 08:57:06', 'GTONE'),
(246, '0012890960', '2019-03-26 10:06:28', 'GTONE'),
(247, '0012863058', '2019-03-26 13:23:13', 'GTONE'),
(248, '0015704523', '2019-03-26 19:11:17', 'GTONE'),
(249, '0015704390', '2019-03-27 07:18:15', 'GTONE'),
(250, '0015704523', '2019-03-27 07:46:10', 'GTONE'),
(251, '0012863058', '2019-03-27 09:29:03', 'GTONE'),
(252, '0015704390', '2019-03-28 08:13:00', 'GTONE'),
(253, '0015704523', '2019-03-28 08:14:27', 'GTONE'),
(254, '0015511656', '2019-03-28 08:25:01', 'GTONE'),
(255, '0000370381', '2019-03-28 08:44:46', 'GTONE'),
(256, '0000370381', '2019-03-28 08:44:48', 'GTONE'),
(257, '0012863058', '2019-03-28 09:48:11', 'GTONE'),
(258, '0015704523', '2019-03-28 18:50:17', 'GTONE'),
(259, '0015704523', '2019-03-28 18:50:19', 'GTONE'),
(260, '0000369343', '2019-03-29 08:15:48', 'GTONE'),
(261, '0000370381', '2019-03-29 08:18:26', 'GTONE'),
(262, '0015704523', '2019-03-29 08:30:30', 'GTONE'),
(263, '0015511656', '2019-03-29 08:31:37', 'GTONE'),
(264, '0015704390', '2019-03-29 17:57:51', 'GTONE'),
(265, '0015704390', '2019-03-30 07:20:58', 'GTONE'),
(266, '0000370381', '2019-04-01 08:08:59', 'GTONE'),
(267, '0015704390', '2019-04-01 08:18:08', 'GTONE'),
(268, '0015511656', '2019-04-01 08:25:11', 'GTONE'),
(269, '0000369343', '2019-04-01 08:46:36', 'GTONE'),
(270, '0012863058', '2019-04-01 17:08:30', 'GTONE'),
(271, '0015511656', '2019-04-01 17:09:03', 'GTONE'),
(272, '0000369343', '2019-04-01 17:09:13', 'GTONE'),
(273, '0000370381', '2019-04-01 17:09:22', 'GTONE'),
(274, '0015704390', '2019-04-01 17:09:26', 'GTONE'),
(275, '0012863058', '2019-04-02 09:49:54', 'GTONE'),
(276, '0015704390', '2019-04-03 08:08:30', 'GTONE'),
(277, '0012863058', '2019-04-03 10:06:26', 'GTONE'),
(278, '0015704390', '2019-04-04 07:46:53', 'GTONE'),
(279, '0012863058', '2019-04-04 08:55:56', 'GTONE'),
(280, '0000370381', '2019-04-04 10:23:02', 'GTONE'),
(281, '0000370381', '2019-04-04 10:23:05', 'GTONE'),
(282, '0012863058', '2019-04-04 12:08:12', 'GTONE'),
(283, '0000370381', '2019-04-05 08:11:53', 'GTONE'),
(284, '0000206266', '2019-04-08 15:41:26', 'GTONE'),
(285, '0015704390', '2019-04-12 08:08:35', 'GTONE'),
(286, '0000370381', '2019-04-12 08:18:26', 'GTONE'),
(287, '0012863058', '2019-04-12 10:57:38', 'GTONE'),
(288, '0015704390', '2019-04-16 08:04:22', 'GTONE'),
(289, '0000370381', '2019-04-16 08:09:29', 'GTONE'),
(290, '0015511669', '2019-04-16 13:46:42', 'GTONE'),
(291, '0015511669', '2019-04-16 13:46:45', 'GTONE'),
(292, '0015511669', '2019-04-16 13:46:55', 'GTONE'),
(293, '0015511669', '2019-04-16 13:52:12', 'GTONE'),
(294, '0015511669', '2019-04-16 13:53:26', 'GTONE'),
(295, '0015511669', '2019-04-16 13:54:36', 'GTONE'),
(296, '0015511669', '2019-04-16 13:56:12', 'GTONE'),
(297, '0015511669', '2019-04-16 13:57:07', 'GTONE'),
(298, '0015511669', '2019-04-16 14:04:18', 'GTONE'),
(299, '0012890960', '2019-04-22 07:15:35', 'GTONE'),
(300, '0000370381', '2019-04-22 08:08:10', 'GTONE'),
(301, '0000370381', '2019-04-24 08:19:06', 'GTONE'),
(302, '0012890960', '2019-04-25 07:19:59', 'GTONE'),
(303, '0015704390', '2019-04-25 08:07:03', 'GTONE'),
(304, '0000370381', '2019-04-25 08:14:46', 'GTONE'),
(305, '0000370381', '2019-04-25 08:14:48', 'GTONE'),
(306, '0015511669', '2019-04-25 08:23:04', 'GTONE'),
(307, '0000206266', '2019-04-29 11:27:08', 'GTONE'),
(308, '0000206266', '2019-04-29 11:27:28', 'GTONE'),
(309, '0000206266', '2019-04-29 11:27:51', 'GTONE'),
(310, '0000206266', '2019-04-29 11:30:52', 'GTONE'),
(311, '0000206266', '2019-04-29 11:32:33', 'GTONE'),
(312, '0000206266', '2019-04-29 11:33:17', 'GTONE'),
(313, '0000206266', '2019-04-29 11:37:09', 'GTONE'),
(314, '0000206266', '2019-04-29 11:44:05', 'GTONE'),
(315, '0012890960', '2019-04-29 17:01:40', 'GTONE'),
(316, '0000370381', '2019-04-29 17:04:04', 'GTONE'),
(317, '0015704390', '2019-04-29 17:05:27', 'GTONE'),
(318, '0012890960', '2019-04-30 08:47:33', 'GTONE'),
(319, '0012890960', '2019-04-30 08:48:37', 'GTONE'),
(320, '0000369343', '2019-05-02 09:09:36', 'GTONE'),
(321, '0000370381', '2019-05-03 08:09:14', 'GTONE'),
(322, '0015704390', '2019-05-03 08:15:08', 'GTONE'),
(323, '0000370381', '2019-05-06 08:05:43', 'GTONE'),
(324, '0015704390', '2019-05-06 08:08:37', 'GTONE'),
(325, '0012890960', '2019-05-07 07:13:31', 'GTONE'),
(326, '0000370381', '2019-05-07 08:14:24', 'GTONE'),
(327, '0012890960', '2019-05-08 08:34:54', 'GTONE'),
(328, '0000369343', '2019-05-08 10:20:35', 'GTONE'),
(329, '0012890960', '2019-05-09 07:31:01', 'GTONE'),
(330, '0015704390', '2019-05-09 08:07:39', 'GTONE'),
(331, '0000370381', '2019-05-09 08:13:11', 'GTONE'),
(332, '0012863058', '2019-05-09 11:08:36', 'GTONE'),
(333, '0015704390', '2019-05-09 17:05:07', 'GTONE'),
(334, '0012890960', '2019-05-10 07:31:28', 'GTONE'),
(335, '0015704390', '2019-05-10 08:12:33', 'GTONE'),
(336, '0000370381', '2019-05-10 08:17:36', 'GTONE'),
(337, '0000370381', '2019-05-10 08:38:52', 'GTONE'),
(338, '0000370381', '2019-05-10 08:40:08', 'GTONE'),
(339, '0012890960', '2019-05-14 07:25:34', 'GTONE'),
(340, '0000370381', '2019-05-14 07:31:47', 'GTONE'),
(341, '0000369343', '2019-05-14 08:29:46', 'GTONE'),
(342, '0015704390', '2019-05-15 07:30:00', 'GTONE'),
(343, '0012890960', '2019-05-15 07:37:01', 'GTONE'),
(344, '0000369343', '2019-05-15 08:29:23', 'GTONE'),
(345, '0000369343', '2019-05-15 08:40:14', 'GTONE'),
(346, '0012863058', '2019-05-15 08:45:41', 'GTONE'),
(347, '0015704390', '2019-05-16 08:32:26', 'GTONE'),
(348, '0015704390', '2019-05-16 08:33:59', 'GTONE'),
(349, '0015704390', '2019-05-16 08:34:14', 'GTONE'),
(350, '0000370381', '2019-05-16 12:54:15', 'GTONE'),
(351, '0015511669', '2019-05-20 07:32:34', 'GTONE'),
(352, '0000370381', '2019-05-20 08:05:21', 'GTONE'),
(353, '0015511669', '2019-05-20 13:25:35', 'GTONE'),
(354, '0015511669', '2019-05-20 13:26:07', 'GTONE'),
(355, '0000206290', '2019-05-20 13:27:38', 'GTONE'),
(356, '0000206290', '2019-05-20 13:27:53', 'GTONE'),
(357, '0000206290', '2019-05-20 13:28:10', 'GTONE'),
(358, '0000206290', '2019-05-20 13:44:40', 'GTONE'),
(359, '0016214400', '2019-05-20 14:26:34', 'GTONE'),
(360, '0016214400', '2019-05-20 14:26:57', 'GTONE'),
(361, '0016214400', '2019-05-20 14:27:13', 'GTONE'),
(362, '0016214400', '2019-05-20 14:28:07', 'GTONE'),
(363, '0016214400', '2019-05-20 14:28:49', 'GTONE'),
(364, '0016214400', '2019-05-20 14:29:33', 'GTONE'),
(365, '0016214400', '2019-05-20 14:34:25', 'GTONE'),
(366, '0016214400', '2019-05-20 14:54:19', 'GTONE'),
(367, '0016214400', '2019-05-20 14:54:31', 'GTONE'),
(368, '0016214400', '2019-05-20 14:55:00', 'GTONE'),
(369, '0012890960', '2019-05-21 07:25:13', 'GTONE'),
(370, '0000370381', '2019-05-21 08:13:37', 'GTONE'),
(371, '0000369343', '2019-05-21 09:01:16', 'GTONE'),
(372, '0015511669', '2019-05-21 17:00:18', 'GTONE'),
(373, '0015511669', '2019-05-21 17:00:32', 'GTONE'),
(374, '0015511669', '2019-05-21 17:00:36', 'GTONE'),
(375, '0015511669', '2019-05-21 17:00:44', 'GTONE'),
(376, '0015704390', '2019-05-22 17:02:14', 'GTONE'),
(377, '0012890960', '2019-05-22 17:02:34', 'GTONE'),
(378, '0012890960', '2019-05-23 07:22:43', 'GTONE'),
(379, '0015704390', '2019-05-23 08:00:00', 'GTONE'),
(380, '0015704390', '2019-05-23 17:04:56', 'GTONE'),
(381, '0012863058', '2019-05-27 10:25:33', 'GTONE'),
(382, '0015704390', '2019-05-28 07:56:37', 'GTONE'),
(383, '0000370381', '2019-05-28 08:01:35', 'GTONE'),
(384, '0012863058', '2019-05-28 10:08:31', 'GTONE'),
(385, '0012863058', '2019-05-28 12:30:56', 'GTONE'),
(386, '0015704390', '2019-05-29 08:03:48', 'GTONE'),
(387, '0012863058', '2019-05-29 08:38:52', 'GTONE'),
(388, '0000370381', '2019-05-30 08:08:22', 'GTONE'),
(389, '0015704390', '2019-05-30 08:12:19', 'GTONE'),
(390, '0012863058', '2019-05-30 08:41:54', 'GTONE'),
(391, '0015511669', '2019-05-30 15:04:55', 'GTONE'),
(392, '0015704390', '2019-05-31 07:42:50', 'GTONE'),
(393, '0000370381', '2019-05-31 08:13:19', 'GTONE'),
(394, '0015511669', '2019-05-31 08:28:02', 'GTONE'),
(395, '0012863058', '2019-05-31 08:37:49', 'GTONE'),
(396, '0015511669', '2019-05-31 17:29:00', 'GTONE'),
(397, '0000370381', '2019-06-03 08:03:16', 'GTONE'),
(398, '0000369343', '2019-06-03 08:18:43', 'GTONE'),
(399, '0015511656', '2019-06-03 08:19:16', 'GTONE'),
(400, '0015704390', '2019-06-06 07:52:41', 'GTONE'),
(401, '0000369343', '2019-06-06 08:26:52', 'GTONE'),
(402, '0015511669', '2019-06-06 17:14:49', 'GTONE'),
(403, '0015511669', '2019-06-06 17:14:57', 'GTONE'),
(404, '0015511669', '2019-06-06 17:15:07', 'GTONE'),
(405, '0000369343', '2019-06-07 08:09:26', 'GTONE'),
(406, '0000370381', '2019-06-10 07:55:16', 'GTONE'),
(407, '0015704390', '2019-06-10 08:00:38', 'GTONE'),
(408, '0012890960', '2019-06-13 17:15:34', 'GTONE'),
(409, '0012890960', '2019-06-17 07:26:39', 'GTONE'),
(410, '0015704523', '2019-06-17 07:36:23', 'GTONE'),
(411, '0015704390', '2019-06-17 08:00:04', 'GTONE'),
(412, '0015511656', '2019-06-17 08:09:35', 'GTONE'),
(413, '0015704381', '2019-06-17 08:42:54', 'GTONE'),
(414, '0012863058', '2019-06-17 08:47:55', 'GTONE'),
(415, '0015704390', '2019-06-17 17:05:55', 'GTONE'),
(416, '0015511656', '2019-06-17 17:07:51', 'GTONE'),
(417, '0015704523', '2019-06-17 17:13:33', 'GTONE'),
(418, '0015704381', '2019-06-17 17:14:26', 'GTONE'),
(419, '0015704523', '2019-06-18 07:50:19', 'GTONE'),
(420, '0015704390', '2019-06-18 07:57:19', 'GTONE'),
(421, '0015511656', '2019-06-18 08:03:19', 'GTONE'),
(422, '0000369343', '2019-06-18 08:22:44', 'GTONE'),
(423, '0015704381', '2019-06-18 08:36:35', 'GTONE'),
(424, '0015704523', '2019-06-19 07:29:27', 'GTONE'),
(425, '0015704390', '2019-06-19 07:45:54', 'GTONE'),
(426, '0015511656', '2019-06-19 08:14:48', 'GTONE'),
(427, '0000369343', '2019-06-19 08:35:31', 'GTONE'),
(428, '0012863058', '2019-06-19 08:39:46', 'GTONE'),
(429, '0015704381', '2019-06-19 08:59:26', 'GTONE'),
(430, '0015704381', '2019-06-19 17:06:34', 'GTONE'),
(431, '0000369343', '2019-06-19 17:06:51', 'GTONE'),
(432, '0015511669', '2019-06-19 17:07:30', 'GTONE'),
(433, '0015704523', '2019-06-19 17:20:34', 'GTONE'),
(434, '0000370381', '2019-06-20 07:42:10', 'GTONE'),
(435, '0015511669', '2019-06-20 07:51:36', 'GTONE'),
(436, '0015704390', '2019-06-20 07:52:49', 'GTONE'),
(437, '0015704523', '2019-06-20 07:54:18', 'GTONE'),
(438, '0015511656', '2019-06-20 08:14:40', 'GTONE'),
(439, '0000369343', '2019-06-20 08:24:45', 'GTONE'),
(440, '0015704381', '2019-06-20 08:47:05', 'GTONE'),
(441, '0000368593', '2019-06-20 12:51:21', 'GTONE'),
(442, '0000368593', '2019-06-20 12:52:35', 'GTONE'),
(443, '0000368593', '2019-06-20 12:52:41', 'GTONE'),
(444, '0015704381', '2019-06-20 17:05:07', 'GTONE'),
(445, '0015704523', '2019-06-20 17:05:12', 'GTONE'),
(446, '0015511669', '2019-06-20 18:10:18', 'GTONE'),
(447, '0000370381', '2019-06-21 07:42:45', 'GTONE'),
(448, '0015704523', '2019-06-21 07:47:42', 'GTONE'),
(449, '0000368593', '2019-06-21 08:25:04', 'GTONE'),
(450, '0000378553', '2019-06-21 08:30:22', 'GTONE'),
(451, '0000378553', '2019-06-21 08:31:31', 'GTONE'),
(452, '0015069576', '2019-06-21 08:37:42', 'GTONE'),
(453, '0000378575', '2019-06-21 08:38:15', 'GTONE'),
(454, '0015112176', '2019-06-21 08:38:35', 'GTONE'),
(455, '0000368796', '2019-06-21 08:38:45', 'GTONE'),
(456, '0000368574', '2019-06-21 08:38:49', 'GTONE'),
(457, '0000378465', '2019-06-21 08:39:04', 'GTONE'),
(458, '0000880884', '2019-06-21 08:42:30', 'GTONE'),
(459, '0000880997', '2019-06-21 08:42:36', 'GTONE'),
(460, '0015706324', '2019-06-21 08:42:40', 'GTONE'),
(461, '0000368797', '2019-06-21 08:42:43', 'GTONE'),
(462, '0000369680', '2019-06-21 08:42:46', 'GTONE'),
(463, '0000378573', '2019-06-21 08:42:49', 'GTONE'),
(464, '0000369666', '2019-06-21 08:42:51', 'GTONE'),
(465, '0014771794', '2019-06-21 08:42:54', 'GTONE'),
(466, '0015070249', '2019-06-21 08:42:56', 'GTONE'),
(467, '0015069609', '2019-06-21 08:43:00', 'GTONE'),
(468, '0015070191', '2019-06-21 08:43:01', 'GTONE'),
(469, '0015070280', '2019-06-21 08:43:03', 'GTONE'),
(470, '0000378592', '2019-06-21 08:43:05', 'GTONE'),
(471, '0000368605', '2019-06-21 08:43:06', 'GTONE'),
(472, '0000880942', '2019-06-21 08:43:08', 'GTONE'),
(473, '0000369628', '2019-06-21 08:43:37', 'GTONE'),
(474, '0000880934', '2019-06-21 08:43:39', 'GTONE'),
(475, '0000369608', '2019-06-21 08:43:41', 'GTONE'),
(476, '0000880939', '2019-06-21 08:44:08', 'GTONE'),
(477, '0000378472', '2019-06-21 08:44:10', 'GTONE'),
(478, '0000378453', '2019-06-21 08:44:13', 'GTONE'),
(479, '0000880928', '2019-06-21 08:44:15', 'GTONE'),
(480, '0000880928', '2019-06-21 08:45:17', 'GTONE'),
(481, '0000880928', '2019-06-21 08:45:39', 'GTONE'),
(482, '0000880928', '2019-06-21 08:48:59', 'GTONE'),
(483, '0000880928', '2019-06-21 08:49:14', 'GTONE'),
(484, '0000880928', '2019-06-21 08:49:27', 'GTONE'),
(485, '0000378453', '2019-06-21 08:49:42', 'GTONE'),
(486, '0000378472', '2019-06-21 08:49:59', 'GTONE'),
(487, '0000880939', '2019-06-21 08:50:17', 'GTONE'),
(488, '0000369608', '2019-06-21 08:50:20', 'GTONE'),
(489, '0000880934', '2019-06-21 08:50:21', 'GTONE'),
(490, '0000369628', '2019-06-21 08:50:23', 'GTONE'),
(491, '0000880942', '2019-06-21 08:50:24', 'GTONE'),
(492, '0000368605', '2019-06-21 08:50:25', 'GTONE'),
(493, '0000378592', '2019-06-21 08:50:26', 'GTONE'),
(494, '0015070280', '2019-06-21 08:50:27', 'GTONE'),
(495, '0015070191', '2019-06-21 08:50:28', 'GTONE'),
(496, '0015069609', '2019-06-21 08:50:29', 'GTONE'),
(497, '0015070249', '2019-06-21 08:50:31', 'GTONE'),
(498, '0014771794', '2019-06-21 08:50:32', 'GTONE'),
(499, '0000369666', '2019-06-21 08:50:33', 'GTONE'),
(500, '0000378573', '2019-06-21 08:50:35', 'GTONE'),
(501, '0000369680', '2019-06-21 08:50:36', 'GTONE'),
(502, '0000368797', '2019-06-21 08:50:37', 'GTONE'),
(503, '0015706324', '2019-06-21 08:50:38', 'GTONE'),
(504, '0000880997', '2019-06-21 08:50:40', 'GTONE'),
(505, '0000880884', '2019-06-21 08:50:41', 'GTONE'),
(506, '0000368796', '2019-06-21 08:50:42', 'GTONE'),
(507, '0000378553', '2019-06-21 08:50:43', 'GTONE'),
(508, '0000368574', '2019-06-21 08:50:45', 'GTONE'),
(509, '0000378465', '2019-06-21 08:50:46', 'GTONE'),
(510, '0015112176', '2019-06-21 08:50:47', 'GTONE'),
(511, '0000378575', '2019-06-21 08:50:48', 'GTONE'),
(512, '0015069576', '2019-06-21 08:50:50', 'GTONE'),
(513, '0000368593', '2019-06-21 08:50:51', 'GTONE'),
(514, '0012890960', '2019-06-25 07:06:26', 'GTONE'),
(515, '0000368797', '2019-06-25 07:20:27', 'GTONE'),
(516, '0000880934', '2019-06-25 07:26:29', 'GTONE'),
(517, '0000880928', '2019-06-25 07:29:05', 'GTONE'),
(518, '0000368593', '2019-06-25 07:29:27', 'GTONE'),
(519, '0015511669', '2019-06-25 07:30:03', 'GTONE'),
(520, '0000369608', '2019-06-25 07:35:14', 'GTONE'),
(521, '0015069576', '2019-06-25 07:38:50', 'GTONE'),
(522, '0014771794', '2019-06-25 07:39:21', 'GTONE'),
(523, '0000368574', '2019-06-25 07:39:43', 'GTONE'),
(524, '0000880942', '2019-06-25 07:39:53', 'GTONE'),
(525, '0000368796', '2019-06-25 07:41:58', 'GTONE'),
(526, '0000370381', '2019-06-25 07:42:39', 'GTONE'),
(527, '0015070280', '2019-06-25 07:45:16', 'GTONE'),
(528, '0000880939', '2019-06-25 07:47:44', 'GTONE'),
(529, '0000880997', '2019-06-25 07:52:30', 'GTONE'),
(530, '0015112176', '2019-06-25 07:52:39', 'GTONE'),
(531, '0000378553', '2019-06-25 07:56:03', 'GTONE'),
(532, '0000378592', '2019-06-25 07:56:52', 'GTONE'),
(533, '0015704523', '2019-06-25 07:59:29', 'GTONE'),
(534, '0015069609', '2019-06-25 08:04:28', 'GTONE'),
(535, '0015706324', '2019-06-25 08:10:48', 'GTONE'),
(536, '0015511656', '2019-06-25 08:11:03', 'GTONE'),
(537, '0012863058', '2019-06-25 08:39:02', 'GTONE'),
(538, '0000369343', '2019-06-25 08:39:38', 'GTONE'),
(539, '0000369680', '2019-06-25 08:44:26', 'GTONE'),
(540, '0015070191', '2019-06-25 08:54:32', 'GTONE'),
(541, '0015704381', '2019-06-25 08:55:22', 'GTONE'),
(542, '0000378465', '2019-06-25 09:49:41', 'GTONE'),
(543, '0000369628', '2019-06-25 10:29:49', 'GTONE'),
(544, '0000368797', '2019-06-25 16:32:00', 'GTONE'),
(545, '0000880997', '2019-06-25 17:02:06', 'GTONE'),
(546, '0000368796', '2019-06-25 17:04:37', 'GTONE'),
(547, '0014771794', '2019-06-25 17:04:55', 'GTONE'),
(548, '0000370381', '2019-06-25 17:04:59', 'GTONE'),
(549, '0015070280', '2019-06-25 17:05:03', 'GTONE'),
(550, '0015704381', '2019-06-25 17:05:41', 'GTONE'),
(551, '0015706324', '2019-06-25 17:06:00', 'GTONE'),
(552, '0000378592', '2019-06-25 17:07:40', 'GTONE'),
(553, '0000880928', '2019-06-25 17:11:26', 'GTONE'),
(554, '0000368593', '2019-06-25 17:16:39', 'GTONE'),
(555, '0000880934', '2019-06-25 17:17:30', 'GTONE'),
(556, '0012863058', '2019-06-25 17:22:13', 'GTONE'),
(557, '0015069609', '2019-06-25 17:22:52', 'GTONE'),
(558, '0015070249', '2019-06-25 17:23:01', 'GTONE'),
(559, '0015112176', '2019-06-25 17:23:19', 'GTONE'),
(560, '0015704523', '2019-06-25 17:24:20', 'GTONE'),
(561, '0000369608', '2019-06-25 17:24:24', 'GTONE'),
(562, '0015069576', '2019-06-25 17:24:27', 'GTONE'),
(563, '0000880942', '2019-06-25 17:52:39', 'GTONE'),
(564, '0000368574', '2019-06-25 17:54:49', 'GTONE'),
(565, '0000369680', '2019-06-25 17:55:50', 'GTONE'),
(566, '0015070191', '2019-06-25 18:03:22', 'GTONE'),
(567, '0000880939', '2019-06-25 18:08:40', 'GTONE'),
(568, '0000880884', '2019-06-25 18:09:02', 'GTONE'),
(569, '0000378553', '2019-06-25 18:55:42', 'GTONE'),
(570, '0000378465', '2019-06-25 19:06:09', 'GTONE'),
(571, '0015511669', '2019-06-25 19:43:49', 'GTONE'),
(572, '0015704390', '2019-06-25 20:01:05', 'GTONE'),
(573, '0000369628', '2019-06-25 20:12:41', 'GTONE'),
(574, '0012890960', '2019-06-26 07:10:55', 'GTONE'),
(575, '0000880934', '2019-06-26 07:17:10', 'GTONE'),
(576, '0000378573', '2019-06-26 07:19:17', 'GTONE'),
(577, '0000368797', '2019-06-26 07:19:30', 'GTONE'),
(578, '0000880928', '2019-06-26 07:25:43', 'GTONE'),
(579, '0000378453', '2019-06-26 07:30:21', 'GTONE'),
(580, '0014771794', '2019-06-26 07:34:01', 'GTONE'),
(581, '0000880939', '2019-06-26 07:34:07', 'GTONE'),
(582, '0000368605', '2019-06-26 07:34:16', 'GTONE'),
(583, '0015069576', '2019-06-26 07:35:33', 'GTONE'),
(584, '0000368796', '2019-06-26 07:39:56', 'GTONE'),
(585, '0000378575', '2019-06-26 07:40:00', 'GTONE'),
(586, '0000368593', '2019-06-26 07:42:56', 'GTONE'),
(587, '0000369608', '2019-06-26 07:45:21', 'GTONE'),
(588, '0000370381', '2019-06-26 07:47:52', 'GTONE'),
(589, '0015070280', '2019-06-26 07:47:57', 'GTONE'),
(590, '0000880942', '2019-06-26 07:48:53', 'GTONE'),
(591, '0000880997', '2019-06-26 07:53:31', 'GTONE'),
(592, '0000368574', '2019-06-26 07:53:35', 'GTONE'),
(593, '0000378592', '2019-06-26 07:54:28', 'GTONE'),
(594, '0015112176', '2019-06-26 07:56:17', 'GTONE'),
(595, '0015704390', '2019-06-26 07:57:05', 'GTONE'),
(596, '0015511669', '2019-06-26 07:57:38', 'GTONE'),
(597, '0015704523', '2019-06-26 08:00:27', 'GTONE'),
(598, '0015070249', '2019-06-26 08:02:45', 'GTONE'),
(599, '0015069609', '2019-06-26 08:08:15', 'GTONE'),
(600, '0015706324', '2019-06-26 08:22:34', 'GTONE'),
(601, '0015511656', '2019-06-26 08:22:46', 'GTONE'),
(602, '0000378553', '2019-06-26 08:34:14', 'GTONE'),
(603, '0000369343', '2019-06-26 08:40:27', 'GTONE'),
(604, '0015070191', '2019-06-26 08:41:33', 'GTONE'),
(605, '0012863058', '2019-06-26 08:42:00', 'GTONE'),
(606, '0000880884', '2019-06-26 08:45:43', 'GTONE'),
(607, '0015704381', '2019-06-26 08:57:50', 'GTONE'),
(608, '0000378465', '2019-06-26 09:40:42', 'GTONE'),
(609, '0000378472', '2019-06-26 09:53:15', 'GTONE'),
(610, '0012863058', '2019-06-26 10:16:27', 'GTONE'),
(611, '0000369628', '2019-06-26 10:45:04', 'GTONE'),
(612, '0000880884', '2019-06-26 12:14:42', 'GTONE'),
(613, '0000880884', '2019-06-26 12:47:23', 'GTONE'),
(614, '0000368797', '2019-06-26 16:29:56', 'GTONE'),
(615, '0000369714', '2019-06-26 16:47:47', 'GTONE'),
(616, '0000880997', '2019-06-26 17:02:54', 'GTONE'),
(617, '0015704381', '2019-06-26 17:08:34', 'GTONE'),
(618, '0000378592', '2019-06-26 17:10:48', 'GTONE'),
(619, '0015070280', '2019-06-26 17:10:52', 'GTONE'),
(620, '0014771794', '2019-06-26 17:12:28', 'GTONE'),
(621, '0000369666', '2019-06-26 17:13:42', 'GTONE'),
(622, '0015704390', '2019-06-26 17:17:09', 'GTONE'),
(623, '0015704523', '2019-06-26 17:37:23', 'GTONE'),
(624, '0000880928', '2019-06-26 17:41:16', 'GTONE'),
(625, '0000378453', '2019-06-26 17:41:26', 'GTONE'),
(626, '0015511669', '2019-06-26 17:56:02', 'GTONE'),
(627, '0000378573', '2019-06-26 17:56:33', 'GTONE'),
(628, '000368593', '2019-06-26 18:07:40', 'GTONE'),
(629, '0000368593', '2019-06-26 18:07:47', 'GTONE'),
(630, '0015706324', '2019-06-26 18:21:58', 'GTONE'),
(631, '0015070249', '2019-06-26 18:48:54', 'GTONE'),
(632, '0015112176', '2019-06-26 18:49:02', 'GTONE'),
(633, '0000368796', '2019-06-26 19:13:21', 'GTONE'),
(634, '0015070191', '2019-06-26 19:13:25', 'GTONE'),
(635, '0000369714', '2019-06-26 19:44:05', 'GTONE'),
(636, '0000880934', '2019-06-26 20:01:14', 'GTONE'),
(637, '0000368574', '2019-06-26 20:01:21', 'GTONE'),
(638, '0015069609', '2019-06-26 20:01:29', 'GTONE'),
(639, '0000368605', '2019-06-26 20:01:33', 'GTONE'),
(640, '0000368605', '2019-06-26 20:01:34', 'GTONE'),
(641, '0000378472', '2019-06-26 20:01:48', 'GTONE'),
(642, '0000378553', '2019-06-26 20:02:11', 'GTONE'),
(643, '0015069576', '2019-06-26 20:02:18', 'GTONE'),
(644, '0000369608', '2019-06-26 20:02:29', 'GTONE'),
(645, '0000880939', '2019-06-26 20:04:01', 'GTONE'),
(646, '0000880884', '2019-06-26 20:04:12', 'GTONE'),
(647, '0000880942', '2019-06-26 20:04:37', 'GTONE'),
(648, '0000369628', '2019-06-26 20:09:27', 'GTONE'),
(649, '0000368797', '2019-06-27 07:24:41', 'GTONE'),
(650, '0000378573', '2019-06-27 07:25:27', 'GTONE'),
(651, '0000368593', '2019-06-27 07:28:03', 'GTONE'),
(652, '0015704523', '2019-06-27 07:31:13', 'GTONE'),
(653, '0014771794', '2019-06-27 07:32:46', 'GTONE'),
(654, '0000880942', '2019-06-27 07:33:58', 'GTONE'),
(655, '0000368605', '2019-06-27 07:36:20', 'GTONE'),
(656, '0000378465', '2019-06-27 07:39:53', 'GTONE'),
(657, '0015511669', '2019-06-27 07:40:02', 'GTONE'),
(658, '0000880997', '2019-06-27 07:40:19', 'GTONE'),
(659, '0015069576', '2019-06-27 07:41:34', 'GTONE'),
(660, '0000368796', '2019-06-27 07:46:00', 'GTONE'),
(661, '0015070249', '2019-06-27 07:46:28', 'GTONE'),
(662, '0015704390', '2019-06-27 07:49:09', 'GTONE'),
(663, '0000378592', '2019-06-27 07:50:11', 'GTONE'),
(664, '0000378575', '2019-06-27 07:50:51', 'GTONE'),
(665, '0000370381', '2019-06-27 07:53:11', 'GTONE'),
(666, '0000880939', '2019-06-27 07:53:27', 'GTONE'),
(667, '0015112176', '2019-06-27 07:55:55', 'GTONE'),
(668, '0000880928', '2019-06-27 08:00:46', 'GTONE'),
(669, '0000368574', '2019-06-27 08:01:11', 'GTONE'),
(670, '0015070280', '2019-06-27 08:01:45', 'GTONE'),
(671, '0015704381', '2019-06-27 08:15:37', 'GTONE'),
(672, '0015706324', '2019-06-27 08:18:26', 'GTONE'),
(673, '0015511656', '2019-06-27 08:18:53', 'GTONE'),
(674, '0015511656', '2019-06-27 08:18:55', 'GTONE'),
(675, '0000880884', '2019-06-27 08:22:19', 'GTONE'),
(676, '0000369343', '2019-06-27 08:34:48', 'GTONE'),
(677, '0015070191', '2019-06-27 08:45:23', 'GTONE'),
(678, '0000378553', '2019-06-27 08:54:15', 'GTONE'),
(679, '0000369714', '2019-06-27 09:02:15', 'GTONE'),
(680, '0015069609', '2019-06-27 09:05:00', 'GTONE'),
(681, '0000369680', '2019-06-27 09:09:00', 'GTONE'),
(682, '0000378472', '2019-06-27 10:02:49', 'GTONE'),
(683, '0000369666', '2019-06-27 10:06:38', 'GTONE'),
(684, '0000880884', '2019-06-27 12:54:39', 'GTONE'),
(685, '0000368797', '2019-06-27 16:30:33', 'GTONE'),
(686, '0000369714', '2019-06-27 16:36:42', 'GTONE'),
(687, '0000378592', '2019-06-27 17:00:48', 'GTONE'),
(688, '0014771794', '2019-06-27 17:00:50', 'GTONE'),
(689, '0000880997', '2019-06-27 17:03:41', 'GTONE'),
(690, '0000880934', '2019-06-27 17:03:59', 'GTONE'),
(691, '0015704381', '2019-06-27 17:05:22', 'GTONE'),
(692, '0015070280', '2019-06-27 17:06:45', 'GTONE'),
(693, '0015706324', '2019-06-27 17:07:07', 'GTONE'),
(694, '0015511669', '2019-06-27 17:10:06', 'GTONE'),
(695, '0015704523', '2019-06-27 17:14:51', 'GTONE'),
(696, '0000378573', '2019-06-27 17:17:02', 'GTONE'),
(697, '0015112176', '2019-06-27 17:25:33', 'GTONE'),
(698, '0015070249', '2019-06-27 17:25:37', 'GTONE'),
(699, '0015069576', '2019-06-27 17:33:24', 'GTONE'),
(700, '0000368593', '2019-06-27 17:33:30', 'GTONE'),
(701, '0000880939', '2019-06-27 18:00:53', 'GTONE'),
(702, '0015704390', '2019-06-27 18:02:23', 'GTONE'),
(703, '0000368796', '2019-06-27 18:09:20', 'GTONE'),
(704, '0015070191', '2019-06-27 18:09:45', 'GTONE'),
(705, '0000378575', '2019-06-27 18:16:31', 'GTONE'),
(706, '0000369680', '2019-06-27 18:23:50', 'GTONE'),
(707, '0000368605', '2019-06-27 18:23:54', 'GTONE'),
(708, '0000368574', '2019-06-27 18:24:03', 'GTONE'),
(709, '0000880884', '2019-06-27 18:25:02', 'GTONE'),
(710, '0000880942', '2019-06-27 18:25:46', 'GTONE'),
(711, '0000378465', '2019-06-27 19:07:06', 'GTONE'),
(712, '0000369714', '2019-06-27 19:09:52', 'GTONE'),
(713, '0000880928', '2019-06-27 20:01:07', 'GTONE'),
(714, '0000378553', '2019-06-27 20:03:39', 'GTONE'),
(715, '0000369666', '2019-06-27 20:06:37', 'GTONE'),
(716, '0000378472', '2019-06-27 20:08:36', 'GTONE'),
(717, '0015069609', '2019-06-27 20:08:45', 'GTONE'),
(718, '0000369628', '2019-06-27 20:12:37', 'GTONE'),
(719, '0014771794', '2019-06-28 06:58:08', 'GTONE'),
(720, '0000880942', '2019-06-28 06:59:55', 'GTONE'),
(721, '0000880934', '2019-06-28 07:03:52', 'GTONE'),
(722, '0000880939', '2019-06-28 07:17:47', 'GTONE'),
(723, '0000368797', '2019-06-28 07:26:41', 'GTONE'),
(724, '0000368797', '2019-06-28 07:26:42', 'GTONE'),
(725, '0012890960', '2019-06-28 07:27:14', 'GTONE'),
(726, '0000378453', '2019-06-28 07:31:49', 'GTONE'),
(727, '0015069576', '2019-06-28 07:37:27', 'GTONE'),
(728, '0000368593', '2019-06-28 07:45:08', 'GTONE'),
(729, '0000368605', '2019-06-28 07:45:32', 'GTONE'),
(730, '0000378573', '2019-06-28 07:48:43', 'GTONE'),
(731, '0015704390', '2019-06-28 07:49:40', 'GTONE'),
(732, '0000378472', '2019-06-28 07:53:24', 'GTONE'),
(733, '0000370381', '2019-06-28 07:53:46', 'GTONE'),
(734, '0000880997', '2019-06-28 07:54:42', 'GTONE'),
(735, '0000378592', '2019-06-28 07:56:28', 'GTONE'),
(736, '0015070280', '2019-06-28 07:57:35', 'GTONE'),
(737, '0000880884', '2019-06-28 07:59:52', 'GTONE'),
(738, '0000378553', '2019-06-28 08:02:21', 'GTONE'),
(739, '0000378575', '2019-06-28 08:02:51', 'GTONE'),
(740, '0000368574', '2019-06-28 08:03:41', 'GTONE'),
(741, '0000880928', '2019-06-28 08:08:35', 'GTONE'),
(742, '0015704523', '2019-06-28 08:11:35', 'GTONE'),
(743, '0015070249', '2019-06-28 08:12:34', 'GTONE'),
(744, '0015112176', '2019-06-28 08:22:19', 'GTONE'),
(745, '0000369608', '2019-06-28 08:22:33', 'GTONE'),
(746, '0000369666', '2019-06-28 08:23:42', 'GTONE'),
(747, '0000369680', '2019-06-28 08:29:58', 'GTONE'),
(748, '0012863058', '2019-06-28 08:30:58', 'GTONE'),
(749, '0015511669', '2019-06-28 08:35:35', 'GTONE'),
(750, '0015070191', '2019-06-28 08:42:58', 'GTONE'),
(751, '0015069609', '2019-06-28 09:02:53', 'GTONE'),
(752, '0015704523', '2019-06-28 09:51:30', 'GTONE'),
(753, '0000369714', '2019-06-28 09:56:29', 'GTONE'),
(754, '0000378465', '2019-06-28 09:57:18', 'GTONE'),
(755, '0000369628', '2019-06-28 11:01:04', 'GTONE'),
(756, '0015704523', '2019-06-28 12:33:53', 'GTONE'),
(757, '0012890960', '2019-06-28 17:16:39', 'GTONE'),
(758, '0000378575', '2019-06-28 17:22:27', 'GTONE'),
(759, '0015511669', '2019-06-28 17:24:36', 'GTONE'),
(760, '0000378553', '2019-06-28 17:26:39', 'GTONE'),
(761, '0014771794', '2019-06-28 17:27:00', 'GTONE'),
(762, '0000378592', '2019-06-28 17:35:03', 'GTONE'),
(763, '0015070280', '2019-06-28 17:35:48', 'GTONE'),
(764, '0015070249', '2019-06-28 17:38:28', 'GTONE'),
(765, '0015112176', '2019-06-28 17:38:42', 'GTONE'),
(766, '0000368574', '2019-06-28 17:39:09', 'GTONE'),
(767, '0000880997', '2019-06-28 17:39:17', 'GTONE'),
(768, '0015511656', '2019-06-28 17:39:26', 'GTONE'),
(769, '0015704523', '2019-06-28 17:43:29', 'GTONE'),
(770, '0000368797', '2019-06-28 17:50:07', 'GTONE'),
(771, '0000368605', '2019-06-28 17:51:19', 'GTONE'),
(772, '0000378453', '2019-06-28 17:52:48', 'GTONE'),
(773, '0000378573', '2019-06-28 17:53:31', 'GTONE'),
(774, '0000369608', '2019-06-28 17:58:07', 'GTONE'),
(775, '0000880934', '2019-06-28 17:58:15', 'GTONE'),
(776, '0015069576', '2019-06-28 17:58:32', 'GTONE'),
(777, '0000368796', '2019-06-28 17:58:56', 'GTONE'),
(778, '0000368593', '2019-06-28 17:59:31', 'GTONE'),
(779, '0015070191', '2019-06-28 17:59:43', 'GTONE'),
(780, '0000880942', '2019-06-28 18:04:23', 'GTONE'),
(781, '0015069609', '2019-06-28 18:16:01', 'GTONE'),
(782, '0000378472', '2019-06-28 18:16:09', 'GTONE'),
(783, '0000369714', '2019-06-28 18:20:43', 'GTONE'),
(784, '0000369666', '2019-06-28 18:23:50', 'GTONE'),
(785, '0012863058', '2019-06-28 18:30:22', 'GTONE'),
(786, '0000369680', '2019-06-28 18:47:42', 'GTONE'),
(787, '0000880939', '2019-06-28 19:10:16', 'GTONE'),
(788, '0000378465', '2019-06-28 19:12:02', 'GTONE'),
(789, '0000880928', '2019-06-28 19:12:15', 'GTONE'),
(790, '0000880884', '2019-06-28 19:12:19', 'GTONE'),
(791, '0000369628', '2019-06-28 20:00:13', 'GTONE'),
(792, '0000370381', '2019-06-29 07:46:55', 'GTONE'),
(793, '0000378553', '2019-06-29 07:50:55', 'GTONE'),
(794, '0015070191', '2019-06-29 07:54:38', 'GTONE'),
(795, '0000378573', '2019-06-29 07:59:43', 'GTONE'),
(796, '0015704523', '2019-06-29 08:07:59', 'GTONE'),
(797, '0000368797', '2019-06-29 08:09:50', 'GTONE'),
(798, '0000369714', '2019-06-29 08:10:04', 'GTONE'),
(799, '0015704390', '2019-06-29 08:11:58', 'GTONE'),
(800, '0000369628', '2019-06-29 08:16:16', 'GTONE'),
(801, '0000378575', '2019-06-29 08:29:46', 'GTONE'),
(802, '0000369666', '2019-06-29 09:23:43', 'GTONE'),
(803, '0000369666', '2019-06-29 11:59:03', 'GTONE'),
(804, '0015704390', '2019-06-29 12:00:04', 'GTONE'),
(805, '0000368797', '2019-06-29 12:15:19', 'GTONE'),
(806, '0000591283', '2019-07-03 08:57:34', 'GTONE'),
(807, '0000378465', '2019-07-03 09:25:15', 'GTONE'),
(808, '0000369628', '2019-07-03 10:54:29', 'GTONE'),
(809, '0000369714', '2019-07-03 11:45:44', 'GTONE'),
(810, '0000369714', '2019-07-03 11:45:46', 'GTONE'),
(811, '0000880884', '2019-07-03 12:04:38', 'GTONE'),
(812, '0015070249', '2019-07-03 12:09:27', 'GTONE'),
(813, '0015070249', '2019-07-03 12:16:02', 'GTONE'),
(814, '0000880884', '2019-07-03 12:55:25', 'GTONE'),
(815, '0000368574', '2019-07-03 13:13:37', 'GTONE'),
(816, '0000369680', '2019-07-03 13:14:53', 'GTONE'),
(817, '0000368574', '2019-07-03 13:52:29', 'GTONE'),
(818, '0000368797', '2019-07-03 16:30:40', 'GTONE'),
(819, '0012863079', '2019-07-03 16:32:40', 'GTONE'),
(820, '0012862066', '2019-07-03 16:32:42', 'GTONE'),
(821, '0012862077', '2019-07-03 16:33:04', 'GTONE'),
(822, '0012862077', '2019-07-03 16:33:26', 'GTONE'),
(823, '0000378592', '2019-07-03 17:02:56', 'GTONE'),
(824, '0015704390', '2019-07-03 17:06:10', 'GTONE'),
(825, '0000369666', '2019-07-03 17:06:39', 'GTONE'),
(826, '0000880928', '2019-07-03 17:06:43', 'GTONE'),
(827, '0015069576', '2019-07-03 17:07:13', 'GTONE'),
(828, '0000369608', '2019-07-03 17:07:51', 'GTONE'),
(829, '0015070280', '2019-07-03 17:07:56', 'GTONE'),
(830, '0000378472', '2019-07-04 07:55:31', 'GTONE'),
(831, '0015704523', '2019-07-04 07:58:54', 'GTONE'),
(832, '0000880928', '2019-07-04 08:00:51', 'GTONE'),
(833, '0015069609', '2019-07-04 08:02:57', 'GTONE'),
(834, '0015511669', '2019-07-04 08:07:03', 'GTONE'),
(835, '0015112176', '2019-07-04 08:15:44', 'GTONE'),
(836, '0015511656', '2019-07-04 08:35:55', 'GTONE'),
(837, '0015706324', '2019-07-04 08:36:41', 'GTONE'),
(838, '0000880884', '2019-07-04 08:40:18', 'GTONE'),
(839, '0015070191', '2019-07-04 08:45:32', 'GTONE'),
(840, '0000369714', '2019-07-04 08:54:13', 'GTONE'),
(841, '0000369680', '2019-07-04 08:58:03', 'GTONE'),
(842, '0000369628', '2019-07-04 10:38:01', 'GTONE'),
(843, '0000591283', '2019-07-04 15:00:20', 'GTONE'),
(844, '0000368797', '2019-07-04 16:35:33', 'GTONE'),
(845, '0000880934', '2019-07-04 16:48:17', 'GTONE'),
(846, '0014771794', '2019-07-04 17:01:38', 'GTONE'),
(847, '0000378592', '2019-07-04 17:01:39', 'GTONE'),
(848, '0015070280', '2019-07-04 17:04:58', 'GTONE'),
(849, '0015511669', '2019-07-04 17:10:41', 'GTONE'),
(850, '0015511656', '2019-07-04 17:12:31', 'GTONE'),
(851, '0015706324', '2019-07-04 17:12:35', 'GTONE'),
(852, '0000368796', '2019-07-04 17:24:23', 'GTONE'),
(853, '0000368593', '2019-07-04 17:25:11', 'GTONE'),
(854, '0015070249', '2019-07-04 17:26:02', 'GTONE'),
(855, '0015112176', '2019-07-04 17:26:28', 'GTONE'),
(856, '0000369608', '2019-07-04 17:29:32', 'GTONE'),
(857, '0015069576', '2019-07-04 17:30:08', 'GTONE'),
(858, '0000378575', '2019-07-04 17:35:50', 'GTONE'),
(859, '0015704523', '2019-07-04 17:44:20', 'GTONE'),
(860, '0000378573', '2019-07-04 17:54:12', 'GTONE'),
(861, '0000880942', '2019-07-04 17:56:21', 'GTONE'),
(862, '0000368605', '2019-07-04 17:59:42', 'GTONE'),
(863, '0000880939', '2019-07-04 18:01:29', 'GTONE'),
(864, '0000369680', '2019-07-04 18:03:45', 'GTONE'),
(865, '0000378453', '2019-07-04 18:16:17', 'GTONE'),
(866, '0000368574', '2019-07-04 18:17:55', 'GTONE'),
(867, '0015070191', '2019-07-04 18:43:24', 'GTONE'),
(868, '0000880884', '2019-07-04 19:16:38', 'GTONE'),
(869, '0000378465', '2019-07-04 19:16:48', 'GTONE'),
(870, '0000880928', '2019-07-04 20:00:09', 'GTONE'),
(871, '0015069609', '2019-07-04 20:01:13', 'GTONE'),
(872, '0000378472', '2019-07-04 20:01:15', 'GTONE'),
(873, '0000369666', '2019-07-04 20:01:49', 'GTONE'),
(874, '0000378553', '2019-07-04 20:03:32', 'GTONE'),
(875, '0000369628', '2019-07-04 20:04:36', 'GTONE'),
(876, '0000880942', '2019-07-05 07:05:22', 'GTONE'),
(877, '0000880934', '2019-07-05 07:07:15', 'GTONE'),
(878, '0000368797', '2019-07-05 07:19:52', 'GTONE'),
(879, '0000880939', '2019-07-05 07:25:46', 'GTONE'),
(880, '0000378553', '2019-07-05 07:26:18', 'GTONE'),
(881, '0000378573', '2019-07-05 07:28:46', 'GTONE'),
(882, '0000368593', '2019-07-05 07:35:41', 'GTONE'),
(883, '0000378453', '2019-07-05 07:35:52', 'GTONE'),
(884, '0000368796', '2019-07-05 07:37:51', 'GTONE'),
(885, '0015069576', '2019-07-05 07:38:51', 'GTONE'),
(886, '0000378592', '2019-07-05 07:39:59', 'GTONE'),
(887, '0015704390', '2019-07-05 07:40:58', 'GTONE'),
(888, '0015070249', '2019-07-05 07:47:05', 'GTONE'),
(889, '0015070280', '2019-07-05 07:47:59', 'GTONE'),
(890, '0000368574', '2019-07-05 07:52:25', 'GTONE'),
(891, '0000378575', '2019-07-05 07:52:41', 'GTONE'),
(892, '0000378472', '2019-07-05 07:53:22', 'GTONE'),
(893, '0000369608', '2019-07-05 07:53:46', 'GTONE'),
(894, '0000370381', '2019-07-05 07:53:49', 'GTONE'),
(895, '0000369666', '2019-07-05 07:57:48', 'GTONE'),
(896, '0000880884', '2019-07-05 07:57:54', 'GTONE'),
(897, '0015704523', '2019-07-05 07:58:29', 'GTONE'),
(898, '0015112176', '2019-07-05 08:00:07', 'GTONE'),
(899, '0015511669', '2019-07-05 08:00:21', 'GTONE'),
(900, '0000368605', '2019-07-05 08:00:36', 'GTONE'),
(901, '0000880928', '2019-07-05 08:11:07', 'GTONE'),
(902, '0015706324', '2019-07-05 08:15:29', 'GTONE'),
(903, '0015511656', '2019-07-05 08:15:39', 'GTONE'),
(904, '0015069609', '2019-07-05 08:19:44', 'GTONE'),
(905, '0012863058', '2019-07-05 08:47:35', 'GTONE'),
(906, '0000369680', '2019-07-05 08:48:18', 'GTONE'),
(907, '0015070191', '2019-07-05 09:03:29', 'GTONE'),
(908, '0000378465', '2019-07-05 09:21:28', 'GTONE'),
(909, '0000369714', '2019-07-05 09:35:26', 'GTONE'),
(910, '0000369628', '2019-07-05 10:52:02', 'GTONE'),
(911, '0015070249', '2019-07-05 12:14:33', 'GTONE'),
(912, '0015069609', '2019-07-05 12:14:37', 'GTONE'),
(913, '0000880884', '2019-07-05 12:49:39', 'GTONE'),
(914, '0015069609', '2019-07-05 16:15:05', 'GTONE'),
(915, '0000368797', '2019-07-05 16:35:30', 'GTONE'),
(916, '0000880934', '2019-07-05 16:37:07', 'GTONE'),
(917, '0000880997', '2019-07-05 16:55:00', 'GTONE'),
(918, '0015511656', '2019-07-05 17:02:52', 'GTONE'),
(919, '0000378592', '2019-07-05 17:02:54', 'GTONE'),
(920, '0000368605', '2019-07-05 17:05:43', 'GTONE'),
(921, '0015070280', '2019-07-05 17:06:44', 'GTONE'),
(922, '0015511669', '2019-07-05 17:09:11', 'GTONE'),
(923, '0015112176', '2019-07-05 17:11:17', 'GTONE'),
(924, '0000378453', '2019-07-05 17:11:20', 'GTONE'),
(925, '0015070249', '2019-07-05 17:11:27', 'GTONE'),
(926, '0000368574', '2019-07-05 17:12:40', 'GTONE'),
(927, '0000378575', '2019-07-05 17:12:44', 'GTONE'),
(928, '0000368593', '2019-07-05 17:14:21', 'GTONE'),
(929, '0015704523', '2019-07-05 17:21:49', 'GTONE'),
(930, '0015704390', '2019-07-05 17:26:28', 'GTONE'),
(931, '0000378553', '2019-07-05 17:32:17', 'GTONE'),
(932, '0000378573', '2019-07-05 17:36:32', 'GTONE'),
(933, '0015069576', '2019-07-05 17:54:26', 'GTONE'),
(934, '0000368796', '2019-07-05 17:54:46', 'GTONE'),
(935, '0000369608', '2019-07-05 17:54:57', 'GTONE'),
(936, '0015070191', '2019-07-05 17:59:49', 'GTONE'),
(937, '0000369714', '2019-07-05 18:01:10', 'GTONE'),
(938, '0000378472', '2019-07-05 18:07:43', 'GTONE'),
(939, '0000880939', '2019-07-05 18:09:16', 'GTONE'),
(940, '0000880942', '2019-07-05 18:11:35', 'GTONE'),
(941, '0000378465', '2019-07-05 19:01:47', 'GTONE'),
(942, '0000369680', '2019-07-05 19:15:08', 'GTONE'),
(943, '0000369666', '2019-07-05 19:29:12', 'GTONE'),
(944, '0000880884', '2019-07-05 20:00:23', 'GTONE'),
(945, '0000880928', '2019-07-05 20:00:38', 'GTONE'),
(946, '0000369628', '2019-07-05 20:04:05', 'GTONE'),
(947, '0015706324', '2019-07-05 20:08:58', 'GTONE'),
(948, '0014771794', '2019-07-06 07:15:34', 'GTONE'),
(949, '0000378553', '2019-07-06 07:29:35', 'GTONE'),
(950, '0015704390', '2019-07-06 07:29:41', 'GTONE'),
(951, '0000880997', '2019-07-06 07:41:14', 'GTONE'),
(952, '0000370381', '2019-07-06 07:51:13', 'GTONE'),
(953, '0000378575', '2019-07-06 07:57:38', 'GTONE'),
(954, '0015704523', '2019-07-06 07:58:36', 'GTONE'),
(955, '0015070191', '2019-07-06 07:58:58', 'GTONE'),
(956, '0000378573', '2019-07-06 08:08:48', 'GTONE'),
(957, '0015511669', '2019-07-06 08:08:52', 'GTONE'),
(958, '0000368797', '2019-07-06 08:11:11', 'GTONE'),
(959, '0000369680', '2019-07-06 08:52:43', 'GTONE'),
(960, '0000369666', '2019-07-06 09:38:01', 'GTONE'),
(961, '0000368593', '2019-07-06 12:09:10', 'GTONE'),
(962, '0015704390', '2019-07-06 14:24:14', 'GTONE'),
(963, '         /', '2019-07-06 15:54:06', 'GTONE'),
(964, '0015511669', '2019-07-06 15:54:10', 'GTONE'),
(965, '0000368593', '2019-07-06 16:06:18', 'GTONE'),
(966, '0000378575', '2019-07-06 16:44:51', 'GTONE'),
(967, '0000369666', '2019-07-06 16:49:51', 'GTONE'),
(968, '0000368797', '2019-07-06 17:00:36', 'GTONE'),
(969, '0000880997', '2019-07-06 17:02:22', 'GTONE'),
(970, '0014771794', '2019-07-06 17:03:02', 'GTONE'),
(971, '0000378553', '2019-07-06 17:03:11', 'GTONE'),
(972, '0015070191', '2019-07-06 17:09:57', 'GTONE'),
(973, '0015704523', '2019-07-06 17:33:14', 'GTONE'),
(974, '0000378573', '2019-07-06 17:36:10', 'GTONE'),
(975, '0000369680', '2019-07-06 17:43:15', 'GTONE');

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

--
-- Truncate table before insert `gate_persondetails`
--

TRUNCATE TABLE `gate_persondetails`;
--
-- Dumping data for table `gate_persondetails`
--

INSERT INTO `gate_persondetails` (`personDetailId`, `userGivenId`, `familyname`, `givenname`, `middlename`, `suffix`, `civilStatus`, `gender`, `mobile_number`, `dateOfBirth`, `age`, `categoryId`, `createdBy`, `updateDate`) VALUES
('03294b0d-9d6b-11e9-9a38-6045cb6ad5d4', '19-0278', 'BENAVIDEZ', 'JESSA MAE', 'DAVID', '', 'Single', 'Female', '09452441091', '2002-03-14', 17, '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:17:20'),
('042e1772-97ef-11e9-9a38-6045cb6ad5d4', '17-054', 'RIGUER', 'HANS CHRISTIAN', 'V.', '', 'Single', 'Male', '090909090909', '2001-02-08', 26, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-26 16:47:18'),
('07b80f22-9d6d-11e9-9a38-6045cb6ad5d4', '19-0006', 'GUNO', 'CEE-JAY', 'DUEÑAS', '', 'Single', 'Male', '09971808033', '2000-09-20', 19, '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:31:47'),
('0bf9498e-932a-11e9-99a7-6045cb6ad5d4', '16-115', 'GARCIA', 'KAYCEE', 'P.', '', 'Married', 'Female', '09092191689', '1991-10-03', 28, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 15:07:20'),
('106e504f-3fbf-11e9-8886-6045cb6ad5d4', '18-176', 'QUITO', 'ROSMIE', 'B.', '', 'Married', 'Female', '09508491287', '1981-02-17', 38, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-06 11:22:18'),
('18235d66-9327-11e9-99a7-6045cb6ad5d4', '19-188', 'NAGUIAT', 'MA. CARMINA', 'B.', '', 'Single', 'Female', '09161232596', '1997-10-29', 22, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:46:12'),
('1ae4ff53-931b-11e9-9281-6045cb6ad5d4', '08-040', 'CARAIG', 'MAMERTO', 'D.', '', 'Married', 'Male', '09285448733', '1964-05-11', 55, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:20:14'),
('1c9cd091-931a-11e9-9281-6045cb6ad5d4', '12-082', 'PAMESA', 'GILBIRT', 'D.', '', 'Married', 'Male', '09121344209', '1992-04-09', 27, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:13:07'),
('1d933f23-9328-11e9-99a7-6045cb6ad5d4', '19-186', 'MARTIN', 'CAMILLE FRANCE ', 'S.', '', 'Single', 'Female', '09122076678', '1998-07-01', 21, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:53:31'),
('1e9c64e5-9329-11e9-99a7-6045cb6ad5d4', '19-185', 'FLORRES', 'KENNETH CHRISTIAN', 'A.', '', 'Single', 'Male', '09771681547', '1993-10-21', 26, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 15:00:42'),
('20572fe1-93bc-11e9-99a7-6045cb6ad5d4', '17-146', 'PEREZ', 'ANNA MARIE', 'C.', '', 'Single', 'Female', '09102006414', '1992-02-16', 27, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-21 08:33:01'),
('25bbc0fe-9d6c-11e9-9a38-6045cb6ad5d4', '19-0039', 'RILLERA', 'RICA', 'AMPARADO', '', 'Single', 'Female', '09460867132', '2003-01-06', 16, '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:25:27'),
('26a8380c-931d-11e9-9281-6045cb6ad5d4', '19-191', 'PANES', 'JIANNE CAMILLE', 'G.', '', 'Single', 'Female', '09954432474', '1997-08-25', 22, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:34:52'),
('2958f0c0-3fc0-11e9-8886-6045cb6ad5d4', '11-0069', 'PANGILINAN', 'JOAHNNA LENE', 'V.', '', 'Married', 'Female', '09284842350', '1990-11-28', 29, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-06 11:30:09'),
('29642907-3fc0-11e9-8886-6045cb6ad5d4', '11-0069', 'PANGILINAN', 'JOAHNNA LENE', 'V.', '', 'Married', 'Female', '09284842350', '1990-11-28', 29, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-06 11:30:09'),
('2a021b22-3fc0-11e9-8886-6045cb6ad5d4', '11-0069', 'PANGILINAN', 'JOAHNNA LENE', 'V.', '', 'Married', 'Female', '09284842350', '1990-11-28', 29, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-06 11:30:10'),
('2bba9734-9d6c-11e9-9a38-6045cb6ad5d4', '19-0039', 'RILLERA', 'RICA', 'AMPARADO', '', 'Single', 'Female', '09460867132', '2003-01-06', 16, '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:25:37'),
('2e3292cb-9d6a-11e9-9a38-6045cb6ad5d4', '19-0337', 'MANGALINDAN', 'MELVIN', 'CRUZ', '', 'Single', 'Male', '09464162419', '2002-08-14', 17, '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:11:23'),
('49a09405-932a-11e9-99a7-6045cb6ad5d4', '16-108', 'SALAZAR', 'MARK JONES', 'M.', '', 'Single', 'Male', '09150667476', '1991-12-04', 28, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 15:09:04'),
('539a33c2-2e97-11e9-918d-6045cb6ad5d4', '08-039', 'TEST', 'TEST', 'TEST', '', 'Married', 'Female', '090909090909', '2001-02-08', 18, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-06 11:41:45'),
('5d7164af-9328-11e9-99a7-6045cb6ad5d4', '17-145', 'PANTIG', 'JOSEPH', 'L.', '', 'Married', 'Male', '09467327824', '1967-07-20', 52, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:55:18'),
('5e9dd2e6-9329-11e9-99a7-6045cb6ad5d4', '19-194', 'PEÑA', 'MARCK CHRISTIAN', 'R.', '', 'Single', 'Male', '09216723967', '2000-01-03', 19, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 15:02:29'),
('63753b67-93bc-11e9-99a7-6045cb6ad5d4', '19-195', 'PINEDA', 'KYLA KATHREEN', 'D.', '', 'Single', 'Female', '09103643707', '1997-09-15', 22, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-21 08:34:54'),
('641091d1-9d6c-11e9-9a38-6045cb6ad5d4', '19-0321', 'FLORA', 'CARLYN MAE', 'CUNANAN', '', 'Single', 'Female', '09100372385', '2003-04-01', 16, '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:27:12'),
('646abb14-3fba-11e9-8886-6045cb6ad5d4', '12-073', 'VALENCIA', 'RAMON', 'D.', '', 'Single', 'Male', '09566237259', '1990-08-09', 29, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-04-16 14:03:01'),
('6648a251-931d-11e9-9281-6045cb6ad5d4', '19-190', 'PAJARILLO', 'JEAMAY', 'S.', '', 'Single', 'Female', '09108115991', '1999-04-22', 20, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:36:39'),
('69d6ea04-931a-11e9-9281-6045cb6ad5d4', '17-131', 'BERNAL', 'JENNIFER', 'G.', '', 'Single', 'Male', '09959310077', '1996-10-19', 23, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:15:17'),
('6a4c4366-59d1-11e9-97d9-6045cb6ad5d4', '08-1213', 'MACARAIG', 'MEMERTO', 'B.', '', 'Married', 'Male', '09088923007', '0000-00-00', 21, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-04-08 15:39:20'),
('77b84e8e-9327-11e9-99a7-6045cb6ad5d4', '19-187', 'MAYUYO', 'ELENA', 'S.', '', 'Single', 'Female', '09508917682', '1997-11-07', 22, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:48:53'),
('7b256e4f-7abf-11e9-90b1-6045cb6ad5d4', '09-000', 'LastTest', 'FirstTest', 'Mid', '', 'Single', 'Male', '09175278188', '1994-02-10', 25, '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-05-20 13:24:01'),
('825d1f20-3bf8-11e9-8886-6045cb6ad5d4', '13-079', 'ARANETA', 'CHRISTOPHER', 'C.', '', 'Single', 'Male', '09063002843', '2001-02-08', 18, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-08 09:30:12'),
('8351fcca-9d6a-11e9-9a38-6045cb6ad5d4', '19-0055', 'VALENCIA', 'ARJAY', 'SABINO', '', 'Single', 'Male', '09123855896', '2002-08-27', 17, '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:13:45'),
('8cc3bf56-7ac0-11e9-90b1-6045cb6ad5d4', '08-999', 'Last2', 'First2', 'Mid2', '', 'Single', 'Male', '09175278188', '2001-02-14', 18, '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-05-20 13:31:40'),
('90dc0ff5-9316-11e9-9281-6045cb6ad5d4', '19-182', 'DEL ROSARIO,', 'FRANCIS', 'O.', '', 'Single', 'Male', '09276521911', '1997-11-07', 21, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 12:47:44'),
('999e8f31-9329-11e9-99a7-6045cb6ad5d4', '19-189', 'PAGUIO', 'JHERVIN', 'P', '', 'Single', 'Male', '09397725103', '1995-04-03', 24, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 15:04:08'),
('99dd3381-3fec-11e9-8886-6045cb6ad5d4', '06-010', 'GARCIA', 'ROWELL', 'L.', '', 'Single', 'Male', '09777811489', '1977-01-03', 42, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-06 16:48:16'),
('9e210acd-3fbc-11e9-8886-6045cb6ad5d4', '14-095', 'SERRANO', 'BEVERLY', 'B.', '', 'Married', 'Female', '09994050178', '1985-08-17', 34, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-06 11:04:47'),
('9ec97cd8-93bc-11e9-99a7-6045cb6ad5d4', '18-175', 'VALENCIA', 'RUSSEL', 'S.', '', 'Single', 'Male', '09185207603', '1997-06-06', 22, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-21 08:36:33'),
('a131f3f4-9328-11e9-99a7-6045cb6ad5d4', '19-197', 'TORRES', 'JOEMEL ROY', 'P.', '', 'Single', 'Male', '09455374883', '1997-12-21', 22, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:57:12'),
('a5403234-931d-11e9-9281-6045cb6ad5d4', '19-183', 'DURAN', 'EVANGELYN ', 'M.', '', 'Single', 'Female', '09123187494', '1997-10-07', 22, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:38:25'),
('a809fd68-3fbf-11e9-8886-6045cb6ad5d4', '06-002', 'CATAPANG ', 'RUTH', 'S.', '', 'Married', 'Female', '09189428723', '1978-10-24', 41, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-06 11:26:32'),
('ab3bbbf5-931d-11e9-9281-6045cb6ad5d4', '19-183', 'DURAN', 'EVANGELYN ', 'M.', '', 'Single', 'Female', '09123187494', '1997-10-07', 22, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:38:35'),
('acb782cd-9d6c-11e9-9a38-6045cb6ad5d4', '19-0003', 'HOLGADO', 'MARK CHRISTIAN', 'CANDADO', '', 'Single', 'Male', '09054110339', '2000-01-10', 19, '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:29:14'),
('ad684a81-4164-11e9-8886-6045cb6ad5d4', '09-049', 'PASCUAL', 'EMERALD', 'S.', '', 'Married', 'Female', '09328610556', '1986-09-23', 33, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-08 13:40:16'),
('adf17405-9327-11e9-99a7-6045cb6ad5d4', '19-193', 'PARAIS', 'VERONICA', 'P.', '', 'Single', 'Female', '09954359883', '1996-09-11', 23, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:50:23'),
('ae905ca1-9d6b-11e9-9a38-6045cb6ad5d4', '19-0184', 'SANTIZAS', 'ANGELICA', 'BALTAZAR', '', 'Single', 'Female', '09071297167', '2002-11-20', 17, '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:22:07'),
('af0389a4-93bb-11e9-99a7-6045cb6ad5d4', '17-151', 'TUMANGUIL', 'RENZ PAULO', 'N.', '', 'Single', 'Male', '09972148541', '1995-10-14', 22, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-21 08:29:51'),
('b10bd7ba-931b-11e9-9281-6045cb6ad5d4', '16-124', 'CATLI', 'RAYMOND', 'M.', '', 'Married', 'Male', '0938773884', '1993-05-18', 26, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:24:26'),
('b6a81760-931a-11e9-9281-6045cb6ad5d4', '18-177', 'DELOS REYES', 'ALEXANDER JOHN', 'C.', '', 'Single', 'Male', '09451564504', '1997-11-10', 22, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:17:25'),
('c36d570d-931c-11e9-9281-6045cb6ad5d4', '18-170', 'MALLARI', 'LAURENCE', 'A.', '', 'Single', 'Male', '09124913469', '1998-01-14', 21, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:32:06'),
('c3fb3e2c-9d6a-11e9-9a38-6045cb6ad5d4', '19-0046', 'SINGIAN', 'ANGELO', 'TEMBLIQUE', '', 'Single', 'Male', '09122188333', '2000-05-02', 19, '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:15:34'),
('d2da8a77-9326-11e9-99a7-6045cb6ad5d4', '19-192', 'PANLAQUI', 'HAROLD', 'S.', '', 'Single', 'Male', '09277110288', '1990-05-06', 29, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:44:16'),
('d4b8c6b4-9329-11e9-99a7-6045cb6ad5d4', '18-166', 'GIGANTE', 'ANGELICA GRACE', 'H.', '', 'Single', 'Female', '09277125797', '1998-01-31', 21, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 15:05:48'),
('da6fca34-9328-11e9-99a7-6045cb6ad5d4', '19-184', 'ELEN', 'JONAH', 'C.', '', 'Married', 'Female', '09070329881', '1993-06-18', 26, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:58:48'),
('de78ba06-3bf3-11e9-8886-6045cb6ad5d4', '08-038', 'CRUZADO', 'MARIA ROMINA GRACIA', 'H.', '', 'Married', 'Female', '09072817452', '1986-06-15', 32, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-03-08 14:06:04'),
('e0d43f9c-3bf8-11e9-8886-6045cb6ad5d4', '12-074', 'PEREZ', 'JOMARK', 'DAVID', '', 'Married', 'Male', '09305005960', '2001-02-08', 18, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-04-16 14:00:17'),
('f129a2b7-9327-11e9-99a7-6045cb6ad5d4', '19-196', 'PONCE', 'NIKKI PAULINE', 'M. ', '', 'Single', 'Female', '09993164401', '1999-09-27', 20, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 14:52:16'),
('f14fc0ba-9d6b-11e9-9a38-6045cb6ad5d4', '19-0181', 'COSE', 'ANDREILYN', 'MAQUILAT', '', 'Single', 'Female', '09357510736', '2002-01-19', 17, '77f9afea-c316-11e8-a587-ace2d3624318', 'Admin', '2019-07-03 16:23:59'),
('f6a84e73-931b-11e9-9281-6045cb6ad5d4', '17-156', 'TAMAYO', 'SALLY', 'S.', '', 'Married', 'Female', '09124913469', '1975-08-24', 44, '88591e2d-c316-11e8-a587-ace2d3624318', 'Admin', '2019-06-20 13:26:22');

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

--
-- Truncate table before insert `gate_personphoto`
--

TRUNCATE TABLE `gate_personphoto`;
--
-- Dumping data for table `gate_personphoto`
--

INSERT INTO `gate_personphoto` (`photoId`, `personDetailId`, `image_url`, `createdBy`, `createDate`, `updateDate`) VALUES
('08e7fab7-93bd-11e9-99a7-6045cb6ad5d4', '6648a251-931d-11e9-9281-6045cb6ad5d4', 'ui/photo_library/5227.jpg', 'Admin', '2019-06-21 08:39:31', '2019-06-21 08:39:31'),
('09047b93-9317-11e9-9281-6045cb6ad5d4', '90dc0ff5-9316-11e9-9281-6045cb6ad5d4', 'ui/photo_library/5213.jpg', 'Admin', '2019-06-20 12:51:06', '2019-06-20 12:51:06'),
('1ffe1659-9d6d-11e9-9a38-6045cb6ad5d4', '07b80f22-9d6d-11e9-9a38-6045cb6ad5d4', 'ui/photo_library/5711.jpg', 'Admin', '2019-07-03 16:32:27', '2019-07-03 16:32:27'),
('27774841-3fbf-11e9-8886-6045cb6ad5d4', '106e504f-3fbf-11e9-8886-6045cb6ad5d4', 'ui/photo_library/MAM MIE.jpg', 'Admin', '2019-03-06 11:22:57', '2019-05-20 13:24:47'),
('2951dd8b-932a-11e9-99a7-6045cb6ad5d4', '0bf9498e-932a-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5242.jpg', 'Admin', '2019-06-20 15:08:09', '2019-06-20 15:08:09'),
('31f8034c-9d6b-11e9-9a38-6045cb6ad5d4', '03294b0d-9d6b-11e9-9a38-6045cb6ad5d4', 'ui/photo_library/5691.jpg', 'Admin', '2019-07-03 16:18:38', '2019-07-03 16:18:38'),
('35bf9c5a-9329-11e9-99a7-6045cb6ad5d4', '1e9c64e5-9329-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5306.jpg', 'Admin', '2019-06-20 15:01:21', '2019-06-20 15:01:21'),
('3a40b50d-931a-11e9-9281-6045cb6ad5d4', '1c9cd091-931a-11e9-9281-6045cb6ad5d4', 'ui/photo_library/5244.jpg', 'Admin', '2019-06-20 13:13:57', '2019-06-20 13:13:57'),
('3cb34df1-9328-11e9-99a7-6045cb6ad5d4', '1d933f23-9328-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5239.jpg', 'Admin', '2019-06-20 14:54:23', '2019-06-20 14:54:23'),
('3ea0db82-9327-11e9-99a7-6045cb6ad5d4', '18235d66-9327-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5232.jpg', 'Admin', '2019-06-20 14:47:17', '2019-06-20 14:47:17'),
('3eb3b6c8-931d-11e9-9281-6045cb6ad5d4', '26a8380c-931d-11e9-9281-6045cb6ad5d4', 'ui/photo_library/5221.jpg', 'Admin', '2019-06-20 13:35:33', '2019-06-20 13:35:33'),
('42be43ab-93bc-11e9-99a7-6045cb6ad5d4', '20572fe1-93bc-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5243.jpg', 'Admin', '2019-06-21 08:33:59', '2019-06-21 08:33:59'),
('4706dddf-9d6c-11e9-9a38-6045cb6ad5d4', '25bbc0fe-9d6c-11e9-9a38-6045cb6ad5d4', 'ui/photo_library/5689.jpg', 'Admin', '2019-07-03 16:26:23', '2019-07-03 16:26:23'),
('5753f742-9d6a-11e9-9a38-6045cb6ad5d4', '2e3292cb-9d6a-11e9-9a38-6045cb6ad5d4', 'ui/photo_library/5715.jpg', 'Admin', '2019-07-03 16:12:32', '2019-07-03 16:12:32'),
('591e1a50-9d6b-11e9-9a38-6045cb6ad5d4', '042e1772-97ef-11e9-9a38-6045cb6ad5d4', 'ui/photo_library/hans.PNG', 'Admin', '2019-07-03 16:19:44', '2019-07-03 16:19:44'),
('5db336fa-3fbd-11e9-8886-6045cb6ad5d4', '9e210acd-3fbc-11e9-8886-6045cb6ad5d4', 'ui/photo_library/SERRANO.PNG', 'Admin', '2019-03-06 11:10:09', '2019-05-20 13:39:32'),
('63c6c117-6a2f-11e9-850d-6045cb6ad5d4', '6a4c4366-59d1-11e9-97d9-6045cb6ad5d4', 'ui/photo_library/Cat03.jpg', 'Admin', '2019-04-29 11:32:18', '2019-04-29 11:32:18'),
('66e5bb38-932a-11e9-99a7-6045cb6ad5d4', '49a09405-932a-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5241.jpg', 'Admin', '2019-06-20 15:09:53', '2019-06-20 15:09:53'),
('67e1ede0-931b-11e9-9281-6045cb6ad5d4', '1ae4ff53-931b-11e9-9281-6045cb6ad5d4', 'ui/photo_library/merts.PNG', 'Admin', '2019-06-20 13:22:23', '2019-06-20 13:22:23'),
('694ea7ca-3fc0-11e9-8886-6045cb6ad5d4', 'e0d43f9c-3bf8-11e9-8886-6045cb6ad5d4', 'ui/photo_library/sir jomark.jpg', 'Admin', '2019-03-06 11:31:57', '2019-06-20 13:23:11'),
('6fc228f9-3fc0-11e9-8886-6045cb6ad5d4', '2958f0c0-3fc0-11e9-8886-6045cb6ad5d4', 'ui/photo_library/MAM JO.PNG', 'Admin', '2019-03-06 11:32:07', '2019-05-20 13:38:27'),
('71b6a350-3fba-11e9-8886-6045cb6ad5d4', '646abb14-3fba-11e9-8886-6045cb6ad5d4', 'ui/photo_library/sir mon.jpg', 'Admin', '2019-03-06 10:49:14', '2019-05-20 13:25:05'),
('78974d40-9329-11e9-99a7-6045cb6ad5d4', '5e9dd2e6-9329-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5296.jpg', 'Admin', '2019-06-20 15:03:13', '2019-06-20 15:03:13'),
('78f4f840-9328-11e9-99a7-6045cb6ad5d4', '5d7164af-9328-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5249.jpg', 'Admin', '2019-06-20 14:56:04', '2019-06-20 14:56:04'),
('79eeb2d2-2e97-11e9-918d-6045cb6ad5d4', '539a33c2-2e97-11e9-918d-6045cb6ad5d4', 'ui/photo_library/Cat03.jpg', 'Admin', '2019-02-12 08:26:26', '2019-03-06 11:41:15'),
('89f75014-9d6c-11e9-9a38-6045cb6ad5d4', '641091d1-9d6c-11e9-9a38-6045cb6ad5d4', 'ui/photo_library/5690.jpg', 'Admin', '2019-07-03 16:28:16', '2019-07-03 16:28:16'),
('8b4cf8e4-931a-11e9-9281-6045cb6ad5d4', '69d6ea04-931a-11e9-9281-6045cb6ad5d4', 'ui/photo_library/5251.jpg', 'Admin', '2019-06-20 13:16:13', '2019-06-20 13:16:13'),
('8c40102d-7abf-11e9-90b1-6045cb6ad5d4', '7b256e4f-7abf-11e9-90b1-6045cb6ad5d4', 'ui/photo_library/Cat03.jpg', 'Admin', '2019-05-20 13:24:29', '2019-05-20 13:24:29'),
('903f66fb-9327-11e9-99a7-6045cb6ad5d4', '77b84e8e-9327-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5235.jpg', 'Admin', '2019-06-20 14:49:34', '2019-06-20 14:49:34'),
('93ae7585-931c-11e9-9281-6045cb6ad5d4', 'f6a84e73-931b-11e9-9281-6045cb6ad5d4', 'ui/photo_library/sally.PNG', 'Admin', '2019-06-20 13:30:46', '2019-06-20 13:30:46'),
('98b3cf96-93bd-11e9-99a7-6045cb6ad5d4', 'a131f3f4-9328-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5230.jpg', 'Admin', '2019-06-21 08:43:32', '2019-06-21 08:43:32'),
('a33dca3f-9d6a-11e9-9a38-6045cb6ad5d4', '8351fcca-9d6a-11e9-9a38-6045cb6ad5d4', 'ui/photo_library/5719.jpg', 'Admin', '2019-07-03 16:14:39', '2019-07-03 16:14:39'),
('a6bbc02e-7ac0-11e9-90b1-6045cb6ad5d4', '8cc3bf56-7ac0-11e9-90b1-6045cb6ad5d4', 'ui/photo_library/MAM JO.PNG', 'Admin', '2019-05-20 13:32:23', '2019-05-20 13:33:11'),
('aa8592f8-93bd-11e9-99a7-6045cb6ad5d4', 'f129a2b7-9327-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5237.jpg', 'Admin', '2019-06-21 08:44:02', '2019-06-21 08:44:02'),
('b592621d-9329-11e9-99a7-6045cb6ad5d4', '999e8f31-9329-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5217.jpg', 'Admin', '2019-06-20 15:04:55', '2019-06-20 15:04:55'),
('b62144aa-3fec-11e9-8886-6045cb6ad5d4', '99dd3381-3fec-11e9-8886-6045cb6ad5d4', 'ui/photo_library/RJAY.JPG', 'Admin', '2019-03-06 16:49:03', '2019-05-20 13:39:13'),
('b83c1175-93bb-11e9-99a7-6045cb6ad5d4', 'af0389a4-93bb-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/rens.PNG', 'Admin', '2019-06-21 08:30:06', '2019-06-21 08:30:06'),
('b8680be7-4164-11e9-8886-6045cb6ad5d4', 'ad684a81-4164-11e9-8886-6045cb6ad5d4', 'ui/photo_library/EMS.JPG', 'Admin', '2019-03-08 13:40:34', '2019-05-20 13:39:57'),
('bde70e6c-93bc-11e9-99a7-6045cb6ad5d4', '9ec97cd8-93bc-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5204.jpg', 'Admin', '2019-06-21 08:37:25', '2019-06-21 08:37:25'),
('bf096b28-3fbf-11e9-8886-6045cb6ad5d4', 'a809fd68-3fbf-11e9-8886-6045cb6ad5d4', 'ui/photo_library/ruth.jpg', 'Admin', '2019-03-06 11:27:11', '2019-03-06 11:27:11'),
('bfdd37fc-931a-11e9-9281-6045cb6ad5d4', 'b6a81760-931a-11e9-9281-6045cb6ad5d4', 'ui/photo_library/5215.jpg', 'Admin', '2019-06-20 13:17:41', '2019-06-20 13:17:41'),
('c37d86e3-3fbc-11e9-8886-6045cb6ad5d4', '825d1f20-3bf8-11e9-8886-6045cb6ad5d4', 'ui/photo_library/CHIRS.JPG', 'Admin', '2019-03-06 11:05:50', '2019-05-20 13:38:58'),
('c7b2f884-9327-11e9-99a7-6045cb6ad5d4', 'adf17405-9327-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5236.jpg', 'Admin', '2019-06-20 14:51:07', '2019-06-20 14:51:07'),
('c8611da6-931d-11e9-9281-6045cb6ad5d4', 'a5403234-931d-11e9-9281-6045cb6ad5d4', 'ui/photo_library/5228.jpg', 'Admin', '2019-06-20 13:39:24', '2019-06-20 13:39:24'),
('d18e33fc-9d6b-11e9-9a38-6045cb6ad5d4', 'ae905ca1-9d6b-11e9-9a38-6045cb6ad5d4', 'ui/photo_library/5695.jpg', 'Admin', '2019-07-03 16:23:06', '2019-07-03 16:23:06'),
('d3ee12d0-931b-11e9-9281-6045cb6ad5d4', 'b10bd7ba-931b-11e9-9281-6045cb6ad5d4', 'ui/photo_library/mong.PNG', 'Admin', '2019-06-20 13:25:24', '2019-06-20 13:25:24'),
('d68b5937-93bc-11e9-99a7-6045cb6ad5d4', '63753b67-93bc-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5223.jpg', 'Admin', '2019-06-21 08:38:07', '2019-06-21 08:38:07'),
('df31eab6-9d6c-11e9-9a38-6045cb6ad5d4', 'acb782cd-9d6c-11e9-9a38-6045cb6ad5d4', 'ui/photo_library/5712.jpg', 'Admin', '2019-07-03 16:30:39', '2019-07-03 16:30:39'),
('e10d7885-9d6a-11e9-9a38-6045cb6ad5d4', 'c3fb3e2c-9d6a-11e9-9a38-6045cb6ad5d4', 'ui/photo_library/5997.jpg', 'Admin', '2019-07-03 16:16:23', '2019-07-03 16:16:23'),
('e8f36b50-931c-11e9-9281-6045cb6ad5d4', 'c36d570d-931c-11e9-9281-6045cb6ad5d4', 'ui/photo_library/law.jpg', 'Admin', '2019-06-20 13:33:09', '2019-06-20 13:33:09'),
('eb0860ed-931c-11e9-9281-6045cb6ad5d4', 'c36d570d-931c-11e9-9281-6045cb6ad5d4', 'ui/photo_library/law.jpg', 'Admin', '2019-06-20 13:33:12', '2019-06-20 13:33:12'),
('eb0f1e78-931c-11e9-9281-6045cb6ad5d4', 'c36d570d-931c-11e9-9281-6045cb6ad5d4', 'ui/photo_library/law.jpg', 'Admin', '2019-06-20 13:33:12', '2019-06-20 13:33:12'),
('f0d686e0-9326-11e9-99a7-6045cb6ad5d4', 'd2da8a77-9326-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5231.jpg', 'Admin', '2019-06-20 14:45:06', '2019-06-20 14:45:06'),
('f511e849-9329-11e9-99a7-6045cb6ad5d4', 'd4b8c6b4-9329-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5219.jpg', 'Admin', '2019-06-20 15:06:42', '2019-06-20 15:06:42'),
('f5f75e05-9328-11e9-99a7-6045cb6ad5d4', 'da6fca34-9328-11e9-99a7-6045cb6ad5d4', 'ui/photo_library/5387.jpg', 'Admin', '2019-06-20 14:59:34', '2019-06-20 14:59:34'),
('fa40d1a0-3bf4-11e9-8886-6045cb6ad5d4', 'de78ba06-3bf3-11e9-8886-6045cb6ad5d4', 'ui/photo_library/OMS.JPG', 'Admin', '2019-03-01 15:38:10', '2019-03-06 11:44:03');

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

--
-- Truncate table before insert `gate_personstatus`
--

TRUNCATE TABLE `gate_personstatus`;
--
-- Dumping data for table `gate_personstatus`
--

INSERT INTO `gate_personstatus` (`gate_personstatusid`, `card_id`, `campus_status`, `gate_id`, `updatedate`) VALUES
(1, 'ghghnghn', 0, '', '2019-02-12 00:36:04'),
(2, '0016069034', 1, '', '2019-02-12 15:35:06'),
(3, '0015704381', 0, '', '2019-06-27 17:05:22'),
(4, '0015704390', 1, '', '2019-07-06 14:24:14'),
(5, '0012890960', 0, '', '2019-06-28 17:16:40'),
(6, '0015511669', 1, '', '2019-07-06 15:54:10'),
(7, '0000369343', 0, '', '2019-06-27 08:34:48'),
(8, '0000370381', 0, '', '2019-07-06 07:51:13'),
(9, '0012863058', 0, '', '2019-07-05 08:47:35'),
(10, '0015511656', 1, '', '2019-07-05 17:02:52'),
(11, '0015492140', 0, '', '2019-03-25 07:43:10'),
(12, '0015704523', 1, '', '2019-07-06 17:33:14'),
(13, '0000206266', 1, '', '2019-04-29 11:44:05'),
(14, '0000206266', 1, '', '2019-04-29 11:44:05'),
(15, '0000206266', 1, '', '2019-04-29 11:44:05'),
(16, '0000206290', 0, '', '2019-05-20 13:44:40'),
(17, '0016214400', 0, '', '2019-05-20 14:55:00'),
(18, '0000368593', 0, '', '2019-07-06 16:06:18'),
(19, '0000369666', 1, '', '2019-07-06 16:49:51'),
(20, '0000378573', 0, '', '2019-07-06 17:36:10'),
(21, '0000369680', 1, '', '2019-07-06 17:43:15'),
(22, '', 1, '', '2019-07-04 18:36:43'),
(23, '0000368797', 1, '', '2019-07-06 17:00:36'),
(24, '0015706324', 0, '', '2019-07-05 20:08:58'),
(25, '0000880997', 1, '', '2019-07-06 17:02:22'),
(26, '0000368574', 1, '', '2019-07-05 17:12:40'),
(27, '0000368796', 0, '', '2019-07-05 17:54:46'),
(28, '0000378465', 1, '', '2019-07-05 19:01:47'),
(29, '0000880884', 1, '', '2019-07-05 20:00:23'),
(30, '0000880928', 1, '', '2019-07-05 20:00:38'),
(31, '0000378453', 1, '', '2019-07-05 17:11:20'),
(32, '0000378472', 0, '', '2019-07-05 18:07:43'),
(33, '0000880939', 1, '', '2019-07-05 18:09:16'),
(34, '0000369608', 0, '', '2019-07-05 17:54:57'),
(35, '0000880934', 0, '', '2019-07-05 16:37:06'),
(36, '0000369628', 1, '', '2019-07-05 20:04:05'),
(37, '0000880942', 1, '', '2019-07-05 18:11:35'),
(38, '0000368605', 0, '', '2019-07-05 17:05:43'),
(39, '0000378592', 0, '', '2019-07-05 17:02:54'),
(40, '0015070280', 0, '', '2019-07-05 17:06:44'),
(41, '0015070191', 1, '', '2019-07-06 17:09:57'),
(42, '0015069609', 1, '', '2019-07-05 16:15:05'),
(43, '0015070249', 1, '', '2019-07-05 17:11:27'),
(44, '0014771794', 1, '', '2019-07-06 17:03:02'),
(45, '0000378553', 1, '', '2019-07-06 17:03:11'),
(46, '0015112176', 0, '', '2019-07-05 17:11:18'),
(47, '0015069576', 0, '', '2019-07-05 17:54:26'),
(48, '0000378575', 1, '', '2019-07-06 16:44:51'),
(49, '0000368574', 1, '', '2019-07-05 17:12:40'),
(50, '0000369714', 1, '', '2019-07-05 18:01:10'),
(51, '0012863079', 1, '', '2019-07-03 16:32:40'),
(52, '0012862066', 1, '', '2019-07-03 16:32:42'),
(53, '0012862077', 0, '', '2019-07-03 16:33:26'),
(54, '0000877136', 0, '', '2019-07-03 16:17:34'),
(55, '0000369557', 0, '', '2019-07-03 16:22:19'),
(56, '0000370640', 0, '', '2019-07-03 16:24:08'),
(57, '0000370242', 0, '', '2019-07-03 16:25:49'),
(58, '0000877103', 0, '', '2019-07-03 16:27:19'),
(59, '0000378477', 0, '', '2019-07-03 16:29:26'),
(60, '0000368816', 0, '', '2019-07-03 16:31:54');

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

--
-- Truncate table before insert `gate_usercategory`
--

TRUNCATE TABLE `gate_usercategory`;
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
-- Truncate table before insert `gate_users`
--

TRUNCATE TABLE `gate_users`;
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

--
-- Truncate table before insert `header_settings`
--

TRUNCATE TABLE `header_settings`;
--
-- Dumping data for table `header_settings`
--

INSERT INTO `header_settings` (`id`, `header_name`, `updatedat`, `updatedby`) VALUES
(1, 'Bulbasaur', '2019-08-18 20:37:32', 'Admin');

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

--
-- Truncate table before insert `logo_table`
--

TRUNCATE TABLE `logo_table`;
--
-- Dumping data for table `logo_table`
--

INSERT INTO `logo_table` (`logoid`, `image_url`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(0, 'ui/photo_library/thumb-1920-597456.jpg', 'Admin', 'Admin', '2019-08-18 20:24:36', '2019-08-18 20:24:36');

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
-- Truncate table before insert `msg_template`
--

TRUNCATE TABLE `msg_template`;
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

--
-- Truncate table before insert `party_stdconnector`
--

TRUNCATE TABLE `party_stdconnector`;
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

--
-- Truncate table before insert `person`
--

TRUNCATE TABLE `person`;
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

--
-- Truncate table before insert `person_image`
--

TRUNCATE TABLE `person_image`;
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

--
-- Truncate table before insert `sms_logs`
--

TRUNCATE TABLE `sms_logs`;
-- --------------------------------------------------------

--
-- Table structure for table `sms_settings`
--

CREATE TABLE `sms_settings` (
  `id` int(11) NOT NULL,
  `ipaddress` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Truncate table before insert `sms_settings`
--

TRUNCATE TABLE `sms_settings`;
--
-- Dumping data for table `sms_settings`
--

INSERT INTO `sms_settings` (`id`, `ipaddress`) VALUES
(1, '192.168.1.2:8080');

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

--
-- Truncate table before insert `staff`
--

TRUNCATE TABLE `staff`;
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

--
-- Truncate table before insert `student`
--

TRUNCATE TABLE `student`;
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
-- Truncate table before insert `user_emergencycontact`
--

TRUNCATE TABLE `user_emergencycontact`;
--
-- Dumping data for table `user_emergencycontact`
--

INSERT INTO `user_emergencycontact` (`contactId`, `contactName`, `contactRelationship`, `contactNumber`, `createDate`, `createdBy`, `updateDate`, `personDetailId`) VALUES
('030cdc4f-9328-11e9-99a7-6045cb6ad5d4', 'ROWENA M. PONCE', 'GUARDIAN', '09121332580', '2019-06-20 14:52:46', 'Admin', '2019-06-20 14:52:46', 'f129a2b7-9327-11e9-99a7-6045cb6ad5d4'),
('049b40e9-9d6c-11e9-9a38-6045cb6ad5d4', 'AILYN B. MAQUILAT', 'GUARDIAN', '09362095966', '2019-07-03 16:24:32', 'Admin', '2019-07-03 16:24:32', 'f14fc0ba-9d6b-11e9-9a38-6045cb6ad5d4'),
('0c1c1135-931c-11e9-9281-6045cb6ad5d4', 'IRISH LANSANG', 'GURDIAN', '09070582755', '2019-06-20 13:26:58', 'Admin', '2019-06-20 13:27:11', 'f6a84e73-931b-11e9-9281-6045cb6ad5d4'),
('15a007d2-9d6b-11e9-9a38-6045cb6ad5d4', 'MARLENE D. BERNANDEZ', 'GUARDIAN', '09081810758', '2019-07-03 16:17:51', 'Admin', '2019-07-03 16:18:20', '03294b0d-9d6b-11e9-9a38-6045cb6ad5d4'),
('18de3aac-9d6d-11e9-9a38-6045cb6ad5d4', 'LYDIA DUEÑAS', 'GUARDIAN', '09267160405', '2019-07-03 16:32:15', 'Admin', '2019-07-03 16:32:15', '07b80f22-9d6d-11e9-9a38-6045cb6ad5d4'),
('1fe64b8d-932a-11e9-99a7-6045cb6ad5d4', 'CONRADO L. PEREY', 'GUARDIAN', '09106883038', '2019-06-20 15:07:54', 'Admin', '2019-06-20 15:07:54', '0bf9498e-932a-11e9-99a7-6045cb6ad5d4'),
('2a0f07fb-9327-11e9-99a7-6045cb6ad5d4', 'MA. CORAZON B. NAGUIAT', 'GUARDIAN', '09479640918', '2019-06-20 14:46:42', 'Admin', '2019-06-20 14:46:42', '18235d66-9327-11e9-99a7-6045cb6ad5d4'),
('2cc8196b-9328-11e9-99a7-6045cb6ad5d4', 'DARWIN G. ACEBO', 'GUARDIAN', '09306044042', '2019-06-20 14:53:56', 'Admin', '2019-06-20 14:53:56', '1d933f23-9328-11e9-99a7-6045cb6ad5d4'),
('2e5fc10a-9329-11e9-99a7-6045cb6ad5d4', 'NICANOR L. FLORES JR.', 'GUARDIAN', '09053382997', '2019-06-20 15:01:08', 'Admin', '2019-06-20 15:01:08', '1e9c64e5-9329-11e9-99a7-6045cb6ad5d4'),
('30338ed0-931a-11e9-9281-6045cb6ad5d4', 'LOVELY N. PAMESA', 'GUARDIAN', '09397901308', '2019-06-20 13:13:40', 'Admin', '2019-06-20 13:13:40', '1c9cd091-931a-11e9-9281-6045cb6ad5d4'),
('331e9c8f-3fbf-11e9-8886-6045cb6ad5d4', 'ECST', 'COMPANY', '09088923007', '2019-03-06 11:23:16', 'Admin', '2019-07-03 16:20:20', '106e504f-3fbf-11e9-8886-6045cb6ad5d4'),
('37faf30e-931d-11e9-9281-6045cb6ad5d4', 'JOHN A. PANES', 'GUARDIAN', '09389713892', '2019-06-20 13:35:21', 'Admin', '2019-06-20 13:35:21', '26a8380c-931d-11e9-9281-6045cb6ad5d4'),
('3809237f-93bc-11e9-99a7-6045cb6ad5d4', 'BERNARDO M. CRUZADO', 'GUARDIAN', '09475442728', '2019-06-21 08:33:41', 'Admin', '2019-06-21 08:33:41', '20572fe1-93bc-11e9-99a7-6045cb6ad5d4'),
('3d9cd6df-9d6c-11e9-9a38-6045cb6ad5d4', 'ELIZABETH', 'GUARDIAN', '09386624140', '2019-07-03 16:26:07', 'Admin', '2019-07-03 16:26:07', '25bbc0fe-9d6c-11e9-9a38-6045cb6ad5d4'),
('4d13b84e-9d6a-11e9-9a38-6045cb6ad5d4', 'MAVIA FE C. MANGALINDAN', 'GUARDIAN', '09124064913', '2019-07-03 16:12:14', 'Admin', '2019-07-03 16:12:14', '2e3292cb-9d6a-11e9-9a38-6045cb6ad5d4'),
('4da796a4-3fbb-11e9-8886-6045cb6ad5d4', 'ecst', 'company', '09088923007', '2019-03-06 10:55:23', 'Admin', '2019-04-08 15:37:49', '646abb14-3fba-11e9-8886-6045cb6ad5d4'),
('583e7911-3fc0-11e9-8886-6045cb6ad5d4', 'ECST', 'COMPANY', '09088923007', '2019-03-06 11:31:28', 'Admin', '2019-03-06 11:31:28', '2958f0c0-3fc0-11e9-8886-6045cb6ad5d4'),
('5b6762fd-932a-11e9-99a7-6045cb6ad5d4', 'JOCELYN SALAZAR', 'GUARDIAN', '09471415265', '2019-06-20 15:09:34', 'Admin', '2019-06-20 15:09:34', '49a09405-932a-11e9-99a7-6045cb6ad5d4'),
('5f91c7de-931b-11e9-9281-6045cb6ad5d4', 'CRESENCIA CARAIG', 'GUARDIAN', '09207118329', '2019-06-20 13:22:09', 'Admin', '2019-06-20 13:22:09', '1ae4ff53-931b-11e9-9281-6045cb6ad5d4'),
('6b1124fd-9328-11e9-99a7-6045cb6ad5d4', 'LUCIA V. PANTIG', 'GUARDIAN', '09071246251', '2019-06-20 14:55:41', 'Admin', '2019-06-20 14:55:41', '5d7164af-9328-11e9-99a7-6045cb6ad5d4'),
('71ad5c3f-9329-11e9-99a7-6045cb6ad5d4', 'MARIA TERESA R. PEÑA', 'GUARDIAN', '09473251552', '2019-06-20 15:03:01', 'Admin', '2019-06-20 15:03:01', '5e9dd2e6-9329-11e9-99a7-6045cb6ad5d4'),
('784043b9-93bc-11e9-99a7-6045cb6ad5d4', 'JENNIFER H. SINGIAN', 'GUARDIAN', '09432830941', '2019-06-21 08:35:28', 'Admin', '2019-06-21 08:35:28', '63753b67-93bc-11e9-99a7-6045cb6ad5d4'),
('789f794e-931d-11e9-9281-6045cb6ad5d4', 'SOLOMON V. PAJARILLO JR.', 'GUARDIAN', '09385810473', '2019-06-20 13:37:10', 'Admin', '2019-06-20 13:37:10', '6648a251-931d-11e9-9281-6045cb6ad5d4'),
('7bc3d1b4-931a-11e9-9281-6045cb6ad5d4', 'TEODORA G. BELTRAN', 'GUARDIAN', '09479465940', '2019-06-20 13:15:47', 'Admin', '2019-06-20 13:15:47', '69d6ea04-931a-11e9-9281-6045cb6ad5d4'),
('7c01e62c-9d6c-11e9-9a38-6045cb6ad5d4', 'CARMELA C. FLORA', 'GUARDIAN', '09282758615', '2019-07-03 16:27:52', 'Admin', '2019-07-03 16:27:52', '641091d1-9d6c-11e9-9a38-6045cb6ad5d4'),
('82aa922b-9d6b-11e9-9a38-6045cb6ad5d4', 'ECST', 'COMPANY', '09088923007', '2019-07-03 16:20:54', 'Admin', '2019-07-03 16:20:54', '042e1772-97ef-11e9-9a38-6045cb6ad5d4'),
('84b8cf3b-9327-11e9-99a7-6045cb6ad5d4', 'EMELYN S. MAYUYO', 'GUARDIAN', '09301641464', '2019-06-20 14:49:14', 'Admin', '2019-06-20 14:49:14', '77b84e8e-9327-11e9-99a7-6045cb6ad5d4'),
('972f87b9-3bf8-11e9-8886-6045cb6ad5d4', 'ECST', 'COMPANY', '09088923007', '2019-03-01 16:04:02', 'Admin', '2019-03-08 09:28:37', '825d1f20-3bf8-11e9-8886-6045cb6ad5d4'),
('9a77dc69-9d6a-11e9-9a38-6045cb6ad5d4', 'HELEN S. VALENCIA', 'GUARDIAN', '09185207603', '2019-07-03 16:14:24', 'Admin', '2019-07-03 16:14:24', '8351fcca-9d6a-11e9-9a38-6045cb6ad5d4'),
('a7d5a268-9316-11e9-9281-6045cb6ad5d4', 'MARLYN DE CRUZ', 'GUARDIAN', '09996631346', '2019-06-20 12:48:23', 'Admin', '2019-06-20 12:48:23', '90dc0ff5-9316-11e9-9281-6045cb6ad5d4'),
('ab06a591-9329-11e9-99a7-6045cb6ad5d4', 'EVA PAGUIO', 'GUARDIAN', '09183767872', '2019-06-20 15:04:38', 'Admin', '2019-06-20 15:04:38', '999e8f31-9329-11e9-99a7-6045cb6ad5d4'),
('b14f4e5f-59d1-11e9-97d9-6045cb6ad5d4', 'nancy', 'mother', '09088923007', '2019-04-08 15:41:19', 'Admin', '2019-04-29 11:40:20', '6a4c4366-59d1-11e9-97d9-6045cb6ad5d4'),
('b18b603a-9328-11e9-99a7-6045cb6ad5d4', 'BILLY E. TORRES', 'GUARDIAN', '09213190434', '2019-06-20 14:57:39', 'Admin', '2019-06-20 14:57:39', 'a131f3f4-9328-11e9-99a7-6045cb6ad5d4'),
('b656dc8b-2e97-11e9-918d-6045cb6ad5d4', 'ROBERT CRUZADO', 'FATHER', '09088923007', '2019-02-12 08:28:07', 'Admin', '2019-03-06 10:57:02', '539a33c2-2e97-11e9-918d-6045cb6ad5d4'),
('b688a375-93bc-11e9-99a7-6045cb6ad5d4', 'HELEN S. VALENCIA', 'GUARDIAN', '09484224225', '2019-06-21 08:37:13', 'Admin', '2019-06-21 08:37:13', '9ec97cd8-93bc-11e9-99a7-6045cb6ad5d4'),
('b8e71b61-3fbf-11e9-8886-6045cb6ad5d4', 'ECST', 'COMPANY', '09088923007', '2019-03-06 11:27:01', 'Admin', '2019-03-08 13:41:10', 'a809fd68-3fbf-11e9-8886-6045cb6ad5d4'),
('beadba04-9327-11e9-99a7-6045cb6ad5d4', 'HAYDEE D. PEÑA', 'GUARDIAN', '09127340912', '2019-06-20 14:50:52', 'Admin', '2019-06-20 14:50:52', 'adf17405-9327-11e9-99a7-6045cb6ad5d4'),
('bf569725-931d-11e9-9281-6045cb6ad5d4', 'EVELYN A. MANGUIL', 'GUARDIAN', '09463035238', '2019-06-20 13:39:08', 'Admin', '2019-06-20 13:39:08', 'a5403234-931d-11e9-9281-6045cb6ad5d4'),
('c093d714-3fec-11e9-8886-6045cb6ad5d4', 'ECST', 'COMPANY', '09088923007', '2019-03-06 16:49:21', 'Admin', '2019-03-06 16:49:21', '99dd3381-3fec-11e9-8886-6045cb6ad5d4'),
('c81171e7-931b-11e9-9281-6045cb6ad5d4', 'MA. CRISTINA M. CATLI', 'GUARDIAN', '09291080952', '2019-06-20 13:25:04', 'Admin', '2019-06-20 13:25:04', 'b10bd7ba-931b-11e9-9281-6045cb6ad5d4'),
('c8d9f5dc-9d6b-11e9-9a38-6045cb6ad5d4', 'MARICEL SANTIZAS', 'GUARDIAN', '09103665682', '2019-07-03 16:22:52', 'Admin', '2019-07-03 16:22:52', 'ae905ca1-9d6b-11e9-9a38-6045cb6ad5d4'),
('cca8f76d-3fbd-11e9-8886-6045cb6ad5d4', 'ECST', 'COMPANY', '09088923007', '2019-03-06 11:13:15', 'Admin', '2019-03-06 11:13:58', '9e210acd-3fbc-11e9-8886-6045cb6ad5d4'),
('ced36ebc-931a-11e9-9281-6045cb6ad5d4', 'MARIA FE C. DELOS REYES', 'GUARDIAN', '09103918386', '2019-06-20 13:18:06', 'Admin', '2019-06-20 13:18:06', 'b6a81760-931a-11e9-9281-6045cb6ad5d4'),
('d57c16f5-4164-11e9-8886-6045cb6ad5d4', 'ECST', 'COMPANY', '09088923007', '2019-03-08 13:41:23', 'Admin', '2019-03-08 13:41:23', 'ad684a81-4164-11e9-8886-6045cb6ad5d4'),
('d69a0abe-931c-11e9-9281-6045cb6ad5d4', 'LIZA A. MALLARI', 'GUARDIAN', '09976733443', '2019-06-20 13:32:38', 'Admin', '2019-06-21 08:41:18', 'c36d570d-931c-11e9-9281-6045cb6ad5d4'),
('d83283ff-9d6a-11e9-9a38-6045cb6ad5d4', 'PERLA SINGIAN', 'GUARDIAN', '09482774775', '2019-07-03 16:16:08', 'Admin', '2019-07-03 16:16:08', 'c3fb3e2c-9d6a-11e9-9a38-6045cb6ad5d4'),
('d83cd9e3-9d6c-11e9-9a38-6045cb6ad5d4', 'CHACO FRANCISCO', 'GUARDIAN', '09676095391', '2019-07-03 16:30:27', 'Admin', '2019-07-03 16:30:27', 'acb782cd-9d6c-11e9-9a38-6045cb6ad5d4'),
('da9ae6ab-93bb-11e9-99a7-6045cb6ad5d4', 'JOSEPHINE TUMANGUIL', 'GUARDIAN', '09972148541', '2019-06-21 08:31:04', 'Admin', '2019-06-21 08:31:04', 'af0389a4-93bb-11e9-99a7-6045cb6ad5d4'),
('dcfbc2e2-3bf4-11e9-8886-6045cb6ad5d4', 'ECST', 'COMPANY', '09494351323', '2019-03-01 15:37:21', 'Admin', '2019-03-08 10:17:58', 'de78ba06-3bf3-11e9-8886-6045cb6ad5d4'),
('e477e676-9326-11e9-99a7-6045cb6ad5d4', 'LEONILA S. PANLAQUI', 'GUARDIAN', '09565885798', '2019-06-20 14:44:45', 'Admin', '2019-06-20 14:44:45', 'd2da8a77-9326-11e9-99a7-6045cb6ad5d4'),
('e5f83e04-9329-11e9-99a7-6045cb6ad5d4', 'CATALINA H. GIGANTE', 'GUARDIAN', '09277125797', '2019-06-20 15:06:16', 'Admin', '2019-06-20 15:06:16', 'd4b8c6b4-9329-11e9-99a7-6045cb6ad5d4'),
('e805a528-9328-11e9-99a7-6045cb6ad5d4', 'JOEL A. ELEN', 'GUARDIAN', '09127624971', '2019-06-20 14:59:10', 'Admin', '2019-06-20 14:59:10', 'da6fca34-9328-11e9-99a7-6045cb6ad5d4'),
('f4d308c6-3bf8-11e9-8886-6045cb6ad5d4', 'MYSELF', 'ME', '09305005960', '2019-03-01 16:06:39', 'Admin', '2019-04-16 14:05:51', 'e0d43f9c-3bf8-11e9-8886-6045cb6ad5d4'),
('f540c39c-7abf-11e9-90b1-6045cb6ad5d4', 'ContactName', '', '09175573914', '2019-05-20 13:27:25', 'Admin', '2019-05-20 13:27:25', '7b256e4f-7abf-11e9-90b1-6045cb6ad5d4');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=975;

--
-- AUTO_INCREMENT for table `contactlist`
--
ALTER TABLE `contactlist`
  MODIFY `contactlistid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `contactlist_users`
--
ALTER TABLE `contactlist_users`
  MODIFY `contactlistuserid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gate_history`
--
ALTER TABLE `gate_history`
  MODIFY `transaction_id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=976;

--
-- AUTO_INCREMENT for table `gate_personstatus`
--
ALTER TABLE `gate_personstatus`
  MODIFY `gate_personstatusid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
