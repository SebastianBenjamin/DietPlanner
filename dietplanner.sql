-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 16, 2025 at 01:21 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dietplanner`
--

-- --------------------------------------------------------

--
-- Table structure for table `diets`
--

CREATE TABLE `diets` (
  `diet_id` int(11) NOT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `diet_name` varchar(255) NOT NULL,
  `diet_preference` varchar(255) DEFAULT NULL,
  `diet_type` varchar(255) DEFAULT NULL,
  `exercise` bit(1) DEFAULT NULL,
  `total_meals` int(11) DEFAULT NULL,
  `water_intake` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `diets`
--

INSERT INTO `diets` (`diet_id`, `created_by`, `diet_name`, `diet_preference`, `diet_type`, `exercise`, `total_meals`, `water_intake`) VALUES
(1, NULL, 'Keto Diet', 'Non-Veg', 'Low-Carb', b'1', 3, 8),
(2, NULL, 'Vegan Diet', 'Veg', 'Plant-Based', b'0', 4, 10),
(3, NULL, 'Paleo Diet', 'Non-Veg', 'Whole Food', b'1', 3, 9),
(4, NULL, 'Mediterranean Diet', 'Veg', 'Balanced', b'1', 5, 12),
(5, NULL, 'High-Protein Diet', 'Non-Veg', 'Weight-Loss', b'0', 4, 7),
(6, '3', 'Ben\'s Diet', 'Vegetarian', 'Low Carb', b'1', 5, 10);

-- --------------------------------------------------------

--
-- Table structure for table `logdata`
--

CREATE TABLE `logdata` (
  `log_id` bigint(20) NOT NULL,
  `log_date` date NOT NULL,
  `exercise` tinyint(1) DEFAULT 0,
  `meal1` tinyint(1) DEFAULT 0,
  `meal2` tinyint(1) DEFAULT 0,
  `meal3` tinyint(1) DEFAULT 0,
  `meal4` tinyint(1) DEFAULT 0,
  `meal5` tinyint(1) DEFAULT 0,
  `meal6` tinyint(1) DEFAULT 0,
  `streak` int(11) DEFAULT 0,
  `water` int(11) DEFAULT 0,
  `diet_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `logdata`
--

INSERT INTO `logdata` (`log_id`, `log_date`, `exercise`, `meal1`, `meal2`, `meal3`, `meal4`, `meal5`, `meal6`, `streak`, `water`, `diet_id`, `user_id`) VALUES
(16, '2025-05-11', 0, 1, 1, 1, 1, 0, 0, 7, 7000, 5, 3),
(17, '2025-05-14', 0, 1, 1, 1, 1, 0, 0, 8, 7000, 5, 3);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `current_streak` int(11) DEFAULT 0,
  `date_of_birth` date DEFAULT NULL,
  `dietary_preference` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `height` double DEFAULT NULL,
  `log_date` date DEFAULT NULL,
  `log_id` int(11) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `weight` double DEFAULT NULL,
  `diet_id` int(11) DEFAULT NULL,
  `last_streakUpdate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `current_streak`, `date_of_birth`, `dietary_preference`, `email`, `full_name`, `gender`, `height`, `log_date`, `log_id`, `password`, `phone_number`, `weight`, `diet_id`, `last_streakUpdate`) VALUES
(2, 0, '2004-03-16', 'Non Vegetarian', 'benjaminsebastian156@gmail.com', 'BENJAMIN SEBASTIAN', 'Male', 180, '2025-05-10', 4, '12345678', '09744087190', 45, 1, NULL),
(3, 8, '2000-01-01', 'Non Vegetarian', 'user@user', 'user', 'Male', 181, '2025-05-14', 17, 'user', '12345678', 42, 6, '2025-05-14');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `diets`
--
ALTER TABLE `diets`
  ADD PRIMARY KEY (`diet_id`);

--
-- Indexes for table `logdata`
--
ALTER TABLE `logdata`
  ADD PRIMARY KEY (`log_id`),
  ADD UNIQUE KEY `UKg8na91loa7w4pi7l3uplihmfs` (`log_date`,`user_id`),
  ADD KEY `FK91xopelpmwcqf36oowgrfd7qn` (`diet_id`),
  ADD KEY `FKebahix33mihfapy5eh2xr94hn` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `UK6dotkott2kjsp8vw4d0m25fb7` (`email`),
  ADD KEY `FKl3ngrbm3397tc1kt3ay6gyyxe` (`diet_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `diets`
--
ALTER TABLE `diets`
  MODIFY `diet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `logdata`
--
ALTER TABLE `logdata`
  MODIFY `log_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `logdata`
--
ALTER TABLE `logdata`
  ADD CONSTRAINT `FK91xopelpmwcqf36oowgrfd7qn` FOREIGN KEY (`diet_id`) REFERENCES `diets` (`diet_id`),
  ADD CONSTRAINT `FKebahix33mihfapy5eh2xr94hn` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `FKl3ngrbm3397tc1kt3ay6gyyxe` FOREIGN KEY (`diet_id`) REFERENCES `diets` (`diet_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
