-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Jun 22, 2026 at 07:25 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `umt_clubsphere_dev`
--

-- --------------------------------------------------------

--
-- Table structure for table `agm_report`
--

CREATE TABLE `agm_report` (
  `agmId` int(11) NOT NULL,
  `clubId` int(11) NOT NULL,
  `reportYear` year(4) NOT NULL,
  `reportPath` varchar(255) DEFAULT NULL,
  `submittedAt` timestamp NULL DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Missing',
  `remarks` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `agm_report`
--

INSERT INTO `agm_report` (`agmId`, `clubId`, `reportYear`, `reportPath`, `submittedAt`, `status`, `remarks`) VALUES
(8, 1002, '2026', 'AGM_1002_2026_1782042702114.pdf', '2026-06-21 11:51:42', 'Pending_MPP', NULL),
(9, 1002, '2025', 'AGM_1002_2025_1777475455867.pdf', '2026-04-29 15:10:55', 'Accepted', ''),
(10, 1002, '2024', 'AGM_1002_2024_1777495224191.pdf', '2026-04-29 20:40:24', 'Accepted', '');

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `logId` int(11) NOT NULL,
  `userId` varchar(10) DEFAULT NULL,
  `proposalId` int(11) DEFAULT NULL,
  `Action` varchar(100) NOT NULL,
  `Description` text DEFAULT NULL,
  `ipAddress` varchar(45) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`logId`, `userId`, `proposalId`, `Action`, `Description`, `ipAddress`, `createdAt`) VALUES
