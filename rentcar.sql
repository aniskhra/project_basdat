-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 06, 2023 at 07:02 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rentcar`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateMinCharge` ()   BEGIN
    SELECT MIN(charge)
    FROM (
        SELECT SUM(charge) AS charge, rental_id
        FROM (
            SELECT rental_id, amount * count AS charge
            FROM rental_rate
            JOIN promotion_rate ON rental_rate.duration = promotion_rate.duration AND rental_rate.class_code = promotion_rate.class_code
        ) AS T
        GROUP BY rental_id
    ) AS T1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateTotalCharge` ()   BEGIN
    SELECT rental_id, SUM(charge) AS total_charge
    FROM (
        SELECT rental_id, amount * count AS charge
        FROM rental_rate
        JOIN promotion_rate ON rental_rate.duration = promotion_rate.duration AND rental_rate.class_code = promotion_rate.class_code
    ) AS T
    GROUP BY rental_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DisplayCompletedRentals` ()   BEGIN
    SELECT SUM(charge) AS total_charge, rental_id
    FROM (
        SELECT rental.rental_id, rental_rate.amount * rental_rate.count AS charge
        FROM rental
        JOIN rental_rate ON rental.class_code = rental_rate.class_code
        JOIN promotion_rate ON rental_rate.duration = promotion_rate.duration AND rental_rate.class_code = promotion_rate.class_code
        WHERE rental.to_date IS NOT NULL
    ) AS T
    GROUP BY rental_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `address`
--

CREATE TABLE `address` (
  `address_id` int(11) NOT NULL,
  `street_num` char(10) NOT NULL,
  `street_name` char(100) NOT NULL,
  `city` char(30) NOT NULL,
  `province` char(30) NOT NULL,
  `postal_code` char(10) NOT NULL,
  `is_headquarter` char(1) NOT NULL
) ;

--
-- Dumping data for table `address`
--

INSERT INTO `address` (`address_id`, `street_num`, `street_name`, `city`, `province`, `postal_code`, `is_headquarter`) VALUES
(1, '123', 'Main St', 'Edmonton', 'AL', 'A1B2C3', '0'),
(2, '456', 'Oak St', 'Vancouver', 'BC', 'X1Y2Z3', '0'),
(3, '789', 'Elm St', 'Winnipeg', 'MA', 'M1N2O3', '0'),
(4, '101', 'Cedar St', 'Fredericton', 'NB', 'E1P2Q3', '0'),
(5, '202', 'Spruce St', 'St. Johns', 'NL', 'N1R2S3', '0'),
(6, '303', 'Pine St', 'Yellowknife', 'NT', 'T1U2V3', '0'),
(7, '404', 'Birch St', 'Halifax', 'NS', 'S1W2X3', '0'),
(8, '505', 'Willow St', 'Iqaluit', 'NU', 'U1Y2Z3', '0'),
(9, '111', 'Hamilton St', 'Hamilton', 'ON', 'O1P2Q3', 'H'),
(10, '707', 'Prince St', 'Charlottetown', 'PE', 'P1Q2R3', '0');

-- --------------------------------------------------------

--
-- Table structure for table `car`
--

CREATE TABLE `car` (
  `car_id` int(11) NOT NULL,
  `class_code` char(1) NOT NULL,
  `car_loc` int(11) NOT NULL,
  `make` char(10) NOT NULL,
  `model` char(20) NOT NULL,
  `year` char(4) NOT NULL,
  `colour` char(10) NOT NULL,
  `lic_plate` char(8) NOT NULL
) ;

--
-- Dumping data for table `car`
--

INSERT INTO `car` (`car_id`, `class_code`, `car_loc`, `make`, `model`, `year`, `colour`, `lic_plate`) VALUES
(1, 'B', 1, 'Toyota', 'Yaris', '2022', 'Silver', 'ABC123'),
(2, 'C', 2, 'Honda', 'Civic', '2021', 'Blue', 'XYZ456'),
(3, 'S', 3, 'Ford', 'Fusion', '2020', 'Black', 'DEF789'),
(4, 'B', 4, 'Chevrolet', 'Spark', '2022', 'Yellow', 'GHI101'),
(5, 'C', 5, 'Nissan', 'Sentra', '2021', 'Silver', 'JKL202'),
(6, 'S', 6, 'Hyundai', 'Sonata', '2020', 'White', 'MNO303'),
(7, 'L', 7, 'Mercedes', 'S-Class', '2022', 'Silver', 'PQR404'),
(8, 'B', 8, 'Kia', 'Rio', '2021', 'Green', 'STU505'),
(9, 'C', 9, 'Mazda', 'Mazda3', '2020', 'Blue', 'VWX606'),
(10, 'S', 10, 'BMW', '3 Series', '2022', 'Black', 'YZA707');

