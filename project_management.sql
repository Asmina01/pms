-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 20, 2025 at 09:47 AM
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
-- Database: `project_management`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_app_milestone`
--

CREATE TABLE `admin_app_milestone` (
  `id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` longtext NOT NULL,
  `due_date` date DEFAULT NULL,
  `completed` tinyint(1) NOT NULL,
  `project_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_app_milestone`
--

INSERT INTO `admin_app_milestone` (`id`, `title`, `description`, `due_date`, `completed`, `project_id`) VALUES
(1, 'Design UI/UX Wireframes', 'Create wireframes and design mockups for the homepage, product pages, and checkout flow.', '2025-03-10', 1, 4),
(2, 'Wireframing', 'Create wireframes and get approval.', '2024-03-10', 1, 4),
(3, 'testing', 'testing completed on', '2025-03-10', 0, 4);

-- --------------------------------------------------------

--
-- Table structure for table `admin_app_project`
--

CREATE TABLE `admin_app_project` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `short_code` varchar(20) NOT NULL,
  `description` longtext NOT NULL,
  `client` varchar(100) NOT NULL,
  `category` varchar(50) NOT NULL,
  `files` varchar(100) DEFAULT NULL,
  `budget` varchar(100) NOT NULL,
  `start_date` date NOT NULL,
  `due_date` date DEFAULT NULL,
  `progress` double NOT NULL,
  `status` varchar(20) NOT NULL,
  `priority` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_app_project`
--

INSERT INTO `admin_app_project` (`id`, `name`, `short_code`, `description`, `client`, `category`, `files`, `budget`, `start_date`, `due_date`, `progress`, `status`, `priority`) VALUES
(4, 'Intelligent yoga coaching system', 'IYCS', 'The Intelligent Yoga Coaching System is an AI-powered platform designed to provide personalized yoga coaching, real-time posture analysis, and guided sessions tailored to individual needs. It integrates computer vision, machine learning, and expert recommendations to help users practice yoga effectively from the comfort of their homes.\r\n\r\nObjectives\r\nProvide AI-powered posture correction and real-time feedback.\r\nOffer personalized yoga routines based on user preferences, health conditions, and goals.\r\nEnable virtual coaching through video tutorials and interactive sessions.\r\nTrack progress and suggest improvements using data analytics.\r\nSupport multi-device accessibility, including web and mobile applications.\r\n\r\nKey Features\r\nAI-Powered Posture Detection\r\nUses computer vision to analyze body alignment.\r\nProvides instant feedback and corrections.\r\nPersonalized Yoga Plans\r\nCustomizes routines based on user input (fitness level, age, flexibility, health conditions).\r\nAdaptive difficulty levels.\r\nVirtual Instructor & Voice Guidance\r\nAI-generated voice coaching for a hands-free experience.\r\nStep-by-step guidance with breathing techniques.\r\nProgress Tracking & Insights\r\nMonitors performance and improvement over time.\r\nGenerates reports and recommendations for better practice.\r\nCommunity & Social Engagement\r\nEnables users to join virtual yoga groups.\r\nAllows sharing progress with friends and instructors.\r\nIntegration with Wearables & IoT\r\nSyncs with smartwatches and fitness trackers.\r\nTracks heart rate, breathing patterns, and calorie burn.\r\n\r\nTechnologies Used\r\nComputer Vision: OpenCV, MediaPipe for posture detection.\r\nMachine Learning: TensorFlow/Keras for movement analysis.\r\nWeb & Mobile Development: Django/Flask for backend, React/Flutter for UI.\r\nDatabase: PostgreSQL/MySQL for storing user profiles and progress.\r\nCloud & AI Services: Google Cloud, AWS, or Azure for model deployment.\r\n\r\nTarget Users\r\nBeginners looking for guided yoga practice.\r\nFitness Enthusiasts wanting personalized routines.\r\nElderly Users needing low-impact, customized yoga.\r\nYoga Instructors for virtual coaching and assessments.\r\n\r\nExpected Outcomes\r\nImproved user engagement and adherence to yoga routines.\r\nMore accessible and cost-effective yoga training.\r\nData-driven insights for better health and wellness.', 'Regional technologies', 'Mobile App', 'files/2c0a0e80-1823-11ea-9d35-91091ed13a2f_yRx23Em.jpg', '40000', '2025-02-01', '2025-03-30', 0, 'In Progress', 'Medium'),
(5, 'crypto currency price prediction', 'CCPP', 'Cryptocurrency price prediction is a challenging yet crucial task in financial markets. Due to the high volatility of cryptocurrencies like Bitcoin (BTC), Ethereum (ETH), and others, predicting their prices involves analyzing historical trends, market sentiment, and technical indicators using AI and statistical models.\r\n\r\nApproaches for Cryptocurrency Price Prediction\r\n1. Traditional Statistical Methods\r\nARIMA (AutoRegressive Integrated Moving Average): A time-series forecasting technique that models cryptocurrency price trends.\r\nGARCH (Generalized Autoregressive Conditional Heteroskedasticity): Used to analyze price volatility in crypto markets.\r\n\r\nFuture of Cryptocurrency Price Prediction\r\nQuantum Computing: Could enhance accuracy in crypto market predictions.\r\nHybrid AI Models: Combining sentiment analysis, deep learning, and blockchain data for better accuracy.\r\nDecentralized Finance (DeFi) & NFTs: Influence market trends and add new variables to predictions.', 'Softronics pvt.ltd.', 'Web Development', 'files/1703134846_5koV8cU.pdf', '25000', '2025-01-10', '2025-02-26', 0, 'Completed', 'Low'),
(6, 'Hospital Management system', 'HMS', 'A Hospital Management System (HMS) is a comprehensive software solution designed to manage all aspects of a hospital\'s operations, including administrative, financial, clinical, and operational tasks. It helps streamline processes, improve efficiency, and provide better patient care. Below is a detailed description of the key components and functionalities typically found in a hospital management system:\r\n\r\nKey Components and Functionalities:\r\nPatient Management:\r\n\r\nRegistration: Patients can be registered in the system with their personal details, contact information, medical history, and insurance details.\r\nAppointments: Patients can book, view, and cancel appointments with doctors. The system helps in managing appointment scheduling and appointment history.\r\nMedical Records: Maintaining electronic medical records (EMRs) for each patient, including their medical history, diagnoses, treatment plans, lab results, and medications.\r\nBilling and Payment: Automated billing for services rendered, including consultations, lab tests, and hospital stays. Patients can also make payments directly through the system.\r\nPrescription Management: Doctors can issue prescriptions for patients, which are saved in the system for easy reference and can be shared with pharmacies or the patient.\r\nHealth Education: The system can include health education materials, guides, and tips that can be shared with patients.', 'Inmakes infotech', 'Web Development', 'files/1703134846_1.pdf', '30000', '2025-02-01', '2025-02-28', 0, 'In Progress', 'Low');