(1, NULL, NULL, 'LOGIN', 'MPP accessed system', '192.168.1.10', '2025-12-30 14:55:41'),
(2, NULL, NULL, 'PROPOSAL_CREATE', 'Created AI Workshop proposal', '192.168.1.50', '2025-12-30 14:55:41'),
(3, NULL, NULL, 'CLUB_STATUS_CHECK', 'Reviewed AGM reports for 2025', '192.168.1.10', '2025-12-30 14:55:41'),
(4, NULL, NULL, 'PROPOSAL_REVIEW', 'Requested revision on Cultural Night', '192.168.1.11', '2025-12-30 14:55:41'),
(5, NULL, NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1', NULL, '2026-01-18 11:13:42'),
(6, NULL, NULL, 'ASSIGN_PRESIDENT', 'Assigned S72053 as President of Club 2', NULL, '2026-01-18 11:25:28'),
(7, NULL, NULL, 'REGISTER_CLUB', 'Registered new club: Kelab Femboy UMT', NULL, '2026-01-18 11:26:20'),
(8, NULL, NULL, 'ASSIGN_PRESIDENT', 'Assigned S70224 as President of Club 1003', NULL, '2026-01-18 11:26:57'),
(9, NULL, NULL, 'REMOVE_PRESIDENT', 'Removed President from Club ID 1001', NULL, '2026-01-18 12:16:46'),
(10, NULL, NULL, 'ASSIGN_PRESIDENT', 'Assigned S71383 as President of Club 1001', NULL, '2026-01-18 12:16:56'),
(11, NULL, NULL, 'REMOVE_PRESIDENT', 'Removed President from Club ID 1003', NULL, '2026-01-18 13:33:00'),
(12, NULL, NULL, 'ASSIGN_PRESIDENT', 'Assigned S70224 as President of Club 999', NULL, '2026-01-18 13:33:44'),
(13, NULL, NULL, 'ASSIGN_PRESIDENT', 'Assigned S70622 as President of Club 3', NULL, '2026-01-18 13:34:08'),
(14, NULL, NULL, 'REMOVE_PRESIDENT', 'Removed President from Club ID 1001', NULL, '2026-01-18 13:35:39'),
(15, NULL, NULL, 'ASSIGN_PRESIDENT', 'Assigned S88888 as President of Club 4', NULL, '2026-01-18 13:39:43'),
(16, NULL, NULL, 'ASSIGN_PRESIDENT', 'Assigned S70224 as President of Club 1001', NULL, '2026-01-18 13:43:15'),
(17, NULL, NULL, 'ASSIGN_PRESIDENT', 'Assigned S71383 as President of Club 1003', NULL, '2026-01-18 13:45:57'),
(18, NULL, NULL, 'ASSIGN_PRESIDENT', 'Assigned S77777 as President of Club 999', NULL, '2026-01-18 14:07:06'),
(19, NULL, NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 3', NULL, '2026-01-18 14:22:44'),
(20, NULL, NULL, 'REMOVE_PRESIDENT', 'Removed President from Club ID 999', NULL, '2026-01-18 14:23:07'),
(21, NULL, NULL, 'DELETE_CLUB', 'Permanently deleted Club ID 1003', NULL, '2026-01-18 23:37:04'),
(22, NULL, NULL, 'REVIEW_AGM', 'AGM Report for Club 1001 was marked as accepted', NULL, '2026-01-18 23:40:05'),
(23, NULL, NULL, 'REVIEW_AGM', 'AGM Report for Club 1001 was marked as Submitted', NULL, '2026-01-18 23:40:25'),
(24, NULL, NULL, 'ASSIGN_PRESIDENT', 'Assigned TEST_CHC as President of Club 999', NULL, '2026-01-19 01:47:20'),
(25, NULL, NULL, 'REGISTER_CLUB', 'Registered new club: Kelab robotic ', NULL, '2026-01-19 03:43:30'),
(26, NULL, NULL, 'REVIEW_AGM', 'AGM Report for Club 1001 was marked as accepted', NULL, '2026-01-19 03:48:05'),
(27, NULL, NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 999', NULL, '2026-01-19 03:48:18'),
(28, NULL, NULL, 'ASSIGN_PRESIDENT', 'Assigned S70622 as President of Club 3', NULL, '2026-01-19 07:53:28'),
(29, NULL, NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 3', NULL, '2026-01-19 08:43:32'),
(30, NULL, NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 3', NULL, '2026-01-19 09:07:25'),
(31, NULL, NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1', NULL, '2026-01-19 10:05:08'),
(32, NULL, NULL, 'REGISTER_CLUB', 'Registered new club: Kelab Kumpul Stem', NULL, '2026-01-19 10:06:18'),
(33, NULL, NULL, 'REVIEW_AGM', 'AGM Report for Club 1001 was marked as Submitted', NULL, '2026-01-19 11:42:17'),
(34, NULL, NULL, 'REVIEW_AGM', 'AGM Report for Club 1001 was marked as accepted', NULL, '2026-01-19 11:46:11'),
(35, NULL, NULL, 'REVIEW_AGM', 'AGM Report for Club 1001 was marked as Submitted', NULL, '2026-01-19 11:46:46'),
(36, NULL, NULL, 'REVIEW_AGM', 'AGM Report for Club 1001 was marked as accepted', NULL, '2026-01-19 11:50:24'),
(37, NULL, NULL, 'REVIEW_AGM', 'AGM Report for Club 1001 was marked as Submitted', NULL, '2026-01-19 11:50:32'),
(38, NULL, NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 3', NULL, '2026-01-19 16:40:23'),
(39, NULL, NULL, 'ASSIGN_PRESIDENT', 'Assigned S71383 as President of Club 1002', NULL, '2026-01-19 16:56:49'),
(40, NULL, NULL, 'ASSIGN_PRESIDENT', 'Assigned S72380 as President of Club 4', NULL, '2026-01-19 16:59:38'),
(41, NULL, NULL, 'REGISTER_CLUB', 'Registered new club: kelab melukis', NULL, '2026-01-21 01:27:18'),
(42, NULL, NULL, 'REVIEW_AGM', 'AGM Report for Club 1001 was marked as accepted', NULL, '2026-01-21 01:28:27'),
(43, NULL, NULL, 'UPDATE_STATUS', 'Changed Club 999 status to active', NULL, '2026-04-13 04:23:14'),
(44, NULL, NULL, 'ASSIGN_PRESIDENT', 'Assigned S72380 as President of Club 1004', NULL, '2026-04-13 04:39:29'),
(45, NULL, NULL, 'REMOVE_PRESIDENT', 'Removed President from Club ID 1004', NULL, '2026-04-13 04:40:32'),
(46, NULL, NULL, 'REVIEW_AGM', 'AGM Report for Club 1001 was marked as Submitted', NULL, '2026-04-13 04:41:09'),
(47, NULL, NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1002', NULL, '2026-04-13 04:42:06'),
(48, NULL, NULL, 'REVIEW_AGM', 'AGM Report for Club 1001 was marked as accepted', NULL, '2026-04-13 04:42:58'),
(49, NULL, NULL, 'REVIEW_AGM', 'AGM Report for Club 1001 was marked as Submitted', NULL, '2026-04-13 04:43:30'),
(50, NULL, NULL, 'REVIEW_AGM', 'AGM Report for Club 1001 was marked as missing', NULL, '2026-04-13 04:43:36'),
(51, NULL, NULL, 'ASSIGN_PRESIDENT', 'Assigned S70810 as President of Club 1004', NULL, '2026-04-13 08:07:14'),
(52, 'MPP001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1001', NULL, '2026-04-15 07:20:34'),
(53, 'MPP001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1001', NULL, '2026-04-29 11:04:04'),
(54, 'MPP001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1002', NULL, '2026-04-29 11:14:55'),
(55, 'MPP001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1001', NULL, '2026-04-29 12:57:30'),
(56, 'MPP001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1002', NULL, '2026-04-29 12:57:40'),
(57, 'MPP001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1002', NULL, '2026-04-29 13:05:31'),
(58, 'MPP001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1002', NULL, '2026-04-29 13:25:59'),
(59, 'MPP001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1002', NULL, '2026-04-29 13:35:21'),
(60, 'MPP001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1002', NULL, '2026-04-29 13:50:35'),
(61, 'MPP001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1002', NULL, '2026-04-29 14:19:18'),
(62, 'MPP001', NULL, 'REVIEW_AGM', 'AGM Report for Club 1002 was marked as Pending_HEPA', NULL, '2026-04-29 14:22:07'),
(63, 'HEPA001', NULL, 'REVIEW_AGM', 'AGM Report for Club 1002 was marked as Accepted', NULL, '2026-04-29 14:27:56'),
(64, 'MPP001', NULL, 'REVIEW_AGM', 'AGM Report for Club 1002 was marked as Missing', NULL, '2026-04-29 14:28:53'),
(65, 'MPP001', NULL, 'REVIEW_AGM', 'AGM Report for Club 1002 was marked as Pending_HEPA', NULL, '2026-04-29 14:30:37'),
(66, 'HEPA001', NULL, 'REVIEW_AGM', 'AGM Report for Club 1002 was marked as Missing', NULL, '2026-04-29 14:31:07'),
(67, 'HEPA001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1002', NULL, '2026-04-29 14:31:12'),
(68, 'HEPA001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1002', NULL, '2026-04-29 14:31:13'),
(69, 'HEPA001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1002', NULL, '2026-04-29 14:31:13'),
(70, 'HEPA001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1002', NULL, '2026-04-29 14:31:14'),
(71, 'HEPA001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1002', NULL, '2026-04-29 14:31:14'),
(72, 'HEPA001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1002', NULL, '2026-04-29 14:31:14'),
(73, 'HEPA001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1002', NULL, '2026-04-29 14:31:14'),
(74, 'HEPA001', NULL, 'SEND_REMINDER', 'Sent AGM Reminder to Club ID 1002', NULL, '2026-04-29 14:31:17'),
(75, 'MPP001', NULL, 'REVIEW_AGM', 'AGM Report for Club 1002 was marked as Missing', NULL, '2026-04-29 15:07:32'),
(76, 'MPP001', NULL, 'REVIEW_AGM', 'AGM Report for Club 1002 was marked as Pending_HEPA', NULL, '2026-04-29 15:11:23'),
(77, 'HEPA001', NULL, 'REVIEW_AGM', 'AGM Report for Club 1002 was marked as Accepted', NULL, '2026-04-29 15:12:10'),
(78, 'MPP001', NULL, 'REVIEW_AGM_MPP', 'AGM Report ID 10 decision: missing', NULL, '2026-04-29 20:28:20'),
(79, 'MPP001', NULL, 'REVIEW_AGM_MPP', 'AGM Report ID 10 decision: accepted', NULL, '2026-04-29 20:32:43'),
(80, 'HEPA001', NULL, 'APPROVE_AGM_HEPA', 'AGM Report ID 10 decision: accepted', NULL, '2026-04-29 20:34:58'),
(81, 'MPP001', NULL, 'REVIEW_AGM_MPP', 'AGM Report ID 10 decision: accepted', NULL, '2026-04-29 20:42:07'),
(82, 'HEPA001', NULL, 'APPROVE_AGM_HEPA', 'AGM Report ID 10 decision: accepted', NULL, '2026-04-29 20:43:13'),
(83, 'HEPA001', NULL, 'APPROVE_AGM_HEPA', 'AGM Report ID 9 decision: accepted', NULL, '2026-04-29 20:45:14'),
(84, 'MPP001', NULL, 'REMOVE_PRESIDENT', 'Removed President from Club ID 1001', NULL, '2026-04-30 08:57:25'),
(85, 'MPP001', NULL, 'ASSIGN_PRESIDENT', 'Assigned S72421 as President of Club 1001', NULL, '2026-04-30 08:57:58'),
(86, 'MPP001', NULL, 'ASSIGN_PRESIDENT', 'Assigned S00021 as President of Club 10000', NULL, '2026-04-30 09:16:05'),
(87, 'S70622', 58, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-02 00:33:00'),
(88, 'staff111', 58, 'Advisor Supported', 'Advisor verified and supported the proposal. Remarks: nice', NULL, '2026-06-02 01:20:00'),
(89, 'S70622', 50, 'Proposal Submitted', 'Proposal successfully submitted to Club Advisor.', NULL, '2026-04-25 17:34:00'),
(90, 'staff111', 50, 'Advisor Supported', 'Proposal supported. Content verified.', NULL, '2026-04-26 02:00:00'),
(91, 'MPP001', 50, 'Pitching Scheduled', 'Meeting set for 2026-04-28 via Google Meet.', NULL, '2026-04-26 07:34:00'),
(92, 'MPP001', 50, 'MPP Endorsed', 'Proposal passed pitching. Forwarded to HEPA.', NULL, '2026-04-28 02:00:00'),
(93, 'HEPA001', 50, 'HEPA Endorsed', 'Final official endorsement granted by HEPA.', NULL, '2026-04-28 06:36:00'),
(94, 'MPP001', 59, 'Budget Altered', 'MPP altered the budget line-items. Reason: Kurangkan pax makanan', NULL, '2026-06-04 02:42:00'),
(95, 'S70622', 60, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-04 04:49:58'),
(96, 'S70622', 53, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-04 04:52:46'),
(97, 'staff111', 60, 'Proposal Rejected', 'Club Advisor returned the proposal. Reason: not nice. remake', NULL, '2026-06-04 06:48:00'),
(98, 'S70622', 60, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-04 06:51:43'),
(99, 'staff111', 60, 'Advisor Supported', 'Advisor verified, uploaded E-Risk, and forwarded to MPP.', NULL, '2026-06-04 06:53:53'),
(100, 'S70622', 61, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-04 07:11:53'),
(101, 'S70622', 62, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-04 13:18:06'),
(102, 'S70622', 63, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-04 13:30:38'),
(103, 'staff111', 63, 'Proposal Rejected', 'Club Advisor returned the proposal. Reason: nice', NULL, '2026-06-04 13:44:14'),
(104, 'S70622', 63, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-04 13:49:06'),
(105, 'S70622', 64, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-04 13:53:31'),
(106, 'S70622', 65, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-04 14:01:54'),
(107, 'staff111', 65, 'Proposal Rejected', 'Club Advisor returned the proposal. Reason: dac', NULL, '2026-06-04 14:02:59'),
(108, 'S70622', 66, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-04 15:21:05'),
(109, 'staff111', 66, 'Proposal Rejected', 'Club Advisor returned the proposal. Reason: betulkan bajet', NULL, '2026-06-04 15:25:47'),
(110, 'S70622', 67, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-04 15:52:04'),
(111, 'staff111', 67, 'Proposal Rejected', 'Club Advisor returned the proposal. Reason: bad', NULL, '2026-06-04 15:53:18'),
(112, 'S70622', 67, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-04 15:54:26'),
(113, 'staff111', 67, 'Advisor Supported', 'Advisor verified, uploaded E-Risk, and forwarded to MPP.', NULL, '2026-06-04 15:56:31'),
(114, 'MPP001', 67, 'Budget Altered', 'MPP altered the budget line-items. Reason: Tambah bajet makanan', NULL, '2026-06-04 15:58:13'),
(115, 'MPP001', 67, 'Pitching Scheduled', 'Meeting set for 2026-06-16 00:33.', NULL, '2026-06-04 16:33:16'),
(116, 'MPP001', 67, 'Budget Altered', 'MPP altered the budget line-items. Reason: null', NULL, '2026-06-04 16:46:31'),
(117, 'MPP001', 67, 'MPP Endorsed', 'MPP endorsed the proposal post-pitching and forwarded to HEPA.', NULL, '2026-06-04 16:46:43'),
(118, 'S72421', 68, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-05 01:22:21'),
(119, 'staff123', 68, 'Advisor Supported', 'Advisor verified, uploaded E-Risk, and forwarded to Faculty.', NULL, '2026-06-05 01:26:13'),
(120, 'fskm', 68, 'Budget Altered', 'MPP altered the budget line-items. Reason: Added food', NULL, '2026-06-05 01:52:50'),
(121, 'fskm', 68, 'Approved by Faculty', 'Fakulti telah memberi kelulusan penuh (Final Approval) tanpa perlu rujukan lanjut ke HEPA.', NULL, '2026-06-05 01:53:03'),
(122, 'fskm', 39, 'Approved by Faculty', 'Fakulti telah memberi kelulusan penuh (Final Approval) tanpa perlu rujukan lanjut ke HEPA.', NULL, '2026-06-05 01:58:25'),
(123, 'S71805', 69, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-05 02:04:18'),
(124, 'staff123', 69, 'Advisor Supported', 'Advisor verified, uploaded E-Risk, and forwarded to Faculty.', NULL, '2026-06-05 02:05:48'),
(125, 'fskm', 69, 'Budget Altered', 'MPP altered the budget line-items. Reason: naikkan budget maknan', NULL, '2026-06-05 02:06:49'),
(126, 'fskm', 69, 'Budget Altered', 'MPP altered the budget line-items. Reason: sss', NULL, '2026-06-05 02:08:37'),
(127, 'fskm', 69, 'Approved by Faculty', 'Fakulti telah memberi kelulusan penuh (Final Approval) tanpa perlu rujukan lanjut ke HEPA.', NULL, '2026-06-05 02:09:01'),
(128, 'S71805', 70, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-05 02:21:39'),
(129, 'staff123', 70, 'Advisor Supported', 'Advisor verified, uploaded E-Risk, and forwarded to Faculty.', NULL, '2026-06-05 02:22:32'),
(130, 'fskm', 70, 'Budget Altered', 'Fakulti telah menukar bajet kertas kerja kepada RM 120.00 dengan ulasan: Added gift', NULL, '2026-06-05 02:24:03'),
(131, 'fskm', 70, 'Approved by Faculty', 'Fakulti telah memberi kelulusan penuh (Final Approval) tanpa perlu rujukan lanjut ke HEPA.', NULL, '2026-06-05 02:24:57'),
(132, 'fskm', 39, 'Faculty Endorsed', 'Fakulti telah menyemak dan menyokong kertas kerja ini kepada HEPA.', NULL, '2026-06-05 03:09:48'),
(133, 'MPP001', 47, 'MPP Endorsed', 'MPP endorsed the proposal post-pitching and forwarded to HEPA.', NULL, '2026-06-05 03:19:32'),
(134, 'HEPA001', 47, 'Budget Altered (HEPA)', 'Pihak HEPA telah membuat pemotongan/perubahan bajet akhir kepada RM 0.11 atas alasan: Add budget', NULL, '2026-06-05 03:21:27'),
(135, 'HEPA001', 47, 'Proposal Rejected', 'HEPA returned the proposal. Reason: bad', NULL, '2026-06-05 03:22:13'),
(136, 'HEPA001', 59, 'Approved by HEPA', 'Tahniah! HEPA telah meluluskan kertas kerja ini secara rasmi.', NULL, '2026-06-05 03:22:56'),
(137, 'MPP001', 60, 'Budget Altered', 'MPP altered the budget line-items. Reason: null', NULL, '2026-06-05 03:30:58'),
(138, 'MPP001', 60, 'MPP Endorsed', 'MPP endorsed the proposal post-pitching and forwarded to HEPA.', NULL, '2026-06-05 03:31:25'),
(139, 'HEPA001', 60, 'Budget Altered (HEPA)', 'Pihak HEPA telah membuat pemotongan/perubahan bajet akhir kepada RM 660.00 atas alasan: Kurangkan peralatan kepada 15 shj', NULL, '2026-06-05 03:32:46'),
(140, 'HEPA001', 60, 'Approved by HEPA', 'Tahniah! HEPA telah meluluskan kertas kerja ini secara rasmi.', NULL, '2026-06-05 03:32:56'),
(141, 'S70622', 71, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-05 08:36:50'),
(142, 'staff111', 71, 'Advisor Supported', 'Advisor verified and forwarded to MPP.', NULL, '2026-06-05 08:37:39'),
(143, 'MPP001', 71, 'Budget Altered (MPP)', 'MPP telah menyunting jadual bajet kepada RM 30.00.\nSebab: Penyelarasan bajet dibuat oleh pihak MPP.^null', NULL, '2026-06-05 08:38:27'),
(144, 'MPP001', 71, 'MPP Endorsed', 'MPP endorsed the proposal and forwarded to HEPA.', NULL, '2026-06-05 08:38:46'),
(145, 'HEPA001', 71, 'Budget Altered (HEPA)', 'Pihak HEPA telah mengubah bajet akhir kepada RM 70.00.\nAlasan: Added Makanan Peserta^Makanan Aiman [Edited by MPP]|3|10.00|30.00\r\nMakanan Peserta & AJK|5|8.00|40.00\r\nGRANDTOTAL| | |70.00', NULL, '2026-06-05 08:41:57'),
(146, 'HEPA001', 71, 'Approved by HEPA', 'Tahniah! HEPA telah meluluskan kertas kerja ini secara rasmi.', NULL, '2026-06-05 08:42:11'),
(147, 'MPP001', 57, 'Budget Altered (MPP)', 'MPP telah menyunting jadual bajet kepada RM 418.00.\nSebab: Penyelarasan bajet dibuat oleh pihak MPP.^Makanan Peserta & AJK|21|8.00|168.00\r\nHadiah|5|10.00|50.00\r\nCenderamata Juri  [Edited by MPP]|2|100.00|200.00\r\nGRANDTOTAL| | |418.00', NULL, '2026-06-05 08:59:17'),
(148, 'MPP001', 57, 'MPP Endorsed', 'MPP endorsed the proposal and forwarded to HEPA.', NULL, '2026-06-05 08:59:39'),
(149, 'HEPA001', 57, 'Budget Altered (HEPA)', 'Pihak HEPA telah mengubah bajet akhir kepada RM 408.00.\nAlasan: reduce the Hadiah to 4^Makanan Peserta & AJK|21|8.00|168.00\r\nHadiah|4|10.00|40.00\r\nCenderamata Juri  [Edited by MPP]|2|100.00|200.00\r\nGRANDTOTAL| | |408.00', NULL, '2026-06-05 09:00:44'),
(150, 'HEPA001', 57, 'Approved by HEPA', 'Tahniah! HEPA telah meluluskan kertas kerja ini secara rasmi.', NULL, '2026-06-05 09:00:49'),
(151, 'S70622', 72, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-05 09:23:14'),
(152, 'staff111', 72, 'Advisor Supported', 'Advisor verified and forwarded to MPP.', NULL, '2026-06-05 09:24:39'),
(153, 'MPP001', 72, 'Budget Altered (MPP)', 'MPP telah menyunting jadual bajet kepada RM 10.00.\nSebab: added rm10 to Aiman^Makanan Aiman|1|10.00|10.00\r\nGRANDTOTAL| | |10.00', NULL, '2026-06-05 09:26:06'),
(154, 'MPP001', 72, 'MPP Endorsed', 'MPP endorsed the proposal and forwarded to HEPA.', NULL, '2026-06-05 09:26:26'),
(155, 'HEPA001', 72, 'Budget Altered (HEPA)', 'Pihak HEPA telah mengubah bajet akhir kepada RM 30.00.\nAlasan: Added makan to peserta for 2 person ^Makanan Aiman|1|10.00|10.00\r\nMakanan Peserta & AJK|2|10.00|20.00\r\nGRANDTOTAL| | |30.00', NULL, '2026-06-05 09:27:51'),
(156, 'HEPA001', 72, 'Approved by HEPA', 'Tahniah! HEPA telah meluluskan kertas kerja ini secara rasmi.', NULL, '2026-06-05 09:27:55'),
(157, 'S72421', 73, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-05 09:44:29'),
(158, 'staff123', 73, 'Advisor Supported', 'Advisor verified and forwarded to Faculty.', NULL, '2026-06-05 09:45:39'),
(159, 'fskm', 73, 'Budget Altered (Faculty)', 'Fakulti telah menukar bajet kertas kerja kepada RM 10.00.\nSebab: tambah makan2 aiman^Makanan Aiman|1|10.00|10.00\r\nGRANDTOTAL| | |10.00', NULL, '2026-06-05 09:47:04'),
(160, 'fskm', 73, 'Approved by Faculty', 'Kelulusan penuh diberikan oleh Fakulti.', NULL, '2026-06-05 09:47:09'),
(161, 'HEPA001', 39, 'Budget Altered (HEPA)', 'Pihak HEPA telah mengubah bajet akhir kepada RM 10.00.\nAlasan: aaa^Makanan Aiman|1|10.00|10.00\r\nGRANDTOTAL| | |10.00', NULL, '2026-06-05 14:00:44'),
(162, 'S71805', 75, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-06 05:37:19'),
(163, 'staff123', 75, 'Advisor Supported', 'Advisor verified and forwarded to Faculty.', NULL, '2026-06-06 05:38:32'),
(164, 'fskm', 75, 'Budget Altered (Faculty)', 'Fakulti telah menukar bajet kertas kerja kepada RM 20.00.\nSebab: Added BBBBB^AAAA|1|10.00|10.00\r\nBBBBB|1|10.00|10.00\r\nGRANDTOTAL| | |20.00', NULL, '2026-06-06 05:39:45'),
(165, 'fskm', 75, 'Faculty Endorsed', 'Fakulti menyokong kertas kerja ini kepada HEPA.', NULL, '2026-06-06 05:39:52'),
(166, 'HEPA001', 75, 'Budget Altered (HEPA)', 'Pihak HEPA telah mengubah bajet akhir kepada RM 240.00.\nAlasan: Added CCCCC^AAAA|1|10.00|10.00\r\nBBBBB|1|10.00|10.00\r\nCCCCC|1|220.00|220.00\r\nGRANDTOTAL| | |240.00', NULL, '2026-06-06 05:56:44'),
(167, 'HEPA001', 75, 'Approved by HEPA', 'Tahniah! HEPA telah meluluskan kertas kerja ini secara rasmi.', NULL, '2026-06-06 06:04:29'),
(168, 'MPP001', 55, 'Budget Altered (MPP)', 'MPP telah menyunting jadual bajet kepada RM 200.00.\nSebab: Added food^Diamond Prizepool 1000 [Edited by MPP]|1|100.00|100.00\r\nMakanan Peserta & AJK|10|10.00|100.00\r\nGRANDTOTAL| | |200.00', NULL, '2026-06-07 04:47:27'),
(169, 'MPP001', 52, 'Budget Altered (MPP)', 'MPP telah menyunting jadual bajet kepada RM 850.00.\nSebab: Added ^Makanan|40|8.00|320.00\r\nHadiah [Edited by MPP]|3|10.00|30.00\r\nHonorarium Penceramah|1|500.00|500.00\r\nGRANDTOTAL| | |850.00', NULL, '2026-06-07 04:48:02'),
(170, 'HEPA001', 67, 'Budget Altered (HEPA)', 'Pihak HEPA telah mengubah bajet akhir kepada RM 110.00.\nAlasan: kueranfkan budget honororiunm^Makanan Aiman [Edited by MPP]|1|10.00|10.00\r\nHonorarium Penceramah [Edited by MPP]|1|100.00|100.00\r\nGRANDTOTAL| | |110.00', NULL, '2026-06-07 04:49:18'),
(171, 'HEPA001', 67, 'Approved by HEPA', 'Tahniah! HEPA telah meluluskan kertas kerja ini secara rasmi.', NULL, '2026-06-07 04:49:23'),
(172, 'S70622', 77, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-17 04:43:34'),
(173, 'S70622', 79, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-17 23:48:47'),
(174, 'staff111', 79, 'Advisor Supported', 'Advisor verified and forwarded to MPP.', NULL, '2026-06-18 01:45:20'),
(175, 'MPP001', 79, 'Pitching Scheduled', 'Meeting set for 2026-06-19 09:48.', NULL, '2026-06-18 01:48:44'),
(176, 'MPP001', 79, 'Budget Altered (MPP)', 'MPP telah menyunting jadual bajet kepada RM 20.00.\nSebab: Altered by MPP: Added food for Aiman^EventTestNormalizedV1|1|10.00|10.00\r\nMakanan Aiman|1|10.00|10.00\r\nGRANDTOTAL| | |20.00', NULL, '2026-06-18 02:00:03'),
(177, 'S72421', 80, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-18 02:20:37'),
(178, 'staff123', 80, 'Advisor Supported', 'Advisor verified and forwarded to MPP.', NULL, '2026-06-18 02:24:05'),
(179, 'S72421', 81, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-18 02:29:30'),
(180, 'staff123', 81, 'Advisor Supported', 'Advisor verified and forwarded to Faculty.', NULL, '2026-06-18 02:30:14'),
(181, 'fskm', 81, 'Budget Altered (Faculty)', 'Fakulti telah menukar bajet kertas kerja kepada RM 50.00.\nSebab: reduce budget to rm50^EventTestNormalizedV4|1|50.00|50.00\r\nGRANDTOTAL| | |50.00', NULL, '2026-06-18 02:32:05'),
(182, 'fskm', 81, 'Approved by Faculty', 'Kelulusan penuh diberikan oleh Fakulti.', NULL, '2026-06-18 02:32:27'),
(183, 'MPP001', 80, 'MPP Endorsed', 'MPP endorsed the proposal and forwarded to HEPA.', NULL, '2026-06-18 02:41:32'),
(184, 'HEPA001', 80, 'Budget Altered (HEPA)', 'Pihak HEPA telah mengubah bajet akhir kepada RM 60.00.\nAlasan: added makanan aiman^EventTestNormalizedV4|1|10.00|10.00\r\nMakanan Aiman|1|50.00|50.00\r\nGRANDTOTAL| | |60.00', NULL, '2026-06-18 02:52:49'),
(185, 'HEPA001', 80, 'Approved by HEPA', 'Tahniah! HEPA telah meluluskan kertas kerja ini secara rasmi.', NULL, '2026-06-18 02:52:59'),
(186, 'S72421', 82, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-18 02:55:02'),
(187, 'staff123', 82, 'Advisor Supported', 'Advisor verified and forwarded to Faculty.', NULL, '2026-06-18 02:58:42'),
(188, 'fskm', 82, 'Budget Altered (Faculty)', 'Fakulti telah menukar bajet kertas kerja kepada RM 120.00.\nSebab: added item^EventTestNormalizedV4|1|10.00|10.00\r\nItem Faculty|1|110.00|110.00\r\nGRANDTOTAL| | |120.00', NULL, '2026-06-18 02:59:23'),
(189, 'fskm', 82, 'Faculty Endorsed', 'Fakulti menyokong kertas kerja ini kepada HEPA.', NULL, '2026-06-18 02:59:47'),
(190, 'HEPA001', 82, 'Budget Altered (HEPA)', 'Pihak HEPA telah mengubah bajet akhir kepada RM 140.00.\nAlasan: added item^EventTestNormalizedV4|1|10.00|10.00\r\nItem Faculty|1|110.00|110.00\r\nItem Hepa|1|20.00|20.00\r\nGRANDTOTAL| | |140.00', NULL, '2026-06-18 03:00:32'),
(191, 'HEPA001', 82, 'Approved by HEPA', 'Tahniah! HEPA telah meluluskan kertas kerja ini secara rasmi.', NULL, '2026-06-18 03:00:36'),
(192, 'MPP001', 79, 'Pitching Scheduled', 'Meeting set for 2026-06-23 14:38.', NULL, '2026-06-18 06:39:14'),
(193, 'MPP001', 79, 'Pitching Scheduled', 'Meeting set for 2026-06-23 14:38.', NULL, '2026-06-18 06:39:16'),
(194, 'S70622', 83, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-18 12:31:50'),
(195, 'S70622', 84, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-18 13:04:49'),
(196, 'S70622', 85, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-18 15:49:02'),
(197, 'S70622', 86, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-18 16:26:52'),
(198, 'S70622', 87, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-18 16:35:54'),
(199, 'S70622', 88, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-18 17:04:57'),
(200, 'S70622', 89, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-18 17:58:08'),
(201, 'S72421', 90, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-21 06:05:49'),
(202, 'staff123', 90, 'Advisor Supported', 'Advisor verified and forwarded to Faculty.', NULL, '2026-06-21 06:08:12'),
(203, 'S70810', 92, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-21 11:51:28'),
(204, 'haikal', 92, 'Advisor Supported', 'Advisor verified and forwarded to MPP.', NULL, '2026-06-21 11:54:03'),
(205, 'MPP001', 92, 'Pitching Scheduled', 'Meeting set for 2026-06-22 19:55.', NULL, '2026-06-21 11:55:33'),
(206, 'MPP001', 92, 'Budget Altered (MPP)', 'MPP telah menyunting jadual bajet kepada RM 1400.00.\nSebab: Altered by MPP: Reduced the food budget to RM4^Makanan Peserta & AJK|350|4.00|1400.00\r\nGRANDTOTAL| | |1400.00', NULL, '2026-06-21 11:56:01'),
(207, 'S70622', 93, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-21 21:50:36'),
(208, 'S70622', 94, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-21 22:14:14'),
(209, 'S70622', 91, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-21 22:21:09'),
(210, 'S70622', 66, 'Proposal Submitted', 'Draft finalized and submitted to Club Advisor.', NULL, '2026-06-21 22:40:45');

-- --------------------------------------------------------

--
-- Table structure for table `clubs`
--

CREATE TABLE `clubs` (
  `clubId` int(11) NOT NULL,
  `clubName` varchar(150) NOT NULL,
  `category` varchar(255) DEFAULT NULL,
  `logoPath` varchar(255) DEFAULT NULL,
  `establishedYear` year(4) DEFAULT NULL,
  `status` enum('active','suspended','inactive') DEFAULT 'active',
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `agmReminderCount` int(11) DEFAULT 0,
  `mission` text DEFAULT NULL,
  `vision` text DEFAULT NULL,
  `cluster` varchar(50) DEFAULT 'Umum',
  `advisorId` varchar(50) DEFAULT NULL,
  `facultyId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clubs`
--

INSERT INTO `clubs` (`clubId`, `clubName`, `category`, `logoPath`, `establishedYear`, `status`, `createdAt`, `agmReminderCount`, `mission`, `vision`, `cluster`, `advisorId`, `facultyId`) VALUES
(1001, 'COMTECH', 'Academic', 'default_logo.png', '2015', 'active', '2026-04-14 09:01:52', 3, NULL, NULL, 'Akademik', 'staff123', NULL),
(1002, 'SAHAM', NULL, 'club_1002_1782093319527.png', '2018', 'active', '2026-04-14 09:01:52', 0, '', '', 'Kerohanian', 'staff111', NULL),
(9999, 'SYSTEM MPP', 'System', 'default_logo.png', '2026', 'active', '2026-04-14 16:14:23', 0, NULL, NULL, 'Umum', NULL, NULL),
(10000, 'ESPORT', 'Non-Academic', 'default_logo.png', '2024', 'active', '2026-04-30 01:22:02', 0, NULL, NULL, 'Kelab Sukan', 'S71383', NULL),
(10006, 'SISPA', 'Non-Academic', 'club_10006_1782042446567.png', '2026', 'active', '2026-06-21 11:43:14', 0, NULL, NULL, 'Kelab Badan Beruniform', 'haikal', NULL),
(10007, 'Kelab Single ', 'Academic', 'default_logo.png', '2026', 'active', '2026-06-21 11:59:21', 0, NULL, NULL, 'Kelab Kebudayaan', 'najmi', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `club_memberships`
--

CREATE TABLE `club_memberships` (
  `membershipId` int(11) NOT NULL,
  `userId` varchar(10) NOT NULL,
  `clubId` int(11) NOT NULL,
  `Position` enum('Pres','Vice Pres','Secr','Treas','Member') NOT NULL,
  `joinYear` year(4) DEFAULT NULL,
  `isActive` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `club_memberships`
--

INSERT INTO `club_memberships` (`membershipId`, `userId`, `clubId`, `Position`, `joinYear`, `isActive`) VALUES
(2, 'S70622', 1002, 'Pres', '2026', 1),
(3, 'S11111', 1001, 'Secr', '2026', 0),
(4, 'S22222', 1002, 'Member', '2026', 1),
(5, 'S88888', 1001, 'Member', '2024', 0),
(6, 'S88888', 1002, 'Secr', '2025', 0),
(8, 'S55555', 1002, 'Member', '2026', 1),
(9, 'S72421', 1001, 'Pres', '2026', 1),
(10, 'S00021', 10000, 'Pres', '2026', 1),
(11, 'S71805', 1001, 'Secr', '2026', 1),
(12, 'S70810', 10006, 'Pres', '2026', 1);

--
-- Triggers `club_memberships`
--
DELIMITER $$
CREATE TRIGGER `prevent_multiple_presidency_insert` BEFORE INSERT ON `club_memberships` FOR EACH ROW BEGIN
    IF NEW.Position = 'Pres' AND NEW.isActive = 1 THEN
        IF EXISTS (SELECT 1 FROM `club_memberships` WHERE `userId` = NEW.userId AND `Position` = 'Pres' AND `isActive` = 1) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Pelajar ini sudah menjadi Presiden di kelab lain.';
        END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `prevent_multiple_presidency_update` BEFORE UPDATE ON `club_memberships` FOR EACH ROW BEGIN
    IF NEW.Position = 'Pres' AND NEW.isActive = 1 THEN
        IF EXISTS (SELECT 1 FROM `club_memberships` WHERE `userId` = NEW.userId AND `Position` = 'Pres' AND `isActive` = 1 AND `membershipId` != NEW.membershipId) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Pelajar ini sudah menjadi Presiden di kelab lain.';
        END IF;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `eventproposal`
--

CREATE TABLE `eventproposal` (
  `proposalId` int(11) NOT NULL,
  `clubId` int(11) NOT NULL,
  `proposalType` varchar(50) DEFAULT 'Event',
  `createdBy` varchar(10) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `objective` text DEFAULT NULL,
  `sdgImpact` text DEFAULT NULL,
  `sdgReason` text DEFAULT NULL,
  `originalBudgetDetails` text DEFAULT NULL,
  `eriskFile` varchar(255) DEFAULT NULL,
  `mppMinutesFile` varchar(255) DEFAULT NULL,
  `hepaRemark` text DEFAULT NULL,
  `proposedDate` date DEFAULT NULL,
  `endDate` date DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `participantUmt` int(11) DEFAULT 0,
  `participantStaff` int(11) DEFAULT 0,
  `participantPublic` int(11) DEFAULT 0,
  `participantOtherDesc` varchar(255) DEFAULT NULL,
  `estimateParticipant` int(11) DEFAULT NULL,
  `estimateBudget` decimal(10,2) DEFAULT NULL,
  `isBudgetAltered` tinyint(1) DEFAULT 0,
  `Status` varchar(50) DEFAULT 'draft',
  `conflictScore` int(11) DEFAULT NULL,
  `aiSuggestion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `feedback` text DEFAULT NULL,
  `venue` varchar(255) NOT NULL,
  `targetAudience` varchar(255) NOT NULL,
  `pitchingDate` datetime DEFAULT NULL,
  `pitchingLocation` varchar(100) DEFAULT NULL,
  `budgetAltered` tinyint(1) DEFAULT 0,
  `budgetDetails` text DEFAULT NULL,
  `isClubFunded` tinyint(1) DEFAULT 1,
  `aiSummary` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `eventproposal`
--

INSERT INTO `eventproposal` (`proposalId`, `clubId`, `proposalType`, `createdBy`, `title`, `description`, `objective`, `sdgImpact`, `sdgReason`, `originalBudgetDetails`, `eriskFile`, `mppMinutesFile`, `hepaRemark`, `proposedDate`, `endDate`, `duration`, `participantUmt`, `participantStaff`, `participantPublic`, `participantOtherDesc`, `estimateParticipant`, `estimateBudget`, `isBudgetAltered`, `Status`, `conflictScore`, `aiSuggestion`, `createdAt`, `updatedAt`, `feedback`, `venue`, `targetAudience`, `pitchingDate`, `pitchingLocation`, `budgetAltered`, `budgetDetails`, `isClubFunded`, `aiSummary`) VALUES
(1, 1002, 'Event', 'S70622', 'Kem Kepimpinan Islamik 2026', 'Memupuk semangat kepimpinan adil berlandaskan Islam', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-07-15', NULL, 2, 0, 0, 0, NULL, 100, 150000.00, 0, 'Rejected', 30, NULL, '2026-04-14 09:08:36', '2026-04-14 09:10:17', 'Sila kurangkan bajet', 'Masjid UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(2, 1002, 'Event', 'S70622', 'Kem Kepimpinan Islamik 2026', 'Memperkasakan kepimpinan berteraskan Islam', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-01', NULL, 1, 0, 0, 0, NULL, 100, 2000.00, 0, 'Approved', 20, NULL, '2026-04-14 09:12:13', '2026-04-14 09:13:36', 'Tiada ulasan tambahan.', 'Masjid UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(3, 1001, 'Event', 'S70810', 'Karnival E-Sport & IT 2026', 'Memupuk semangat kesukanan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-07-22', NULL, 2, 0, 0, 0, NULL, 1000, 300000.00, 0, 'Approved', 30, NULL, '2026-04-14 09:19:37', '2026-04-14 09:22:53', 'Tiada ulasan tambahan.', 'Perpustakaan Sultanah Nur Zahirah, UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(4, 1001, 'Event', 'S70810', 'Selamatkan Komputer: Cybersecurity Awareness Day 2026', 'Bengkel mengajar cara hack laptop orang', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-07-31', NULL, 7, 0, 0, 0, NULL, 1000, 2000000.00, 0, 'Rejected', 30, NULL, '2026-04-14 11:47:33', '2026-04-14 11:48:57', 'Mung gilo bajet sapa 2 juto???', 'Masjid UMT', 'Warga Terengganu', NULL, NULL, 0, NULL, 1, NULL),
(5, 1002, 'Event', 'S70622', 'Munajat Perdana', 'Selawat bersama', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-09', NULL, 1, 0, 0, 0, NULL, 200, 800.00, 0, 'Draft', 0, NULL, '2026-04-14 11:54:24', '2026-04-15 02:05:14', 'Retracted by CHC for editing.', 'Masjid UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(6, 1002, 'Event', 'S70622', 'Pertandingan Tilawah Al-Quran', 'baca quran, sedap = menang', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2028-01-01', NULL, 7, 0, 0, 0, NULL, 100, 500.00, 0, 'Meeting_Scheduled', 0, NULL, '2026-04-14 11:58:04', '2026-04-28 14:32:27', 'PITCHING SCHEDULED.\nTarikh & Masa: 2026-04-30 14:30:00\nLink/Lokasi: https://meet.google.com/whs-qfnu-qzz', 'Masjid UMT', 'Warga UMT', '2026-04-30 14:30:00', 'https://meet.google.com/whs-qfnu-qzz', 0, NULL, 1, NULL),
(7, 1001, 'Event', 'S70810', 'Kelas Coding Bersama Sir Amir', 'kelas fun fun jer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-22', NULL, 1, 0, 0, 0, NULL, 20, 300.00, 0, 'submitted', 20, NULL, '2026-04-14 15:37:16', '2026-04-14 15:37:16', NULL, 'Makmal Pengaturcaraan 1, FSKM, UMT', 'Pelajar FSKM', NULL, NULL, 0, NULL, 1, NULL),
(13, 1002, 'Event', 'S70622', 'Kursus Pengurusan Jenazah 2026', 'Berkongsi Ilmu bersama dengan En Fakrul.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-01', NULL, 1, 0, 0, 0, NULL, 50, 3000000.00, 0, 'Rejected', 140, NULL, '2026-04-15 00:41:22', '2026-04-15 00:42:14', 'apa ni', 'Kubur', 'Warga Tok Jembal', NULL, NULL, 0, NULL, 1, NULL),
(18, 1002, 'Event', 'S70622', '111', '111', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-16', NULL, 11, 0, 0, 0, NULL, 111, 11111.00, 0, 'Submitted', 110, NULL, '2026-04-15 09:35:02', '2026-04-15 09:35:02', NULL, '1111', '1111', NULL, NULL, 0, NULL, 1, NULL),
(19, 1002, 'Event', 'S70622', 'Test1', 'Test1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-16', NULL, 1, 0, 0, 0, NULL, 11, 111.00, 0, 'Pending_MPP', 50, NULL, '2026-04-16 07:55:31', '2026-04-16 07:57:59', 'Supported by Advisor: Good', 'Masjid UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(20, 1002, 'Event', 'S70622', 'test2', 'test2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-17', NULL, 2, 0, 0, 0, NULL, 22, 222.00, 0, 'Draft', 50, NULL, '2026-04-16 08:15:26', '2026-04-19 15:36:29', 'Retracted by CHC for editing.', 'Masjid UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(21, 1002, 'Event', 'S70622', 'Test3', 'Test3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-16', NULL, 3, 0, 0, 0, NULL, 33, 333.00, 0, 'Submitted', 50, NULL, '2026-04-16 08:19:31', '2026-04-16 08:19:31', NULL, 'Masjid UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(22, 1002, 'Event', 'S70622', 'Test4', 'test4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-16', NULL, 4, 0, 0, 0, NULL, 44, 4444.00, 0, 'Submitted', 70, NULL, '2026-04-16 09:05:42', '2026-04-16 09:05:42', NULL, 'Masjid UMT', 'Warga Tok Jembal', NULL, NULL, 0, NULL, 1, NULL),
(23, 1002, 'Event', 'S70622', 'Test5', 'test5', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-16', NULL, 5, 0, 0, 0, NULL, 55, 5555.00, 0, 'Submitted', 90, NULL, '2026-04-16 09:18:44', '2026-04-16 09:18:44', NULL, 'Masjid UMT', 'Warga Tok Jembal', NULL, NULL, 0, NULL, 1, NULL),
(24, 1002, 'Event', 'S70622', 'Test6', 'Test6', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-19', NULL, 2, 0, 0, 0, NULL, 110, 1300.00, 0, 'Submitted', 50, NULL, '2026-04-19 12:04:21', '2026-04-19 12:04:21', NULL, 'Masjid UMT', 'Warga Tok Jembal', NULL, NULL, 0, NULL, 1, NULL),
(25, 1002, 'Event', 'S70622', 'Test7', 'Test7', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-19', NULL, 7, 0, 0, 0, NULL, 77, 777.00, 0, 'Submitted', 50, NULL, '2026-04-19 13:30:10', '2026-04-19 13:30:10', NULL, 'Masjid UMT', 'Warga Tok Jembal', NULL, NULL, 0, NULL, 1, NULL),
(26, 1002, 'Event', 'S70622', 'Test10:11-19/4/2026', 'Test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-19', NULL, 1, 0, 0, 0, NULL, 11, 11.00, 0, 'Approved', 50, NULL, '2026-04-19 14:12:08', '2026-04-19 14:13:21', 'Tiada ulasan tambahan.', 'Masjid UMT', 'Warga Tok Jembal', NULL, NULL, 0, NULL, 1, NULL),
(27, 1002, 'Event', 'S70622', 'Test123', '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-19', NULL, 123, 0, 0, 0, NULL, 123, 123.00, 0, 'Pending_MPP', 0, NULL, '2026-04-19 14:34:06', '2026-04-19 15:18:27', 'Supported by Advisor: Good', 'Masjid UMT', 'Warga Tok Jembal', NULL, NULL, 0, NULL, 1, NULL),
(28, 1002, 'Event', 'S70622', 'Test999', '999', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-19', NULL, 999, 0, 0, 0, NULL, 999, 999.00, 0, 'Pending_MPP', 0, NULL, '2026-04-19 15:18:57', '2026-04-19 15:20:43', 'Supported by Advisor: Good', 'Masjid UMT', 'Warga Tok Jembal', NULL, NULL, 0, NULL, 1, NULL),
(29, 1002, 'Event', 'S70622', 'TestAccept1', 'test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-30', NULL, 2, 0, 0, 0, NULL, 10, 100.00, 0, 'Meeting_Scheduled', 0, NULL, '2026-04-19 15:32:45', '2026-04-28 15:48:48', 'PITCHING SCHEDULED.\nTarikh & Masa: 2026-04-30 23:48:00\nLink/Lokasi: https://zoom.my/j/123456789', 'Masjid UMT', 'Warga Tok Jembal', '2026-04-30 23:48:00', 'https://zoom.my/j/123456789', 0, NULL, 1, NULL),
(30, 1002, 'Event', 'S70622', 'TestReject1', 'Test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-21', NULL, 1, 0, 0, 0, NULL, 100, 400000.00, 0, 'Rejected', 0, NULL, '2026-04-19 15:33:09', '2026-04-19 15:35:19', 'Rejected by Advisor: Betulkan Tarikh', 'Masjid UMT', 'Warga Tok Jembal', NULL, NULL, 0, NULL, 1, NULL),
(31, 1002, 'Event', 'S70622', 'TestAccept2', 'test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-19', NULL, 1, 0, 0, 0, NULL, 11, 111.00, 0, 'Meeting_Scheduled', 0, NULL, '2026-04-19 15:39:08', '2026-04-28 15:39:16', 'PITCHING SCHEDULED.\nTarikh & Masa: 2026-04-13 23:39:00\nLink/Lokasi: https://meet.google.com/rxw-revc-czt', 'Masjid UMT', 'Warga Tok Jembal', '2026-04-13 23:39:00', 'https://meet.google.com/rxw-revc-czt', 0, NULL, 1, NULL),
(32, 1002, 'Event', 'S70622', 'TestReject2', 'test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-19', NULL, 11, 0, 0, 0, NULL, 11, 111.00, 0, 'Meeting_Scheduled', 0, NULL, '2026-04-19 15:39:32', '2026-04-25 11:06:57', 'PITCHING SCHEDULED.\nTarikh & Masa: 2026-04-28 20:06:00\nLink/Lokasi: https://meet.google.com/how-xrnj-qre', 'Masjid UMT', 'Warga Tok Jembal', '2026-04-28 20:06:00', 'https://meet.google.com/how-xrnj-qre', 0, NULL, 1, NULL),
(33, 1002, 'Event', 'S70622', 'Test-Advisor.Pass-MPP.Pitch', 'test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-20', NULL, 2, 0, 0, 0, NULL, 20, 100.00, 0, 'Meeting_Scheduled', 0, NULL, '2026-04-19 16:55:29', '2026-04-19 17:05:59', 'PITCHING SCHEDULED\nDate: 2026-04-20\nTime: 18:08\nLink: https://google.meet.com', 'Masjid UMT', 'Warga Tok Jembal', NULL, NULL, 0, NULL, 1, NULL),
(34, 1002, 'Event', 'S70622', 'TestMeeting1', 'test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-20', NULL, 2, 0, 0, 0, NULL, 22, 222.00, 0, 'Meeting_Scheduled', 0, NULL, '2026-04-19 17:30:14', '2026-04-19 17:32:37', 'PITCHING SCHEDULED\nDate: 2026-04-23\nTime: 20:38\nLink: https://meet.google.com/abc-defg-hij', 'Masjid UMT', 'Warga Tok Jembal', NULL, NULL, 0, NULL, 1, NULL),
(35, 1002, 'Event', 'S70622', 'TestMeeting2', 'Test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-20', NULL, 22, 0, 0, 0, NULL, 222, 2222.00, 0, 'Approved', 0, NULL, '2026-04-19 17:44:16', '2026-04-19 17:52:52', 'Approved by MPP after review.', 'Masjid UMT', 'Warga Tok Jembal', NULL, NULL, 0, NULL, 1, NULL),
(36, 1002, 'Event', 'S70622', 'TestMeeting3', 'test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-20', NULL, 1, 0, 0, 0, NULL, 2222, 111.00, 0, 'Draft', 0, NULL, '2026-04-19 17:53:22', '2026-04-25 04:53:29', 'Rejected by MPP: Change date', 'Masjid UMT', 'Warga Tok Jembal', NULL, NULL, 0, NULL, 1, NULL),
(37, 1002, 'Event', 'S70622', 'TestProp1', 'Test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-20', NULL, 2, 0, 0, 0, NULL, 22, 222.00, 0, 'Meeting_Scheduled', 0, NULL, '2026-04-19 17:58:57', '2026-04-19 18:00:41', 'PITCHING SCHEDULED\nDate: 2026-04-23\nTime: 21:00\nLink: https://meet.google.com/abc-defg-hij', 'Masjid UMT', 'Warga Tok Jembal', NULL, NULL, 0, NULL, 1, NULL),
(38, 1002, 'Event', 'S70622', 'TestHepa1', 'test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-09', NULL, 2, 0, 0, 0, NULL, 150, 1500.00, 0, 'Approved', 0, NULL, '2026-04-19 18:35:55', '2026-04-19 18:44:49', 'Final endorsement granted by HEPA. Congratulations.', 'Masjid UMT', 'Warga Tok Jembal', NULL, NULL, 0, NULL, 1, NULL),
(39, 1001, 'Event', 'S70810', 'Bengkel C#', 'bengkel', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-02', NULL, 1, 0, 0, 0, NULL, 25, 10.00, 1, 'Pending_HEPA', 0, NULL, '2026-04-19 19:50:20', '2026-06-05 14:00:44', 'Altered by HEPA: aaa', 'Makmal Pengaturcaraan 1, FSKM, UMT', 'FSKM Students', NULL, NULL, 0, NULL, 1, NULL),
(40, 1001, 'Event', 'S70810', 'Bengkel Database', 'database class with Dr Faizah Aplop', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-09', NULL, 1, 0, 0, 0, NULL, 20, 250.00, 0, 'Rejected', 0, NULL, '2026-04-19 19:53:49', '2026-04-20 00:58:22', 'Faculty has rejected the proposal', 'Makmal Pengaturcaraan 1, FSKM, UMT', 'FSKM Students', NULL, NULL, 0, NULL, 1, NULL),
(41, 1001, 'Event', 'S70810', 'Bengkel Web Design', 'bengkel web design menggunakan Figma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-29', NULL, 1, 0, 0, 0, NULL, 20, 300.00, 0, 'Approved', 0, NULL, '2026-04-19 21:12:01', '2026-04-19 21:44:08', 'Final endorsement granted by HEPA.', 'Makmal Pengaturcaraan 1, FSKM, UMT', 'FSKM Students', NULL, NULL, 0, NULL, 1, NULL),
(42, 1001, 'Event', 'S70810', 'Test1', 'Test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-20', NULL, 2, 0, 0, 0, NULL, 22, 22.00, 0, 'Approved', 0, NULL, '2026-04-19 21:34:14', '2026-04-19 21:44:06', 'Final endorsement granted by HEPA.', 'Makmal Pengaturcaraan 1, FSKM, UMT', 'FSKM Students', NULL, NULL, 0, NULL, 1, NULL),
(43, 1001, 'Event', 'S70810', 'TestProposal1', 'Test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-20', NULL, 1, 0, 0, 0, NULL, 100, 1000.00, 0, 'Approved', 0, NULL, '2026-04-20 00:46:04', '2026-04-20 01:41:08', 'Final endorsement granted by HEPA.', 'Makmal Pengaturcaraan 1, FSKM, UMT', 'FSKM Students', NULL, NULL, 0, NULL, 1, NULL),
(44, 1001, 'Event', 'S70810', 'Pertandingan Sumo Robot 2026', 'pertandingan memupuk pakar it dan pakar ekonomi, jaguh sukan dan juga jutawan untuk bermain robot sumo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-20', NULL, 11, 0, 0, 0, NULL, 111, 1111.00, 0, 'Rejected', 0, NULL, '2026-04-20 01:09:00', '2026-04-20 01:15:33', 'Rejected by Faculty: Revise venue, kinda not suitable', 'Makmal Pengaturcaraan 1, FSKM, UMT', 'FSKM Students', NULL, NULL, 0, NULL, 1, NULL),
(45, 1002, 'Event', 'S70622', 'TEST', 'TT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-20', NULL, 222, 0, 0, 0, NULL, 222, 222.00, 0, 'Meeting_Scheduled', 0, NULL, '2026-04-20 05:06:07', '2026-04-25 11:04:44', 'PITCHING SCHEDULED.\nTarikh & Masa: 2026-04-26 19:04:00\nLink/Lokasi: https://meet.google.com/vpr-mafg-ssx', 'Makmal Pengaturcaraan 1, FSKM, UMT', 'FSKM Students', '2026-04-26 19:04:00', 'https://meet.google.com/vpr-mafg-ssx', 0, NULL, 1, NULL),
(46, 1001, 'Event', 'S70810', 'test123', 'wqwq', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-21', NULL, 1, 0, 0, 0, NULL, 20, 300.00, 0, 'Approved', 0, NULL, '2026-04-20 05:13:04', '2026-04-26 06:46:02', 'Final endorsement granted by HEPA.', 'Makmal Pengaturcaraan 1, FSKM, UMT', 'FSKM Students', NULL, NULL, 0, NULL, 1, NULL),
(47, 1002, 'Event', 'S70622', 'Bengkel Asas Internet of Things (IoT) & Raspberry Pi Pico', 'Program pendedahan asas komponen elektronik dan pengaturcaraan IoT menggunakan mikropengawal Raspberry Pi Pico.', '1. Memberi pendedahan asas mengenai teknologi Internet of Things (IoT).\r\n2. Melatih pelajar membina projek mudah menggunakan Raspberry Pi Pico.\r\n3. Memupuk pemikiran kritis dalam menyelesaikan masalah teknikal.', 'SDG 4 (Pendidikan Berkualiti) - Meningkatkan kemahiran teknikal dan literasi digital pelajar selari dengan keperluan industri perisian dan teknologi automasi masa kini.', NULL, '1. Makanan Peserta: RM 5.00 x 40 orang = RM 200.00\r\n2. Sewaan Kit IoT: RM 30.00 x 10 set = RM 300.00\r\nJUMLAH KESELURUHAN: RM 500.00', NULL, 'uploads/mpp_minutes/PROPOSAL_47_MINUTES_All_Proposals__Faculty.pdf', NULL, '2026-05-15', NULL, 1, 0, 0, 0, NULL, 40, 0.11, 1, 'Rejected', 0, NULL, '2026-04-25 15:25:11', '2026-06-05 03:22:13', 'Rejected by HEPA: bad', 'Makmal Pengaturcaraan 1, FSKM, UMT', 'FSKM Students', '2026-04-26 15:00:00', 'https://meet.google.com/dtv-opmi-aqb', 0, NULL, 1, NULL),
(48, 1002, 'Event', 'S70622', 'TestAI1', 'TestAI', 'qq', 'qq', NULL, NULL, NULL, NULL, NULL, '2026-04-28', NULL, 1, 0, 0, 0, NULL, 22, 4000.00, 0, 'Pending_MPP', 130, NULL, '2026-04-26 00:51:38', '2026-04-28 15:55:15', 'Supported by Advisor: Bagus Teruskan', 'Makmal Pengaturcaraan 1, FSKM, UMT', 'FSKM Students', NULL, NULL, 0, NULL, 1, NULL),
(49, 1002, 'Event', 'S70622', 'TestAI2', 'test', 'qq', 'qq', NULL, NULL, NULL, NULL, NULL, '2026-04-28', NULL, 1, 0, 0, 0, NULL, 300, 120.00, 0, 'Meeting_Scheduled', 130, NULL, '2026-04-26 01:02:30', '2026-04-28 15:59:13', 'PITCHING SCHEDULED.\nTarikh & Masa: 2026-05-07 23:59:00\nLink/Lokasi: https://meet.google.com/biz-tnsh-tkv', 'Masjid UMT', 'Warga Tok Jembal', '2026-05-07 23:59:00', 'https://meet.google.com/biz-tnsh-tkv', 0, NULL, 1, NULL),
(50, 1002, 'Event', 'S70622', 'Bengkel Pembangunan Aplikasi Web & IoT 2026', 'Program pendedahan intensif untuk mendedahkan ahli kelab dengan integrasi Internet of Things (IoT) menggunakan mikropengawal Raspberry Pi Pico serta asas pembangunan aplikasi web.', '1. Memberi pendedahan praktikal mengenai pengaturcaraan litar pintar IoT.\r\n2. Meningkatkan kemahiran ahli kelab dalam membina prototaip sistem berasaskan web.\r\n3. Memupuk kemahiran kerja berpasukan melalui pembentangan projek mini.', 'SDG 4 (Pendidikan Berkualiti) - Meningkatkan kemahiran teknikal, literasi digital, dan kebolehpasaran pelajar selari dengan revolusi industri teknologi masa kini.', NULL, NULL, NULL, NULL, NULL, '2026-06-19', NULL, 1, 0, 0, 0, NULL, 40, 750.00, 0, 'Approved', 30, NULL, '2026-04-26 01:34:25', '2026-04-28 14:36:03', 'Final endorsement granted by HEPA.', 'Makmal Pengaturcaraan 1, FSKM, UMT', 'FSKM Students', '2026-04-28 15:34:00', 'https://meet.google.com/fts-dydy-zqh', 0, NULL, 1, NULL),
(51, 1002, 'Event', 'S70622', 'Geng Gegar Masjid', 'Memupuk semangat cinta akan masjid dalam hati anak-anak muda terutamanya pelajar UMT', '1. Meningkatkan keterlibatan pelajar dalam  aktiviti kerohanian di Masjid UMT.\r\n2. Memupuk semangat cinta akan masjid dalam kalangan golongan muda terutamanya pelajar-pelajar UMT', 'SDG4- Pendidikan', NULL, NULL, NULL, NULL, NULL, '2026-05-22', NULL, 1, 0, 0, 0, NULL, 100, 0.00, 0, 'Approved', 100, NULL, '2026-04-28 15:30:07', '2026-04-28 15:36:12', 'Final endorsement granted by HEPA.', 'Masjid UMT', 'Warga UMT', '2026-04-28 23:34:00', 'https://meet.google.com/abc-defg-hij', 0, NULL, 1, NULL),
(52, 1002, 'Event', 'S70622', 'TestProgram1', 'test', '1. Help me', 'SDG99 - What is This?!', NULL, 'Makanan|40|8.00|320.00\r\nHadiah|4|10.00|40.00\r\nGRANDTOTAL| | |360.00', NULL, NULL, NULL, '2026-04-30', NULL, 1, 0, 0, 0, NULL, 30, 850.00, 1, 'Pending_MPP', 130, NULL, '2026-04-29 21:03:27', '2026-06-07 04:48:02', 'Altered by MPP: Added ', 'Masjid UMT', 'Warga Tok Jembal', NULL, NULL, 0, NULL, 1, NULL),
(53, 1002, 'Event', 'S70622', 'Program Test 1', 'Test', 'test1', 'Good Health & Well-being (SDG 3)', 'aaa', NULL, NULL, NULL, NULL, '2026-05-09', '2026-05-09', 1, 111, 0, 0, '', 111, 340.00, 0, 'Pending_Advisor', 0, NULL, '2026-04-30 02:50:08', '2026-06-04 04:52:46', 'Ditolak oleh MPP: sesuaikan tarikh', 'Makmal Pengaturcaraan 1, FSKM, UMT', 'FSKM Students', '2026-05-07 10:55:00', 'https://meet.google.com/zps-idrp-qna', 0, NULL, 1, NULL),
(54, 1001, 'Event', 'S70810', 'Bengkel Coding 2026', 'mendedahkan coding kepada pelajar', 'To educate student', 'SDG4', NULL, NULL, NULL, NULL, NULL, '2026-05-01', NULL, 1, 0, 0, 0, NULL, 20, 260.00, 0, 'Pending_HEPA', 150, NULL, '2026-04-30 03:14:24', '2026-04-30 03:21:26', 'Faculty Endorsed: Content Verified. Pending HEPA Budget.', 'Makmal Pengaturcaraan 1, FSKM, UMT', 'FSKM Students', NULL, NULL, 0, NULL, 1, NULL),
(55, 10000, 'Event', 'S00021', '1v1 Franco Tournament 2026', 'This program is aimed to train the student on how to use Franco hook more properly.', 'To produce a world-class Franco user\r\nTo sharpen user\'s instinct on franco hook', 'SDG4', NULL, 'Diamond Prizepool 1000 [Edited by MPP]|1|100.00|100.00\r\nGRANDTOTAL| | |100.00', NULL, NULL, NULL, '2026-05-21', NULL, 1, 0, 0, 0, NULL, 20, 200.00, 1, 'Pending_MPP', 30, NULL, '2026-04-30 09:23:02', '2026-06-07 04:47:27', 'Altered by MPP: Added food', 'Dewan Al-Falah', 'UMT Student', NULL, NULL, 0, NULL, 1, NULL),
(56, 1001, 'Event', 'S71805', 'Comtech Annual Dinner', 'look pretty and eat eat', '1. Help student create memories ', 'Quality time ', NULL, NULL, NULL, NULL, NULL, '2026-06-05', NULL, 1, 0, 0, 0, NULL, 80, 500.00, 0, 'Pending_HEPA', 80, NULL, '2026-04-30 10:01:15', '2026-04-30 10:05:48', 'Faculty Endorsed: Content Verified. Pending HEPA Budget.', 'Hotel Besau', 'All FTKK student', NULL, NULL, 0, NULL, 1, NULL),
(57, 1002, 'Event', 'S70622', 'EventTest1.1', 'Test', 'To help...\r\nTo enjoy...\r\nTo kill...', 'Quality Education (SDG 4)', 'Sebab bole', 'Makanan Peserta & AJK|21|8.00|168.00\r\nHadiah|5|10.00|50.00\r\nCenderamata Juri [Edited by MPP]|1|100.00|100.00\r\nGRANDTOTAL| | |318.00', NULL, 'uploads/mpp_minutes/PROPOSAL_57_MINUTES_All_Proposals__Faculty.pdf', NULL, '2026-05-28', '2026-05-30', 3, 20, 1, 1, '', 22, 408.00, 1, 'Approved', 130, NULL, '2026-05-19 15:50:04', '2026-06-05 09:00:49', 'Official HEPA Approval Granted.', 'Makmal Pengaturcaraan 1, FSKM, UMT', 'FSKM Students', NULL, NULL, 0, NULL, 1, NULL),
(58, 1002, 'Event', 'S70622', 'Pertandingan Azan Peringkat Kebangsaan 2026', 'The program is aiming to produce world class bilal that can recite Azan beautifully and recruiting the winner as Malaysia\'s National Bilal. ', 'Help student be more confident to recite Azan\r\nChoose the best bilal to be recruit as National Bilal', 'Peace, Justice (SDG 16)', 'Promote peace in practicing one religion\'s activity. ', NULL, 'uploads/erisk/PROPOSAL_58_ERISK_CCNA-_Introduction_to_Networks_certificate_haikal-danialmr-gmail-com_25f81e75-4e78-4ada-9bfc-ffc8bfa05629.pdf', NULL, NULL, '2026-07-01', '2026-07-01', 1, 5, 0, 10, '', 15, 1080.00, 0, 'Draft', 100, NULL, '2026-06-02 08:33:09', '2026-06-04 06:38:50', 'Ditolak oleh MPP: Amend Budget', 'Pusat Islam Sultan Mahmud', 'UMT Students & Other University Representatives', NULL, NULL, 0, NULL, 1, NULL),
(59, 1002, 'Event', 'S70622', 'Solat Hajat Perdana sempena Maal Hijrah', 'Program bertujuan untuk melakukan solat hajat bersama-sama di Masjid UMT bagi memohon keberkatan dan perlindungan untuk tahun baru hijrah yang akan datang. ', 'Untuk menyatakan hajat tahun baru hijrah\r\nUntuk memohon perlindungan dan keberkatan bagi tahun baru\r\nUntuk meraikan ukhwan sesama warga.', 'Peace, Justice (SDG 16)', 'Islam agama kedamaian', 'Honorarium Penceramah|1|300.00|300.00\r\nMakanan Peserta & AJK|150|8.00|1200.00\r\nGRANDTOTAL| | |1500.00', 'uploads/erisk/PROPOSAL_59_ERISK_CCNA-_Introduction_to_Networks_certificate_haikal-danialmr-gmail-com_25f81e75-4e78-4ada-9bfc-ffc8bfa05629.pdf', 'uploads/mpp_minutes/PROPOSAL_59_MINUTES_Transcript_S70622_HaikalDanialMohdRohaiza.pdf', NULL, '2026-06-17', '2026-06-17', 1, 100, 20, 0, '', 120, 1340.00, 1, 'Approved', 0, NULL, '2026-06-04 01:49:00', '2026-06-05 03:22:56', 'Official HEPA Approval Granted.', 'Masjid UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(60, 1002, 'Event', 'S70622', 'Kursus Ibadah Korban', 'early exposure of korban', 'To help\r\nTo expose\r\nTo guide', 'Peace, Justice (SDG 16)', 'Islam agama kedamaian', 'Honorarium Penceramah|1|300.00|300.00\r\nMakanan Peserta |30|7.00|210.00\r\nGRANDTOTAL| | |510.00', 'uploads/erisk/PROPOSAL_60_ERISK_Result_Sem_5.pdf', 'uploads/mpp_minutes/PROPOSAL_60_MINUTES_All_Proposals__Faculty.pdf', NULL, '2026-07-02', '2026-07-02', 1, 15, 5, 0, '', 20, 660.00, 1, 'Approved', 100, NULL, '2026-06-04 04:49:58', '2026-06-05 03:32:56', 'Official HEPA Approval Granted.', 'Masjid UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(61, 1002, 'Event', 'S70622', 'Jom Kenali Aiman Ikhwan 2026', 'The program is held to let the public know more about Aiman Ikhwan. ', 'To introduce Aiman to the public\r\nTo increase public awareness about existence of Aiman\r\nTo find a waifu for Aiman', 'Climate Action (SDG 13)', 'Help earth fight climate change', NULL, NULL, NULL, NULL, '2026-06-30', '2026-06-30', 1, 100, 100, 100, 'School Student', 300, 500.00, 0, 'Pending_Advisor', 100, NULL, '2026-06-04 07:11:53', '2026-06-04 07:11:53', NULL, 'Dewan Sultan Mizan, UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(62, 1002, 'Event', 'S70622', 'Program_Example_1', 'Program_background_1', 'To help\r\nTo guide\r\nTo pour', 'Good Health & Well-being (SDG 3)', 'Badan Sihat Otak Cerdas', NULL, NULL, NULL, NULL, '2026-06-18', '2026-06-18', 1, 100, 0, 0, 'School Student', 100, 0.00, 0, 'Pending_Advisor', 100, NULL, '2026-06-04 13:18:06', '2026-06-04 13:18:06', NULL, 'Dewan Sultan Mizan, UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(63, 1002, 'Event', 'S70622', 'Program Kenali Iman 2026', 'mengenali Iman. Iman tak dapat diwarisi. Oleh seorang ayah yang bertakwa. ', 'to\r\nto\r\nto', 'Good Health & Well-being (SDG 3)', 'ssss', NULL, 'uploads/erisk/PROPOSAL_63_ERISK_Echoes_of_What_Was_Drama_Dialog_Script.pdf', NULL, NULL, '2026-06-23', '2026-06-23', 1, 1000, 0, 0, '', 1000, 0.00, 0, 'Pending_Advisor', 100, NULL, '2026-06-04 13:30:38', '2026-06-04 13:49:06', 'Rejected by Advisor: nice', 'Dewan Sultan Mizan, UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(64, 1002, 'Event', 'S70622', 'aaaa', 'aaa', 'aaa', 'Quality Education (SDG 4)', 'aa', NULL, NULL, NULL, NULL, '2026-06-19', '2026-06-19', 1, 1000, 0, 0, 'School Student', 1000, 0.00, 0, 'Pending_Advisor', 100, NULL, '2026-06-04 13:53:31', '2026-06-04 13:53:31', NULL, 'Dewan Sultan Mizan, UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(65, 1002, 'Event', 'S70622', 'bbbbb', 'bbbb', 'vvvvvv', 'Quality Education (SDG 4)', 'vvvvv', NULL, NULL, NULL, NULL, '2026-06-04', '2026-06-04', 1, 444, 0, 0, '', 444, 0.00, 0, 'Draft', 130, NULL, '2026-06-04 14:01:54', '2026-06-05 09:37:14', 'Rejected by Advisor: dac', 'Dewan Sultan Mizan, UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(66, 1002, 'Event', 'S70622', 'Program Santuni Komuniti Tempatan', 'cccc', 'cccc\r\ncccc\r\ncccc', 'SDG 2: Zero Hunger | SDG 3: Good Health & Well-being', 'SDG 2: Zero Hunger ^ aa ||| SDG 3: Good Health & Well-being ^ aaa', NULL, NULL, NULL, NULL, '2026-06-04', '2026-06-04', 1, 444, 0, 0, '', 444, 120.00, 0, 'Pending_Advisor', 0, '<ul class=\'mb-3 list-unstyled\' style=\'line-height: 1.8;\'><li class=\'mb-2\'><i class=\'fas fa-info-circle text-warning me-2\'></i><span class=\'text-warning text-dark\'><b>Doubtful Financials:</b> Unusually low cost (RM0.27/pax).</span></li><li class=\'mb-2\'><i class=\'fas fa-exclamation-triangle text-danger me-2\'></i><span class=\'text-danger\'><b>Annual Limit (CRITICAL):</b> Exceeds RM 1,000 yearly club limit with NO sponsorship listed.</span></li><li class=\'mb-2\'><i class=\'fas fa-exclamation-triangle text-danger me-2\'></i><span class=\'text-danger\'><b>Logistics Risk:</b> High crowd density (444 pax/day). Strict crowd control required.</span></li><li class=\'mb-2\'><i class=\'fas fa-clock text-danger me-2\'></i><span class=\'text-danger\'><b>Timing Warning:</b> Very short notice (-18 days).</span></li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>AI Viability Index:</h6><div><span class=\'badge bg-danger fs-6 shadow-sm\'><i class=\'fas fa-times-circle me-1\'></i> BERISIKO (0%)</span></div></div><div class=\'mt-3 p-3 bg-danger bg-opacity-10 rounded border border-danger\'><small class=\'text-danger fw-bold d-block mb-1\'>AI Judgement:</small> <small class=\'text-dark\'>NOT RECOMMENDED. This proposal has critical flaws. High probability of rejection.</small></div>', '2026-06-04 15:21:05', '2026-06-21 22:40:45', 'Rejected by Advisor: betulkan bajet', 'Dewan Sultan Mizan, UMT', 'Warga UMT', NULL, NULL, 0, '', 1, 'Doubtful Financials: Unusually low cost (RM0.27/pax).Annual Limit (CRITICAL): Exceeds RM 1,000 yearly club limit with NO sponsorship listed.Logistics Risk: High crowd density (444 pax/day). Strict crowd control required.Timing Warning: Very short notice (-18 days).AI Viability Index: BERISIKO (0%)AI Judgement: NOT RECOMMENDED. This proposal has critical flaws. High probability of rejection. System Auto-Generated Executive Summary:\"The system has analyzed \'Program Santuni Komuniti Tempatan\'. Based on the heuristic matrix, please ensure all logistical and financial preparations adhere to university guidelines ahead of the 1-day schedule.\"'),
(67, 1002, 'Event', 'S70622', 'dddddd', 'ddddddd', 'ddddd\r\nddddd\r\nddddd\r\nddddd\r\nddddd', 'Quality Education (SDG 4)', 'dddddddd', 'Makanan Aiman|1|0.00|0.00\r\nGRANDTOTAL| | |0.00', 'uploads/erisk/PROPOSAL_67_ERISK_Echoes_of_What_Was_Drama_Dialog_Script.pdf', 'uploads/mpp_minutes/PROPOSAL_67_MINUTES_Echoes_of_What_Was_Drama_Dialog_Script.pdf', NULL, '2026-06-04', '2026-06-04', 1, 444, 0, 0, '', 444, 110.00, 1, 'Approved', 130, NULL, '2026-06-04 15:52:04', '2026-06-07 04:49:23', 'Official HEPA Approval Granted.', 'Dewan Sultan Mizan, UMT', 'Warga UMT', '2026-06-16 00:33:00', 'https://meet.google.com/bwv-ojqg-wtn', 0, NULL, 1, NULL),
(68, 1001, 'Event', 'S72421', 'aaaa', 'aaaaa', 'aaaa\'\r\naaaa\r\naaaa', 'Quality Education (SDG 4)', 'aaaaa', 'Makanan Aiman|1|0.00|0.00\r\nGRANDTOTAL| | |0.00', 'uploads/erisk/PROPOSAL_68_ERISK_All_Proposals__Faculty.pdf', NULL, NULL, '2026-06-05', '2026-06-05', 1, 10, 0, 0, 'School Student', 10, 108.00, 1, 'Approved', 130, NULL, '2026-06-05 01:22:21', '2026-06-05 01:53:03', 'Diluluskan sepenuhnya oleh Fakulti.', 'Dewan Sultan Mizan, UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(69, 1001, 'Event', 'S71805', 'bbbbb', 'bbbbb', 'bbb\r\nbbb\r\nbbb\r\nbbb', 'Quality Education (SDG 4)', 'bbbb', 'Makanan Aiman|1|10.00|10.00\r\nGRANDTOTAL| | |10.00', 'uploads/erisk/PROPOSAL_69_ERISK_All_Proposals__Faculty.pdf', NULL, NULL, '2026-06-05', '2026-06-05', 1, 10, 0, 0, 'School Student', 10, 10.10, 1, 'Approved', 130, NULL, '2026-06-05 02:04:18', '2026-06-05 02:09:01', 'Diluluskan sepenuhnya oleh Fakulti.', 'Dewan Sultan Mizan, UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(70, 1001, 'Event', 'S71805', 'cccccc', 'cccccc', 'ccccc\r\nccccc\r\nccccc', 'Quality Education (SDG 4)', 'cccccc', 'Makanan Aiman|1|0.00|0.00\r\nGRANDTOTAL| | |0.00', 'uploads/erisk/PROPOSAL_70_ERISK_All_Proposals__Faculty.pdf', NULL, NULL, '2026-06-05', '2026-06-05', 1, 10, 0, 0, 'School Student', 10, 120.00, 1, 'Approved', 130, NULL, '2026-06-05 02:21:39', '2026-06-05 02:24:57', 'Diluluskan sepenuhnya oleh Fakulti.', 'Dewan Sultan Mizan, UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(71, 1002, 'Event', 'S70622', 'rrrr', 'rrrrr', 'rrrr\r\nrrrr\r\nrrrr\r\nrrrr', 'Quality Education (SDG 4)', 'rrrrr', 'Makanan Aiman|1|0.00|0.00\r\nGRANDTOTAL| | |0.00', 'uploads/erisk/PROPOSAL_71_ERISK_All_Proposals__Faculty.pdf', 'uploads/mpp_minutes/PROPOSAL_71_MINUTES_All_Proposals__Faculty.pdf', NULL, '2026-06-05', '2026-06-05', 1, 10, 0, 0, 'School Student', 10, 70.00, 1, 'Approved', 130, NULL, '2026-06-05 08:36:49', '2026-06-05 08:42:11', 'Official HEPA Approval Granted.', 'Dewan Sultan Mizan, UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(72, 1002, 'Event', 'S70622', 'qqqq', 'qqqqq', 'qqqqq', 'Quality Education (SDG 4)', 'qqqq', 'Makanan Aiman|1|0.00|0.00\r\nGRANDTOTAL| | |0.00', 'uploads/erisk/PROPOSAL_72_ERISK_All_Proposals__Faculty.pdf', 'uploads/mpp_minutes/PROPOSAL_72_MINUTES_All_Proposals__Faculty.pdf', NULL, '2026-06-05', '2026-06-05', 1, 10, 0, 0, 'School Student', 10, 30.00, 1, 'Approved', 130, NULL, '2026-06-05 09:23:14', '2026-06-05 09:27:55', 'Official HEPA Approval Granted.', 'Dewan Sultan Mizan, UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(73, 1001, 'Event', 'S72421', 'ppppppp', 'ppppppppppppp', 'ppppppp\r\npppp\r\nppp', 'Quality Education (SDG 4)', 'ppppp', 'Makanan Aiman|1|0.00|0.00\r\nGRANDTOTAL| | |0.00', 'uploads/erisk/PROPOSAL_73_ERISK_All_Proposals__Faculty.pdf', NULL, NULL, '2026-06-05', '2026-06-05', 1, 10, 0, 0, 'School Student', 10, 10.00, 1, 'Approved', 130, NULL, '2026-06-05 09:44:29', '2026-06-05 09:47:09', 'Diluluskan sepenuhnya oleh Fakulti.', 'Dewan Sultan Mizan, UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(74, 1002, 'Event', 'S70622', 'TestSDG', 'TestSDG', 'TestSDG\r\nTestSDG\r\nTestSDG', 'SDG 1: No Poverty | SDG 2: Zero Hunger', 'SDG 1: No Poverty ^ sebab bole ||| SDG 2: Zero Hunger ^ sebab bole', NULL, NULL, NULL, NULL, '2026-06-06', '2026-06-06', 1, 11, 1, 0, '', 12, 72.00, 0, 'Draft', 0, NULL, '2026-06-05 22:42:33', '2026-06-06 04:27:04', NULL, 'Masjid UMT', 'FSKM Students', NULL, NULL, 0, NULL, 1, NULL),
(75, 1001, 'Event', 'S71805', 'TestSDG2', 'TestSDG2', 'TestSDG2\r\nTestSDG2\r\nTestSDG2', 'SDG 6: Clean Water & Sanitation | SDG 12: Responsible Consumption & Production | SDG 17: Partnerships for the Goals', 'SDG 6: Clean Water & Sanitation ^ cuz why not ||| SDG 12: Responsible Consumption & Production ^ cuz why not ||| SDG 17: Partnerships for the Goals ^ cuz why not', 'AAAA|1|10.00|10.00\r\nGRANDTOTAL| | |10.00', 'uploads/erisk/PROPOSAL_75_ERISK_UMT_ClubSphere_Master_Report.pdf', NULL, NULL, '2026-06-06', '2026-06-06', 1, 111, 0, 0, '', 111, 240.00, 1, 'Approved', 0, NULL, '2026-06-06 05:37:10', '2026-06-06 06:04:29', 'Official HEPA Approval Granted.', 'Dewan Sultan Mizan, UMT', 'FSKM Students', NULL, NULL, 0, NULL, 1, NULL),
(76, 1002, 'Event', 'S70622', 'TestNormalizedTable', 'TestNormalizedTable', 'TestNormalizedTable\r\nTestNormalizedTable\r\nTestNormalizedTable', 'SDG 4: Quality Education | SDG 5: Gender Equality', 'SDG 4: Quality Education ^ TestNormalizedTable ||| SDG 5: Gender Equality ^ TestNormalizedTable', NULL, NULL, NULL, NULL, '2026-06-09', '2026-06-09', 1, 11, 1, 0, '', 12, 20.00, 0, 'Draft', 0, NULL, '2026-06-09 14:47:26', '2026-06-09 17:02:11', NULL, 'Masjid UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(77, 1002, 'Event', 'S70622', 'EventTestNormalizedV1', 'EventTestNormalizedV1', 'EventTestNormalizedV1\r\nEventTestNormalizedV1\r\nEventTestNormalizedV1', 'SDG 1: No Poverty | SDG 2: Zero Hunger', 'SDG 1: No Poverty ^ EventTestNormalizedV1 ||| SDG 2: Zero Hunger ^ EventTestNormalizedV1', NULL, NULL, NULL, NULL, '2026-06-17', '2026-06-17', 1, 11, 0, 0, '', 11, 1220.00, 0, 'Pending_Advisor', 130, NULL, '2026-06-17 04:40:28', '2026-06-17 04:43:34', NULL, 'Masjid UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(78, 1002, 'Event', 'S70622', 'EventTestNormalizedV2', 'EventTestNormalizedV2', 'EventTestNormalizedV2', 'SDG 1: No Poverty', '', NULL, NULL, NULL, NULL, '2026-07-10', '2026-07-10', 0, 11, 1, 0, '', 0, 0.00, 0, 'Draft', 0, '', '2026-06-17 07:25:31', '2026-06-17 07:25:31', NULL, 'Masjid UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(79, 1002, 'Event', 'S70622', 'EventTestNormalizedV3', 'EventTestNormalizedV3', 'EventTestNormalizedV3\r\nEventTestNormalizedV3\r\nEventTestNormalizedV3', 'SDG 1: No Poverty', 'SDG 1: No Poverty ^ EventTestNormalizedV3', NULL, 'uploads/erisk/PROPOSAL_79_ERISK_Cyber_Security_-_G11__Mobile_Application_Security_and_Privacy_Risks.pdf', NULL, NULL, '2026-07-10', '2026-07-10', 1, 11, 0, 0, '', 11, 20.00, 0, 'Meeting_Scheduled', 100, '<ul class=\'mb-3\' style=\'line-height: 1.8;\'><li class=\'text-warning text-dark\'><b>Doubtful Financials (Too Low):</b> Average cost is unrealistic (RM0.91/participant).</li><li class=\'text-success\'><b>Controlled Logistics:</b> Daily participant capacity is well managed.</li><li class=\'text-success\'><b>Ideal Timing Planning:</b> No clashes with major University events.</li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>Overall Risk Index:</h6><div><span class=\'badge bg-warning text-dark fs-6 shadow-sm\'><i class=\'fas fa-exclamation-triangle me-1\'></i> MODERATE (46%)</span></div></div><div class=\'mt-2 p-2 bg-warning bg-opacity-10 rounded border border-warning\'><small class=\'text-warning-emphasis fw-bold\'>AI Judgement:</small> <small class=\'text-dark\'>PROCEED WITH CAUTION. Close monitoring is required before endorsement.</small></div>', '2026-06-17 23:48:27', '2026-06-18 06:39:16', 'PITCHING SCHEDULED.\nTarikh & Masa: 2026-06-23 14:38:00\nLink/Lokasi: https://meet.google.com/fqd-niae-avg', 'Masjid UMT', 'Warga UMT', '2026-06-23 14:38:00', 'https://meet.google.com/fqd-niae-avg', 1, NULL, 1, NULL),
(80, 1001, 'Event', 'S72421', 'EventTestNormalizedV4', 'EventTestNormalizedV4', 'EventTestNormalizedV4\r\nEventTestNormalizedV4', 'SDG 6: Clean Water & Sanitation | SDG 14: Life Below Water', 'SDG 6: Clean Water & Sanitation ^ EventTestNormalizedV4 ||| SDG 14: Life Below Water ^ EventTestNormalizedV4', NULL, 'uploads/erisk/PROPOSAL_80_ERISK_Cyber_Security_-_G11__Mobile_Application_Security_and_Privacy_Risks__2_.pdf', 'uploads/mpp_minutes/PROPOSAL_80_MINUTES_Cyber_Security_-_G11__Mobile_Application_Security_and_Privacy_Risks__1_.pdf', NULL, '2026-06-19', '2026-06-19', 1, 111, 0, 0, '', 111, 60.00, 0, 'Approved', 130, '<ul class=\'mb-3\' style=\'line-height: 1.8;\'><li class=\'text-warning text-dark\'><b>Doubtful Financials (Too Low):</b> Average cost is unrealistic (RM0.09/participant).</li><li class=\'text-success\'><b>Controlled Logistics:</b> Daily participant capacity is well managed.</li><li class=\'text-danger\'><b>Timing Warning:</b> Proposed date is too URGENT (less than 2 weeks from today).</li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>Overall Risk Index:</h6><div><span class=\'badge bg-warning text-dark fs-6 shadow-sm\'><i class=\'fas fa-exclamation-triangle me-1\'></i> MODERATE (54%)</span></div></div><div class=\'mt-2 p-2 bg-warning bg-opacity-10 rounded border border-warning\'><small class=\'text-warning-emphasis fw-bold\'>AI Judgement:</small> <small class=\'text-dark\'>PROCEED WITH CAUTION. Close monitoring is required before endorsement.</small></div>', '2026-06-18 02:20:22', '2026-06-18 02:52:59', 'Official HEPA Approval Granted.', 'Makmal Pengaturcaraan 1, FSKM, UMT', 'FSKM Students', NULL, NULL, 1, NULL, 1, NULL),
(81, 1001, 'Event', 'S72421', 'EventTestNormalizedV5', 'EventTestNormalizedV5', 'EventTestNormalizedV5\r\nEventTestNormalizedV5\'EventTestNormalizedV5\r\nEventTestNormalizedV5', 'SDG 2: Zero Hunger', 'SDG 2: Zero Hunger ^ EventTestNormalizedV5', NULL, 'uploads/erisk/PROPOSAL_81_ERISK_Cyber_Security_-_G11__Mobile_Application_Security_and_Privacy_Risks__1_.pdf', NULL, NULL, '2026-07-01', '2026-07-01', 1, 11, 11, 11, 'University Representative', 33, 50.00, 0, 'Approved', 130, '<ul class=\'mb-3\' style=\'line-height: 1.8;\'><li class=\'text-success\'><b>Efficient Financials:</b> Optimum spending (RM3.33/participant).</li><li class=\'text-success\'><b>Controlled Logistics:</b> Daily participant capacity is well managed.</li><li class=\'text-danger\'><b>Timing Warning:</b> Proposed date is too URGENT (less than 2 weeks from today).</li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>Overall Risk Index:</h6><div><span class=\'badge bg-success fs-6 shadow-sm\'><i class=\'fas fa-check-circle me-1\'></i> OPTIMUM (31%)</span></div></div><div class=\'mt-2 p-2 bg-success bg-opacity-10 rounded border border-success\'><small class=\'text-success fw-bold\'>AI Judgement:</small> <small class=\'text-dark\'>HIGHLY RECOMMENDED. Clear calendar, solid planning, and budget meets specifications.</small></div>', '2026-06-18 02:29:22', '2026-06-18 02:32:27', 'Diluluskan sepenuhnya oleh Fakulti.', 'Masjid UMT', 'FSKM Students', NULL, NULL, 1, NULL, 1, NULL),
(82, 1001, 'Event', 'S72421', 'EventTestNormalizedV6', 'EventTestNormalizedV6', 'EventTestNormalizedV6\r\nEventTestNormalizedV6', 'SDG 1: No Poverty', 'SDG 1: No Poverty ^ EventTestNormalizedV6', NULL, 'uploads/erisk/PROPOSAL_82_ERISK_Cyber_Security_-_G11__Mobile_Application_Security_and_Privacy_Risks__1_.pdf', NULL, NULL, '2026-06-18', '2026-06-18', 1, 11, 11, 11, 'University Representative', 33, 140.00, 0, 'Approved', 130, '<ul class=\'mb-3\' style=\'line-height: 1.8;\'><li class=\'text-warning text-dark\'><b>Doubtful Financials (Too Low):</b> Average cost is unrealistic (RM0.30/participant).</li><li class=\'text-success\'><b>Controlled Logistics:</b> Daily participant capacity is well managed.</li><li class=\'text-danger\'><b>Timing Warning:</b> Proposed date is too URGENT (less than 2 weeks from today).</li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>Overall Risk Index:</h6><div><span class=\'badge bg-warning text-dark fs-6 shadow-sm\'><i class=\'fas fa-exclamation-triangle me-1\'></i> MODERATE (54%)</span></div></div><div class=\'mt-2 p-2 bg-warning bg-opacity-10 rounded border border-warning\'><small class=\'text-warning-emphasis fw-bold\'>AI Judgement:</small> <small class=\'text-dark\'>PROCEED WITH CAUTION. Close monitoring is required before endorsement.</small></div>', '2026-06-18 02:54:53', '2026-06-18 03:00:35', 'Official HEPA Approval Granted.', 'Masjid UMT', 'FSKM Students', NULL, NULL, 1, NULL, 1, NULL),
(83, 1002, 'Event', 'S70622', 'TestAIV1', 'TestAIV1', 'TestAIV1\r\nTestAIV1\r\nTestAIV1', 'SDG 7: Affordable & Clean Energy | SDG 11: Sustainable Cities & Communities | SDG 15: Life on Land', 'SDG 7: Affordable & Clean Energy ^ TestAIV1 ||| SDG 11: Sustainable Cities & Communities ^ TestAIV1 ||| SDG 15: Life on Land ^ TestAIV1', NULL, NULL, NULL, NULL, '2026-07-08', '2026-07-08', 1, 11, 11, 11, 'University Representative', 33, 100.00, 0, 'Pending_Advisor', 100, '<ul class=\'mb-3 list-unstyled\' style=\'line-height: 1.8;\'><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Efficient Financials:</b> Optimum spending (RM3.03/pax).</span></li><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Controlled Logistics:</b> Daily participant capacity is well managed.</span></li><li class=\'mb-2\'><i class=\'fas fa-clock text-warning me-2\'></i><span class=\'text-warning text-dark\'><b>Timeline:</b> 20 days notice. Submit immediately to avoid delays.</span></li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>AI Viability Index:</h6><div><span class=\'badge bg-success fs-6 shadow-sm\'><i class=\'fas fa-check-circle me-1\'></i> OPTIMUM (90%)</span></div></div><div class=\'mt-3 p-3 bg-success bg-opacity-10 rounded border border-success\'><small class=\'text-success fw-bold d-block mb-1\'>AI Judgement:</small> <small class=\'text-dark\'>HIGHLY RECOMMENDED. Clear calendar, solid planning, and budget meets specifications.</small></div>', '2026-06-18 12:31:02', '2026-06-18 12:31:50', NULL, 'Masjid UMT', 'FSKM Students', NULL, NULL, 0, NULL, 1, NULL),
(84, 1002, 'Event', 'S70622', 'EventAi2', 'The program is to introduce user with ', 'TO help\r\nto produce\r\nto reduce', 'SDG 1: No Poverty', 'SDG 1: No Poverty ^ because can', NULL, NULL, NULL, NULL, '2026-07-01', '2026-07-01', 1, 11, 11, 11, 'University Representative', 33, 10.00, 0, 'Pending_Advisor', 130, '<ul class=\'mb-3 list-unstyled\' style=\'line-height: 1.8;\'><li class=\'mb-2\'><i class=\'fas fa-info-circle text-warning me-2\'></i><span class=\'text-warning text-dark\'><b>Doubtful Financials:</b> Unusually low cost (RM0.30/pax). Ensure all expenses are accounted for.</span></li><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Controlled Logistics:</b> Daily participant capacity is well managed.</span></li><li class=\'mb-2\'><i class=\'fas fa-clock text-danger me-2\'></i><span class=\'text-danger\'><b>Timing Warning:</b> Very short notice (13 days). High risk of immediate rejection.</span></li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>AI Viability Index:</h6><div><span class=\'badge bg-warning text-dark fs-6 shadow-sm\'><i class=\'fas fa-exclamation-triangle me-1\'></i> MODERATE (60%)</span></div></div><div class=\'mt-3 p-3 bg-warning bg-opacity-10 rounded border border-warning\'><small class=\'text-warning-emphasis fw-bold d-block mb-1\'>AI Judgement:</small> <small class=\'text-dark\'>PROCEED WITH CAUTION. The system detects some logistical or financial inefficiencies. Reviewers may request amendments.</small></div>', '2026-06-18 13:04:49', '2026-06-18 13:04:49', NULL, 'Masjid UMT', 'FSKM Students', NULL, NULL, 0, NULL, 1, NULL),
(85, 1002, 'Event', 'S70622', 'Kempen Jom ke Masjid UMT', 'Kempen ini membuka minda warga sekitar UMT untuk mengunjungi & mengimarahkan masjid.', 'Untuk promosi\r\nUntuk Imarahkan', 'SDG 16: Peace, Justice & Strong Institutions', 'SDG 16: Peace, Justice & Strong Institutions ^ Meraikan keamanan dan kebebasan beragama', NULL, NULL, NULL, NULL, '2026-07-10', '2026-07-10', 1, 100, 10, 10, '', 120, 1600.00, 0, 'Pending_Advisor', 55, '<ul class=\'mb-3 list-unstyled\' style=\'line-height: 1.8;\'><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Efficient Financials:</b> Optimum spending (RM13.33/pax).</span></li><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Controlled Logistics:</b> Daily participant capacity is well managed.</span></li><li class=\'mb-2\'><i class=\'fas fa-clock text-warning me-2\'></i><span class=\'text-warning text-dark\'><b>Timeline:</b> 22 days notice. Submit immediately to avoid delays.</span></li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>AI Viability Index:</h6><div><span class=\'badge bg-success fs-6 shadow-sm\'><i class=\'fas fa-check-circle me-1\'></i> OPTIMUM (90%)</span></div></div><div class=\'mt-3 p-3 bg-success bg-opacity-10 rounded border border-success\'><small class=\'text-success fw-bold d-block mb-1\'>AI Judgement:</small> <small class=\'text-dark\'>HIGHLY RECOMMENDED. Clear calendar, solid planning, and budget meets specifications.</small></div>', '2026-06-18 15:48:28', '2026-06-18 15:49:02', NULL, 'Masjid UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL),
(86, 1002, 'Event', 'S70622', 'Annual Dinner', 'A dinner night to appreciate and reward the hardworking committee and club members. ', 'To appreciate \r\nTo reward\r\nTo closen ', 'SDG 17: Partnerships for the Goals', 'SDG 17: Partnerships for the Goals ^ To show and reward the best relationship and teamwork between club members and committee', NULL, NULL, NULL, NULL, '2026-06-26', '2026-06-26', 1, 130, 2, 0, '', 132, 2700.00, 0, 'Pending_Advisor', 35, '<ul class=\'mb-3 list-unstyled\' style=\'line-height: 1.8;\'><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Efficient Financials:</b> Optimum spending (RM20.45/pax).</span></li><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Controlled Logistics:</b> Daily participant capacity is well managed.</span></li><li class=\'mb-2\'><i class=\'fas fa-clock text-danger me-2\'></i><span class=\'text-danger\'><b>Timing Warning:</b> Very short notice (7 days).</span></li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>AI Viability Index:</h6><div><span class=\'badge bg-warning text-dark fs-6 shadow-sm\'><i class=\'fas fa-exclamation-triangle me-1\'></i> MODERATE (70%)</span></div></div><div class=\'mt-3 p-3 bg-warning bg-opacity-10 rounded border border-warning\'><small class=\'text-warning-emphasis fw-bold d-block mb-1\'>AI Judgement:</small> <small class=\'text-dark\'>PROCEED WITH CAUTION. The system detects some logistical or financial inefficiencies.</small></div>', '2026-06-18 16:26:10', '2026-06-18 16:26:51', NULL, 'Quinara Hotel', 'Club Members', NULL, NULL, 0, NULL, 1, NULL),
(87, 1002, 'Event', 'S70622', 'Gotong Royong Masjid', 'Cuci masjid', 'Untuk membersihkan \r\nUntuk memupuk\r\nUntuk mengeratkan ', 'SDG 17: Partnerships for the Goals', 'SDG 17: Partnerships for the Goals ^ Semangat berkumpulan', NULL, NULL, NULL, NULL, '2026-06-30', '2026-06-30', 1, 20, 0, 0, '', 20, 200.00, 0, 'Pending_Advisor', 35, '<ul class=\'mb-3 list-unstyled\' style=\'line-height: 1.8;\'><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Efficient Financials:</b> Optimum spending (RM10.00/pax).</span></li><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Controlled Logistics:</b> Daily participant capacity is well managed.</span></li><li class=\'mb-2\'><i class=\'fas fa-clock text-danger me-2\'></i><span class=\'text-danger\'><b>Timing Warning:</b> Very short notice (11 days).</span></li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>AI Viability Index:</h6><div><span class=\'badge bg-warning text-dark fs-6 shadow-sm\'><i class=\'fas fa-exclamation-triangle me-1\'></i> MODERATE (70%)</span></div></div><div class=\'mt-3 p-3 bg-warning bg-opacity-10 rounded border border-warning\'><small class=\'text-warning-emphasis fw-bold d-block mb-1\'>AI Judgement:</small> <small class=\'text-dark\'>PROCEED WITH CAUTION. The system detects some logistical or financial inefficiencies.</small></div>', '2026-06-18 16:35:54', '2026-06-18 16:35:54', NULL, 'Masjid UMT', 'Ahli Kelab', NULL, NULL, 0, NULL, 1, NULL),
(88, 1002, 'Event', 'S70622', 'Score vs Index', 'Score vs Index', 'Score vs Index\r\nScore vs Index\r\nScore vs Index', 'SDG 2: Zero Hunger', 'SDG 2: Zero Hunger ^ Score vs Index', NULL, NULL, NULL, NULL, '2026-07-10', '2026-07-10', 1, 100, 10, 10, '', 120, 10.00, 0, 'Pending_Advisor', 45, '<ul class=\'mb-3 list-unstyled\' style=\'line-height: 1.8;\'><li class=\'mb-2\'><i class=\'fas fa-info-circle text-warning me-2\'></i><span class=\'text-warning text-dark\'><b>Doubtful Financials:</b> Unusually low cost (RM0.08/pax).</span></li><li class=\'mb-2\'><i class=\'fas fa-exclamation-triangle text-danger me-2\'></i><span class=\'text-danger\'><b>Annual Limit (CRITICAL):</b> Exceeds RM 1,000 yearly club limit with NO sponsorship listed.</span></li><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Controlled Logistics:</b> Daily participant capacity is well managed.</span></li><li class=\'mb-2\'><i class=\'fas fa-clock text-warning me-2\'></i><span class=\'text-warning text-dark\'><b>Timeline:</b> 21 days notice. Submit immediately.</span></li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>AI Viability Index:</h6><div><span class=\'badge bg-danger fs-6 shadow-sm\'><i class=\'fas fa-times-circle me-1\'></i> BERISIKO (45%)</span></div></div><div class=\'mt-3 p-3 bg-danger bg-opacity-10 rounded border border-danger\'><small class=\'text-danger fw-bold d-block mb-1\'>AI Judgement:</small> <small class=\'text-dark\'>NOT RECOMMENDED. This proposal has critical flaws. High probability of rejection.</small></div>', '2026-06-18 17:04:57', '2026-06-18 17:04:57', NULL, 'Masjid UMT', 'Warga UMT', NULL, NULL, 0, NULL, 1, NULL);
INSERT INTO `eventproposal` (`proposalId`, `clubId`, `proposalType`, `createdBy`, `title`, `description`, `objective`, `sdgImpact`, `sdgReason`, `originalBudgetDetails`, `eriskFile`, `mppMinutesFile`, `hepaRemark`, `proposedDate`, `endDate`, `duration`, `participantUmt`, `participantStaff`, `participantPublic`, `participantOtherDesc`, `estimateParticipant`, `estimateBudget`, `isBudgetAltered`, `Status`, `conflictScore`, `aiSuggestion`, `createdAt`, `updatedAt`, `feedback`, `venue`, `targetAudience`, `pitchingDate`, `pitchingLocation`, `budgetAltered`, `budgetDetails`, `isClubFunded`, `aiSummary`) VALUES
(89, 1002, 'Event', 'S70622', 'TestLimitBudget1000', 'blablabla', 'To\r\nTo\r\n', 'SDG 2: Zero Hunger', 'SDG 2: Zero Hunger ^ To', NULL, NULL, NULL, NULL, '2026-07-07', '2026-07-08', 2, 120, 0, 0, '', 120, 1300.00, 0, 'Pending_Advisor', 75, '<ul class=\'mb-3 list-unstyled\' style=\'line-height: 1.8;\'><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Efficient Financials:</b> Optimum spending (RM10.83/pax).</span></li><li class=\'mb-2\'><i class=\'fas fa-info-circle text-warning me-2\'></i><span class=\'text-warning text-dark\'><b>Annual Limit:</b> Exceeds RM 1,000 yearly limit, but external funding noted.</span></li><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Controlled Logistics:</b> Daily participant capacity is well managed.</span></li><li class=\'mb-2\'><i class=\'fas fa-clock text-warning me-2\'></i><span class=\'text-warning text-dark\'><b>Timeline:</b> 18 days notice. Submit immediately.</span></li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>AI Viability Index:</h6><div><span class=\'badge bg-success fs-6 shadow-sm\'><i class=\'fas fa-check-circle me-1\'></i> OPTIMUM (75%)</span></div></div><div class=\'mt-3 p-3 bg-success bg-opacity-10 rounded border border-success\'><small class=\'text-success fw-bold d-block mb-1\'>AI Judgement:</small> <small class=\'text-dark\'>HIGHLY RECOMMENDED. Clear calendar, solid planning, and budget meets specifications.</small></div>', '2026-06-18 17:58:07', '2026-06-18 17:58:07', NULL, 'Masjid UMT', 'Warga UMT', NULL, NULL, 0, 'Yuran Penyertaan RM10, Sponsor Hadiah Syarikat B RM200', 1, NULL),
(90, 1001, 'Event', 'S72421', 'Bengkel Robotik 2026', 'Bengkel bertujuan memberikan pendedahan kepada peserta mengenai robot menggunakan Arduino dan bahasa pengaturcaraan C', 'Untuk memberikan pendedahan\r\nUntuk mencari bakat baru', 'SDG 4: Quality Education', 'SDG 4: Quality Education ^ Memberikan peluang kepada semua pelajar untuk mempelajari pembinaan robot', NULL, 'uploads/erisk/PROPOSAL_90_ERISK_Cover_Letter_-_KBMC.pdf', NULL, NULL, '2026-07-11', '2026-07-11', 1, 20, 0, 0, '', 20, 440.00, 0, 'Pending_Faculty', 90, '<ul class=\'mb-3 list-unstyled\' style=\'line-height: 1.8;\'><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Efficient Financials:</b> Optimum spending (RM22.00/pax).</span></li><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Independent Funding:</b> Program does not utilize the club\'s annual RM 1,000 wallet.</span></li><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Controlled Logistics:</b> Daily participant capacity is well managed.</span></li><li class=\'mb-2\'><i class=\'fas fa-clock text-warning me-2\'></i><span class=\'text-warning text-dark\'><b>Timeline:</b> 20 days notice. Submit immediately.</span></li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>AI Viability Index:</h6><div><span class=\'badge bg-success fs-6 shadow-sm\'><i class=\'fas fa-check-circle me-1\'></i> OPTIMUM (90%)</span></div></div><div class=\'mt-3 p-3 bg-success bg-opacity-10 rounded border border-success\'><small class=\'text-success fw-bold d-block mb-1\'>AI Judgement:</small> <small class=\'text-dark\'>HIGHLY RECOMMENDED. Clear calendar, solid planning, and budget meets specifications.</small></div>', '2026-06-21 06:05:49', '2026-06-21 06:08:12', 'Supported by Advisor: Nice', 'Makmal Pengaturcaraan 1, FSKM, UMT', 'FSKM Students', NULL, NULL, 0, 'Sponsor Arduino Kit by Drabot Sdn. Bhd. RM500, Yuran Penyertaan RM12', 0, NULL),
(91, 1002, 'Event', 'S70622', 'Pertandingan Tilawah Al-Quran Peringkat Universiti 2026', 'Pertandingan antara 9 orang pelajar dari seluruh fakulti di UMT. Yang terbaik akan terpilih untuk mewakili UMT ke Pertandingan Tilawah Al-Quran peringkat Kebangsaan pada 27 September akan datang.', 'Untuk melahirkan Qari & Qariah UMT yang berdaya saing di peringkat Kebangsaan\r\nUntuk memupuk perasaan cinta akan Al-Quran', 'SDG 16: Peace, Justice & Strong Institutions', 'SDG 16: Peace, Justice & Strong Institutions ^ Menunjukkan yang Islam merupakan agama Kedamaian', NULL, NULL, NULL, NULL, '2026-07-16', '2026-07-16', 1, 9, 0, 0, '', 9, 80.00, 0, 'Pending_Advisor', 55, '<ul class=\'mb-3 list-unstyled\' style=\'line-height: 1.8;\'><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Efficient Financials:</b> Optimum spending (RM8.89/pax).</span></li><li class=\'mb-2\'><i class=\'fas fa-exclamation-triangle text-danger me-2\'></i><span class=\'text-danger\'><b>Annual Limit (CRITICAL):</b> Exceeds RM 1,000 yearly club limit with NO sponsorship listed.</span></li><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Controlled Logistics:</b> Daily participant capacity is well managed.</span></li><li class=\'mb-2\'><i class=\'fas fa-clock text-warning me-2\'></i><span class=\'text-warning text-dark\'><b>Timeline:</b> 24 days notice. Submit immediately.</span></li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>AI Viability Index:</h6><div><span class=\'badge bg-warning text-dark fs-6 shadow-sm\'><i class=\'fas fa-exclamation-triangle me-1\'></i> MODERATE (55%)</span></div></div><div class=\'mt-3 p-3 bg-warning bg-opacity-10 rounded border border-warning\'><small class=\'text-warning-emphasis fw-bold d-block mb-1\'>AI Judgement:</small> <small class=\'text-dark\'>PROCEED WITH CAUTION. The system detects some logistical or financial inefficiencies.</small></div>', '2026-06-21 09:54:25', '2026-06-21 22:21:09', NULL, 'Masjid UMT', 'Pelajar UMT', NULL, NULL, 0, '', 1, 'Error processing AI logic. Please check your inputs.'),
(92, 10006, 'Event', 'S70810', 'Zombie Run 3.0 ', 'Blablabla', 'Untuk blablabla\r\nUntuk Blablabla', 'SDG 3: Good Health & Well-being', 'SDG 3: Good Health & Well-being ^ Lari2', NULL, 'uploads/erisk/PROPOSAL_92_ERISK_Cover_Letter_-_KBMC.pdf', NULL, NULL, '2026-07-04', '2026-07-04', 1, 300, 0, 0, '', 300, 1400.00, 0, 'Meeting_Scheduled', 25, '<ul class=\'mb-3 list-unstyled\' style=\'line-height: 1.8;\'><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Efficient Financials:</b> Optimum spending (RM7.00/pax).</span></li><li class=\'mb-2\'><i class=\'fas fa-exclamation-triangle text-danger me-2\'></i><span class=\'text-danger\'><b>Annual Limit (CRITICAL):</b> Exceeds RM 1,000 yearly club limit with NO sponsorship listed.</span></li><li class=\'mb-2\'><i class=\'fas fa-info-circle text-warning me-2\'></i><span class=\'text-warning text-dark\'><b>Participant Density:</b> Moderate crowd (300 pax/day).</span></li><li class=\'mb-2\'><i class=\'fas fa-clock text-danger me-2\'></i><span class=\'text-danger\'><b>Timing Warning:</b> Very short notice (13 days).</span></li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>AI Viability Index:</h6><div><span class=\'badge bg-danger fs-6 shadow-sm\'><i class=\'fas fa-times-circle me-1\'></i> BERISIKO (25%)</span></div></div><div class=\'mt-3 p-3 bg-danger bg-opacity-10 rounded border border-danger\'><small class=\'text-danger fw-bold d-block mb-1\'>AI Judgement:</small> <small class=\'text-dark\'>NOT RECOMMENDED. This proposal has critical flaws. High probability of rejection.</small></div>', '2026-06-21 11:51:28', '2026-06-21 11:56:01', 'PITCHING SCHEDULED.\nTarikh & Masa: 2026-06-22 19:55:00\nLink/Lokasi: https://meet.google.com/abc-defg-hij', 'PSR, UMT', 'Pelajar UMT', '2026-06-22 19:55:00', 'https://meet.google.com/abc-defg-hij', 1, '', 1, NULL),
(93, 1002, 'Event', 'S70622', 'Pertandingan Azan', 'mencari bilal baru', 'Untuk\r\nUntuk', 'SDG 10: Reduced Inequalities', 'SDG 10: Reduced Inequalities ^ Nice', NULL, NULL, NULL, NULL, '2026-06-24', '2026-06-24', 1, 200, 0, 0, '', 200, 2000.00, 0, 'Pending_Advisor', 25, '<ul class=\'mb-3 list-unstyled\' style=\'line-height: 1.8;\'><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Efficient Financials:</b> Optimum spending (RM10.00/pax).</span></li><li class=\'mb-2\'><i class=\'fas fa-exclamation-triangle text-danger me-2\'></i><span class=\'text-danger\'><b>Annual Limit (CRITICAL):</b> Exceeds RM 1,000 yearly club limit with NO sponsorship listed.</span></li><li class=\'mb-2\'><i class=\'fas fa-info-circle text-warning me-2\'></i><span class=\'text-warning text-dark\'><b>Participant Density:</b> Moderate crowd (200 pax/day).</span></li><li class=\'mb-2\'><i class=\'fas fa-clock text-danger me-2\'></i><span class=\'text-danger\'><b>Timing Warning:</b> Very short notice (2 days).</span></li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>AI Viability Index:</h6><div><span class=\'badge bg-danger fs-6 shadow-sm\'><i class=\'fas fa-times-circle me-1\'></i> BERISIKO (25%)</span></div></div><div class=\'mt-3 p-3 bg-danger bg-opacity-10 rounded border border-danger\'><small class=\'text-danger fw-bold d-block mb-1\'>AI Judgement:</small> <small class=\'text-dark\'>NOT RECOMMENDED. This proposal has critical flaws. High probability of rejection.</small></div>', '2026-06-21 21:50:36', '2026-06-21 21:50:36', NULL, 'Masjid UMT', 'Pelajar UMT', NULL, NULL, 0, '', 1, 'No AI Analysis requested during submission.'),
(94, 1002, 'Event', 'S70622', 'Bengkel Khat', 'aaa', 'aaa', 'SDG 1: No Poverty', 'SDG 1: No Poverty ^ aaa', NULL, NULL, NULL, NULL, '2026-07-10', '2026-07-10', 1, 30, 0, 0, '', 30, 350.00, 0, 'Pending_Advisor', 75, '<ul class=\'mb-3 list-unstyled\' style=\'line-height: 1.8;\'><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Efficient Financials:</b> Optimum spending (RM11.67/pax).</span></li><li class=\'mb-2\'><i class=\'fas fa-info-circle text-warning me-2\'></i><span class=\'text-warning text-dark\'><b>Annual Limit:</b> Exceeds RM 1,000 yearly limit, but external funding noted.</span></li><li class=\'mb-2\'><i class=\'fas fa-check-circle text-success me-2\'></i><span class=\'text-success\'><b>Controlled Logistics:</b> Daily participant capacity is well managed.</span></li><li class=\'mb-2\'><i class=\'fas fa-clock text-warning me-2\'></i><span class=\'text-warning text-dark\'><b>Timeline:</b> 18 days notice. Submit immediately.</span></li></ul><hr><div class=\'d-flex align-items-center justify-content-between\'><h6 class=\'fw-bold mb-0\'>AI Viability Index:</h6><div><span class=\'badge bg-success fs-6 shadow-sm\'><i class=\'fas fa-check-circle me-1\'></i> OPTIMUM (75%)</span></div></div><div class=\'mt-3 p-3 bg-success bg-opacity-10 rounded border border-success\'><small class=\'text-success fw-bold d-block mb-1\'>AI Judgement:</small> <small class=\'text-dark\'>HIGHLY RECOMMENDED. Clear calendar, solid planning, and budget meets specifications.</small></div>', '2026-06-21 22:14:14', '2026-06-21 22:14:14', NULL, 'Masjid UMT', 'Pelajar UMT', NULL, NULL, 0, 'Yuran Penyertaan RM5', 1, 'Efficient Financials: Optimum spending (RM11.67/pax).Annual Limit: Exceeds RM 1,000 yearly limit, but external funding noted.Controlled Logistics: Daily participant capacity is well managed.Timeline: 18 days notice. Submit immediately.AI Viability Index: OPTIMUM (75%)AI Judgement: HIGHLY RECOMMENDED. Clear calendar, solid planning, and budget meets specifications. System Auto-Generated Executive Summary:\"The system has analyzed \'Bengkel Khat\'. Based on the heuristic matrix, please ensure all logistical and financial preparations adhere to university guidelines ahead of the 1-day schedule.\"'),
(95, 1002, 'Event', 'S70622', 'Program UMT Berselawat 2026', 'Program ini diadakan bertujuan untuk menyemarakkan aktiviti selawat dan munajat, mengingati Rasulullah SAW.', 'Untuk meningkatkan\r\nUntuk mewujudkan', 'SDG 16: Peace, Justice & Strong Institutions', 'SDG 16: Peace, Justice & Strong Institutions ^ Memberikan ketenangan dan peringatan akan Rasulullah', NULL, NULL, NULL, NULL, '2026-07-11', '2026-07-11', 1, 500, 0, 0, '', 500, 3740.00, 0, 'Draft', 0, '', '2026-06-22 02:01:31', '2026-06-22 02:01:31', NULL, 'Masjid UMT', 'Warga UMT', NULL, NULL, 0, 'Tajaan Cenderamata Syarikat ABC Sdn. Bhd. RM300', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `master_calendar`
--

CREATE TABLE `master_calendar` (
  `calendarId` int(11) NOT NULL,
  `eventTitle` varchar(200) NOT NULL,
  `startDate` date NOT NULL,
  `endDate` date NOT NULL,
  `eventType` enum('Exam','Public Holiday','Convocation','UMT Official','Ramadan','Others') NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `master_calendar`
--

INSERT INTO `master_calendar` (`calendarId`, `eventTitle`, `startDate`, `endDate`, `eventType`, `description`) VALUES
(1, 'New Year\'s Day', '2026-01-01', '2026-01-01', 'Public Holiday', 'Federal Holiday (2026)'),
(2, 'Thaipusam', '2026-02-01', '2026-02-01', 'Public Holiday', 'Federal Holiday (2026)'),
(3, 'Chinese New Year', '2026-02-17', '2026-02-17', 'Public Holiday', 'Federal Holiday (2026)'),
(4, 'Hari Raya Aidilfitri', '2026-03-20', '2026-03-20', 'Public Holiday', 'Federal Holiday (2026)'),
(5, 'Labour Day', '2026-05-01', '2026-05-01', 'Public Holiday', 'Federal Holiday (2026)'),
(6, 'Wesak Day', '2026-05-31', '2026-05-31', 'Public Holiday', 'Federal Holiday (2026)'),
(7, 'Agong\'s Birthday', '2026-06-07', '2026-06-07', 'Public Holiday', 'Federal Holiday (2026)'),
(8, 'Merdeka Day', '2026-08-31', '2026-08-31', 'Public Holiday', 'Federal Holiday (2026)'),
(9, 'Malaysia Day', '2026-09-16', '2026-09-16', 'Public Holiday', 'Federal Holiday (2026)'),
(10, 'Deepavali', '2026-11-08', '2026-11-08', 'Public Holiday', 'Federal Holiday (2026)'),
(11, 'Christmas Day', '2026-12-25', '2026-12-25', 'Public Holiday', 'Federal Holiday (2026)'),
(12, 'Chinese New Year (Day 2)', '2026-02-18', '2026-02-18', 'Public Holiday', 'Federal Holiday (2026)'),
(13, 'Hari Raya Aidilfitri (Day 2)', '2026-03-21', '2026-03-21', 'Public Holiday', 'Federal Holiday (2026)'),
(14, 'Hari Raya Haji', '2026-05-27', '2026-05-27', 'Public Holiday', 'Federal Holiday (2026)'),
(15, 'Awal Muharram', '2026-06-16', '2026-06-16', 'Public Holiday', 'Federal Holiday (2026)'),
(16, 'Prophet Muhammad\'s Birthday', '2026-09-24', '2026-09-24', 'Public Holiday', 'Federal Holiday (2026)'),
(17, 'Study Week', '2026-01-18', '2026-01-22', 'UMT Official', 'Undergraduate students having study week before their final exam. good Luck!s');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notificationId` int(11) NOT NULL,
  `clubId` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `type` enum('REMINDER','ANNOUNCEMENT','STATUS') NOT NULL,
  `actionLink` varchar(255) DEFAULT NULL,
  `actionLabel` varchar(50) DEFAULT NULL,
  `isRead` tinyint(1) DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `targetRole` varchar(20) DEFAULT 'All'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notificationId`, `clubId`, `title`, `message`, `type`, `actionLink`, `actionLabel`, `isRead`, `createdAt`, `targetRole`) VALUES
(1, 1002, 'Proposal Rejected', 'Your proposal requires amendments. Please review the feedback.', 'STATUS', '/chc/events', 'Lihat', 1, '2026-04-14 09:10:17', 'All'),
(2, 1002, 'Proposal Approved!', 'Your proposal has been approved by MPP.', 'STATUS', '/chc/events', 'Lihat', 1, '2026-04-14 09:13:36', 'All'),
(3, 1001, 'Proposal Approved!', 'Your proposal has been approved by MPP.', 'STATUS', '/chc/events', 'Lihat', 1, '2026-04-14 09:22:53', 'All'),
(4, 1001, 'Proposal Rejected', 'Your proposal requires amendments. Please review the feedback.', 'STATUS', '/chc/events', 'Lihat', 1, '2026-04-14 11:48:57', 'All'),
(7, 9999, 'New Proposal Submitted', 'Proposal baru perlukan semakan: 1111', 'STATUS', '/mpp/proposals', 'Lihat', 1, '2026-04-14 16:22:00', 'All'),
(8, 9999, 'New Proposal Submitted', 'New Approval need review: 111', 'STATUS', '/mpp/proposals', 'Lihat', 1, '2026-04-14 16:43:16', 'All'),
(9, 9999, 'New Proposal Submitted', 'New Approval need review: Kursus Pengurusan Jenazah 2026', 'STATUS', '/mpp/proposals', 'Lihat', 1, '2026-04-15 00:41:22', 'All'),
(10, 1002, 'Proposal Rejected', 'Your proposal requires amendments. Please review the feedback.', 'STATUS', '/chc/events', 'Lihat', 1, '2026-04-15 00:42:14', 'All'),
(11, 9999, 'New Proposal Submitted', 'New Approval need review: 111', 'STATUS', '/mpp/proposals', 'Lihat', 1, '2026-04-15 01:44:39', 'All'),
(13, 9999, 'New Proposal Submitted', 'New Approval need review: 111', 'STATUS', '/mpp/proposals', 'Lihat', 1, '2026-04-15 09:35:02', 'All'),
(14, 1002, 'New Proposal: SAHAM', 'A new proposal \'Test5\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Review', 1, '2026-04-16 09:18:44', 'Advisor'),
(15, 1002, 'New Proposal: SAHAM', 'A new proposal \'Test6\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Review', 1, '2026-04-19 12:04:21', 'Advisor'),
(16, 9999, 'New Proposal Submitted', 'New Approval need review: Test7', 'STATUS', '/mpp/proposals', 'Lihat', 1, '2026-04-19 13:30:10', 'All'),
(17, 1002, 'New Proposal Submitted', 'A new proposal \'Test10:11-19/4/2026\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 14:12:08', 'Advisor'),
(18, 1002, 'Proposal Approved!', 'Your proposal has been approved by MPP.', 'STATUS', '/chc/events', 'Lihat', 1, '2026-04-19 14:13:21', 'All'),
(19, 1002, 'New Proposal Submitted', 'A new proposal \'Test123\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 14:34:06', 'Advisor'),
(20, 1002, 'Proposal for Review', 'Advisor has supported a proposal. Needs your review.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-04-19 15:18:27', 'MPP'),
(21, 1002, 'New Proposal Submitted', 'A new proposal \'Test999\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 15:18:57', 'Advisor'),
(22, 1002, 'Proposal for Review', 'Advisor has supported a proposal. Needs your review.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-04-19 15:20:43', 'MPP'),
(23, 1002, 'New Proposal Submitted', 'A new proposal \'TestAccept1\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 15:32:45', 'Advisor'),
(24, 1002, 'New Proposal Submitted', 'A new proposal \'TestReject1\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 15:33:09', 'Advisor'),
(25, 1002, 'New Proposal Submitted', 'A new proposal \'TestAccept2\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 15:39:08', 'Advisor'),
(26, 1002, 'New Proposal Submitted', 'A new proposal \'TestReject2\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 15:39:32', 'Advisor'),
(27, 1002, 'Proposal Rejected', 'Your Advisor has rejected your proposal: TestReject2. Check advisor remarks for guidance.', 'STATUS', '/chc/events', 'View', 1, '2026-04-19 15:48:00', 'CHC'),
(28, 1002, 'New Review Required', 'Advisor has supported: TestAccept2. Needs your review.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-04-19 15:48:14', 'MPP'),
(29, 1002, 'Advisor Supported', 'Your advisor has supported your proposal: TestAccept2. Now forwarded to MPP.', 'STATUS', '/chc/events', 'View', 1, '2026-04-19 15:48:14', 'CHC'),
(30, 1002, 'New Proposal Submitted', 'A new proposal \'TestReject2\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 15:48:56', 'Advisor'),
(31, 1002, 'New Review Required', 'Advisor has supported: TestReject2. Needs your review.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-04-19 15:49:35', 'MPP'),
(32, 1002, 'Advisor Supported', 'Your advisor has supported your proposal: TestReject2. Now forwarded to MPP.', 'STATUS', '/chc/events', 'View', 1, '2026-04-19 15:49:35', 'CHC'),
(33, 1002, 'New Proposal Submitted', 'A new proposal \'Test-Advisor.Pass-MPP.Pitch\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 16:55:29', 'Advisor'),
(34, 1002, 'New Review Required', 'Advisor has supported: Test-Advisor.Pass-MPP.Pitch. Needs your review.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-04-19 16:56:41', 'MPP'),
(35, 1002, 'Advisor Supported', 'Your advisor has supported your proposal: Test-Advisor.Pass-MPP.Pitch. Now forwarded to MPP.', 'STATUS', '/chc/events', 'View', 1, '2026-04-19 16:56:41', 'CHC'),
(36, 1002, 'Pitching Scheduled!', 'MPP has scheduled a pitching session for \'Test-Advisor.Pass-MPP.Pitch\' on 2026-04-20 at 18:08.', 'STATUS', '/chc/events', 'View Details', 1, '2026-04-19 17:05:59', 'CHC'),
(37, 1002, 'New Proposal Submitted', 'A new proposal \'TestMeeting1\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 17:30:14', 'Advisor'),
(38, 1002, 'Pitching Scheduled!', 'MPP has scheduled a pitching session for \'TestMeeting1\' on 2026-04-23 at 20:38.', 'STATUS', '/chc/events', 'View Details', 1, '2026-04-19 17:32:37', 'CHC'),
(39, 1002, 'New Proposal Submitted', 'A new proposal \'TestMeeting2\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 17:44:16', 'Advisor'),
(40, 1002, 'New Proposal for Review', 'Advisor has supported proposal \'TestMeeting2\' from SAHAM.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-04-19 17:45:33', 'MPP'),
(41, 1002, 'Advisor Supported', 'Your advisor has supported your proposal: TestMeeting2. Now forwarded to MPP.', 'STATUS', '/chc/events', 'View', 1, '2026-04-19 17:45:33', 'CHC'),
(42, 1002, 'Pitching Scheduled!', 'MPP has scheduled a pitching session for \'TestMeeting2\' on 2026-04-15 at 19:51.', 'STATUS', '/chc/events', 'View Details', 1, '2026-04-19 17:46:35', 'CHC'),
(43, 1002, 'Proposal Approved!', 'Congratulations! MPP has approved your proposal \'TestMeeting2\'.', 'STATUS', '/chc/events', 'View', 1, '2026-04-19 17:52:52', 'CHC'),
(44, 1002, 'New Proposal Submitted', 'A new proposal \'TestMeeting3\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 17:53:22', 'Advisor'),
(45, 1002, 'New Proposal Submitted', 'A new proposal \'TestProp1\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 17:58:57', 'Advisor'),
(46, 1002, 'New Proposal for Review', 'Advisor has supported proposal \'TestProp1\' from SAHAM.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-04-19 17:59:24', 'MPP'),
(47, 1002, 'Advisor Supported', 'Your advisor has supported your proposal: TestProp1. Now forwarded to MPP.', 'STATUS', '/chc/events', 'View', 1, '2026-04-19 17:59:24', 'CHC'),
(48, 1002, 'Proposal Rejected', 'MPP rejected your proposal \'TestMeeting3\'. Please check the feedback.', 'STATUS', '/chc/events', 'View Remarks', 1, '2026-04-19 18:00:29', 'CHC'),
(49, 1002, 'Pitching Scheduled!', 'MPP has scheduled a pitching session for \'TestProp1\' on 2026-04-23 at 21:00.', 'STATUS', '/chc/events', 'View Details', 1, '2026-04-19 18:00:41', 'CHC'),
(50, 1002, 'New Proposal Submitted', 'A new proposal \'TestHepa1\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 18:35:55', 'Advisor'),
(51, 1002, 'New Proposal for Review', 'Advisor has supported proposal \'TestHepa1\' from SAHAM.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-04-19 18:36:47', 'MPP'),
(52, 1002, 'Advisor Supported', 'Your advisor has supported your proposal: TestHepa1. Now forwarded to MPP.', 'STATUS', '/chc/events', 'View', 1, '2026-04-19 18:36:47', 'CHC'),
(53, 1002, 'Pitching Scheduled!', 'MPP has scheduled a pitching session for \'TestHepa1\' on 2026-04-23 at 15:00.', 'STATUS', '/chc/events', 'View Details', 1, '2026-04-19 18:37:38', 'CHC'),
(54, 1002, 'Proposal Ready for Endorsement', 'MPP has approved \'TestHepa1\'. Please provide final endorsement.', 'STATUS', '/hepa/review', 'Endorse', 1, '2026-04-19 18:38:30', 'HEPA'),
(55, 1002, 'MPP Approved', 'Your proposal \'TestHepa1\' has been approved by MPP and is now with HEPA for final endorsement.', 'STATUS', '/chc/events', 'View', 1, '2026-04-19 18:38:30', 'CHC'),
(56, 1002, 'Congratulations! Fully Approved', 'Your proposal \'TestHepa1\' has received final approval from HEPA. You may proceed with the event.', 'STATUS', '/chc/events', 'View', 1, '2026-04-19 18:44:49', 'CHC'),
(57, 1001, 'New Proposal Submitted', 'A new proposal \'Bengkel C#\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 19:50:20', 'Advisor'),
(58, 1001, 'New Proposal for Review', 'Advisor has supported proposal \'Bengkel C#\' from COMTECH.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-04-19 19:51:16', 'HEPA'),
(59, 1001, 'Advisor Supported', 'Your advisor has supported your proposal: Bengkel C#. Now forwarded to HEPA.', 'STATUS', '/chc/events', 'View', 1, '2026-04-19 19:51:16', 'CHC'),
(60, 1001, 'New Proposal Submitted', 'A new proposal \'Bengkel Database\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 19:53:49', 'Advisor'),
(61, 1001, 'New Proposal for Review', 'Advisor has supported proposal \'Bengkel Database\' from COMTECH.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-04-19 19:54:29', 'Faculty'),
(62, 1001, 'Advisor Supported', 'Your advisor has supported your proposal: Bengkel Database. Now forwarded to Faculty.', 'STATUS', '/chc/events', 'View', 1, '2026-04-19 19:54:29', 'CHC'),
(63, 1001, 'New Proposal Submitted', 'A new proposal \'Bengkel Web Design\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 21:12:01', 'Advisor'),
(64, 1001, 'New Proposal for Review', 'Advisor has supported proposal \'Bengkel Web Design\' from COMTECH.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-04-19 21:14:06', 'Faculty'),
(65, 1001, 'Advisor Supported', 'Your advisor has supported your proposal: Bengkel Web Design. Now forwarded to Faculty.', 'STATUS', '/chc/events', 'View', 1, '2026-04-19 21:14:06', 'CHC'),
(66, 1001, 'Academic Proposal: Budget Clearance Needed', 'Faculty has endorsed \'Bengkel Web Design\'. Please review the budget.', 'STATUS', '/hepa/dashboard', 'Review', 1, '2026-04-19 21:32:36', 'HEPA'),
(67, 1001, 'Faculty Approved', 'Your proposal \'Bengkel Web Design\' content has been verified and sent to HEPA.', 'STATUS', '/chc/events', 'View', 1, '2026-04-19 21:32:36', 'CHC'),
(68, 1001, 'New Proposal Submitted', 'A new proposal \'Test1\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-19 21:34:14', 'Advisor'),
(69, 1001, 'Academic Proposal: Budget Clearance Needed', 'Faculty has endorsed \'Test1\'. Please review the budget.', 'STATUS', '/hepa/dashboard', 'Review', 1, '2026-04-19 21:43:28', 'HEPA'),
(70, 1001, 'Faculty Approved', 'Your proposal \'Test1\' content has been verified and sent to HEPA.', 'STATUS', '/chc/events', 'View', 1, '2026-04-19 21:43:28', 'CHC'),
(71, 1001, 'New Proposal Submitted', 'A new proposal \'TestProposal1\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-20 00:46:04', 'Advisor'),
(72, 1001, 'New Proposal for Review', 'Advisor has supported proposal \'TestProposal1\'. Needs your verification.', 'STATUS', '/faculty/dashboard', 'Review', 1, '2026-04-20 00:47:29', 'Faculty'),
(73, 1001, 'Advisor Supported', 'Your advisor has supported your proposal: TestProposal1. Now forwarded to Faculty.', 'STATUS', '/chc/events', 'View', 1, '2026-04-20 00:47:29', 'CHC'),
(74, 1001, 'Academic Proposal: Budget Clearance Needed', 'Faculty has endorsed \'TestProposal1\'. Please review the budget.', 'STATUS', '/hepa/dashboard', 'Review', 1, '2026-04-20 00:48:47', 'HEPA'),
(75, 1001, 'Faculty Approved', 'Your proposal \'TestProposal1\' content has been verified and sent to HEPA.', 'STATUS', '/chc/events', 'View', 1, '2026-04-20 00:48:47', 'CHC'),
(76, 1001, 'Faculty Rejected', 'Your proposal \'Bengkel Database\' content has been rejected. View feedback for amendment', 'STATUS', '/chc/events', 'View', 1, '2026-04-20 00:58:22', 'CHC'),
(77, 1001, 'Faculty Rejected', 'Your proposal \'Bengkel C#\' content has been rejected. View feedback for amendment', 'STATUS', '/chc/events', 'View', 1, '2026-04-20 01:01:08', 'CHC'),
(78, 1001, 'New Proposal Submitted', 'A new proposal \'Pertandingan Sumo Robot 2026\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-20 01:09:00', 'Advisor'),
(79, 1001, 'New Proposal for Review', 'Advisor has supported proposal \'Pertandingan Sumo Robot 2026\'. Needs your verification.', 'STATUS', '/faculty/dashboard', 'Review', 1, '2026-04-20 01:10:01', 'Faculty'),
(80, 1001, 'Advisor Supported', 'Your advisor has supported your proposal: Pertandingan Sumo Robot 2026. Now forwarded to Faculty.', 'STATUS', '/chc/events', 'View', 1, '2026-04-20 01:10:01', 'CHC'),
(81, 1001, 'Faculty Rejected', 'Your proposal \'Pertandingan Sumo Robot 2026\' content has been rejected. Feedback: Revise venue, kinda not suitable', 'STATUS', '/chc/events', 'View', 1, '2026-04-20 01:15:33', 'CHC'),
(82, 1002, 'New Proposal Submitted', 'A new proposal \'TEST\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-20 05:06:07', 'Advisor'),
(83, 1002, 'New Proposal for Review', 'Advisor has supported proposal \'TEST\'. Needs your review.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-04-20 05:07:44', 'MPP'),
(84, 1002, 'Advisor Supported', 'Your advisor has supported your proposal: TEST. Now forwarded to MPP.', 'STATUS', '/chc/events', 'View', 1, '2026-04-20 05:07:44', 'CHC'),
(85, 1001, 'New Proposal Submitted', 'A new proposal \'test123\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-20 05:13:04', 'Advisor'),
(86, 1001, 'Academic Proposal: Budget Clearance Needed', 'Faculty has endorsed \'test123\'. Please review the budget.', 'STATUS', '/hepa/dashboard', 'Review', 1, '2026-04-20 05:15:16', 'HEPA'),
(87, 1001, 'Faculty Approved', 'Your proposal \'test123\' content has been verified and sent to HEPA.', 'STATUS', '/chc/events', 'View', 1, '2026-04-20 05:15:16', 'CHC'),
(88, 1002, 'Pitching Scheduled!', 'MPP has scheduled a pitching session for \'TEST\' on null at null.', 'STATUS', '/chc/events', 'View Details', 1, '2026-04-25 04:51:21', 'CHC'),
(89, 1002, 'Pitching Scheduled!', 'MPP has scheduled a pitching session for \'TEST\' on null at null.', 'STATUS', '/chc/events', 'View Details', 1, '2026-04-25 04:56:35', 'CHC'),
(90, 1002, 'Pitching Scheduled!', 'MPP has scheduled a pitching session for \'TEST\' on null at null.', 'STATUS', '/chc/events', 'View Details', 1, '2026-04-25 05:43:43', 'CHC'),
(91, 1002, 'Sesi Pitching Ditetapkan!', 'MPP telah menjadualkan sesi pitching untuk \'TEST\'.\nSila semak pautan: https://meet.google.com/tpn-hqhf-nkq', 'STATUS', '/chc/events', 'Lihat Perincian', 1, '2026-04-25 10:07:25', 'CHC'),
(92, 1002, 'Sesi Pitching Ditetapkan!', 'MPP telah menjadualkan sesi pitching untuk \'TestReject2\'.\nTarikh: 2026-04-28 20:06\nPautan: https://meet.google.com/how-xrnj-qre', 'STATUS', '/chc/events', 'Lihat Perincian', 1, '2026-04-25 11:06:57', 'CHC'),
(93, 1002, 'New Proposal Submitted', 'A new proposal \'Bengkel Asas Internet of Things (IoT) & Raspberry Pi Pico\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-25 15:25:11', 'Advisor'),
(94, 1002, 'New Proposal for Review', 'Advisor has supported proposal \'Bengkel Asas Internet of Things (IoT) & Raspberry Pi Pico\'. Needs your review.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-04-25 15:26:47', 'MPP'),
(95, 1002, 'Advisor Supported', 'Your advisor has supported your proposal: Bengkel Asas Internet of Things (IoT) & Raspberry Pi Pico. Now forwarded to MPP.', 'STATUS', '/chc/events', 'View', 1, '2026-04-25 15:26:47', 'CHC'),
(96, 1002, 'Sesi Pitching Ditetapkan!', 'MPP telah menjadualkan sesi pitching untuk \'Bengkel Asas Internet of Things (IoT) & Raspberry Pi Pico\'.\nTarikh: 2026-04-26 15:00\nPautan: https://meet.google.com/dtv-opmi-aqb', 'STATUS', '/chc/events', 'Lihat Perincian', 1, '2026-04-25 15:27:56', 'CHC'),
(97, 1002, 'New Proposal Submitted', 'A new proposal \'TestAI1\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-26 00:51:38', 'Advisor'),
(98, 1002, 'New Proposal Submitted', 'A new proposal \'TestAI2\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-26 01:02:30', 'Advisor'),
(99, 1002, 'New Proposal Submitted', 'A new proposal \'Bengkel Pembangunan Aplikasi Web & IoT 2026\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-26 01:40:30', 'Advisor'),
(100, 1002, 'Sesi Pitching Ditetapkan!', 'MPP telah menjadualkan sesi pitching untuk \'Bengkel Pembangunan Aplikasi Web & IoT 2026\'.\nTarikh: 2026-04-28 15:34\nPautan: https://meet.google.com/fts-dydy-zqh', 'STATUS', '/chc/events', 'Lihat Perincian', 1, '2026-04-26 05:34:34', 'CHC'),
(101, 1002, 'Sesi Pitching Ditetapkan!', 'MPP telah menjadualkan sesi pitching untuk \'Pertandingan Tilawah Al-Quran\'.\nTarikh: 2026-04-30 14:30\nPautan: https://meet.google.com/whs-qfnu-qzz', 'STATUS', '/chc/events', 'Lihat Perincian', 1, '2026-04-28 14:32:27', 'CHC'),
(102, 1002, 'Proposal Sedia Lulus', 'MPP telah menyokong \'Bengkel Pembangunan Aplikasi Web & IoT 2026\'. Sila beri kelulusan akhir.', 'STATUS', '/hepa/review', 'Endorse', 1, '2026-04-28 14:34:17', 'HEPA'),
(103, 1002, 'Disokong oleh MPP', 'Proposal \'Bengkel Pembangunan Aplikasi Web & IoT 2026\' melepasi semakan MPP dan kini di pihak HEPA.', 'STATUS', '/chc/events', 'Lihat', 1, '2026-04-28 14:34:17', 'CHC'),
(104, 1002, 'New Proposal Submitted', 'A new proposal \'Geng Gegar Masjid\' is waiting for your review.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-04-28 15:30:23', 'Advisor'),
(105, 1002, 'New Proposal for Review', 'Advisor has supported proposal \'Geng Gegar Masjid\'. Needs your review.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-04-28 15:31:39', 'MPP'),
(106, 1002, 'Advisor Supported', 'Your advisor has supported your proposal: Geng Gegar Masjid. Now forwarded to MPP.', 'STATUS', '/chc/events', 'View', 1, '2026-04-28 15:31:39', 'CHC'),
(107, 1002, 'Sesi Pitching Ditetapkan!', 'MPP telah menjadualkan sesi pitching untuk \'Geng Gegar Masjid\'.\nTarikh: 2026-04-28 23:34\nPautan: https://meet.google.com/abc-defg-hij', 'STATUS', '/chc/events', 'Lihat Perincian', 1, '2026-04-28 15:34:28', 'CHC'),
(108, 1002, 'Proposal Sedia Lulus', 'MPP telah menyokong \'Geng Gegar Masjid\'. Sila beri kelulusan akhir.', 'STATUS', '/hepa/endorse', 'Endorse', 1, '2026-04-28 15:35:19', 'HEPA'),
(109, 1002, 'Disokong oleh MPP', 'Proposal \'Geng Gegar Masjid\' melepasi semakan MPP dan kini di pihak HEPA.', 'STATUS', '/chc/events', 'Lihat', 1, '2026-04-28 15:35:19', 'CHC'),
(110, 1002, 'Proposal Officially Endorsed!', 'Congratulations! HEPA has officially endorsed your event proposal.', 'STATUS', '/chc/events', 'View Details', 1, '2026-04-28 15:36:12', 'CHC'),
(111, 1002, 'Proposal Endorsed', 'HEPA has successfully endorsed a proposal you verified.', 'STATUS', '/mpp/proposals', 'View Record', 1, '2026-04-28 15:36:12', 'MPP'),
(112, 1002, 'Sesi Pitching Ditetapkan!', 'MPP telah menjadualkan sesi pitching untuk \'TestAccept2\'.\nTarikh: 2026-04-13 23:39\nPautan: https://meet.google.com/rxw-revc-czt', 'STATUS', '/chc/events', 'Lihat Perincian', 1, '2026-04-28 15:39:16', 'CHC'),
(113, 1002, 'Sesi Pitching Ditetapkan!', 'MPP telah menjadualkan sesi pitching untuk \'TestAccept1\'.\nTarikh: 2026-04-29 14:47\nPautan: https://meet.google.com/irk-pbtj-org', 'STATUS', '/chc/events', 'Lihat Perincian', 1, '2026-04-28 15:47:25', 'CHC'),
(114, 1002, 'New Proposal for Review', 'Advisor has supported proposal \'TestAI1\'. Needs your review.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-04-28 15:55:15', 'MPP'),
(115, 1002, 'Advisor Supported', 'Your advisor has supported your proposal: TestAI1. Now forwarded to MPP.', 'STATUS', '/chc/events', 'View', 1, '2026-04-28 15:55:15', 'CHC'),
(116, 1002, 'Sesi Pitching Ditetapkan!', 'MPP telah menjadualkan sesi pitching untuk \'TestAI2\'.\nTarikh: 2026-05-07 23:59\nPautan: https://meet.google.com/biz-tnsh-tkv', 'STATUS', '/chc/events', 'Lihat Perincian', 1, '2026-04-28 15:59:13', 'CHC'),
(117, 1002, 'AMARAN: Laporan AGM Tertunggak!', 'Sila muat naik laporan Mesyuarat Agung Tahunan (AGM) bagi tahun 2026 dengan segera bagi mengelakkan kelab digantung dari beroperasi.', 'REMINDER', 'common/agm', 'Hantar Sekarang', 1, '2026-04-29 13:05:31', 'All'),
(118, 1002, 'AMARAN: Laporan AGM Tertunggak!', 'Sila muat naik laporan Mesyuarat Agung Tahunan (AGM) bagi tahun 2026 dengan segera bagi mengelakkan kelab digantung dari beroperasi.', 'REMINDER', '/common/agm', 'Hantar Sekarang', 1, '2026-04-29 13:25:59', 'All'),
(119, 1002, 'AMARAN: Laporan AGM Tertunggak!', 'Sila muat naik laporan Mesyuarat Agung Tahunan (AGM) bagi tahun 2026 dengan segera bagi mengelakkan kelab digantung dari beroperasi.', 'REMINDER', '/common/agm', 'Hantar Sekarang', 1, '2026-04-29 13:35:21', 'All'),
(120, 1002, 'AMARAN: Laporan AGM Tertunggak!', 'Sila muat naik laporan Mesyuarat Agung Tahunan (AGM) bagi tahun 2026 dengan segera bagi mengelakkan kelab digantung dari beroperasi.', 'REMINDER', '/common/agm', 'Hantar Sekarang', 1, '2026-04-29 13:50:35', 'All'),
(121, 1002, 'Laporan AGM Baru', 'Satu laporan AGM Tahun 2026 perlu disemak.', 'STATUS', '/mpp/club', 'Semak', 1, '2026-04-29 13:55:21', 'MPP'),
(122, 1002, 'AMARAN: Laporan AGM Tertunggak!', 'Sila muat naik laporan Mesyuarat Agung Tahunan (AGM) bagi tahun 2026 dengan segera bagi mengelakkan kelab digantung dari beroperasi.', 'REMINDER', '/common/agm', 'Hantar Sekarang', 1, '2026-04-29 14:19:18', 'All'),
(123, 1002, 'Laporan AGM Baru', 'Satu laporan AGM Tahun 2026 perlu disemak.', 'STATUS', '/mpp/agm', 'Semak', 1, '2026-04-29 14:19:31', 'MPP'),
(124, 1002, 'Laporan AGM Baru', 'Satu laporan AGM Tahun 2026 perlu disemak.', 'STATUS', '/mpp/agm', 'Semak', 1, '2026-04-29 14:21:36', 'MPP'),
(125, 1002, 'AGM Disokong MPP', 'Laporan AGM 2026-01-01 telah disokong MPP dan dihantar ke HEPA.', 'STATUS', '/mpp/agm', 'Semak', 1, '2026-04-29 14:22:07', 'HEPA'),
(126, 1002, 'Status Laporan AGM Dikemaskini', 'Laporan AGM kelab anda kini berstatus: PENDING_HEPA', 'STATUS', '/common/agm', 'Lihat Status', 1, '2026-04-29 14:22:07', 'CHC'),
(127, 1002, 'Status Laporan AGM Dikemaskini', 'Laporan AGM kelab anda kini berstatus: ACCEPTED', 'STATUS', '/common/agm', 'Lihat Status', 1, '2026-04-29 14:27:56', 'CHC'),
(128, 1002, 'Laporan AGM Baru', 'Satu laporan AGM Tahun 2025 perlu disemak.', 'STATUS', '/mpp/agm', 'Semak', 1, '2026-04-29 14:28:21', 'MPP'),
(129, 1002, 'Status Laporan AGM Dikemaskini', 'Laporan AGM kelab anda kini berstatus: MISSING', 'STATUS', '/common/agm', 'Lihat Status', 1, '2026-04-29 14:28:53', 'CHC'),
(130, 1002, 'Laporan AGM Dikemaskini', 'Kelab telah mengemas kini laporan AGM Tahun 2025', 'STATUS', '/mpp/agm', 'Semak', 1, '2026-04-29 14:30:14', 'MPP'),
(131, 1002, 'AGM Disokong MPP', 'Laporan AGM 2025-01-01 telah disokong MPP dan dihantar ke HEPA.', 'STATUS', '/hepa/agm', 'Semak', 1, '2026-04-29 14:30:37', 'HEPA'),
(132, 1002, 'Status Laporan AGM Dikemaskini', 'Laporan AGM kelab anda kini berstatus: PENDING_HEPA', 'STATUS', '/common/agm', 'Lihat Status', 1, '2026-04-29 14:30:37', 'CHC'),
(133, 1002, 'Status Laporan AGM Dikemaskini', 'Laporan AGM kelab anda kini berstatus: MISSING', 'STATUS', '/common/agm', 'Lihat Status', 1, '2026-04-29 14:31:07', 'CHC'),
(134, 1002, 'AMARAN: Laporan AGM Tertunggak!', 'Sila muat naik laporan Mesyuarat Agung Tahunan (AGM) bagi tahun 2026 segera.', 'REMINDER', '/common/agm', 'Hantar Sekarang', 1, '2026-04-29 14:31:12', 'CHC'),
(135, 1002, 'AMARAN: Laporan AGM Tertunggak!', 'Sila muat naik laporan Mesyuarat Agung Tahunan (AGM) bagi tahun 2026 segera.', 'REMINDER', '/common/agm', 'Hantar Sekarang', 1, '2026-04-29 14:31:13', 'CHC'),
(136, 1002, 'AMARAN: Laporan AGM Tertunggak!', 'Sila muat naik laporan Mesyuarat Agung Tahunan (AGM) bagi tahun 2026 segera.', 'REMINDER', '/common/agm', 'Hantar Sekarang', 1, '2026-04-29 14:31:13', 'CHC'),
(137, 1002, 'AMARAN: Laporan AGM Tertunggak!', 'Sila muat naik laporan Mesyuarat Agung Tahunan (AGM) bagi tahun 2026 segera.', 'REMINDER', '/common/agm', 'Hantar Sekarang', 1, '2026-04-29 14:31:14', 'CHC'),
(138, 1002, 'AMARAN: Laporan AGM Tertunggak!', 'Sila muat naik laporan Mesyuarat Agung Tahunan (AGM) bagi tahun 2026 segera.', 'REMINDER', '/common/agm', 'Hantar Sekarang', 1, '2026-04-29 14:31:14', 'CHC'),
(139, 1002, 'AMARAN: Laporan AGM Tertunggak!', 'Sila muat naik laporan Mesyuarat Agung Tahunan (AGM) bagi tahun 2026 segera.', 'REMINDER', '/common/agm', 'Hantar Sekarang', 1, '2026-04-29 14:31:14', 'CHC'),
(140, 1002, 'AMARAN: Laporan AGM Tertunggak!', 'Sila muat naik laporan Mesyuarat Agung Tahunan (AGM) bagi tahun 2026 segera.', 'REMINDER', '/common/agm', 'Hantar Sekarang', 1, '2026-04-29 14:31:14', 'CHC'),
(141, 1002, 'AMARAN: Laporan AGM Tertunggak!', 'Sila muat naik laporan Mesyuarat Agung Tahunan (AGM) bagi tahun 2026 segera.', 'REMINDER', '/common/agm', 'Hantar Sekarang', 1, '2026-04-29 14:31:17', 'CHC'),
(142, 1002, 'Laporan AGM Dikemaskini', 'Kelab telah mengemas kini laporan AGM Tahun 2025', 'STATUS', '/mpp/agm', 'Semak', 1, '2026-04-29 15:00:46', 'MPP'),
(143, 1002, 'Status Laporan AGM Dikemaskini', 'Laporan AGM kelab anda kini berstatus: MISSING', 'STATUS', '/common/agm', 'Lihat Status', 1, '2026-04-29 15:07:32', 'CHC'),
(144, 1002, 'Semakan AGM Diperlukan', 'Kelab ID 1002 telah menghantar laporan AGM tahun 2025', 'STATUS', '/mpp/agm', 'Semak Sekarang', 1, '2026-04-29 15:10:55', 'MPP'),
(145, 1002, 'AGM Disokong MPP', 'Laporan AGM 2025-01-01 dihantar ke HEPA.', 'STATUS', '/mpp/agm', 'Semak', 1, '2026-04-29 15:11:23', 'HEPA'),
(146, 1002, 'Status Laporan AGM Dikemaskini', 'Laporan AGM kelab anda kini berstatus: PENDING_HEPA', 'STATUS', '/common/agm', 'Lihat Status', 1, '2026-04-29 15:11:23', 'CHC'),
(147, 1002, 'Status Laporan AGM Dikemaskini', 'Laporan AGM kelab anda kini berstatus: ACCEPTED', 'STATUS', '/common/agm', 'Lihat Status', 1, '2026-04-29 15:12:10', 'CHC'),
(148, 1002, 'Semakan AGM Diperlukan', 'Kelab ID 1002 telah menghantar laporan AGM tahun 2024', 'STATUS', '/mpp/agm', 'Semak Sekarang', 1, '2026-04-29 20:27:41', 'MPP'),
(149, 1002, 'Semakan AGM Diperlukan', 'Kelab ID 1002 telah menghantar laporan AGM tahun 2024', 'STATUS', '/mpp/agm', 'Semak Sekarang', 1, '2026-04-29 20:32:07', 'MPP'),
(150, 1002, 'AGM Disokong MPP', 'Laporan AGM 2024-01-01 dihantar ke HEPA.', 'STATUS', '/mpp/agm', 'Semak', 1, '2026-04-29 20:32:43', 'HEPA'),
(151, 1002, 'Semakan AGM Diperlukan', 'Kelab ID 1002 telah menghantar laporan AGM tahun 2024', 'STATUS', '/mpp/agm', 'Semak Sekarang', 1, '2026-04-29 20:40:24', 'MPP'),
(152, 1002, 'AGM Endorsed by MPP', 'AGM Report 2024-01-01 endorsed by MPP. Pending your final approval.', 'STATUS', '/hepa/agm', 'Review', 1, '2026-04-29 20:42:07', 'HEPA'),
(153, 1002, 'AGM Endorsed by MPP', 'AGM Report 2024-01-01 has been endorsed by MPP and is awaiting HEPA approval.', 'STATUS', '/common/agm', 'View Status', 1, '2026-04-29 20:42:07', 'CHC'),
(154, 1002, 'AGM Approved by HEPA', 'AGM Report 2024-01-01 has been officially approved.', 'STATUS', '/common/agm', 'View', 1, '2026-04-29 20:43:13', 'CHC'),
(155, 1002, 'AGM Approved by HEPA', 'AGM Report 2025-01-01 has been officially approved.', 'STATUS', '/common/agm', 'View', 1, '2026-04-29 20:45:14', 'CHC'),
(156, 1002, 'New Proposal Submitted', 'A new proposal \'TestProgram1\' is waiting for your review.', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-04-29 21:03:39', 'Advisor'),
(157, 1002, 'New Proposal Submitted', 'A new proposal \'Program Test 1\' is waiting for your review.', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-04-30 02:51:18', 'Advisor'),
(158, 1002, 'New Proposal for Review', 'Advisor has supported proposal \'Program Test 1\'. Needs your review.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-04-30 02:54:21', 'MPP'),
(159, 1002, 'Advisor Supported', 'Your advisor has supported your proposal: Program Test 1. Now forwarded to MPP.', 'STATUS', '/chc/events', 'View', 1, '2026-04-30 02:54:21', 'CHC'),
(160, 1002, 'Sesi Pitching Ditetapkan!', 'MPP telah menjadualkan sesi pitching untuk \'Program Test 1\'.\nTarikh: 2026-05-07 10:55\nPautan: https://meet.google.com/nci-ektf-krp', 'STATUS', '/chc/events', 'Lihat Perincian', 1, '2026-04-30 02:55:58', 'CHC'),
(161, 1002, 'Sesi Pitching Ditetapkan!', 'MPP telah menjadualkan sesi pitching untuk \'Program Test 1\'.\nTarikh: 2026-05-07 10:55\nPautan: https://meet.google.com/zps-idrp-qna', 'STATUS', '/chc/events', 'Lihat Perincian', 1, '2026-04-30 02:55:59', 'CHC'),
(162, 1002, 'Kertas Kerja Ditolak', 'MPP telah menolak proposal \'Program Test 1\'.', 'STATUS', '/chc/events', 'Lihat Ulasan', 1, '2026-04-30 03:00:42', 'CHC'),
(163, 1002, 'Kertas Kerja Ditolak', 'MPP telah menolak proposal \'Program Test 1\'.', 'STATUS', '/chc/events', 'Lihat Ulasan', 1, '2026-04-30 03:00:42', 'CHC'),
(164, 1001, 'New Proposal Submitted', 'A new proposal \'Bengkel Coding 2026\' is waiting for your review.', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-04-30 03:14:24', 'Advisor'),
(165, 1001, 'New Proposal for Review', 'Advisor has supported proposal \'Bengkel Coding 2026\'. Needs your verification.', 'STATUS', '/faculty/dashboard', 'Review', 1, '2026-04-30 03:18:45', 'Faculty'),
(166, 1001, 'Advisor Supported', 'Your advisor has supported your proposal: Bengkel Coding 2026. Now forwarded to Faculty.', 'STATUS', '/chc/events', 'View', 1, '2026-04-30 03:18:45', 'CHC'),
(167, 1001, 'Academic Proposal: Budget Clearance Needed', 'Faculty has endorsed \'Bengkel Coding 2026\'. Please review the budget.', 'STATUS', '/hepa/endorse', 'Review', 1, '2026-04-30 03:21:26', 'HEPA'),
(168, 1001, 'Faculty Approved', 'Your proposal \'Bengkel Coding 2026\' content has been verified and sent to HEPA.', 'STATUS', '/chc/events', 'View', 1, '2026-04-30 03:21:26', 'CHC'),
(169, 10000, 'New Proposal Submitted', 'A new proposal \'1v1 Franco Tournament 2026\' is waiting for your review.', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-04-30 09:23:02', 'Advisor'),
(170, 10000, 'Proposal Rejected', 'Your Advisor has rejected your proposal: 1v1 Franco Tournament 2026. Check advisor remarks for guidance.', 'STATUS', '/chc/events', 'View Remarks', 1, '2026-04-30 09:28:42', 'CHC'),
(171, 10000, 'New Proposal Submitted', 'A new proposal \'1v1 Franco Tournament 2026\' is waiting for your review.', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-04-30 09:30:50', 'Advisor'),
(172, 1001, 'New Proposal Submitted', 'A new proposal \'Comtech Annual Dinner\' is waiting for your review.', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-04-30 10:01:15', 'Advisor'),
(173, 1001, 'New Proposal for Review', 'Advisor has supported proposal \'Comtech Annual Dinner\'. Needs your verification.', 'STATUS', '/faculty/dashboard', 'Review', 1, '2026-04-30 10:02:05', 'Faculty'),
(174, 1001, 'Advisor Supported', 'Your advisor has supported your proposal: Comtech Annual Dinner. Now forwarded to Faculty.', 'STATUS', '/chc/events', 'View', 1, '2026-04-30 10:02:05', 'CHC'),
(175, 1001, 'Academic Proposal: Budget Clearance Needed', 'Faculty has endorsed \'Comtech Annual Dinner\'. Please review the budget.', 'STATUS', '/hepa/endorse', 'Review', 1, '2026-04-30 10:05:48', 'HEPA'),
(176, 1001, 'Faculty Approved', 'Your proposal \'Comtech Annual Dinner\' content has been verified and sent to HEPA.', 'STATUS', '/chc/events', 'View', 1, '2026-04-30 10:05:48', 'CHC'),
(177, 1002, 'New Proposal Submitted', 'A new proposal \'EventTest1.1\' is waiting for your review.', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-05-19 15:50:04', 'Advisor'),
(178, 1002, 'New Proposal for Review', 'Advisor has supported proposal \'EventTest1.1\'. Needs your review.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-05-19 16:00:17', 'MPP'),
(179, 1002, 'Advisor Supported', 'Your advisor has supported your proposal: EventTest1.1. Now forwarded to MPP.', 'STATUS', '/chc/events', 'View', 1, '2026-05-19 16:00:17', 'CHC'),
(180, 1002, 'New Proposal Submitted', 'A new proposal \'Pertandingan Azan Peringkat Kebangsaan 2026\' is waiting for your review.', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-02 08:33:09', 'Advisor'),
(181, 1002, 'New Proposal for Review', 'Advisor has supported proposal \'Pertandingan Azan Peringkat Kebangsaan 2026\'. Needs your review.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-06-02 08:36:41', 'MPP'),
(182, 1002, 'Advisor Supported', 'Your advisor has supported your proposal: Pertandingan Azan Peringkat Kebangsaan 2026. Now forwarded to MPP.', 'STATUS', '/chc/events', 'View', 1, '2026-06-02 08:36:41', 'CHC'),
(183, 1002, 'Proposal Rejected', 'Your Advisor has rejected your proposal: Pertandingan Azan Peringkat Kebangsaan 2026. Check advisor remarks for guidance.', 'STATUS', '/chc/events', 'View Remarks', 1, '2026-06-02 08:38:42', 'CHC'),
(184, 1002, 'New Proposal Submitted', 'A new proposal \'Pertandingan Azan Peringkat Kebangsaan 2026\' is waiting for your review.', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-02 09:01:18', 'Advisor'),
(185, 1002, 'Proposal Rejected', 'Your Advisor has rejected your proposal: Pertandingan Azan Peringkat Kebangsaan 2026. Check advisor remarks for guidance.', 'STATUS', '/chc/events', 'View Remarks', 1, '2026-06-02 09:19:59', 'CHC'),
(186, 1002, 'New Proposal Submitted', 'A new proposal \'Pertandingan Azan Peringkat Kebangsaan 2026\' is waiting for your review.', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-02 09:20:19', 'Advisor'),
(187, 1002, 'New Proposal for Review', 'Advisor has supported proposal \'Pertandingan Azan Peringkat Kebangsaan 2026\'. Needs your review.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-06-02 09:20:49', 'MPP'),
(188, 1002, 'Advisor Supported', 'Your advisor has supported your proposal: Pertandingan Azan Peringkat Kebangsaan 2026. Now forwarded to MPP.', 'STATUS', '/chc/events', 'View', 1, '2026-06-02 09:20:49', 'CHC'),
(189, 1002, 'Kertas Kerja Ditolak', 'MPP telah menolak proposal \'Pertandingan Azan Peringkat Kebangsaan 2026\'. Sila semak ulasan.', 'STATUS', '/chc/events', 'Lihat Ulasan', 1, '2026-06-03 01:02:30', 'CHC'),
(190, 1002, 'New Proposal Submitted', 'A new proposal \'Solat Hajat Perdana sempena Maal Hijrah\' is waiting for your review.', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-04 01:50:06', 'Advisor'),
(191, 1002, 'New Proposal for Review', 'Advisor has supported proposal \'Solat Hajat Perdana sempena Maal Hijrah\'. Needs your review.', 'STATUS', '/mpp/proposals', 'Review', 1, '2026-06-04 01:52:37', 'MPP'),
(192, 1002, 'Advisor Supported', 'Your advisor has supported your proposal: Solat Hajat Perdana sempena Maal Hijrah. Now forwarded to MPP.', 'STATUS', '/chc/events', 'View', 1, '2026-06-04 01:52:37', 'CHC'),
(193, 1002, 'Proposal Sedia Lulus', 'MPP telah menyokong \'Solat Hajat Perdana sempena Maal Hijrah\'. Sila beri kelulusan akhir.', 'STATUS', '/hepa/endorse', 'Endorse', 1, '2026-06-04 03:12:34', 'HEPA'),
(194, 1002, 'Disokong oleh MPP', 'Proposal \'Solat Hajat Perdana sempena Maal Hijrah\' melepasi semakan MPP dan kini di pihak HEPA.', 'STATUS', '/chc/events', 'Lihat', 1, '2026-06-04 03:12:34', 'CHC'),
(195, 1002, 'Proposal Supported', 'Your advisor has supported the proposal and forwarded it to MPP.', 'STATUS', '/chc/track?id=60', 'Track Status', 1, '2026-06-04 06:53:53', 'CHC'),
(196, 1002, 'Pending MPP Review', 'A new proposal is awaiting your review.', 'STATUS', '/mpp/proposals', 'Review Now', 1, '2026-06-04 06:53:53', 'MPP'),
(197, 1002, 'New Proposal Submitted', 'A new proposal \'Program_Example_1\' requires your review.', 'STATUS', '/advisor/proposals', 'Review Now', 1, '2026-06-04 13:18:06', 'Advisor'),
(198, 1002, 'Proposal Submitted', 'Your proposal \'Program_Example_1\' has been sent to the Advisor.', 'STATUS', '/chc/track?id=62', 'Track Status', 1, '2026-06-04 13:18:06', 'CHC'),
(199, 1002, 'New Proposal Submitted', 'A new proposal \'Program Kenali Iman 2026\' requires your review.', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-04 13:30:38', 'Advisor'),
(200, 1002, 'Proposal Submitted', 'Your proposal \'Program Kenali Iman 2026\' has been sent to the Advisor.', 'STATUS', '/chc/track?id=63', 'Track Status', 1, '2026-06-04 13:30:38', 'CHC'),
(201, 1002, 'Proposal Requires Amendment', 'Your proposal was returned by Club Advisor.', 'STATUS', '/chc/track?id=63', 'View Feedback', 1, '2026-06-04 13:44:14', 'CHC'),
(202, 1002, 'New Proposal Submitted', 'A new proposal \'Program Kenali Iman 2026\' requires your review.', 'STATUS', '/advisor/proposals', 'Review Now', 1, '2026-06-04 13:49:06', 'Advisor'),
(203, 1002, 'Proposal Submitted', 'Your proposal \'Program Kenali Iman 2026\' has been sent to the Advisor.', 'STATUS', '/chc/track?id=63', 'Track Status', 1, '2026-06-04 13:49:06', 'CHC'),
(204, 1002, 'New Proposal Submitted', 'A new proposal \'aaaa\' requires your review.', 'STATUS', '/advisor/proposals', 'Review Now', 1, '2026-06-04 13:53:31', 'Advisor'),
(205, 1002, 'Proposal Submitted', 'Your proposal \'aaaa\' has been sent to the Advisor.', 'STATUS', '/chc/track?id=64', 'Track Status', 1, '2026-06-04 13:53:31', 'CHC'),
(206, 1002, 'New Proposal Submitted', 'A new proposal \'bbbbb\' requires your review.', 'STATUS', '/advisor/proposals', 'Review Now', 1, '2026-06-04 14:01:54', 'Advisor'),
(207, 1002, 'Proposal Submitted', 'Your proposal \'bbbbb\' has been sent to the Advisor.', 'STATUS', '/chc/track?id=65', 'Track Status', 1, '2026-06-04 14:01:54', 'CHC'),
(208, 1002, 'Proposal Requires Amendment', 'Your proposal was returned by Club Advisor.', 'STATUS', '/chc/track?id=65', 'View Feedback', 1, '2026-06-04 14:02:59', 'CHC'),
(209, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: cccc', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-04 15:21:05', 'Advisor'),
(210, 1002, 'Proposal Submitted', 'Kertas kerja anda \'cccc\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=66', 'Track Status', 1, '2026-06-04 15:21:05', 'CHC'),
(211, 1002, 'Proposal Requires Amendment', 'Kertas kerja \'cccc\' telah dikembalikan oleh Club Advisor.\nUlasan: betulkan bajet', 'STATUS', '/chc/track?id=66', 'View Feedback', 1, '2026-06-04 15:25:47', 'CHC'),
(212, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: dddddd', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-04 15:52:04', 'Advisor'),
(213, 1002, 'Proposal Submitted', 'Kertas kerja anda \'dddddd\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=67', 'Track Status', 1, '2026-06-04 15:52:04', 'CHC'),
(214, 1002, 'Proposal Requires Amendment', 'Kertas kerja \'dddddd\' telah dikembalikan oleh Club Advisor.\nUlasan: bad', 'STATUS', '/chc/track?id=67', 'View Feedback', 1, '2026-06-04 15:53:18', 'CHC'),
(215, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: dddddd', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-04 15:54:26', 'Advisor'),
(216, 1002, 'Proposal Submitted', 'Kertas kerja anda \'dddddd\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=67', 'Track Status', 1, '2026-06-04 15:54:26', 'CHC'),
(217, 1002, 'Proposal Supported', 'Berita baik! Penasihat anda telah menyokong kertas kerja: dddddd. Ia kini dipanjangkan kepada MPP untuk semakan.', 'STATUS', '/chc/track?id=67', 'Track Status', 1, '2026-06-04 15:56:31', 'CHC'),
(218, 1002, 'Pending MPP Review', 'Satu kertas kerja baharu memerlukan semakan anda.', 'STATUS', '/mpp/proposals', 'Review Now', 1, '2026-06-04 15:56:31', 'MPP'),
(219, 1002, 'Pitching Scheduled', 'Sesi pembentangan (Pitching) bagi kertas kerja \'dddddd\' telah dijadualkan pada: 2026-06-16 00:33', 'STATUS', '/chc/track?id=67', 'View Link', 1, '2026-06-04 16:33:16', 'CHC'),
(220, 1002, 'Bajet Proposal Diubah', 'MPP telah menyunting jadual bajet untuk \'dddddd\'. Jumlah Baru: RM 210.00\nSebab: null', 'STATUS', '/chc/track?id=67', 'Semak Perubahan', 1, '2026-06-04 16:46:31', 'CHC'),
(221, 1002, 'MPP Endorsed', 'Tahniah! MPP telah memperakui kertas kerja \'dddddd\'. Ia kini menunggu kelulusan akhir daripada pihak HEPA.', 'STATUS', '/chc/track?id=67', 'Track Status', 1, '2026-06-04 16:46:43', 'CHC'),
(222, 1002, 'Pending HEPA Approval', 'Satu kertas kerja sedang menunggu kelulusan akhir.', 'STATUS', '/hepa/proposals', 'Review Now', 1, '2026-06-04 16:46:43', 'HEPA'),
(223, 1001, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: aaaa', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-05 01:22:21', 'Advisor'),
(224, 1001, 'Proposal Submitted', 'Kertas kerja anda \'aaaa\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=68', 'Track Status', 1, '2026-06-05 01:22:21', 'CHC'),
(225, 1001, 'Proposal Supported', 'Berita baik! Penasihat anda telah menyokong kertas kerja: aaaa. Ia kini dipanjangkan kepada Faculty untuk semakan.', 'STATUS', '/chc/track?id=68', 'Track Status', 1, '2026-06-05 01:26:13', 'CHC'),
(226, 1001, 'Pending Faculty Review', 'Satu kertas kerja baharu memerlukan semakan anda.', 'STATUS', '/faculty/dashboard', 'Review Now', 1, '2026-06-05 01:26:13', 'Faculty'),
(227, 1001, 'Bajet Proposal Diubah', 'MPP telah menyunting jadual bajet untuk \'aaaa\'. Jumlah Baru: RM 108.00\nSebab: Added food', 'STATUS', '/chc/track?id=68', 'Semak Perubahan', 1, '2026-06-05 01:52:50', 'CHC'),
(228, 1001, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: bbbbb', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-05 02:04:18', 'Advisor'),
(229, 1001, 'Proposal Submitted', 'Kertas kerja anda \'bbbbb\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=69', 'Track Status', 1, '2026-06-05 02:04:18', 'CHC'),
(230, 1001, 'Proposal Supported', 'Berita baik! Penasihat anda telah menyokong kertas kerja: bbbbb. Ia kini dipanjangkan kepada Faculty untuk semakan.', 'STATUS', '/chc/track?id=69', 'Track Status', 1, '2026-06-05 02:05:48', 'CHC'),
(231, 1001, 'Pending Faculty Review', 'Satu kertas kerja baharu memerlukan semakan anda.', 'STATUS', '/faculty/dashboard', 'Review Now', 1, '2026-06-05 02:05:48', 'Faculty'),
(232, 1001, 'Bajet Proposal Diubah', 'MPP telah menyunting jadual bajet untuk \'bbbbb\'. Jumlah Baru: RM 10.05\nSebab: naikkan budget maknan', 'STATUS', '/chc/track?id=69', 'Semak Perubahan', 1, '2026-06-05 02:06:49', 'CHC'),
(233, 1001, 'Bajet Proposal Diubah', 'MPP telah menyunting jadual bajet untuk \'bbbbb\'. Jumlah Baru: RM 10.10\nSebab: sss', 'STATUS', '/chc/track?id=69', 'Semak Perubahan', 1, '2026-06-05 02:08:37', 'CHC'),
(234, 1001, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: cccccc', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-05 02:21:39', 'Advisor'),
(235, 1001, 'Proposal Submitted', 'Kertas kerja anda \'cccccc\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=70', 'Track Status', 1, '2026-06-05 02:21:39', 'CHC'),
(236, 1001, 'Proposal Supported', 'Berita baik! Penasihat anda telah menyokong kertas kerja: cccccc. Ia kini dipanjangkan kepada Faculty untuk semakan.', 'STATUS', '/chc/track?id=70', 'Track Status', 1, '2026-06-05 02:22:32', 'CHC'),
(237, 1001, 'Pending Faculty Review', 'Satu kertas kerja baharu memerlukan semakan anda.', 'STATUS', '/faculty/dashboard', 'Review Now', 1, '2026-06-05 02:22:32', 'Faculty'),
(238, 1001, 'Bajet Diubah oleh Fakulti', 'Fakulti telah menyemak dan menukar bajet untuk \'cccccc\'. Sila rujuk paparan kertas kerja.', 'STATUS', '/chc/track?id=70', 'Semak', 1, '2026-06-05 02:24:03', 'CHC'),
(239, 1001, 'Kertas Kerja Diluluskan!', 'Tahniah! Fakulti telah meluluskan sepenuhnya kertas kerja \'cccccc\'.', 'STATUS', '/chc/track?id=70', 'Lihat', 1, '2026-06-05 02:24:57', 'CHC'),
(240, 1001, 'Kertas Kerja Kelab Diluluskan', 'Fakulti telah meluluskan kertas kerja kelab seliaan anda: \'cccccc\'.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-06-05 02:24:57', 'Advisor'),
(241, 1001, 'Fakulti Endorsed', 'Tahniah! Fakulti telah memperakui kertas kerja \'Bengkel C#\'. Ia kini menunggu kelulusan akhir daripada pihak HEPA.', 'STATUS', '/chc/track?id=39', 'Track Status', 1, '2026-06-05 03:09:48', 'CHC'),
(242, 1001, 'Pending HEPA Approval', 'Satu kertas kerja Akademik sedang menunggu kelulusan akhir.', 'STATUS', '/hepa/proposals', 'Review Now', 1, '2026-06-05 03:09:48', 'HEPA'),
(243, 1002, 'MPP Endorsed', 'Tahniah! MPP telah memperakui kertas kerja \'Bengkel Asas Internet of Things (IoT) & Raspberry Pi Pico\'. Ia kini menunggu kelulusan akhir daripada pihak HEPA.', 'STATUS', '/chc/track?id=47', 'Track Status', 1, '2026-06-05 03:19:32', 'CHC'),
(244, 1002, 'Pending HEPA Approval', 'Satu kertas kerja sedang menunggu kelulusan akhir.', 'STATUS', '/hepa/proposals', 'Review Now', 1, '2026-06-05 03:19:32', 'HEPA'),
(245, 1002, 'Semakan Bajet HEPA', 'Pihak HEPA telah mengubah bajet untuk \'Bengkel Asas Internet of Things (IoT) & Raspberry Pi Pico\' sebelum kelulusan.', 'STATUS', '/chc/track?id=47', 'Semak', 1, '2026-06-05 03:21:27', 'CHC'),
(246, 1002, 'Proposal Requires Amendment', 'Kertas kerja \'Bengkel Asas Internet of Things (IoT) & Raspberry Pi Pico\' telah dikembalikan oleh HEPA.\nUlasan: bad', 'STATUS', '/chc/track?id=47', 'View Feedback', 1, '2026-06-05 03:22:13', 'CHC'),
(247, 1002, 'Kertas Kerja Diluluskan Penuh!', 'Tahniah! Kertas kerja \'Solat Hajat Perdana sempena Maal Hijrah\' telah mendapat kelulusan akhir HEPA. Anda boleh muat turun Surat Kelulusan sekarang.', 'STATUS', '/chc/track?id=59', 'Lihat', 1, '2026-06-05 03:22:56', 'CHC'),
(248, 1002, 'Kelulusan Akhir HEPA', 'Kertas kerja kelab seliaan anda: \'Solat Hajat Perdana sempena Maal Hijrah\' telah diluluskan sepenuhnya oleh pihak HEPA.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-06-05 03:22:56', 'Advisor'),
(249, 1002, 'Bajet Proposal Diubah', 'MPP telah menyunting jadual bajet untuk \'Kursus Ibadah Korban\'. Jumlah Baru: RM 710.00\nSebab: null', 'STATUS', '/chc/track?id=60', 'Semak Perubahan', 1, '2026-06-05 03:30:58', 'CHC'),
(250, 1002, 'MPP Endorsed', 'Tahniah! MPP telah memperakui kertas kerja \'Kursus Ibadah Korban\'. Ia kini menunggu kelulusan akhir daripada pihak HEPA.', 'STATUS', '/chc/track?id=60', 'Track Status', 1, '2026-06-05 03:31:25', 'CHC'),
(251, 1002, 'Pending HEPA Approval', 'Satu kertas kerja sedang menunggu kelulusan akhir.', 'STATUS', '/hepa/proposals', 'Review Now', 1, '2026-06-05 03:31:25', 'HEPA'),
(252, 1002, 'Semakan Bajet HEPA', 'Pihak HEPA telah mengubah bajet untuk \'Kursus Ibadah Korban\' sebelum kelulusan.', 'STATUS', '/chc/track?id=60', 'Semak', 1, '2026-06-05 03:32:46', 'CHC'),
(253, 1002, 'Kertas Kerja Diluluskan Penuh!', 'Tahniah! Kertas kerja \'Kursus Ibadah Korban\' telah mendapat kelulusan akhir HEPA. Anda boleh muat turun Surat Kelulusan sekarang.', 'STATUS', '/chc/track?id=60', 'Lihat', 1, '2026-06-05 03:32:56', 'CHC'),
(254, 1002, 'Kelulusan Akhir HEPA', 'Kertas kerja kelab seliaan anda: \'Kursus Ibadah Korban\' telah diluluskan sepenuhnya oleh pihak HEPA.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-06-05 03:32:56', 'Advisor'),
(255, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: rrrr', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-05 08:36:50', 'Advisor'),
(256, 1002, 'Proposal Submitted', 'Kertas kerja anda \'rrrr\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=71', 'Track Status', 1, '2026-06-05 08:36:50', 'CHC'),
(257, 1002, 'Proposal Supported', 'Penasihat telah menyokong kertas kerja: rrrr', 'STATUS', '/chc/track?id=71', 'Track Status', 1, '2026-06-05 08:37:38', 'CHC'),
(258, 1002, 'Pending MPP Review', 'Satu kertas kerja baharu memerlukan semakan anda.', 'STATUS', '/mpp/proposals', 'Review Now', 1, '2026-06-05 08:37:39', 'MPP'),
(259, 1002, 'Bajet Proposal Diubah', 'MPP telah menyunting jadual bajet untuk \'rrrr\'.', 'STATUS', '/chc/track?id=71', 'Semak', 1, '2026-06-05 08:38:27', 'CHC'),
(260, 1002, 'MPP Endorsed', 'MPP telah memperakui kertas kerja. Menunggu kelulusan HEPA.', 'STATUS', '/chc/track?id=71', 'Track Status', 1, '2026-06-05 08:38:46', 'CHC'),
(261, 1002, 'Pending HEPA Approval', 'Satu kertas kerja baharu menunggu kelulusan akhir.', 'STATUS', '/hepa/review?id=71', 'Review Now', 1, '2026-06-05 08:38:46', 'HEPA'),
(262, 1002, 'Semakan Bajet HEPA', 'Pihak HEPA telah mengubah bajet untuk \'rrrr\'.', 'STATUS', '/chc/track?id=71', 'Semak', 1, '2026-06-05 08:41:57', 'CHC'),
(263, 1002, 'Kertas Kerja Diluluskan Penuh!', 'Tahniah! Kertas kerja \'rrrr\' diluluskan akhir oleh HEPA.', 'STATUS', '/chc/track?id=71', 'Lihat', 1, '2026-06-05 08:42:11', 'CHC'),
(264, 1002, 'Kelulusan Akhir HEPA', 'Kertas kerja kelab seliaan anda telah diluluskan sepenuhnya.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-06-05 08:42:11', 'Advisor'),
(265, 1002, 'Bajet Proposal Diubah', 'MPP telah menyunting jadual bajet untuk \'EventTest1.1\'.', 'STATUS', '/chc/track?id=57', 'Semak', 1, '2026-06-05 08:59:17', 'CHC'),
(266, 1002, 'MPP Endorsed', 'MPP telah memperakui kertas kerja. Menunggu kelulusan HEPA.', 'STATUS', '/chc/track?id=57', 'Track Status', 1, '2026-06-05 08:59:39', 'CHC'),
(267, 1002, 'Pending HEPA Approval', 'Satu kertas kerja baharu menunggu kelulusan akhir.', 'STATUS', '/hepa/review?id=57', 'Review Now', 1, '2026-06-05 08:59:39', 'HEPA');
INSERT INTO `notifications` (`notificationId`, `clubId`, `title`, `message`, `type`, `actionLink`, `actionLabel`, `isRead`, `createdAt`, `targetRole`) VALUES
(268, 1002, 'Semakan Bajet HEPA', 'Pihak HEPA telah mengubah bajet untuk \'EventTest1.1\'.', 'STATUS', '/chc/track?id=57', 'Semak', 1, '2026-06-05 09:00:44', 'CHC'),
(269, 1002, 'Kertas Kerja Diluluskan Penuh!', 'Tahniah! Kertas kerja \'EventTest1.1\' diluluskan akhir oleh HEPA.', 'STATUS', '/chc/track?id=57', 'Lihat', 1, '2026-06-05 09:00:49', 'CHC'),
(270, 1002, 'Kelulusan Akhir HEPA', 'Kertas kerja kelab seliaan anda telah diluluskan sepenuhnya.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-06-05 09:00:49', 'Advisor'),
(271, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: qqqq', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-05 09:23:14', 'Advisor'),
(272, 1002, 'Proposal Submitted', 'Kertas kerja anda \'qqqq\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=72', 'Track Status', 1, '2026-06-05 09:23:14', 'CHC'),
(273, 1002, 'Proposal Supported', 'Penasihat telah menyokong kertas kerja: qqqq', 'STATUS', '/chc/track?id=72', 'Track Status', 1, '2026-06-05 09:24:39', 'CHC'),
(274, 1002, 'Pending MPP Review', 'Satu kertas kerja baharu memerlukan semakan anda.', 'STATUS', '/mpp/proposals', 'Review Now', 1, '2026-06-05 09:24:39', 'MPP'),
(275, 1002, 'Bajet Proposal Diubah', 'MPP telah menyunting jadual bajet untuk \'qqqq\'.', 'STATUS', '/chc/track?id=72', 'Semak', 1, '2026-06-05 09:26:06', 'CHC'),
(276, 1002, 'MPP Endorsed', 'MPP telah memperakui kertas kerja. Menunggu kelulusan HEPA.', 'STATUS', '/chc/track?id=72', 'Track Status', 1, '2026-06-05 09:26:26', 'CHC'),
(277, 1002, 'Pending HEPA Approval', 'Satu kertas kerja baharu menunggu kelulusan akhir.', 'STATUS', '/hepa/review?id=72', 'Review Now', 1, '2026-06-05 09:26:27', 'HEPA'),
(278, 1002, 'Semakan Bajet HEPA', 'Pihak HEPA telah mengubah bajet untuk \'qqqq\'.', 'STATUS', '/chc/track?id=72', 'Semak', 1, '2026-06-05 09:27:51', 'CHC'),
(279, 1002, 'Kertas Kerja Diluluskan Penuh!', 'Tahniah! Kertas kerja \'qqqq\' diluluskan akhir oleh HEPA.', 'STATUS', '/chc/track?id=72', 'Lihat', 1, '2026-06-05 09:27:55', 'CHC'),
(280, 1002, 'Kelulusan Akhir HEPA', 'Kertas kerja kelab seliaan anda telah diluluskan sepenuhnya.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-06-05 09:27:55', 'Advisor'),
(281, 1001, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: ppppppp', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-05 09:44:29', 'Advisor'),
(282, 1001, 'Proposal Submitted', 'Kertas kerja anda \'ppppppp\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=73', 'Track Status', 1, '2026-06-05 09:44:29', 'CHC'),
(283, 1001, 'Proposal Supported', 'Penasihat telah menyokong kertas kerja: ppppppp', 'STATUS', '/chc/track?id=73', 'Track Status', 1, '2026-06-05 09:45:39', 'CHC'),
(284, 1001, 'Pending Faculty Review', 'Satu kertas kerja baharu memerlukan semakan anda.', 'STATUS', '/faculty/dashboard', 'Review Now', 1, '2026-06-05 09:45:39', 'Faculty'),
(285, 1001, 'Bajet Diubah oleh Fakulti', 'Fakulti telah menukar bajet untuk \'ppppppp\'.', 'STATUS', '/chc/track?id=73', 'Semak', 1, '2026-06-05 09:47:04', 'CHC'),
(286, 1001, 'Kertas Kerja Diluluskan!', 'Tahniah! Fakulti telah meluluskan sepenuhnya kertas kerja \'ppppppp\'.', 'STATUS', '/chc/track?id=73', 'Lihat', 1, '2026-06-05 09:47:09', 'CHC'),
(287, 1001, 'Kertas Kerja Kelab Diluluskan', 'Fakulti telah meluluskan kertas kerja kelab seliaan anda.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-06-05 09:47:09', 'Advisor'),
(288, 1001, 'Semakan Bajet HEPA', 'Pihak HEPA telah mengubah bajet untuk \'Bengkel C#\'.', 'STATUS', '/chc/track?id=39', 'Semak', 1, '2026-06-05 14:00:44', 'CHC'),
(289, 1001, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: TestSDG2', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-06 05:37:19', 'Advisor'),
(290, 1001, 'Proposal Submitted', 'Kertas kerja anda \'TestSDG2\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=75', 'Track Status', 1, '2026-06-06 05:37:19', 'CHC'),
(291, 1001, 'Proposal Supported', 'Penasihat telah menyokong kertas kerja: TestSDG2', 'STATUS', '/chc/track?id=75', 'Track Status', 1, '2026-06-06 05:38:32', 'CHC'),
(292, 1001, 'Pending Faculty Review', 'Satu kertas kerja baharu memerlukan semakan anda.', 'STATUS', '/faculty/dashboard', 'Review Now', 1, '2026-06-06 05:38:32', 'Faculty'),
(293, 1001, 'Bajet Diubah oleh Fakulti', 'Fakulti telah menukar bajet untuk \'TestSDG2\'.', 'STATUS', '/chc/track?id=75', 'Semak', 1, '2026-06-06 05:39:45', 'CHC'),
(294, 1001, 'Fakulti Endorsed', 'Fakulti memperakui kertas kerja. Menunggu kelulusan HEPA.', 'STATUS', '/chc/track?id=75', 'Track Status', 1, '2026-06-06 05:39:52', 'CHC'),
(295, 1001, 'Pending HEPA Approval', 'Satu kertas kerja Akademik menunggu kelulusan akhir.', 'STATUS', '/hepa/review?id=75', 'Review Now', 1, '2026-06-06 05:39:52', 'HEPA'),
(296, 1001, 'Semakan Bajet HEPA', 'Pihak HEPA telah mengubah bajet untuk \'TestSDG2\'.', 'STATUS', '/chc/track?id=75', 'Semak', 1, '2026-06-06 05:56:44', 'CHC'),
(297, 1001, 'Kertas Kerja Diluluskan Penuh!', 'Tahniah! Kertas kerja \'TestSDG2\' diluluskan akhir oleh HEPA.', 'STATUS', '/chc/track?id=75', 'Lihat', 1, '2026-06-06 06:04:29', 'CHC'),
(298, 1001, 'Kelulusan Akhir HEPA', 'Kertas kerja kelab seliaan anda telah diluluskan sepenuhnya.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-06-06 06:04:29', 'Advisor'),
(299, 10000, 'Bajet Proposal Diubah', 'MPP telah menyunting jadual bajet untuk \'1v1 Franco Tournament 2026\'.', 'STATUS', '/chc/track?id=55', 'Semak', 1, '2026-06-07 04:47:27', 'CHC'),
(300, 1002, 'Bajet Proposal Diubah', 'MPP telah menyunting jadual bajet untuk \'TestProgram1\'.', 'STATUS', '/chc/track?id=52', 'Semak', 1, '2026-06-07 04:48:02', 'CHC'),
(301, 1002, 'Semakan Bajet HEPA', 'Pihak HEPA telah mengubah bajet untuk \'dddddd\'.', 'STATUS', '/chc/track?id=67', 'Semak', 1, '2026-06-07 04:49:18', 'CHC'),
(302, 1002, 'Kertas Kerja Diluluskan Penuh!', 'Tahniah! Kertas kerja \'dddddd\' diluluskan akhir oleh HEPA.', 'STATUS', '/chc/track?id=67', 'Lihat', 1, '2026-06-07 04:49:23', 'CHC'),
(303, 1002, 'Kelulusan Akhir HEPA', 'Kertas kerja kelab seliaan anda telah diluluskan sepenuhnya.', 'STATUS', '/advisor/dashboard', 'Lihat', 1, '2026-06-07 04:49:23', 'Advisor'),
(304, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: EventTestNormalizedV1', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-17 04:43:34', 'Advisor'),
(305, 1002, 'Proposal Submitted', 'Kertas kerja anda \'EventTestNormalizedV1\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=77', 'Track Status', 1, '2026-06-17 04:43:34', 'CHC'),
(306, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: EventTestNormalizedV3', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-17 23:48:47', 'Advisor'),
(307, 1002, 'Proposal Submitted', 'Kertas kerja anda \'EventTestNormalizedV3\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=79', 'Track Status', 1, '2026-06-17 23:48:47', 'CHC'),
(308, 1002, 'Proposal Supported', 'Penasihat telah menyokong kertas kerja: EventTestNormalizedV3', 'STATUS', '/chc/track?id=79', 'Track Status', 1, '2026-06-18 01:45:20', 'CHC'),
(309, 1002, 'Pending MPP Review', 'Satu kertas kerja baharu memerlukan semakan anda.', 'STATUS', '/mpp/proposals', 'Review Now', 1, '2026-06-18 01:45:20', 'MPP'),
(310, 1002, 'Pitching Scheduled', 'Sesi pembentangan (Pitching) bagi kertas kerja \'EventTestNormalizedV3\' telah dijadualkan pada: 2026-06-19 09:48', 'STATUS', '/chc/track?id=79', 'View Link', 1, '2026-06-18 01:48:44', 'CHC'),
(311, 1002, 'Bajet Proposal Diubah', 'MPP telah menyunting jadual bajet untuk \'EventTestNormalizedV3\'.', 'STATUS', '/chc/track?id=79', 'Semak', 1, '2026-06-18 02:00:03', 'CHC'),
(312, 1001, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: EventTestNormalizedV4', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-18 02:20:37', 'Advisor'),
(313, 1001, 'Proposal Submitted', 'Kertas kerja anda \'EventTestNormalizedV4\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=80', 'Track Status', 1, '2026-06-18 02:20:37', 'CHC'),
(314, 1001, 'Proposal Supported', 'Penasihat telah menyokong kertas kerja: EventTestNormalizedV4', 'STATUS', '/chc/track?id=80', 'Track Status', 1, '2026-06-18 02:24:05', 'CHC'),
(315, 1001, 'Pending MPP Review', 'Satu kertas kerja baharu memerlukan semakan anda.', 'STATUS', '/mpp/proposals', 'Review Now', 1, '2026-06-18 02:24:05', 'MPP'),
(316, 1001, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: EventTestNormalizedV5', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-18 02:29:30', 'Advisor'),
(317, 1001, 'Proposal Submitted', 'Kertas kerja anda \'EventTestNormalizedV5\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=81', 'Track Status', 1, '2026-06-18 02:29:30', 'CHC'),
(318, 1001, 'Proposal Supported', 'Penasihat telah menyokong kertas kerja: EventTestNormalizedV5', 'STATUS', '/chc/track?id=81', 'Track Status', 1, '2026-06-18 02:30:14', 'CHC'),
(319, 1001, 'Pending Faculty Review', 'Satu kertas kerja baharu memerlukan semakan anda.', 'STATUS', '/faculty/dashboard', 'Review Now', 1, '2026-06-18 02:30:14', 'Faculty'),
(320, 1001, 'Bajet Diubah oleh Fakulti', 'Fakulti telah menukar bajet untuk \'EventTestNormalizedV5\'.', 'STATUS', '/chc/track?id=81', 'Semak', 1, '2026-06-18 02:32:05', 'CHC'),
(321, 1001, 'Kertas Kerja Diluluskan!', 'Tahniah! Fakulti telah meluluskan sepenuhnya kertas kerja \'EventTestNormalizedV5\'.', 'STATUS', '/chc/track?id=81', 'Lihat', 1, '2026-06-18 02:32:27', 'CHC'),
(322, 1001, 'Kertas Kerja Kelab Diluluskan', 'Fakulti telah meluluskan kertas kerja kelab seliaan anda.', 'STATUS', '/advisor/dashboard', 'Lihat', 0, '2026-06-18 02:32:27', 'Advisor'),
(323, 1001, 'MPP Endorsed', 'MPP telah memperakui kertas kerja. Menunggu kelulusan HEPA.', 'STATUS', '/chc/track?id=80', 'Track Status', 1, '2026-06-18 02:41:32', 'CHC'),
(324, 1001, 'Pending HEPA Approval', 'Satu kertas kerja baharu menunggu kelulusan akhir.', 'STATUS', '/hepa/review?id=80', 'Review Now', 1, '2026-06-18 02:41:32', 'HEPA'),
(325, 1001, 'Semakan Bajet HEPA', 'Pihak HEPA telah mengubah bajet untuk \'EventTestNormalizedV4\'.', 'STATUS', '/chc/track?id=80', 'Semak', 1, '2026-06-18 02:52:49', 'CHC'),
(326, 1001, 'Kertas Kerja Diluluskan Penuh!', 'Tahniah! Kertas kerja \'EventTestNormalizedV4\' diluluskan akhir oleh HEPA.', 'STATUS', '/chc/track?id=80', 'Lihat', 1, '2026-06-18 02:52:59', 'CHC'),
(327, 1001, 'Kelulusan Akhir HEPA', 'Kertas kerja kelab seliaan anda telah diluluskan sepenuhnya.', 'STATUS', '/advisor/dashboard', 'Lihat', 0, '2026-06-18 02:52:59', 'Advisor'),
(328, 1001, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: EventTestNormalizedV6', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-18 02:55:02', 'Advisor'),
(329, 1001, 'Proposal Submitted', 'Kertas kerja anda \'EventTestNormalizedV6\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=82', 'Track Status', 1, '2026-06-18 02:55:02', 'CHC'),
(330, 1001, 'Proposal Supported', 'Penasihat telah menyokong kertas kerja: EventTestNormalizedV6', 'STATUS', '/chc/track?id=82', 'Track Status', 1, '2026-06-18 02:58:42', 'CHC'),
(331, 1001, 'Pending Faculty Review', 'Satu kertas kerja baharu memerlukan semakan anda.', 'STATUS', '/faculty/dashboard', 'Review Now', 1, '2026-06-18 02:58:42', 'Faculty'),
(332, 1001, 'Bajet Diubah oleh Fakulti', 'Fakulti telah menukar bajet untuk \'EventTestNormalizedV6\'.', 'STATUS', '/chc/track?id=82', 'Semak', 1, '2026-06-18 02:59:23', 'CHC'),
(333, 1001, 'Fakulti Endorsed', 'Fakulti memperakui kertas kerja. Menunggu kelulusan HEPA.', 'STATUS', '/chc/track?id=82', 'Track Status', 1, '2026-06-18 02:59:47', 'CHC'),
(334, 1001, 'Pending HEPA Approval', 'Satu kertas kerja Akademik menunggu kelulusan akhir.', 'STATUS', '/hepa/review?id=82', 'Review Now', 1, '2026-06-18 02:59:47', 'HEPA'),
(335, 1001, 'Semakan Bajet HEPA', 'Pihak HEPA telah mengubah bajet untuk \'EventTestNormalizedV6\'.', 'STATUS', '/chc/track?id=82', 'Semak', 1, '2026-06-18 03:00:32', 'CHC'),
(336, 1001, 'Kertas Kerja Diluluskan Penuh!', 'Tahniah! Kertas kerja \'EventTestNormalizedV6\' diluluskan akhir oleh HEPA.', 'STATUS', '/chc/track?id=82', 'Lihat', 1, '2026-06-18 03:00:36', 'CHC'),
(337, 1001, 'Kelulusan Akhir HEPA', 'Kertas kerja kelab seliaan anda telah diluluskan sepenuhnya.', 'STATUS', '/advisor/dashboard', 'Lihat', 0, '2026-06-18 03:00:36', 'Advisor'),
(338, 1002, 'Pitching Scheduled', 'Sesi pembentangan (Pitching) bagi kertas kerja \'EventTestNormalizedV3\' telah dijadualkan pada: 2026-06-23 14:38', 'STATUS', '/chc/track?id=79', 'View Link', 1, '2026-06-18 06:39:14', 'CHC'),
(339, 1002, 'Pitching Scheduled', 'Sesi pembentangan (Pitching) bagi kertas kerja \'EventTestNormalizedV3\' telah dijadualkan pada: 2026-06-23 14:38', 'STATUS', '/chc/track?id=79', 'View Link', 1, '2026-06-18 06:39:16', 'CHC'),
(340, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: TestAIV1', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-18 12:31:50', 'Advisor'),
(341, 1002, 'Proposal Submitted', 'Kertas kerja anda \'TestAIV1\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=83', 'Track Status', 1, '2026-06-18 12:31:50', 'CHC'),
(342, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: EventAi2', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-18 13:04:49', 'Advisor'),
(343, 1002, 'Proposal Submitted', 'Kertas kerja anda \'EventAi2\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=84', 'Track Status', 1, '2026-06-18 13:04:49', 'CHC'),
(344, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: Kempen Jom ke Masjid UMT', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-18 15:49:02', 'Advisor'),
(345, 1002, 'Proposal Submitted', 'Kertas kerja anda \'Kempen Jom ke Masjid UMT\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=85', 'Track Status', 1, '2026-06-18 15:49:02', 'CHC'),
(346, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: Annual Dinner', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-18 16:26:52', 'Advisor'),
(347, 1002, 'Proposal Submitted', 'Kertas kerja anda \'Annual Dinner\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=86', 'Track Status', 1, '2026-06-18 16:26:52', 'CHC'),
(348, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: Gotong Royong Masjid', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-18 16:35:54', 'Advisor'),
(349, 1002, 'Proposal Submitted', 'Kertas kerja anda \'Gotong Royong Masjid\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=87', 'Track Status', 1, '2026-06-18 16:35:54', 'CHC'),
(350, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: Score vs Index', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-18 17:04:57', 'Advisor'),
(351, 1002, 'Proposal Submitted', 'Kertas kerja anda \'Score vs Index\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=88', 'Track Status', 1, '2026-06-18 17:04:57', 'CHC'),
(352, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: TestLimitBudget1000', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-18 17:58:08', 'Advisor'),
(353, 1002, 'Proposal Submitted', 'Kertas kerja anda \'TestLimitBudget1000\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=89', 'Track Status', 1, '2026-06-18 17:58:08', 'CHC'),
(354, 1001, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: Bengkel Robotik 2026', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-21 06:05:49', 'Advisor'),
(355, 1001, 'Proposal Submitted', 'Kertas kerja anda \'Bengkel Robotik 2026\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=90', 'Track Status', 1, '2026-06-21 06:05:49', 'CHC'),
(356, 1001, 'Proposal Supported', 'Penasihat telah menyokong kertas kerja: Bengkel Robotik 2026', 'STATUS', '/chc/track?id=90', 'Track Status', 1, '2026-06-21 06:08:12', 'CHC'),
(357, 1001, 'Pending Faculty Review', 'Satu kertas kerja baharu memerlukan semakan anda.', 'STATUS', '/faculty/dashboard', 'Review Now', 0, '2026-06-21 06:08:12', 'Faculty'),
(358, 10006, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: Zombie Run 3.0 ', 'STATUS', '/advisor/pending', 'Review Now', 0, '2026-06-21 11:51:28', 'Advisor'),
(359, 10006, 'Proposal Submitted', 'Kertas kerja anda \'Zombie Run 3.0 \' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=92', 'Track Status', 1, '2026-06-21 11:51:28', 'CHC'),
(360, 1002, 'Semakan AGM Diperlukan', 'Kelab ID 1002 telah menghantar laporan AGM tahun 2026', 'STATUS', '/mpp/agm', 'Semak Sekarang', 1, '2026-06-21 11:51:42', 'MPP'),
(361, 10006, 'Proposal Supported', 'Penasihat telah menyokong kertas kerja: Zombie Run 3.0 ', 'STATUS', '/chc/track?id=92', 'Track Status', 1, '2026-06-21 11:54:03', 'CHC'),
(362, 10006, 'Pending MPP Review', 'Satu kertas kerja baharu memerlukan semakan anda.', 'STATUS', '/mpp/proposals', 'Review Now', 1, '2026-06-21 11:54:03', 'MPP'),
(363, 10006, 'Pitching Scheduled', 'Sesi pembentangan (Pitching) bagi kertas kerja \'Zombie Run 3.0 \' telah dijadualkan pada: 2026-06-22 19:55', 'STATUS', '/chc/track?id=92', 'View Link', 1, '2026-06-21 11:55:33', 'CHC'),
(364, 10006, 'Bajet Proposal Diubah', 'MPP telah menyunting jadual bajet untuk \'Zombie Run 3.0 \'.', 'STATUS', '/chc/track?id=92', 'Semak', 1, '2026-06-21 11:56:01', 'CHC'),
(365, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: Pertandingan Azan', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-21 21:50:36', 'Advisor'),
(366, 1002, 'Proposal Submitted', 'Kertas kerja anda \'Pertandingan Azan\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=93', 'Track Status', 0, '2026-06-21 21:50:36', 'CHC'),
(367, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: Bengkel Khat', 'STATUS', '/advisor/pending', 'Review Now', 1, '2026-06-21 22:14:14', 'Advisor'),
(368, 1002, 'Proposal Submitted', 'Kertas kerja anda \'Bengkel Khat\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=94', 'Track Status', 1, '2026-06-21 22:14:14', 'CHC'),
(369, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: Pertandingan Tilawah Al-Quran Peringkat Universiti 2026', 'STATUS', '/advisor/pending', 'Review Now', 0, '2026-06-21 22:21:09', 'Advisor'),
(370, 1002, 'Proposal Submitted', 'Kertas kerja anda \'Pertandingan Tilawah Al-Quran Peringkat Universiti 2026\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=91', 'Track Status', 0, '2026-06-21 22:21:09', 'CHC'),
(371, 1002, 'New Proposal Submitted', 'Sila semak kertas kerja baharu: Program Santuni Komuniti Tempatan', 'STATUS', '/advisor/pending', 'Review Now', 0, '2026-06-21 22:40:45', 'Advisor'),
(372, 1002, 'Proposal Submitted', 'Kertas kerja anda \'Program Santuni Komuniti Tempatan\' telah berjaya dihantar kepada Penasihat.', 'STATUS', '/chc/track?id=66', 'Track Status', 0, '2026-06-21 22:40:45', 'CHC');

-- --------------------------------------------------------

--
-- Table structure for table `proposal_budgets`
--

CREATE TABLE `proposal_budgets` (
  `budgetId` int(11) NOT NULL,
  `proposalId` int(11) NOT NULL,
  `itemName` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unitPrice` decimal(10,2) NOT NULL,
  `totalPrice` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `proposal_budgets`
--

INSERT INTO `proposal_budgets` (`budgetId`, `proposalId`, `itemName`, `quantity`, `unitPrice`, `totalPrice`) VALUES
(15, 76, 'TestNormalizedTable', 1, 10.00, 10.00),
(16, 76, 'TestNormalizedTable', 1, 10.00, 10.00),
(23, 77, 'EventTestNormalizedV1', 1, 10.00, 10.00),
(24, 77, 'EventTestNormalizedV1 2', 11, 110.00, 1210.00),
(25, 78, 'EventTestNormalizedV1', 1, 0.00, 0.00),
(29, 79, 'EventTestNormalizedV1', 1, 10.00, 10.00),
(30, 79, 'Makanan Aiman', 1, 10.00, 10.00),
(35, 81, 'EventTestNormalizedV4', 1, 50.00, 50.00),
(36, 80, 'EventTestNormalizedV4', 1, 10.00, 10.00),
(37, 80, 'Makanan Aiman', 1, 50.00, 50.00),
(42, 82, 'EventTestNormalizedV4', 1, 10.00, 10.00),
(43, 82, 'Item Faculty', 1, 110.00, 110.00),
(44, 82, 'Item Hepa', 1, 20.00, 20.00),
(46, 83, 'EventTestNormalizedV4', 1, 100.00, 100.00),
(47, 84, 'EventTestNormalizedV4', 1, 10.00, 10.00),
(49, 85, 'Makanan Peserta & AJK', 200, 8.00, 1600.00),
(51, 86, 'Dinner Quinara', 135, 20.00, 2700.00),
(52, 87, 'Makanan peserta ', 25, 8.00, 200.00),
(53, 88, 'Makanan Peserta & AJK', 1, 10.00, 10.00),
(54, 89, 'Makanan Peserta & AJK', 130, 10.00, 1300.00),
(55, 90, 'Makanan Peserta & AJK', 20, 8.00, 160.00),
(56, 90, 'Kit Tambahan', 5, 50.00, 250.00),
(57, 90, 'Hadiah Pemenang ', 3, 10.00, 30.00),
(60, 92, 'Makanan Peserta & AJK', 350, 4.00, 1400.00),
(62, 93, 'Makanan Peserta & AJK', 250, 8.00, 2000.00),
(63, 94, 'Makanan Peserta & AJK', 35, 10.00, 350.00),
(64, 91, 'Makanan Peserta & AJK', 10, 8.00, 80.00),
(65, 66, 'Makanan Peserta', 1, 110.00, 110.00),
(66, 66, 'Hadiah', 1, 10.00, 10.00),
(69, 95, 'Makanan Peserta & AJK', 520, 7.00, 3640.00),
(70, 95, 'Cenderamata Jemputan', 1, 100.00, 100.00);

-- --------------------------------------------------------

--
-- Table structure for table `proposal_committees`
--

CREATE TABLE `proposal_committees` (
  `committeeId` int(11) NOT NULL,
  `proposalId` int(11) NOT NULL,
  `matricNo` varchar(20) NOT NULL,
  `name` varchar(150) NOT NULL,
  `role` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `proposal_committees`
--

INSERT INTO `proposal_committees` (`committeeId`, `proposalId`, `matricNo`, `name`, `role`) VALUES
(15, 76, 'S00000', 'TestNormalizedTable', 'TestNormalizedTable'),
(16, 76, 'S11111', 'TestNormalizedTable', 'TestNormalizedTable'),
(20, 77, 'S222222', 'EventTestNormalizedV1', 'EventTestNormalizedV1'),
(21, 78, 'S222222', 'EventTestNormalizedV1', 'EventTestNormalizedV1'),
(24, 79, 'S222222', 'EventTestNormalizedV1', 'EventTestNormalizedV1'),
(26, 80, 'S222222', 'EventTestNormalizedV4', 'EventTestNormalizedV4'),
(28, 81, 'S222222', 'EventTestNormalizedV4', 'EventTestNormalizedV4'),
(30, 82, 'S222222', 'EventTestNormalizedV4', 'EventTestNormalizedV4'),
(32, 83, 'S222222', 'EventTestNormalizedV4', 'EventTestNormalizedV4'),
(33, 84, 'S222222', 'EventTestNormalizedV4', 'EventTestNormalizedV4'),
(35, 85, 'S70622', 'Haikal', 'Director'),
(37, 86, 'S70622 ', 'Haikal', 'Director'),
(38, 87, 'S70622 ', 'Haikal Danial ', 'Director '),
(39, 88, 'S70622', 'Haikal', 'Director'),
(40, 89, 'S70622', 'Haikal', 'Director'),
(41, 90, 'S70622', 'Haikal', 'Director'),
(43, 92, 'S70622', 'Haikal', 'Director'),
(45, 93, 'S70622', 'Haikal', 'Director'),
(46, 94, 'S70622', 'Haikal', 'Director'),
(47, 91, 'S70622', 'Haikal', 'Director'),
(48, 66, 'S222222', 'EventTestNormalizedV1', 'Director'),
(50, 95, 'S70622', 'Haikal', 'Director');

-- --------------------------------------------------------

--
-- Table structure for table `proposal_itineraries`
--

CREATE TABLE `proposal_itineraries` (
  `itineraryId` int(11) NOT NULL,
  `proposalId` int(11) NOT NULL,
  `day` varchar(50) NOT NULL,
  `time` varchar(20) NOT NULL,
  `activity` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `proposal_itineraries`
--

INSERT INTO `proposal_itineraries` (`itineraryId`, `proposalId`, `day`, `time`, `activity`) VALUES
(22, 76, 'Day 1', '09:00', 'TestNormalizedTable'),
(23, 76, 'Day 1', '10:00', 'TestNormalizedTable'),
(24, 76, 'Day 1', '11:00', 'TestNormalizedTable'),
(31, 77, 'DAY 1', '11:11', 'EventTestNormalizedV1'),
(32, 77, 'DAY 1', '11:11', 'EventTestNormalizedV1'),
(37, 79, 'DAY 1', '11:11', 'EventTestNormalizedV2'),
(38, 79, 'DAY 1', '11:22', 'EventTestNormalizedV3'),
(41, 80, 'DAY 1', '11:11', 'EventTestNormalizedV4'),
(42, 80, 'DAY 1', '02:22', 'EventTestNormalizedV4'),
(45, 81, 'DAY 1', '11:11', 'EventTestNormalizedV5'),
(46, 81, 'DAY 1', '14:22', 'EventTestNormalizedV5'),
(48, 82, 'DAY 1', '11:11', 'EventTestNormalizedV5'),
(51, 83, 'DAY 1', '', ''),
(52, 84, 'DAY 1', '11:11', 'TestAIV1'),
(54, 85, 'DAY 1', '21:00', 'Ceramah Perdana'),
(59, 86, 'DAY 1', '19:00', 'Pendaftaran'),
(60, 86, 'DAY 1', '20:00', 'Ucapan Perasmian'),
(61, 86, 'DAY 1', '20:30', 'Makan Malam'),
(62, 86, 'DAY 1', '23:00', 'Bersurai'),
(63, 87, 'DAY 1', '08:00', 'Bersih Masjid'),
(64, 87, 'DAY 1', '11:35', 'Makan Tengahari '),
(65, 87, 'DAY 1', '12:00', 'Bersurai '),
(66, 88, 'DAY 1', '11:11', 'Score vs Index'),
(67, 89, 'DAY 1', '11:11', 'ggg'),
(68, 89, 'DAY 2', '11:11', 'hhhh'),
(69, 90, 'DAY 1', '08:00', 'Pendaftaran'),
(70, 90, 'DAY 1', '09:00', 'Bengkel 1'),
(71, 90, 'DAY 1', '10:30', 'Rehat / Minum Pagi'),
(72, 90, 'DAY 1', '11:00', 'Bengkel 2'),
(73, 90, 'DAY 1', '12:30', 'Pertandingan Kalah Mati'),
(74, 90, 'DAY 1', '14:00', 'Penutup'),
(77, 92, 'DAY 1', '20:00', 'Pendaftaran'),
(80, 93, 'DAY 1', '03:33', 'Pendaftaran'),
(81, 94, 'DAY 1', '11:11', 'Pendaftaran'),
(82, 91, 'DAY 1', '08:00', 'Pendaftaran'),
(83, 91, 'DAY 1', '09:00', 'Pusingan 1'),
(84, 66, 'DAY 1', '11:11', 'aaa'),
(86, 95, 'DAY 1', '21:00', 'Mula Bermunajjat');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `userId` varchar(10) NOT NULL,
  `fullName` varchar(100) NOT NULL,
  `email` varchar(80) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('CHC','MPP','Student','HEPA','Advisor','Faculty') NOT NULL,
  `department` varchar(50) DEFAULT NULL,
  `isActive` tinyint(1) DEFAULT 1,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `phone` varchar(20) DEFAULT NULL,
  `isTempPassword` tinyint(1) DEFAULT 1,
  `otp_code` varchar(10) DEFAULT NULL,
  `otp_expiry` datetime DEFAULT NULL,
  `portfolio` varchar(100) DEFAULT 'Ahli Majlis'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`userId`, `fullName`, `email`, `password`, `role`, `department`, `isActive`, `createdAt`, `phone`, `isTempPassword`, `otp_code`, `otp_expiry`, `portfolio`) VALUES
('fskm', 'Fakulti Sains Komputer & Matematik', 'fskm@umt.edu.my', '12345678', 'Faculty', 'FSKM', 1, '2026-04-19 19:56:43', NULL, 1, NULL, NULL, 'Ahli Majlis'),
('haikal', 'Haikal Danial', 'haikal.picturevaulth02@gmail.com', 'Temp123!', 'Advisor', NULL, 1, '2026-06-21 11:35:49', NULL, 1, NULL, NULL, 'Ahli Majlis'),
('HEPA001', 'En. Khalies (Staff HEPA)', 'khalies@umt.edu.my', '12345678', 'HEPA', 'HEPA', 1, '2026-04-14 09:01:52', NULL, 0, NULL, NULL, 'Ahli Majlis'),
('MPP001', 'Ahmad', 'ahmad.mpp@umt.edu.my', '12345678', 'MPP', 'FSMA', 1, '2026-04-14 09:01:52', '', 0, NULL, NULL, 'Yang Di-Pertua (YDP)'),
('najmi', 'Muhammad Naim Najmi Bin Hazre', 'naim.hazre@gmail.com', 'NaimNajmi', 'Advisor', 'FSKM', 1, '2026-06-21 11:59:21', '01125696678', 0, NULL, NULL, 'Ahli Majlis'),
('S00021', 'Ekal', 'harrybobby2017@gmail.com', '12345678', 'CHC', 'Student', 1, '2026-04-30 09:16:05', NULL, 0, NULL, NULL, 'Ahli Majlis'),
('S11111', 'Ali Bin Abu (Setiausaha COMTECH)', 's11111@ocean.umt.edu.my', '12345678', 'CHC', 'FSKM', 1, '2026-04-14 09:01:52', NULL, 0, NULL, NULL, 'Ahli Majlis'),
('S22222', 'Raju (Ahli Biasa SAHAM)', 's22222@ocean.umt.edu.my', '12345678', 'Student', 'FSSM', 1, '2026-04-14 09:01:52', NULL, 0, NULL, NULL, 'Ahli Majlis'),
('S55555', 'Muhamad Aiman Ikhwan Bin Badrul ', 's55555@ocean.umt.edu.my', 'S55555', 'Student', 'General', 1, '2026-04-30 02:47:12', '', 1, NULL, NULL, 'Ahli Majlis'),
('S70224', 'Muhammad Naim Najmi Bin Hazre', 'S70224@ocean.umt.edu.my', 'X3Tys4wda1', 'CHC', 'Student', 1, '2026-06-21 12:00:16', NULL, 1, NULL, NULL, 'Ahli Majlis'),
('S70622', 'Haikal Danial ', 's70622@ocean.umt.edu.my', '12345678', 'CHC', 'FSKM', 1, '2026-04-14 09:01:52', '0188627356', 0, '134948', '2026-06-07 13:05:10', 'Ahli Majlis'),
('S70810', 'Muhamad Amir ', 's70810@ocean.umt.edu.my', 'bQrmYkAPDR', 'CHC', 'FSKM', 1, '2026-04-14 09:01:52', '', 0, NULL, NULL, 'Ahli Majlis'),
('S71383', 'Khairul \'Tenkhay\' Iman  ', 'S71383@ocean.umt.edu.my', 'Temp123!', 'Advisor', NULL, 1, '2026-04-30 01:22:02', NULL, 1, NULL, NULL, 'Ahli Majlis'),
('S71805', 'Siti Fikriyah Bt I.R. Abdul Khawi', 'S71805@umt.edu.my', 'Yoongi090393', 'CHC', 'FSKM', 1, '2026-04-30 09:48:46', '01123122923', 0, NULL, NULL, 'Ahli Majlis'),
('S72421', 'Nooratikah Binti Azmien', 'S72421@ocean.umt.edu.my', '12345678', 'CHC', 'Student', 1, '2026-04-30 08:57:58', NULL, 0, NULL, NULL, 'Ahli Majlis'),
('S88888', 'Ali Rustam Bin Abu', 'ali.rustam@student.umt.edu.my', 'password123', 'CHC', 'Fakulti Sains Komputer', 1, '2026-04-26 12:19:36', NULL, 1, NULL, NULL, 'Ahli Majlis'),
('staff111', 'Ustaz Farhan Bin Othman', 'farhan123@umt.edu.my', '12345678', 'Advisor', 'FSMA', 1, '2026-04-16 06:56:01', '', 1, NULL, NULL, 'Ahli Majlis'),
('staff123', 'Dr. Ahmad Fauzi', 'ahmad@umt.edu.my', '12345678', 'Advisor', 'FSKM', 1, '2026-04-16 06:56:01', NULL, 1, NULL, NULL, 'Ahli Majlis');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `agm_report`
--
ALTER TABLE `agm_report`
  ADD PRIMARY KEY (`agmId`),
  ADD KEY `clubId` (`clubId`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`logId`),
  ADD KEY `userId` (`userId`);

--
-- Indexes for table `clubs`
--
ALTER TABLE `clubs`
  ADD PRIMARY KEY (`clubId`),
  ADD UNIQUE KEY `unique_club_name` (`clubName`);

--
-- Indexes for table `club_memberships`
--
ALTER TABLE `club_memberships`
  ADD PRIMARY KEY (`membershipId`),
  ADD UNIQUE KEY `unique_membership` (`userId`,`clubId`,`Position`),
  ADD KEY `clubId` (`clubId`);

--
-- Indexes for table `eventproposal`
--
ALTER TABLE `eventproposal`
  ADD PRIMARY KEY (`proposalId`),
  ADD KEY `clubId` (`clubId`),
  ADD KEY `createdBy` (`createdBy`);

--
-- Indexes for table `master_calendar`
--
ALTER TABLE `master_calendar`
  ADD PRIMARY KEY (`calendarId`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notificationId`),
  ADD KEY `clubId` (`clubId`);

--
-- Indexes for table `proposal_budgets`
--
ALTER TABLE `proposal_budgets`
  ADD PRIMARY KEY (`budgetId`),
  ADD KEY `proposalId` (`proposalId`);

--
-- Indexes for table `proposal_committees`
--
ALTER TABLE `proposal_committees`
  ADD PRIMARY KEY (`committeeId`),
  ADD KEY `proposalId` (`proposalId`);

--
-- Indexes for table `proposal_itineraries`
--
ALTER TABLE `proposal_itineraries`
  ADD PRIMARY KEY (`itineraryId`),
  ADD KEY `proposalId` (`proposalId`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`userId`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `agm_report`
--
ALTER TABLE `agm_report`
  MODIFY `agmId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `logId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=211;

--
-- AUTO_INCREMENT for table `clubs`
--
ALTER TABLE `clubs`
  MODIFY `clubId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10008;

--
-- AUTO_INCREMENT for table `club_memberships`
--
ALTER TABLE `club_memberships`
  MODIFY `membershipId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `eventproposal`
--
ALTER TABLE `eventproposal`
  MODIFY `proposalId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=96;

--
-- AUTO_INCREMENT for table `master_calendar`
--
ALTER TABLE `master_calendar`
  MODIFY `calendarId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notificationId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=373;

--
-- AUTO_INCREMENT for table `proposal_budgets`
--
ALTER TABLE `proposal_budgets`
  MODIFY `budgetId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `proposal_committees`
--
ALTER TABLE `proposal_committees`
  MODIFY `committeeId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `proposal_itineraries`
--
ALTER TABLE `proposal_itineraries`
  MODIFY `itineraryId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `agm_report`
--
ALTER TABLE `agm_report`
  ADD CONSTRAINT `agm_report_ibfk_1` FOREIGN KEY (`clubId`) REFERENCES `clubs` (`clubId`) ON DELETE CASCADE;

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`) ON DELETE SET NULL;

--
-- Constraints for table `club_memberships`
--
ALTER TABLE `club_memberships`
  ADD CONSTRAINT `club_memberships_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`) ON DELETE CASCADE,
  ADD CONSTRAINT `club_memberships_ibfk_2` FOREIGN KEY (`clubId`) REFERENCES `clubs` (`clubId`) ON DELETE CASCADE;

--
-- Constraints for table `eventproposal`
--
ALTER TABLE `eventproposal`
  ADD CONSTRAINT `eventproposal_ibfk_1` FOREIGN KEY (`clubId`) REFERENCES `clubs` (`clubId`) ON DELETE CASCADE,
  ADD CONSTRAINT `eventproposal_ibfk_2` FOREIGN KEY (`createdBy`) REFERENCES `user` (`userId`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`clubId`) REFERENCES `clubs` (`clubId`) ON DELETE CASCADE;

--
-- Constraints for table `proposal_budgets`
--
ALTER TABLE `proposal_budgets`
  ADD CONSTRAINT `proposal_budgets_ibfk_1` FOREIGN KEY (`proposalId`) REFERENCES `eventproposal` (`proposalId`) ON DELETE CASCADE;

--
-- Constraints for table `proposal_committees`
--
ALTER TABLE `proposal_committees`
  ADD CONSTRAINT `proposal_committees_ibfk_1` FOREIGN KEY (`proposalId`) REFERENCES `eventproposal` (`proposalId`) ON DELETE CASCADE;

--
-- Constraints for table `proposal_itineraries`
--
ALTER TABLE `proposal_itineraries`
  ADD CONSTRAINT `proposal_itineraries_ibfk_1` FOREIGN KEY (`proposalId`) REFERENCES `eventproposal` (`proposalId`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
