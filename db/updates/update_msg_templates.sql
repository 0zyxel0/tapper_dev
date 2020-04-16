-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 16, 2020 at 03:41 PM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.3

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
-- Table structure for table `msg_template`
--

CREATE TABLE `msg_template` (
  `messageId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `message_type` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `msg_intro` varchar(60) COLLATE utf8_unicode_ci DEFAULT NULL,
  `msg_text` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `createdBy` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `createDate` datetime NOT NULL,
  `updatedBy` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `updateDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `msg_template`
--
ALTER TABLE `msg_template`
  ADD PRIMARY KEY (`messageId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