-- --------------------------------------------------------

--
-- Table structure for table `car_class`
--

CREATE TABLE `car_class` (
  `class_code` char(1) NOT NULL,
  `class_desc` varchar(20) NOT NULL CHECK (`class_code` in ('B','C','S','L'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `car_class`
--

INSERT INTO `car_class` (`class_code`, `class_desc`) VALUES
('B', 'Subcompact'),
('C', 'Compact'),
('L', 'Luxury'),
('S', 'Sedan');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `driver_lic` char(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`driver_lic`) VALUES
('D003'),
('D005'),
('D006'),
('D007'),
('D008'),
('D009'),
('D010');

-- --------------------------------------------------------

--
-- Table structure for table `dropoff_charge`
--

CREATE TABLE `dropoff_charge` (
  `class_code` char(1) NOT NULL,
  `from_loc` int(11) NOT NULL,
  `to_loc` int(11) NOT NULL,
  `charge` decimal(4,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dropoff_charge`
--

INSERT INTO `dropoff_charge` (`class_code`, `from_loc`, `to_loc`, `charge`) VALUES
('B', 7, 8, '7.00'),
('C', 2, 6, '18.00'),
('L', 1, 2, '22.00'),
('S', 3, 4, '17.00');

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `driver_lic` char(20) NOT NULL,
  `work_loc` int(11) NOT NULL,
  `employee_type` char(1) NOT NULL,
  `is_president` char(1) NOT NULL,
  `is_vice_president` char(1) NOT NULL
) ;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`driver_lic`, `work_loc`, `employee_type`, `is_president`, `is_vice_president`) VALUES
('D001', 9, 'M', 'P', '0'),
('D002', 7, 'C', '0', '0'),
('D003', 9, 'M', '0', 'M'),
('D004', 4, 'D', '0', '0'),
('D005', 9, 'M', '0', 'P');

-- --------------------------------------------------------

--
-- Table structure for table `employee_type`
--

CREATE TABLE `employee_type` (
  `employee_type` char(1) NOT NULL
) ;

--
-- Dumping data for table `employee_type`
--

INSERT INTO `employee_type` (`employee_type`) VALUES
('C'),
('D'),
('K'),
('M');

-- --------------------------------------------------------

--
-- Table structure for table `person`
--

CREATE TABLE `person` (
  `driver_lic` char(20) NOT NULL,
  `first_name` char(50) NOT NULL,
  `last_name` char(50) NOT NULL,
  `address_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `person`
--

INSERT INTO `person` (`driver_lic`, `first_name`, `last_name`, `address_id`) VALUES
('D001', 'John', 'Doe', 1),
('D002', 'Jane', 'Smith', 5),
('D003', 'Bob', 'Johnson', 8),
('D004', 'Anne', 'Marie', 7),
('D005', 'James', 'Arthur', 10),
('D006', 'Christina', 'Perri', 9),
('D007', 'Dean', 'Lewis', 2),
('D008', 'Ethan', 'Lee', 3),
('D009', 'Vicky', 'Jang', 6),
('D010', 'Steve', 'Park', 4);

-- --------------------------------------------------------

--
-- Table structure for table `phone`
--

CREATE TABLE `phone` (
  `phone_num` char(20) NOT NULL,
  `driver_lic` char(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `phone`
--

INSERT INTO `phone` (`phone_num`, `driver_lic`) VALUES
('123-456-7890', 'D001'),
('202-555-0183', 'D004'),
('202-659-7996', 'D005'),
('213-757-9810', 'D007'),
('328-074-3451', 'D006'),
('407-312-4573', 'D009'),
('549-612-2986', 'D008'),
('705-242-8366', 'D003'),
('854-671-3632', 'D010'),
('987-654-3210', 'D002');

-- --------------------------------------------------------

--
-- Table structure for table `promotion`
--

CREATE TABLE `promotion` (
  `duration` char(1) NOT NULL,
  `class_code` char(1) NOT NULL,
  `from_date` date NOT NULL,
  `percentage` decimal(4,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `promotion`
--

INSERT INTO `promotion` (`duration`, `class_code`, `from_date`, `percentage`) VALUES
('W', 'B', '2023-12-01', '0.60'),
('W', 'C', '2023-11-08', '0.60'),
('W', 'L', '2024-02-21', '0.55'),
('W', 'S', '2023-11-15', '0.55');

-- --------------------------------------------------------

--
-- Table structure for table `promotion_rate`
--

CREATE TABLE `promotion_rate` (
  `duration` char(1) NOT NULL,
  `class_code` char(1) NOT NULL,
  `amount` decimal(8,2) NOT NULL
) ;

--
-- Dumping data for table `promotion_rate`
--

INSERT INTO `promotion_rate` (`duration`, `class_code`, `amount`) VALUES
('D', 'B', '30.00'),
('D', 'C', '35.00'),
('D', 'L', '50.00'),
('D', 'S', '40.00'),
('M', 'B', '1000.00'),
('M', 'C', '1200.00'),
('M', 'L', '1500.00'),
('M', 'S', '1300.00'),
('T', 'B', '280.00'),
('T', 'C', '330.00'),
('T', 'L', '550.00'),
('T', 'S', '380.00'),
('W', 'B', '150.00'),
('W', 'C', '180.00'),
('W', 'L', '300.00'),
('W', 'S', '200.00');

-- --------------------------------------------------------

--
-- Table structure for table `rental`
--

CREATE TABLE `rental` (
  `rental_id` int(11) NOT NULL,
  `driver_lic` char(20) NOT NULL,
  `car_id` int(11) NOT NULL,
  `from_loc` int(11) NOT NULL,
  `dropoff_loc` int(11) NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date DEFAULT NULL,
  `tank_stats` char(1) NOT NULL,
  `init_odo` int(11) NOT NULL,
  `return_odo` int(11) DEFAULT NULL
) ;

--
-- Dumping data for table `rental`
--

INSERT INTO `rental` (`rental_id`, `driver_lic`, `car_id`, `from_loc`, `dropoff_loc`, `from_date`, `to_date`, `tank_stats`, `init_odo`, `return_odo`) VALUES
(1, 'D005', 7, 9, 9, '2023-11-01', '2023-11-02', 'F', 10000, 10050),
(2, 'D006', 3, 3, 4, '2023-11-08', '2023-11-15', 'H', 8500, 9200),
(3, 'D007', 9, 2, 6, '2023-11-05', '2023-11-10', 'Q', 12000, 12250),
(4, 'D008', 4, 7, 2, '2023-12-01', '2023-12-15', 'T', 9500, 10300),
(5, 'D009', 1, 10, 10, '2024-01-10', '2024-02-10', 'E', 11000, 16000),
(6, 'D003', 5, 1, 2, '2023-11-20', NULL, 'F', 8500, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `rental_rate`
--

CREATE TABLE `rental_rate` (
  `rental_id` int(11) NOT NULL,
  `duration` char(1) NOT NULL,
  `class_code` char(1) NOT NULL,
  `count` int(11) NOT NULL
) ;

--
-- Dumping data for table `rental_rate`
--

INSERT INTO `rental_rate` (`rental_id`, `duration`, `class_code`, `count`) VALUES
(1, 'D', 'L', 1),
(2, 'W', 'S', 1),
(3, 'D', 'C', 5),
(4, 'T', 'B', 1),
(5, 'M', 'B', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address`
--
ALTER TABLE `address`
  ADD PRIMARY KEY (`address_id`),
  ADD UNIQUE KEY `street_num` (`street_num`,`street_name`,`city`,`province`);

--
-- Indexes for table `car`
--
ALTER TABLE `car`
  ADD PRIMARY KEY (`car_id`),
  ADD KEY `class_code` (`class_code`),
  ADD KEY `car_loc` (`car_loc`);

--
-- Indexes for table `car_class`
--
ALTER TABLE `car_class`
  ADD PRIMARY KEY (`class_code`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`driver_lic`);

--
-- Indexes for table `dropoff_charge`
--
ALTER TABLE `dropoff_charge`
  ADD PRIMARY KEY (`class_code`,`from_loc`,`to_loc`),
  ADD KEY `from_loc` (`from_loc`),
  ADD KEY `to_loc` (`to_loc`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`driver_lic`),
  ADD KEY `work_loc` (`work_loc`),
  ADD KEY `employee_type` (`employee_type`);

--
-- Indexes for table `employee_type`
--
ALTER TABLE `employee_type`
  ADD PRIMARY KEY (`employee_type`);

--
-- Indexes for table `person`
--
ALTER TABLE `person`
  ADD PRIMARY KEY (`driver_lic`),
  ADD KEY `address_id` (`address_id`);

--
-- Indexes for table `phone`
--
ALTER TABLE `phone`
  ADD PRIMARY KEY (`phone_num`,`driver_lic`),
  ADD KEY `driver_lic` (`driver_lic`);

--
-- Indexes for table `promotion`
--
ALTER TABLE `promotion`
  ADD PRIMARY KEY (`duration`,`class_code`),
  ADD KEY `class_code` (`class_code`);

--
-- Indexes for table `promotion_rate`
--
ALTER TABLE `promotion_rate`
  ADD PRIMARY KEY (`duration`,`class_code`),
  ADD KEY `class_code` (`class_code`);

--
-- Indexes for table `rental`
--
ALTER TABLE `rental`
  ADD PRIMARY KEY (`rental_id`),
  ADD UNIQUE KEY `car_id` (`car_id`,`from_date`),
  ADD KEY `driver_lic` (`driver_lic`),
  ADD KEY `from_loc` (`from_loc`),
  ADD KEY `dropoff_loc` (`dropoff_loc`);

--
-- Indexes for table `rental_rate`
--
ALTER TABLE `rental_rate`
  ADD PRIMARY KEY (`rental_id`,`duration`,`class_code`),
  ADD KEY `duration` (`duration`),
  ADD KEY `class_code` (`class_code`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `car`
--
ALTER TABLE `car`
  ADD CONSTRAINT `car_ibfk_1` FOREIGN KEY (`class_code`) REFERENCES `car_class` (`class_code`),
  ADD CONSTRAINT `car_ibfk_2` FOREIGN KEY (`car_loc`) REFERENCES `address` (`address_id`);

--
-- Constraints for table `customer`
--
ALTER TABLE `customer`
  ADD CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`driver_lic`) REFERENCES `person` (`driver_lic`);

--
-- Constraints for table `dropoff_charge`
--
ALTER TABLE `dropoff_charge`
  ADD CONSTRAINT `dropoff_charge_ibfk_1` FOREIGN KEY (`class_code`) REFERENCES `car_class` (`class_code`),
  ADD CONSTRAINT `dropoff_charge_ibfk_2` FOREIGN KEY (`from_loc`) REFERENCES `address` (`address_id`),
  ADD CONSTRAINT `dropoff_charge_ibfk_3` FOREIGN KEY (`to_loc`) REFERENCES `address` (`address_id`);

--
-- Constraints for table `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`driver_lic`) REFERENCES `person` (`driver_lic`),
  ADD CONSTRAINT `employee_ibfk_2` FOREIGN KEY (`work_loc`) REFERENCES `address` (`address_id`),
  ADD CONSTRAINT `employee_ibfk_3` FOREIGN KEY (`employee_type`) REFERENCES `employee_type` (`employee_type`);

--
-- Constraints for table `person`
--
ALTER TABLE `person`
  ADD CONSTRAINT `person_ibfk_1` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`);

--
-- Constraints for table `phone`
--
ALTER TABLE `phone`
  ADD CONSTRAINT `phone_ibfk_1` FOREIGN KEY (`driver_lic`) REFERENCES `person` (`driver_lic`);

--
-- Constraints for table `promotion`
--
ALTER TABLE `promotion`
  ADD CONSTRAINT `promotion_ibfk_1` FOREIGN KEY (`duration`) REFERENCES `promotion_rate` (`duration`),
  ADD CONSTRAINT `promotion_ibfk_2` FOREIGN KEY (`class_code`) REFERENCES `promotion_rate` (`class_code`);

--
-- Constraints for table `promotion_rate`
--
ALTER TABLE `promotion_rate`
  ADD CONSTRAINT `promotion_rate_ibfk_1` FOREIGN KEY (`class_code`) REFERENCES `car_class` (`class_code`);

--
-- Constraints for table `rental`
--
ALTER TABLE `rental`
  ADD CONSTRAINT `rental_ibfk_1` FOREIGN KEY (`car_id`) REFERENCES `car` (`car_id`),
  ADD CONSTRAINT `rental_ibfk_2` FOREIGN KEY (`driver_lic`) REFERENCES `customer` (`driver_lic`),
  ADD CONSTRAINT `rental_ibfk_3` FOREIGN KEY (`from_loc`) REFERENCES `address` (`address_id`),
  ADD CONSTRAINT `rental_ibfk_4` FOREIGN KEY (`dropoff_loc`) REFERENCES `address` (`address_id`);

--
-- Constraints for table `rental_rate`
--
ALTER TABLE `rental_rate`
  ADD CONSTRAINT `rental_rate_ibfk_1` FOREIGN KEY (`rental_id`) REFERENCES `rental` (`rental_id`),
  ADD CONSTRAINT `rental_rate_ibfk_2` FOREIGN KEY (`duration`) REFERENCES `promotion_rate` (`duration`),
  ADD CONSTRAINT `rental_rate_ibfk_3` FOREIGN KEY (`class_code`) REFERENCES `promotion_rate` (`class_code`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
