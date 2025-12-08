-- Active: 1765052611710@@db-mysql-itom-do-user-28250611-0.j.db.ondigitalocean.com@25060@group12
-- ============================================
-- ParkPal Database Schema - DDL Script
-- Database: MySQL Server (group12)
-- Version: 2.0
-- Date: December 7, 2025
-- Description: Data Definition Language (DDL) script for ParkPal
--              National Park Lodging & Review Platform
--              Simplified schema - 5 core tables only
-- ============================================

USE group12;

-- ============================================
-- DROP EXISTING TABLES
-- ============================================
-- Drop in reverse order due to foreign key dependencies

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Park_Review;

DROP TABLE IF EXISTS Trip_Component;

DROP TABLE IF EXISTS Trip;

DROP TABLE IF EXISTS Lodging_Reservation;

DROP TABLE IF EXISTS Lodging;

DROP TABLE IF EXISTS Flight_Booking;

DROP TABLE IF EXISTS Flight;

DROP TABLE IF EXISTS Park_Airport;

DROP TABLE IF EXISTS Airport;

DROP TABLE IF EXISTS National_Park;

DROP TABLE IF EXISTS User;

-- Drop views if they exist
DROP VIEW IF EXISTS v_active_trips;

DROP VIEW IF EXISTS v_park_reviews;

DROP VIEW IF EXISTS v_park_ratings;

DROP VIEW IF EXISTS v_upcoming_flights;

DROP VIEW IF EXISTS v_lodging_by_park;

DROP VIEW IF EXISTS v_user_reservations;

-- Drop procedures if they exist
DROP PROCEDURE IF EXISTS sp_get_trip_details;

DROP PROCEDURE IF EXISTS sp_get_park_details;

DROP PROCEDURE IF EXISTS sp_get_user_dashboard;

-- Drop triggers if they exist
DROP TRIGGER IF EXISTS trg_update_trip_cost;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- TABLE CREATION
-- ============================================