-- --------------------------------------------------------

--
-- Table structure for table `admin_app_projectfunctions`
--

CREATE TABLE `admin_app_projectfunctions` (
  `id` bigint(20) NOT NULL,
  `function` longtext NOT NULL,
  `project_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_app_projectfunctions`
--

INSERT INTO `admin_app_projectfunctions` (`id`, `function`, `project_id`) VALUES
(14, 'Front end designing', 4),
(15, 'database connections', 5),
(16, 'template designing', 4),
(17, 'management the module', 6),
(18, 'Modeling and connection', 5),
(19, 'Functions and forms', 4);

-- --------------------------------------------------------

--
-- Table structure for table `admin_app_projectlead`
--

CREATE TABLE `admin_app_projectlead` (
  `id` bigint(20) NOT NULL,
  `project_id` bigint(20) NOT NULL,
  `user_id` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_app_projectlead`
--

INSERT INTO `admin_app_projectlead` (`id`, `project_id`, `user_id`) VALUES
(1, 4, '1119'),
(2, 5, '1114'),
(3, 6, '1120');

-- --------------------------------------------------------

--
-- Table structure for table `admin_app_project_assigned`
--

CREATE TABLE `admin_app_project_assigned` (
  `id` bigint(20) NOT NULL,
  `project_id` bigint(20) NOT NULL,
  `user_id` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_app_project_assigned`
--

INSERT INTO `admin_app_project_assigned` (`id`, `project_id`, `user_id`) VALUES
(26, 4, '1114'),
(13, 4, '1118'),
(16, 4, '1119'),
(27, 4, '1121'),
(21, 5, '1114'),
(20, 5, '1118'),
(17, 5, '1119'),
(18, 5, '1120'),
(28, 6, '1115'),
(25, 6, '1116'),
(29, 6, '1118'),
(23, 6, '1120'),
(22, 6, '1121');

-- --------------------------------------------------------

--
-- Table structure for table `admin_app_sprint`
--

CREATE TABLE `admin_app_sprint` (
  `id` bigint(20) NOT NULL,
  `sprint_name` varchar(100) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `description` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_app_sprint`
--

INSERT INTO `admin_app_sprint` (`id`, `sprint_name`, `start_date`, `end_date`, `description`) VALUES
(1, 'erp', '2025-01-22', '2025-01-28', 'testing'),
(2, 'HHP-SPC', '2025-02-01', '2025-02-28', 'feb high and low'),
(3, 'ASM-IP', '2025-03-01', '2025-03-31', 'march pending workes'),
(4, 'NW- AUT', '2025-03-01', '2025-03-31', '0yfxdfghjkkgfg'),
(5, 'FEB- test', '2025-02-01', '2025-02-28', 'asdftgyh');

-- --------------------------------------------------------

--
-- Table structure for table `admin_app_sprint_completed_tasks`
--

CREATE TABLE `admin_app_sprint_completed_tasks` (
  `id` bigint(20) NOT NULL,
  `sprint_id` bigint(20) NOT NULL,
  `task_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `admin_app_sprint_in_progress_tasks`
--

CREATE TABLE `admin_app_sprint_in_progress_tasks` (
  `id` bigint(20) NOT NULL,
  `sprint_id` bigint(20) NOT NULL,
  `task_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `admin_app_sprint_pending_tasks`
--

CREATE TABLE `admin_app_sprint_pending_tasks` (
  `id` bigint(20) NOT NULL,
  `sprint_id` bigint(20) NOT NULL,
  `task_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_app_sprint_pending_tasks`
--

INSERT INTO `admin_app_sprint_pending_tasks` (`id`, `sprint_id`, `task_id`) VALUES
(18, 1, 32),
(24, 1, 38),
(20, 2, 35),
(22, 2, 36),
(21, 3, 34),
(25, 3, 39),
(16, 4, 31),
(19, 4, 33),
(23, 4, 37);

-- --------------------------------------------------------

--
-- Table structure for table `admin_app_sprint_tasks`
--

CREATE TABLE `admin_app_sprint_tasks` (
  `id` bigint(20) NOT NULL,
  `sprint_id` bigint(20) NOT NULL,
  `task_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_app_sprint_tasks`
--

INSERT INTO `admin_app_sprint_tasks` (`id`, `sprint_id`, `task_id`) VALUES
(23, 1, 32),
(29, 1, 38),
(25, 2, 35),
(27, 2, 36),
(26, 3, 34),
(30, 3, 39),
(21, 4, 31),
(24, 4, 33),
(28, 4, 37);

-- --------------------------------------------------------

--
-- Table structure for table `admin_app_task`
--

CREATE TABLE `admin_app_task` (
  `id` bigint(20) NOT NULL,
  `task_name` varchar(100) NOT NULL,
  `description` longtext NOT NULL,
  `category` varchar(50) NOT NULL,
  `priority` varchar(20) NOT NULL,
  `status` varchar(50) NOT NULL,
  `start_date` date NOT NULL,
  `due_date` date DEFAULT NULL,
  `estimated_hours` int(10) UNSIGNED NOT NULL CHECK (`estimated_hours` >= 0),
  `project_id` bigint(20) NOT NULL,
  `function_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_app_task`
--

INSERT INTO `admin_app_task` (`id`, `task_name`, `description`, `category`, `priority`, `status`, `start_date`, `due_date`, `estimated_hours`, `project_id`, `function_id`) VALUES
(31, 'Animation', 'sertyu', 'Front end', 'Medium', 'Completed', '2025-02-16', '2025-02-19', 16, 4, 14),
(32, 'main template', 'erfg', 'UI design', 'Low', 'Completed', '2025-02-17', '2025-02-19', 9, 4, 16),
(33, 'Database connections and migrations', 'Data connection', 'Database', 'Medium', 'Completed', '2025-02-17', '2025-02-19', 16, 5, 15),
(34, 'Module manage', 'dxfcghbjkl;', 'Front end', 'Medium', 'Completed', '2025-02-18', '2025-02-20', 9, 6, 17),
(35, 'functions and properties setting', 'rxdfghio', 'Support', 'Medium', 'Completed', '2025-02-19', '2025-02-20', 9, 6, 17),
(36, 'functions and forms', 'bnm', 'Support', 'Medium', 'Completed', '2025-02-22', '2025-02-24', 14, 4, 19),
(37, 'testing', 'ddasdf', 'Testing', 'Medium', 'In Progress', '2025-03-03', '2025-03-08', 19, 4, 14),
(38, 'module resetting', 'asdfdfgh', 'Testing', 'Medium', 'In Progress', '2025-03-04', '2025-03-08', 4, 6, 17),
(39, 'ux design', 'dwefrgethryjtukyilu;oi', 'UI design', 'Medium', 'In Progress', '2025-03-19', '2025-03-22', 16, 4, 14);

-- --------------------------------------------------------

--
-- Table structure for table `admin_app_taskprogress`
--

CREATE TABLE `admin_app_taskprogress` (
  `id` bigint(20) NOT NULL,
  `start_time` datetime(6) NOT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  `task_id` bigint(20) NOT NULL,
  `user_id` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `admin_app_task_assigned_to`
--

CREATE TABLE `admin_app_task_assigned_to` (
  `id` bigint(20) NOT NULL,
  `task_id` bigint(20) NOT NULL,
  `user_id` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_app_task_assigned_to`
--

INSERT INTO `admin_app_task_assigned_to` (`id`, `task_id`, `user_id`) VALUES
(30, 31, '1114'),
(31, 32, '1114'),
(32, 33, '1115'),
(33, 34, '1116'),
(34, 35, '1121'),
(35, 36, '1115'),
(36, 37, 'A001'),
(37, 38, '1116'),
(38, 39, '1118');

-- --------------------------------------------------------

--
-- Table structure for table `admin_app_timelineevent`
--

CREATE TABLE `admin_app_timelineevent` (
  `id` bigint(20) NOT NULL,
  `project_id` bigint(20) NOT NULL,
  `event_type` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_app_timelineevent`
--

INSERT INTO `admin_app_timelineevent` (`id`, `project_id`, `event_type`, `description`, `start_date`, `end_date`) VALUES
(1, 4, 'Testing', 'sdfg', '2025-01-03', '2025-10-03'),
(2, 4, 'debugging', 'debugging', '2025-02-15', '2025-02-28');

-- --------------------------------------------------------

--
-- Table structure for table `admin_app_user`
--

CREATE TABLE `admin_app_user` (
  `reg_no` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `designation` varchar(100) NOT NULL,
  `image` varchar(100) DEFAULT NULL,
  `phone` varchar(15) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_app_user`
--

INSERT INTO `admin_app_user` (`reg_no`, `name`, `designation`, `image`, `phone`, `email`, `password`, `role`) VALUES
('1114', 'Sara abraham', 'softwear tester', 'images/emp_2_NKLw3Gc.jpg', '03452345676', 'sara@gmail.com', 'Sara1234', 'employee'),
('1115', 'George', 'Backend developer', 'images/emp_5_bPl9ixg.jpg', '7686823689', 'george@gmail.com', 'George1234', 'employee'),
('1116', 'Leo', 'Full stack developer', 'images/emp_7_Q6PqRDu.jpg', '07656789098', 'leo@gmail.com', 'Leo1234', 'employee'),
('1117', 'celin mathew', 'QA Engineer', 'images/emp_4_HAG0gQi.jpg', '07656789898', 'celin@gmail.com', 'Celin1234', 'employee'),
('1118', 'Sakeer', 'System Analyst', 'images/emp_9_ytejLLQ.jpg', '7489478900', 'sakeer@gmail.com', 'Sakeer1234', 'employee'),
('1119', 'Mask leo', 'Database Administrator', 'images/emp_10_pCyj8CQ.jpg', '6789367799', 'maskleo@gmail.com', 'Maskleo1234', 'employee'),
('1120', 'john', 'DevOps Engineer', 'images/emp_8_zrwxkJl.jpg', '7487897890', 'john@gmail.com', 'John1234', 'employee'),
('1121', 'Asmina es', 'Full stack developer', 'images/Profile.png', '9744255167', 'asminaes01@gmail.com', 'Asmina1234', 'employee'),
('A001', 'Admin User', 'Admin', 'images/Profile.png', '9756789900', 'admin@example.com', 'admin123', 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add permission', 1, 'add_permission'),
(2, 'Can change permission', 1, 'change_permission'),
(3, 'Can delete permission', 1, 'delete_permission'),
(4, 'Can view permission', 1, 'view_permission'),
(5, 'Can add group', 2, 'add_group'),
(6, 'Can change group', 2, 'change_group'),
(7, 'Can delete group', 2, 'delete_group'),
(8, 'Can view group', 2, 'view_group'),
(9, 'Can add user', 3, 'add_user'),
(10, 'Can change user', 3, 'change_user'),
(11, 'Can delete user', 3, 'delete_user'),
(12, 'Can view user', 3, 'view_user'),
(13, 'Can add content type', 4, 'add_contenttype'),
(14, 'Can change content type', 4, 'change_contenttype'),
(15, 'Can delete content type', 4, 'delete_contenttype'),
(16, 'Can view content type', 4, 'view_contenttype'),
(17, 'Can add project', 5, 'add_project'),
(18, 'Can change project', 5, 'change_project'),
(19, 'Can delete project', 5, 'delete_project'),
(20, 'Can view project', 5, 'view_project'),
(21, 'Can add sprint', 6, 'add_sprint'),
(22, 'Can change sprint', 6, 'change_sprint'),
(23, 'Can delete sprint', 6, 'delete_sprint'),
(24, 'Can view sprint', 6, 'view_sprint'),
(25, 'Can add task', 7, 'add_task'),
(26, 'Can change task', 7, 'change_task'),
(27, 'Can delete task', 7, 'delete_task'),
(28, 'Can view task', 7, 'view_task'),
(29, 'Can add user', 8, 'add_user'),
(30, 'Can change user', 8, 'change_user'),
(31, 'Can delete user', 8, 'delete_user'),
(32, 'Can view user', 8, 'view_user'),
(33, 'Can add taskprogress', 9, 'add_taskprogress'),
(34, 'Can change taskprogress', 9, 'change_taskprogress'),
(35, 'Can delete taskprogress', 9, 'delete_taskprogress'),
(36, 'Can view taskprogress', 9, 'view_taskprogress'),
(37, 'Can add comment', 10, 'add_comment'),
(38, 'Can change comment', 10, 'change_comment'),
(39, 'Can delete comment', 10, 'delete_comment'),
(40, 'Can view comment', 10, 'view_comment'),
(41, 'Can add log entry', 11, 'add_logentry'),
(42, 'Can change log entry', 11, 'change_logentry'),
(43, 'Can delete log entry', 11, 'delete_logentry'),
(44, 'Can view log entry', 11, 'view_logentry'),
(45, 'Can add session', 12, 'add_session'),
(46, 'Can change session', 12, 'change_session'),
(47, 'Can delete session', 12, 'delete_session'),
(48, 'Can view session', 12, 'view_session'),
(49, 'Can add task time', 13, 'add_tasktime'),
(50, 'Can change task time', 13, 'change_tasktime'),
(51, 'Can delete task time', 13, 'delete_tasktime'),
(52, 'Can view task time', 13, 'view_tasktime'),
(53, 'Can add comment', 14, 'add_comment'),
(54, 'Can change comment', 14, 'change_comment'),
(55, 'Can delete comment', 14, 'delete_comment'),
(56, 'Can view comment', 14, 'view_comment'),
(57, 'Can add project_details', 15, 'add_project_details'),
(58, 'Can change project_details', 15, 'change_project_details'),
(59, 'Can delete project_details', 15, 'delete_project_details'),
(60, 'Can view project_details', 15, 'view_project_details'),
(61, 'Can add project functions', 16, 'add_projectfunctions'),
(62, 'Can change project functions', 16, 'change_projectfunctions'),
(63, 'Can delete project functions', 16, 'delete_projectfunctions'),
(64, 'Can view project functions', 16, 'view_projectfunctions'),
(65, 'Can add milestone', 17, 'add_milestone'),
(66, 'Can change milestone', 17, 'change_milestone'),
(67, 'Can delete milestone', 17, 'delete_milestone'),
(68, 'Can view milestone', 17, 'view_milestone'),
(69, 'Can add timeline event', 18, 'add_timelineevent'),
(70, 'Can change timeline event', 18, 'change_timelineevent'),
(71, 'Can delete timeline event', 18, 'delete_timelineevent'),
(72, 'Can view timeline event', 18, 'view_timelineevent'),
(73, 'Can add project lead', 19, 'add_projectlead'),
(74, 'Can change project lead', 19, 'change_projectlead'),
(75, 'Can delete project lead', 19, 'delete_projectlead'),
(76, 'Can view project lead', 19, 'view_projectlead');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'pbkdf2_sha256$600000$2vAlYeCBGcZyycwzBWj4TR$NymhwRJ1ha+B/oqKTqOIO6TLyd7h8xk4is+7YNQ7npk=', NULL, 1, 'ADMIN', '', '', 'admin@gmail.com', 1, 1, '2025-02-28 09:38:43.588004');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(11, 'admin', 'logentry'),
(10, 'admin_app', 'comment'),
(17, 'admin_app', 'milestone'),
(5, 'admin_app', 'project'),
(16, 'admin_app', 'projectfunctions'),
(19, 'admin_app', 'projectlead'),
(15, 'admin_app', 'project_details'),
(6, 'admin_app', 'sprint'),
(7, 'admin_app', 'task'),
(9, 'admin_app', 'taskprogress'),
(18, 'admin_app', 'timelineevent'),
(8, 'admin_app', 'user'),
(2, 'auth', 'group'),
(1, 'auth', 'permission'),
(3, 'auth', 'user'),
(4, 'contenttypes', 'contenttype'),
(14, 'employee_app', 'comment'),
(13, 'employee_app', 'tasktime'),
(12, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-01-21 14:04:14.796827'),
(2, 'auth', '0001_initial', '2025-01-21 14:04:15.921828'),
(3, 'admin_app', '0001_initial', '2025-01-21 14:04:17.374953'),
(4, 'admin_app', '0002_remove_task_sprint', '2025-01-23 05:18:50.600885'),
(5, 'admin_app', '0003_sprint_tasks', '2025-01-23 05:40:02.162949'),
(6, 'admin_app', '0004_sprint_is_active', '2025-01-23 05:46:01.558060'),
(7, 'admin_app', '0005_remove_sprint_is_active', '2025-01-23 05:47:28.085054'),
(8, 'admin_app', '0006_alter_task_status', '2025-01-24 07:54:03.914351'),
(9, 'admin_app', '0007_sprint_completed_tasks_sprint_in_progress_tasks_and_more', '2025-01-25 15:30:42.856283'),
(10, 'admin', '0001_initial', '2025-01-27 06:58:41.115719'),
(11, 'admin', '0002_logentry_remove_auto_add', '2025-01-27 06:58:41.162598'),
(12, 'admin', '0003_logentry_add_action_flag_choices', '2025-01-27 06:58:41.193847'),
(13, 'contenttypes', '0002_remove_content_type_name', '2025-01-27 06:58:41.396969'),
(14, 'auth', '0002_alter_permission_name_max_length', '2025-01-27 06:58:41.600095'),
(15, 'auth', '0003_alter_user_email_max_length', '2025-01-27 06:58:41.662595'),
(16, 'auth', '0004_alter_user_username_opts', '2025-01-27 06:58:41.693844'),
(17, 'auth', '0005_alter_user_last_login_null', '2025-01-27 06:58:41.881346'),
(18, 'auth', '0006_require_contenttypes_0002', '2025-01-27 06:58:41.896990'),
(19, 'auth', '0007_alter_validators_add_error_messages', '2025-01-27 06:58:41.912609'),
(20, 'auth', '0008_alter_user_username_max_length', '2025-01-27 06:58:41.959469'),
(21, 'auth', '0009_alter_user_last_name_max_length', '2025-01-27 06:58:42.006361'),
(22, 'auth', '0010_alter_group_name_max_length', '2025-01-27 06:58:42.084489'),
(23, 'auth', '0011_update_proxy_permissions', '2025-01-27 06:58:42.115741'),
(24, 'auth', '0012_alter_user_first_name_max_length', '2025-01-27 06:58:42.146971'),
(25, 'sessions', '0001_initial', '2025-01-27 06:58:42.240739'),
(26, 'employee_app', '0001_initial', '2025-01-27 07:36:14.231506'),
(27, 'employee_app', '0002_alter_tasktime_options', '2025-01-28 05:08:43.645695'),
(28, 'employee_app', '0003_alter_tasktime_options', '2025-01-28 05:37:07.860939'),
(29, 'employee_app', '0004_alter_tasktime_task', '2025-01-28 06:09:17.445668'),
(30, 'employee_app', '0005_tasktime_total_time', '2025-01-30 07:47:53.806239'),
(31, 'employee_app', '0006_remove_tasktime_total_time', '2025-01-30 07:47:53.868723'),
(32, 'admin_app', '0008_user_password', '2025-01-30 08:43:19.718219'),
(33, 'admin_app', '0009_user_role_alter_comment_user', '2025-01-31 07:02:08.111838'),
(34, 'admin_app', '0010_delete_comment', '2025-02-03 08:38:56.353610'),
(35, 'employee_app', '0007_comment', '2025-02-03 08:46:06.909946'),
(36, 'employee_app', '0008_tasktime_completed_time', '2025-02-04 15:42:17.952907'),
(37, 'employee_app', '0009_tasktime_total_duration', '2025-02-05 10:04:06.905531'),
(38, 'employee_app', '0010_remove_tasktime_total_duration', '2025-02-05 11:25:51.676624'),
(39, 'admin_app', '0011_project_details', '2025-02-10 07:24:20.045005'),
(40, 'admin_app', '0012_projectfunctions', '2025-02-10 08:11:04.432796'),
(41, 'admin_app', '0013_task_function', '2025-02-10 11:48:48.191218'),
(42, 'admin_app', '0014_alter_task_project', '2025-02-11 02:51:03.435056'),
(43, 'admin_app', '0015_alter_projectfunctions_project', '2025-02-13 07:09:57.844843'),
(44, 'admin_app', '0016_alter_task_project_delete_project_details', '2025-02-13 14:26:25.319180'),
(45, 'admin_app', '0017_timelineevent_milestone', '2025-02-24 06:11:57.470494'),
(46, 'admin_app', '0018_remove_timelineevent_timestamp_and_more', '2025-02-25 07:30:22.555893'),
(47, 'admin_app', '0019_alter_timelineevent_end_date_and_more', '2025-02-25 07:30:22.571535'),
(48, 'admin_app', '0020_projectlead', '2025-03-01 06:31:56.610179'),
(49, 'admin_app', '0021_alter_project_status', '2025-03-04 05:27:12.969282'),
(50, 'employee_app', '0011_tasktime_time_spent', '2025-03-10 05:54:13.228790'),
(51, 'employee_app', '0012_remove_tasktime_time_spent', '2025-03-13 05:22:13.606988'),
(52, 'admin_app', '0022_alter_project_status', '2025-03-15 03:23:05.162897'),
(53, 'admin_app', '0023_alter_project_status', '2025-03-15 03:29:18.842950');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('zu35txg3at6y2uvmb8aovq7ff0u5a98n', 'eyJlbXBsb3llZV9pZCI6Imxlb0BnbWFpbC5jb20ifQ:1tv9a2:QUOder6Cy_S5gHOzpX8IYlh_MZgxMoTdLw-y6FHZ4gg', '2025-04-03 06:40:38.915351');

-- --------------------------------------------------------

--
-- Table structure for table `employee_app_comment`
--

CREATE TABLE `employee_app_comment` (
  `id` bigint(20) NOT NULL,
  `content` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `project_id` bigint(20) NOT NULL,
  `user_id` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employee_app_tasktime`
--

CREATE TABLE `employee_app_tasktime` (
  `id` bigint(20) NOT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `stop_time` datetime(6) DEFAULT NULL,
  `task_id` bigint(20) NOT NULL,
  `completed_time` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_app_tasktime`
--

INSERT INTO `employee_app_tasktime` (`id`, `start_time`, `stop_time`, `task_id`, `completed_time`) VALUES
(37, '2025-02-18 08:20:01.229000', '2025-02-18 08:23:31.491000', 33, NULL),
(38, '2025-02-18 08:19:57.944000', '2025-02-18 08:23:36.731000', 31, NULL),
(39, '2025-02-18 08:36:58.312000', '2025-02-18 08:38:10.191000', 33, NULL),
(40, '2025-02-18 08:41:57.902000', '2025-02-18 08:42:02.454000', 31, NULL),
(41, '2025-02-18 08:42:30.186000', '2025-02-18 08:42:33.892000', 31, NULL),
(42, '2025-02-18 08:43:57.495000', '2025-02-18 08:44:02.062000', 31, NULL),
(43, '2025-02-18 08:44:24.723000', '2025-02-18 08:44:36.235000', 31, NULL),
(44, '2025-02-20 05:53:39.043000', '2025-02-20 05:54:46.916000', 31, NULL),
(45, '2025-02-20 06:06:47.932000', '2025-02-20 06:07:52.315000', 31, NULL),
(46, '2025-02-20 07:29:50.852000', '2025-02-20 07:31:43.812000', 35, NULL),
(47, '2025-02-20 07:30:01.908000', '2025-02-20 07:32:12.906000', 33, NULL),
(48, '2025-02-20 07:33:07.682000', '2025-02-20 07:34:10.866000', 35, NULL),
(49, '2025-02-20 07:33:01.347000', '2025-02-20 07:36:46.585000', 33, NULL),
(50, '2025-02-20 07:42:44.501000', '2025-02-20 07:43:50.048000', 35, NULL),
(51, '2025-02-20 07:44:48.134000', '2025-02-20 07:46:08.467000', 32, NULL),
(52, '2025-02-22 07:07:19.981000', '2025-02-22 07:09:36.842000', 32, NULL),
(53, '2025-02-23 06:46:48.279000', '2025-02-23 06:49:07.906000', 32, NULL),
(54, '2025-02-23 15:54:52.948209', '2025-02-23 15:54:52.963832', 31, NULL),
(55, '2025-02-23 15:55:52.854916', '2025-02-23 15:55:52.870557', 31, NULL),
(56, '2025-03-03 07:43:07.084467', '2025-03-03 07:43:07.184659', 37, NULL),
(57, '2025-03-05 05:18:30.286395', '2025-03-05 05:18:30.302030', 32, NULL),
(58, '2025-03-06 04:59:41.522546', '2025-03-06 04:59:41.538174', 34, NULL),
(59, '2025-03-07 05:13:57.314869', '2025-03-07 05:13:57.330509', 36, NULL),
(60, '2025-03-07 06:17:23.865881', '2025-03-07 06:17:23.905884', 36, NULL),
(61, '2025-03-07 06:21:13.347556', '2025-03-07 06:21:13.363549', 36, NULL),
(62, '2025-03-10 06:15:53.376173', '2025-03-10 06:15:53.407423', 34, NULL),
(63, '2025-03-10 07:31:34.239968', '2025-03-10 07:31:34.255595', 34, NULL),
(64, '2025-03-10 07:52:46.823236', '2025-03-10 07:52:46.862872', 34, NULL),
(65, '2025-03-10 07:55:32.364852', '2025-03-10 07:55:32.426132', 34, NULL),
(66, '2025-03-10 08:00:49.446137', '2025-03-10 08:00:49.497985', 34, NULL),
(67, '2025-03-10 08:27:03.314036', '2025-03-10 08:27:03.388730', 34, NULL),
(68, '2025-03-12 07:06:55.056972', '2025-03-12 07:06:55.103872', 34, NULL),
(69, '2025-03-12 07:15:35.400768', '2025-03-12 07:15:35.416412', 36, NULL),
(70, '2025-03-12 07:19:04.237192', '2025-03-12 07:19:04.252815', 34, NULL),
(71, '2025-03-12 07:24:14.862503', '2025-03-12 07:24:14.890184', 38, NULL),
(72, '2025-03-12 07:41:25.280040', '2025-03-12 07:41:25.302208', 38, NULL),
(73, '2025-03-13 05:34:00.293821', '2025-03-13 05:34:00.309468', 38, NULL),
(74, '2025-03-13 05:39:47.831161', '2025-03-13 05:39:47.846798', 31, NULL),
(75, '2025-03-13 05:48:00.012189', '2025-03-13 05:48:00.034329', 38, NULL),
(76, '2025-03-13 05:48:06.129387', '2025-03-13 05:48:06.145006', 38, NULL),
(77, '2025-03-13 05:52:04.146189', '2025-03-13 05:52:04.161846', 38, NULL),
(78, '2025-03-13 05:59:31.702227', '2025-03-13 05:59:31.739994', 38, NULL),
(79, '2025-03-13 07:14:11.840000', '2025-03-13 07:18:51.377000', 38, NULL),
(80, '2025-03-13 07:22:04.376000', '2025-03-13 07:23:04.987000', 34, NULL),
(81, '2025-03-13 07:23:53.880000', '2025-03-13 07:25:24.315000', 36, NULL),
(82, '2025-03-13 07:40:01.120000', '2025-03-13 07:53:04.224000', 36, NULL),
(83, '2025-03-18 05:16:24.950000', '2025-03-18 05:17:26.141000', 37, NULL),
(84, '2025-03-18 06:36:52.630000', '2025-03-18 06:42:53.484000', 37, NULL),
(85, '2025-03-18 07:44:40.443000', '2025-03-18 07:45:41.242000', 38, NULL),
(86, '2025-03-18 08:32:34.096000', '2025-03-18 08:35:37.301000', 38, NULL),
(87, '2025-03-18 08:43:58.644000', '2025-03-18 08:44:59.258000', 36, NULL),
(88, '2025-03-20 05:39:21.941000', '2025-03-20 05:44:22.839000', 39, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_app_milestone`
--
ALTER TABLE `admin_app_milestone`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_app_milestone_project_id_c20e26e7_fk_admin_app_project_id` (`project_id`);

--
-- Indexes for table `admin_app_project`
--
ALTER TABLE `admin_app_project`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `short_code` (`short_code`);

--
-- Indexes for table `admin_app_projectfunctions`
--
ALTER TABLE `admin_app_projectfunctions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_app_projectfun_project_id_e5cd8f31_fk_admin_app` (`project_id`);

--
-- Indexes for table `admin_app_projectlead`
--
ALTER TABLE `admin_app_projectlead`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `project_id` (`project_id`),
  ADD KEY `admin_app_projectlead_user_id_6c623efe_fk_admin_app_user_reg_no` (`user_id`);

--
-- Indexes for table `admin_app_project_assigned`
--
ALTER TABLE `admin_app_project_assigned`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admin_app_project_assigned_project_id_user_id_3f454891_uniq` (`project_id`,`user_id`),
  ADD KEY `admin_app_project_as_user_id_69f80cff_fk_admin_app` (`user_id`);

--
-- Indexes for table `admin_app_sprint`
--
ALTER TABLE `admin_app_sprint`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `admin_app_sprint_completed_tasks`
--
ALTER TABLE `admin_app_sprint_completed_tasks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admin_app_sprint_completed_tasks_sprint_id_task_id_2d3c3737_uniq` (`sprint_id`,`task_id`),
  ADD KEY `admin_app_sprint_com_task_id_9a7b6b20_fk_admin_app` (`task_id`);

--
-- Indexes for table `admin_app_sprint_in_progress_tasks`
--
ALTER TABLE `admin_app_sprint_in_progress_tasks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admin_app_sprint_in_prog_sprint_id_task_id_52d661b8_uniq` (`sprint_id`,`task_id`),
  ADD KEY `admin_app_sprint_in__task_id_653c6a7a_fk_admin_app` (`task_id`);

--
-- Indexes for table `admin_app_sprint_pending_tasks`
--
ALTER TABLE `admin_app_sprint_pending_tasks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admin_app_sprint_pending_tasks_sprint_id_task_id_cf0e8f05_uniq` (`sprint_id`,`task_id`),
  ADD KEY `admin_app_sprint_pen_task_id_438731b8_fk_admin_app` (`task_id`);

--
-- Indexes for table `admin_app_sprint_tasks`
--
ALTER TABLE `admin_app_sprint_tasks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admin_app_sprint_tasks_sprint_id_task_id_ceb1c599_uniq` (`sprint_id`,`task_id`),
  ADD KEY `admin_app_sprint_tasks_task_id_0753eb85_fk_admin_app_task_id` (`task_id`);

--
-- Indexes for table `admin_app_task`
--
ALTER TABLE `admin_app_task`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_app_task_function_id_67f0917e_fk_admin_app` (`function_id`),
  ADD KEY `admin_app_task_project_id_23e787f3_fk_admin_app_project_id` (`project_id`);

--
-- Indexes for table `admin_app_taskprogress`
--
ALTER TABLE `admin_app_taskprogress`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_app_taskprogress_task_id_c603e152_fk_admin_app_task_id` (`task_id`),
  ADD KEY `admin_app_taskprogress_user_id_e049e2d3_fk_admin_app_user_reg_no` (`user_id`);

--
-- Indexes for table `admin_app_task_assigned_to`
--
ALTER TABLE `admin_app_task_assigned_to`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admin_app_task_assigned_to_task_id_user_id_4994c8a8_uniq` (`task_id`,`user_id`),
  ADD KEY `admin_app_task_assig_user_id_b99a23fe_fk_admin_app` (`user_id`);

--
-- Indexes for table `admin_app_timelineevent`
--
ALTER TABLE `admin_app_timelineevent`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_project` (`project_id`);

--
-- Indexes for table `admin_app_user`
--
ALTER TABLE `admin_app_user`
  ADD PRIMARY KEY (`reg_no`);

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Indexes for table `employee_app_comment`
--
ALTER TABLE `employee_app_comment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_app_comment_project_id_bd5e8399_fk_admin_app_project_id` (`project_id`),
  ADD KEY `employee_app_comment_user_id_e35b83c6_fk_admin_app_user_reg_no` (`user_id`);

--
-- Indexes for table `employee_app_tasktime`
--
ALTER TABLE `employee_app_tasktime`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_app_tasktime_task_id_d13171a8_fk_admin_app_task_id` (`task_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_app_milestone`
--
ALTER TABLE `admin_app_milestone`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `admin_app_project`
--
ALTER TABLE `admin_app_project`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `admin_app_projectfunctions`
--
ALTER TABLE `admin_app_projectfunctions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `admin_app_projectlead`
--
ALTER TABLE `admin_app_projectlead`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `admin_app_project_assigned`
--
ALTER TABLE `admin_app_project_assigned`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `admin_app_sprint`
--
ALTER TABLE `admin_app_sprint`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `admin_app_sprint_completed_tasks`
--
ALTER TABLE `admin_app_sprint_completed_tasks`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin_app_sprint_in_progress_tasks`
--
ALTER TABLE `admin_app_sprint_in_progress_tasks`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin_app_sprint_pending_tasks`
--
ALTER TABLE `admin_app_sprint_pending_tasks`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `admin_app_sprint_tasks`
--
ALTER TABLE `admin_app_sprint_tasks`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `admin_app_task`
--
ALTER TABLE `admin_app_task`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `admin_app_taskprogress`
--
ALTER TABLE `admin_app_taskprogress`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin_app_task_assigned_to`
--
ALTER TABLE `admin_app_task_assigned_to`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `admin_app_timelineevent`
--
ALTER TABLE `admin_app_timelineevent`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `employee_app_comment`
--
ALTER TABLE `employee_app_comment`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employee_app_tasktime`
--
ALTER TABLE `employee_app_tasktime`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin_app_milestone`
--
ALTER TABLE `admin_app_milestone`
  ADD CONSTRAINT `admin_app_milestone_project_id_c20e26e7_fk_admin_app_project_id` FOREIGN KEY (`project_id`) REFERENCES `admin_app_project` (`id`);

--
-- Constraints for table `admin_app_projectfunctions`
--
ALTER TABLE `admin_app_projectfunctions`
  ADD CONSTRAINT `admin_app_projectfun_project_id_e5cd8f31_fk_admin_app` FOREIGN KEY (`project_id`) REFERENCES `admin_app_project` (`id`);

--
-- Constraints for table `admin_app_projectlead`
--
ALTER TABLE `admin_app_projectlead`
  ADD CONSTRAINT `admin_app_projectlea_project_id_955a9147_fk_admin_app` FOREIGN KEY (`project_id`) REFERENCES `admin_app_project` (`id`),
  ADD CONSTRAINT `admin_app_projectlead_user_id_6c623efe_fk_admin_app_user_reg_no` FOREIGN KEY (`user_id`) REFERENCES `admin_app_user` (`reg_no`);

--
-- Constraints for table `admin_app_project_assigned`
--
ALTER TABLE `admin_app_project_assigned`
  ADD CONSTRAINT `admin_app_project_as_project_id_f7bbe30c_fk_admin_app` FOREIGN KEY (`project_id`) REFERENCES `admin_app_project` (`id`),
  ADD CONSTRAINT `admin_app_project_as_user_id_69f80cff_fk_admin_app` FOREIGN KEY (`user_id`) REFERENCES `admin_app_user` (`reg_no`);

--
-- Constraints for table `admin_app_sprint_completed_tasks`
--
ALTER TABLE `admin_app_sprint_completed_tasks`
  ADD CONSTRAINT `admin_app_sprint_com_sprint_id_408f99d0_fk_admin_app` FOREIGN KEY (`sprint_id`) REFERENCES `admin_app_sprint` (`id`),
  ADD CONSTRAINT `admin_app_sprint_com_task_id_9a7b6b20_fk_admin_app` FOREIGN KEY (`task_id`) REFERENCES `admin_app_task` (`id`);

--
-- Constraints for table `admin_app_sprint_in_progress_tasks`
--
ALTER TABLE `admin_app_sprint_in_progress_tasks`
  ADD CONSTRAINT `admin_app_sprint_in__sprint_id_4eb3d2d0_fk_admin_app` FOREIGN KEY (`sprint_id`) REFERENCES `admin_app_sprint` (`id`),
  ADD CONSTRAINT `admin_app_sprint_in__task_id_653c6a7a_fk_admin_app` FOREIGN KEY (`task_id`) REFERENCES `admin_app_task` (`id`);

--
-- Constraints for table `admin_app_sprint_pending_tasks`
--
ALTER TABLE `admin_app_sprint_pending_tasks`
  ADD CONSTRAINT `admin_app_sprint_pen_sprint_id_4564c70c_fk_admin_app` FOREIGN KEY (`sprint_id`) REFERENCES `admin_app_sprint` (`id`),
  ADD CONSTRAINT `admin_app_sprint_pen_task_id_438731b8_fk_admin_app` FOREIGN KEY (`task_id`) REFERENCES `admin_app_task` (`id`);

--
-- Constraints for table `admin_app_sprint_tasks`
--
ALTER TABLE `admin_app_sprint_tasks`
  ADD CONSTRAINT `admin_app_sprint_tasks_sprint_id_6c959afb_fk_admin_app_sprint_id` FOREIGN KEY (`sprint_id`) REFERENCES `admin_app_sprint` (`id`),
  ADD CONSTRAINT `admin_app_sprint_tasks_task_id_0753eb85_fk_admin_app_task_id` FOREIGN KEY (`task_id`) REFERENCES `admin_app_task` (`id`);

--
-- Constraints for table `admin_app_task`
--
ALTER TABLE `admin_app_task`
  ADD CONSTRAINT `admin_app_task_function_id_67f0917e_fk_admin_app` FOREIGN KEY (`function_id`) REFERENCES `admin_app_projectfunctions` (`id`),
  ADD CONSTRAINT `admin_app_task_project_id_23e787f3_fk_admin_app_project_id` FOREIGN KEY (`project_id`) REFERENCES `admin_app_project` (`id`);

--
-- Constraints for table `admin_app_taskprogress`
--
ALTER TABLE `admin_app_taskprogress`
  ADD CONSTRAINT `admin_app_taskprogress_task_id_c603e152_fk_admin_app_task_id` FOREIGN KEY (`task_id`) REFERENCES `admin_app_task` (`id`),
  ADD CONSTRAINT `admin_app_taskprogress_user_id_e049e2d3_fk_admin_app_user_reg_no` FOREIGN KEY (`user_id`) REFERENCES `admin_app_user` (`reg_no`);

--
-- Constraints for table `admin_app_task_assigned_to`
--
ALTER TABLE `admin_app_task_assigned_to`
  ADD CONSTRAINT `admin_app_task_assig_user_id_b99a23fe_fk_admin_app` FOREIGN KEY (`user_id`) REFERENCES `admin_app_user` (`reg_no`),
  ADD CONSTRAINT `admin_app_task_assigned_to_task_id_8078033a_fk_admin_app_task_id` FOREIGN KEY (`task_id`) REFERENCES `admin_app_task` (`id`);

--
-- Constraints for table `admin_app_timelineevent`
--
ALTER TABLE `admin_app_timelineevent`
  ADD CONSTRAINT `fk_project` FOREIGN KEY (`project_id`) REFERENCES `admin_app_project` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `employee_app_comment`
--
ALTER TABLE `employee_app_comment`
  ADD CONSTRAINT `employee_app_comment_project_id_bd5e8399_fk_admin_app_project_id` FOREIGN KEY (`project_id`) REFERENCES `admin_app_project` (`id`),
  ADD CONSTRAINT `employee_app_comment_user_id_e35b83c6_fk_admin_app_user_reg_no` FOREIGN KEY (`user_id`) REFERENCES `admin_app_user` (`reg_no`);

--
-- Constraints for table `employee_app_tasktime`
--
ALTER TABLE `employee_app_tasktime`
  ADD CONSTRAINT `employee_app_tasktime_task_id_d13171a8_fk_admin_app_task_id` FOREIGN KEY (`task_id`) REFERENCES `admin_app_task` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