-- --------------------------------------------
-- Table: User
-- Description: User accounts and authentication information
-- --------------------------------------------
CREATE TABLE User (
    User_ID INT AUTO_INCREMENT,
    Email VARCHAR(255) NOT NULL,
    Password_Hash VARCHAR(255) NOT NULL,
    First_Name VARCHAR(100) NOT NULL,
    Last_Name VARCHAR(100) NOT NULL,
    Phone_Number VARCHAR(20),
    Created_At TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (User_ID),
    UNIQUE KEY unique_email (Email),
    INDEX idx_email (Email)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'User accounts and authentication information';

-- --------------------------------------------
-- Table: National_Park
-- Description: All 63 US National Parks information
-- --------------------------------------------
CREATE TABLE National_Park (
    Park_ID INT AUTO_INCREMENT,
    Park_Name VARCHAR(255) NOT NULL,
    State VARCHAR(100) NOT NULL,
    Region VARCHAR(100),
    Description TEXT,
    Wildlife_Information TEXT,
    Plant_Information TEXT,
    Area_Square_Miles DECIMAL(10, 2),
    Annual_Visitors INT,
    Best_Time_To_Visit VARCHAR(100),
    Entry_Fee DECIMAL(10, 2),
    Free_Entry_Days TEXT,
    Official_Website VARCHAR(500),
    Latitude DECIMAL(10, 8),
    Longitude DECIMAL(11, 8),
    Park_Activities_Events TEXT,
    Popular_Park_Trails TEXT,
    Difficulty_Rating VARCHAR(50),
    Kid_Friendliness_Rating INT,
    Pet_Friendliness_Rating INT,
    PRIMARY KEY (Park_ID),
    UNIQUE KEY unique_park_name (Park_Name),
    INDEX idx_state (State),
    INDEX idx_region (Region),
    INDEX idx_park_name (Park_Name)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'All 63 US National Parks information';

-- --------------------------------------------
-- Table: Lodging
-- Description: Lodging options near national parks
-- --------------------------------------------
CREATE TABLE Lodging (
    Lodging_ID INT AUTO_INCREMENT,
    Park_ID INT NOT NULL,
    Lodging_Name VARCHAR(255) NOT NULL,
    Lodging_Type VARCHAR(50) NOT NULL,
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    Zip_Code VARCHAR(10),
    Description TEXT,
    Amenities TEXT,
    Price_Per_Night DECIMAL(10, 2) NOT NULL,
    Contact_Phone VARCHAR(20),
    Contact_Email VARCHAR(255),
    Distance_From_Park_Miles DECIMAL(10, 2),
    Star_Rating DECIMAL(2, 1),
    PRIMARY KEY (Lodging_ID),
    INDEX idx_park_id (Park_ID),
    INDEX idx_lodging_type (Lodging_Type),
    INDEX idx_price (Price_Per_Night),
    CONSTRAINT fk_lodging_park FOREIGN KEY (Park_ID) REFERENCES National_Park (Park_ID) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Lodging options near national parks (hotels, lodges, campgrounds, cabins)';

-- --------------------------------------------
-- Table: Lodging_Reservation
-- Description: Lodging reservation records for users
-- --------------------------------------------
CREATE TABLE Lodging_Reservation (
    Reservation_ID INT AUTO_INCREMENT,
    User_ID INT NOT NULL,
    Lodging_ID INT NOT NULL,
    Check_In_Date DATE NOT NULL,
    Check_Out_Date DATE NOT NULL,
    Number_Of_Guests INT NOT NULL,
    Number_Of_Rooms INT NOT NULL,
    Guest_Name VARCHAR(200) NOT NULL,
    Guest_Phone VARCHAR(20) NOT NULL,
    Guest_Email VARCHAR(255) NOT NULL,
    Confirmation_Number VARCHAR(50) NOT NULL,
    Reservation_Status VARCHAR(50) NOT NULL,
    Total_Cost DECIMAL(10, 2) NOT NULL,
    Created_At TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (Reservation_ID),
    UNIQUE KEY unique_confirmation (Confirmation_Number),
    INDEX idx_user_id (User_ID),
    INDEX idx_lodging_id (Lodging_ID),
    INDEX idx_check_in_date (Check_In_Date),
    INDEX idx_reservation_status (Reservation_Status),
    CONSTRAINT fk_reservation_user FOREIGN KEY (User_ID) REFERENCES User (User_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_reservation_lodging FOREIGN KEY (Lodging_ID) REFERENCES Lodging (Lodging_ID) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Lodging reservation records for users';

-- --------------------------------------------
-- Table: Park_Review
-- Description: User reviews and ratings for national parks
-- --------------------------------------------
CREATE TABLE Park_Review (
    Review_ID INT AUTO_INCREMENT,
    User_ID INT NOT NULL,
    Park_ID INT NOT NULL,
    Rating INT NOT NULL,
    Review_Text TEXT NOT NULL,
    Visit_Date DATE NOT NULL,
    Review_Date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Photo_URLs TEXT,
    PRIMARY KEY (Review_ID),
    INDEX idx_user_id (User_ID),
    INDEX idx_park_id (Park_ID),
    INDEX idx_rating (Rating),
    INDEX idx_review_date (Review_Date),
    CONSTRAINT fk_review_user FOREIGN KEY (User_ID) REFERENCES User (User_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_review_park FOREIGN KEY (Park_ID) REFERENCES National_Park (Park_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_rating CHECK (Rating BETWEEN 1 AND 5)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'User reviews and ratings for national parks';

-- ============================================
-- VIEWS (For common queries and reporting)
-- ============================================

-- View: Park Reviews with User Information
CREATE VIEW v_park_reviews AS
SELECT pr.Review_ID, pr.Rating, pr.Review_Text, pr.Visit_Date, pr.Review_Date, pr.Photo_URLs, u.User_ID, u.First_Name, u.Last_Name, u.Email, np.Park_ID, np.Park_Name, np.State
FROM
    Park_Review pr
    INNER JOIN User u ON pr.User_ID = u.User_ID
    INNER JOIN National_Park np ON pr.Park_ID = np.Park_ID
ORDER BY pr.Review_Date DESC;

-- View: Park Average Ratings
CREATE VIEW v_park_ratings AS
SELECT
    np.Park_ID,
    np.Park_Name,
    np.State,
    COUNT(pr.Review_ID) AS Total_Reviews,
    ROUND(AVG(pr.Rating), 2) AS Average_Rating,
    MIN(pr.Rating) AS Min_Rating,
    MAX(pr.Rating) AS Max_Rating
FROM
    National_Park np
    LEFT JOIN Park_Review pr ON np.Park_ID = pr.Park_ID
GROUP BY
    np.Park_ID,
    np.Park_Name,
    np.State;

-- View: Lodging with Park Information and Average Ratings
CREATE VIEW v_lodging_by_park AS
SELECT
    l.Lodging_ID,
    l.Lodging_Name,
    l.Lodging_Type,
    l.Price_Per_Night,
    l.Star_Rating,
    l.Distance_From_Park_Miles,
    l.City AS Lodging_City,
    l.State AS Lodging_State,
    np.Park_ID,
    np.Park_Name,
    np.State AS Park_State
FROM Lodging l
    INNER JOIN National_Park np ON l.Park_ID = np.Park_ID
ORDER BY np.Park_Name, l.Price_Per_Night;

-- View: User Reservation History
CREATE VIEW v_user_reservations AS
SELECT
    lr.Reservation_ID,
    lr.Confirmation_Number,
    lr.Check_In_Date,
    lr.Check_Out_Date,
    lr.Number_Of_Guests,
    lr.Number_Of_Rooms,
    lr.Reservation_Status,
    lr.Total_Cost,
    lr.Created_At,
    u.User_ID,
    u.First_Name,
    u.Last_Name,
    u.Email,
    l.Lodging_ID,
    l.Lodging_Name,
    l.Lodging_Type,
    np.Park_ID,
    np.Park_Name,
    np.State AS Park_State
FROM
    Lodging_Reservation lr
    INNER JOIN User u ON lr.User_ID = u.User_ID
    INNER JOIN Lodging l ON lr.Lodging_ID = l.Lodging_ID
    INNER JOIN National_Park np ON l.Park_ID = np.Park_ID
ORDER BY lr.Check_In_Date DESC;

-- ============================================
-- STORED PROCEDURES
-- ============================================

DELIMITER / /

-- Procedure: Get Park Details with Lodging and Reviews
CREATE PROCEDURE sp_get_park_details(IN p_park_id INT)
BEGIN
    -- Get park basic information
    SELECT * FROM National_Park WHERE Park_ID = p_park_id;
    
    -- Get park ratings summary
    SELECT * FROM v_park_ratings WHERE Park_ID = p_park_id;
    
    -- Get available lodging near this park
    SELECT * FROM Lodging WHERE Park_ID = p_park_id ORDER BY Price_Per_Night;
    
    -- Get recent reviews for this park
    SELECT * FROM v_park_reviews WHERE Park_ID = p_park_id ORDER BY Review_Date DESC LIMIT 10;
END //

-- Procedure: Get User Dashboard Data
CREATE PROCEDURE sp_get_user_dashboard(IN p_user_id INT)
BEGIN
    -- Get user information
    SELECT * FROM User WHERE User_ID = p_user_id;
    
    -- Get upcoming reservations
    SELECT * FROM v_user_reservations 
    WHERE User_ID = p_user_id 
        AND Check_In_Date >= CURDATE()
        AND Reservation_Status IN ('confirmed', 'pending')
    ORDER BY Check_In_Date;
    
    -- Get past reservations
    SELECT * FROM v_user_reservations 
    WHERE User_ID = p_user_id 
        AND Check_Out_Date < CURDATE()
    ORDER BY Check_Out_Date DESC
    LIMIT 5;
    
    -- Get user's reviews
    SELECT * FROM v_park_reviews 
    WHERE User_ID = p_user_id 
    ORDER BY Review_Date DESC
    LIMIT 10;
END //

DELIMITER;

-- ============================================
-- TRIGGERS
-- ============================================

DELIMITER / /

-- Trigger: Validate reservation dates
CREATE TRIGGER trg_validate_reservation_dates
BEFORE INSERT ON Lodging_Reservation
FOR EACH ROW
BEGIN
    IF NEW.Check_Out_Date <= NEW.Check_In_Date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Check-out date must be after check-in date';
    END IF;
    
    IF NEW.Check_In_Date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Check-in date cannot be in the past';
    END IF;
END //

-- Trigger: Auto-generate confirmation number if not provided
CREATE TRIGGER trg_generate_confirmation_number
BEFORE INSERT ON Lodging_Reservation
FOR EACH ROW
BEGIN
    IF NEW.Confirmation_Number IS NULL OR NEW.Confirmation_Number = '' THEN
        SET NEW.Confirmation_Number = CONCAT('RES-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(NEW.Reservation_ID, 6, '0'));
    END IF;
END //

DELIMITER;

-- ============================================
-- DATABASE SCHEMA VERIFICATION
-- ============================================

-- Show all tables in current database
SHOW TABLES;

-- Count tables created
SELECT COUNT(*) AS Tables_Created
FROM information_schema.TABLES
WHERE
    TABLE_SCHEMA = DATABASE()
    AND TABLE_TYPE = 'BASE TABLE';

-- Count views created
SELECT COUNT(*) AS Views_Created
FROM information_schema.VIEWS
WHERE
    TABLE_SCHEMA = DATABASE();

-- ============================================
-- END OF DDL SCRIPT
-- ============================================

-- Script execution completed successfully
-- Tables Created: 5
-- Views Created: 4
-- Stored Procedures Created: 2
-- Triggers Created: 2