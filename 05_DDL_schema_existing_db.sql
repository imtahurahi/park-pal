SHOW TABLES;
-- ============================================
-- ParkPal Database Schema - DDL Script
-- Database: MySQL Server
-- Version: 1.0 (Modified for existing database)
-- Date: December 6, 2025
-- Description: Data Definition Language (DDL) script for ParkPal
--              National Park Trip Planning Platform
-- Note: This version assumes database already exists
-- ============================================
-- Use existing database (change 'defaultdb' to your actual database name if different)
-- Common DigitalOcean default database names: defaultdb, group12, or similar
USE group12;

-- Drop existing tables if they exist (in reverse order due to foreign keys)
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

-- Drop procedures if they exist
DROP PROCEDURE IF EXISTS sp_get_trip_details;

-- Drop triggers if they exist
DROP TRIGGER IF EXISTS trg_update_trip_cost;

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
-- Table: Airport
-- Description: Airport information including DFW and airports near national parks
-- --------------------------------------------
CREATE TABLE Airport (
    Airport_ID INT AUTO_INCREMENT,
    Airport_Code VARCHAR(3) NOT NULL,
    Airport_Name VARCHAR(255) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    Latitude DECIMAL(10, 8),
    Longitude DECIMAL(11, 8),
    PRIMARY KEY (Airport_ID),
    UNIQUE KEY unique_airport_code (Airport_Code),
    INDEX idx_airport_code (Airport_Code),
    INDEX idx_city (City),
    INDEX idx_state (State)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Airport information including DFW and airports near national parks';

-- --------------------------------------------
-- Table: Park_Airport (Junction Table)
-- Description: Links parks to nearby airports with distances
-- --------------------------------------------
CREATE TABLE Park_Airport (
    Park_ID INT NOT NULL,
    Airport_ID INT NOT NULL,
    Distance_Miles DECIMAL(10, 2),
    PRIMARY KEY (Park_ID, Airport_ID),
    INDEX idx_park_id (Park_ID),
    INDEX idx_airport_id (Airport_ID),
    CONSTRAINT fk_park_airport_park FOREIGN KEY (Park_ID) REFERENCES National_Park (Park_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_park_airport_airport FOREIGN KEY (Airport_ID) REFERENCES Airport (Airport_ID) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Junction table linking parks to nearby airports with distances';

-- --------------------------------------------
-- Table: Flight
-- Description: Flight information and availability
-- --------------------------------------------
CREATE TABLE Flight (
    Flight_ID INT AUTO_INCREMENT,
    Airline VARCHAR(100) NOT NULL,
    Flight_Number VARCHAR(20) NOT NULL,
    Departure_Airport_ID INT NOT NULL,
    Arrival_Airport_ID INT NOT NULL,
    Departure_Time TIMESTAMP NOT NULL,
    Arrival_Time TIMESTAMP NOT NULL,
    Duration_Minutes INT,
    Number_Of_Stops INT DEFAULT 0,
    Price DECIMAL(10, 2) NOT NULL,
    Available_Seats INT NOT NULL,
    PRIMARY KEY (Flight_ID),
    INDEX idx_departure_airport (Departure_Airport_ID),
    INDEX idx_arrival_airport (Arrival_Airport_ID),
    INDEX idx_departure_time (Departure_Time),
    INDEX idx_airline (Airline),
    INDEX idx_flight_number (Flight_Number),
    CONSTRAINT fk_flight_departure_airport FOREIGN KEY (Departure_Airport_ID) REFERENCES Airport (Airport_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_flight_arrival_airport FOREIGN KEY (Arrival_Airport_ID) REFERENCES Airport (Airport_ID) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Flight information and availability';

-- --------------------------------------------
-- Table: Flight_Booking
-- Description: Flight booking records for users
-- --------------------------------------------
CREATE TABLE Flight_Booking (
    Booking_ID INT AUTO_INCREMENT,
    User_ID INT NOT NULL,
    Flight_ID INT NOT NULL,
    Passenger_First_Name VARCHAR(100) NOT NULL,
    Passenger_Last_Name VARCHAR(100) NOT NULL,
    Passenger_DOB DATE NOT NULL,
    Confirmation_Number VARCHAR(50) NOT NULL,
    Booking_Status VARCHAR(50) NOT NULL,
    Booking_Date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Total_Cost DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (Booking_ID),
    UNIQUE KEY unique_confirmation (Confirmation_Number),
    INDEX idx_user_id (User_ID),
    INDEX idx_flight_id (Flight_ID),
    INDEX idx_confirmation_number (Confirmation_Number),
    INDEX idx_booking_status (Booking_Status),
    INDEX idx_booking_date (Booking_Date),
    CONSTRAINT fk_flight_booking_user FOREIGN KEY (User_ID) REFERENCES User (User_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_flight_booking_flight FOREIGN KEY (Flight_ID) REFERENCES Flight (Flight_ID) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Flight booking records for users';

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
    INDEX idx_star_rating (Star_Rating),
    INDEX idx_city (City),
    INDEX idx_state (State),
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
    INDEX idx_confirmation_number (Confirmation_Number),
    INDEX idx_check_in_date (Check_In_Date),
    INDEX idx_check_out_date (Check_Out_Date),
    INDEX idx_reservation_status (Reservation_Status),
    CONSTRAINT fk_lodging_reservation_user FOREIGN KEY (User_ID) REFERENCES User (User_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_lodging_reservation_lodging FOREIGN KEY (Lodging_ID) REFERENCES Lodging (Lodging_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_checkout_after_checkin CHECK (
        Check_Out_Date > Check_In_Date
    )
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Lodging reservation records for users';

-- --------------------------------------------
-- Table: Trip
-- Description: Trip planning and tracking for users
-- --------------------------------------------
CREATE TABLE Trip (
    Trip_ID INT AUTO_INCREMENT,
    User_ID INT NOT NULL,
    Park_ID INT NOT NULL,
    Trip_Start_Date DATE NOT NULL,
    Trip_End_Date DATE NOT NULL,
    Trip_Status VARCHAR(50) NOT NULL,
    Total_Cost DECIMAL(10, 2),
    Created_At TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (Trip_ID),
    INDEX idx_user_id (User_ID),
    INDEX idx_park_id (Park_ID),
    INDEX idx_trip_status (Trip_Status),
    INDEX idx_trip_start_date (Trip_Start_Date),
    INDEX idx_trip_end_date (Trip_End_Date),
    CONSTRAINT fk_trip_user FOREIGN KEY (User_ID) REFERENCES User (User_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_trip_park FOREIGN KEY (Park_ID) REFERENCES National_Park (Park_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_trip_end_after_start CHECK (
        Trip_End_Date >= Trip_Start_Date
    )
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Trip planning and tracking for users';

-- --------------------------------------------
-- Table: Trip_Component (Junction Table)
-- Description: Links trips to flight bookings and lodging reservations
-- --------------------------------------------
CREATE TABLE Trip_Component (
    Trip_ID INT NOT NULL,
    Flight_Booking_ID INT,
    Lodging_Reservation_ID INT,
    PRIMARY KEY (Trip_ID),
    INDEX idx_flight_booking_id (Flight_Booking_ID),
    INDEX idx_lodging_reservation_id (Lodging_Reservation_ID),
    CONSTRAINT fk_trip_component_trip FOREIGN KEY (Trip_ID) REFERENCES Trip (Trip_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_trip_component_flight_booking FOREIGN KEY (Flight_Booking_ID) REFERENCES Flight_Booking (Booking_ID) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_trip_component_lodging_reservation FOREIGN KEY (Lodging_Reservation_ID) REFERENCES Lodging_Reservation (Reservation_ID) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Junction table linking trips to flight bookings and lodging reservations';

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
    INDEX idx_visit_date (Visit_Date),
    CONSTRAINT fk_park_review_user FOREIGN KEY (User_ID) REFERENCES User (User_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_park_review_park FOREIGN KEY (Park_ID) REFERENCES National_Park (Park_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_rating_range CHECK (
        Rating >= 1
        AND Rating <= 5
    )
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'User reviews and ratings for national parks';

-- ============================================
-- VIEWS (Optional - for common queries)
-- ============================================

-- View: Active Trips with Park Information
CREATE VIEW v_active_trips AS
SELECT
    t.Trip_ID,
    t.User_ID,
    CONCAT(
        u.First_Name,
        ' ',
        u.Last_Name
    ) AS User_Name,
    np.Park_Name,
    np.State AS Park_State,
    t.Trip_Start_Date,
    t.Trip_End_Date,
    t.Trip_Status,
    t.Total_Cost
FROM
    Trip t
    INNER JOIN User u ON t.User_ID = u.User_ID
    INNER JOIN National_Park np ON t.Park_ID = np.Park_ID
WHERE
    t.Trip_Status IN ('planned', 'booked');

-- View: Park Reviews with User Information
CREATE VIEW v_park_reviews AS
SELECT
    pr.Review_ID,
    pr.Park_ID,
    np.Park_Name,
    pr.User_ID,
    CONCAT(
        u.First_Name,
        ' ',
        u.Last_Name
    ) AS Reviewer_Name,
    pr.Rating,
    pr.Review_Text,
    pr.Visit_Date,
    pr.Review_Date
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
    AVG(pr.Rating) AS Average_Rating,
    MIN(pr.Rating) AS Min_Rating,
    MAX(pr.Rating) AS Max_Rating
FROM
    National_Park np
    LEFT JOIN Park_Review pr ON np.Park_ID = pr.Park_ID
GROUP BY
    np.Park_ID,
    np.Park_Name,
    np.State;

-- View: Upcoming Flight Bookings
CREATE VIEW v_upcoming_flights AS
SELECT
    fb.Booking_ID,
    fb.User_ID,
    CONCAT(
        u.First_Name,
        ' ',
        u.Last_Name
    ) AS User_Name,
    fb.Confirmation_Number,
    f.Airline,
    f.Flight_Number,
    dep_airport.Airport_Name AS Departure_Airport,
    arr_airport.Airport_Name AS Arrival_Airport,
    f.Departure_Time,
    f.Arrival_Time,
    fb.Total_Cost,
    fb.Booking_Status
FROM
    Flight_Booking fb
    INNER JOIN User u ON fb.User_ID = u.User_ID
    INNER JOIN Flight f ON fb.Flight_ID = f.Flight_ID
    INNER JOIN Airport dep_airport ON f.Departure_Airport_ID = dep_airport.Airport_ID
    INNER JOIN Airport arr_airport ON f.Arrival_Airport_ID = arr_airport.Airport_ID
WHERE
    f.Departure_Time > NOW()
    AND fb.Booking_Status = 'confirmed'
ORDER BY f.Departure_Time;

-- View: Lodging with Park Information
CREATE VIEW v_lodging_by_park AS
SELECT
    l.Lodging_ID,
    l.Lodging_Name,
    l.Lodging_Type,
    l.Price_Per_Night,
    l.Star_Rating,
    l.Distance_From_Park_Miles,
    np.Park_Name,
    np.State AS Park_State,
    l.City AS Lodging_City,
    l.State AS Lodging_State
FROM Lodging l
    INNER JOIN National_Park np ON l.Park_ID = np.Park_ID
ORDER BY np.Park_Name, l.Price_Per_Night;

-- ============================================
-- STORED PROCEDURES (Optional - for common operations)
-- ============================================

DELIMITER / /

-- Procedure: Get Trip Details
CREATE PROCEDURE sp_get_trip_details(IN p_trip_id INT)
BEGIN
    -- Get trip basic information
    SELECT 
        t.Trip_ID,
        t.User_ID,
        CONCAT(u.First_Name, ' ', u.Last_Name) AS User_Name,
        u.Email,
        np.Park_Name,
        np.State AS Park_State,
        t.Trip_Start_Date,
        t.Trip_End_Date,
        t.Trip_Status,
        t.Total_Cost,
        t.Created_At,
        t.Updated_At
    FROM Trip t
    INNER JOIN User u ON t.User_ID = u.User_ID
    INNER JOIN National_Park np ON t.Park_ID = np.Park_ID
    WHERE t.Trip_ID = p_trip_id;
    
    -- Get flight booking details if exists
    SELECT 
        fb.Booking_ID,
        fb.Confirmation_Number,
        f.Airline,
        f.Flight_Number,
        dep.Airport_Name AS Departure_Airport,
        arr.Airport_Name AS Arrival_Airport,
        f.Departure_Time,
        f.Arrival_Time,
        fb.Total_Cost AS Flight_Cost
    FROM Trip_Component tc
    INNER JOIN Flight_Booking fb ON tc.Flight_Booking_ID = fb.Booking_ID
    INNER JOIN Flight f ON fb.Flight_ID = f.Flight_ID
    INNER JOIN Airport dep ON f.Departure_Airport_ID = dep.Airport_ID
    INNER JOIN Airport arr ON f.Arrival_Airport_ID = arr.Airport_ID
    WHERE tc.Trip_ID = p_trip_id;
    
    -- Get lodging reservation details if exists
    SELECT 
        lr.Reservation_ID,
        lr.Confirmation_Number,
        l.Lodging_Name,
        l.Lodging_Type,
        lr.Check_In_Date,
        lr.Check_Out_Date,
        lr.Number_Of_Guests,
        lr.Number_Of_Rooms,
        lr.Total_Cost AS Lodging_Cost
    FROM Trip_Component tc
    INNER JOIN Lodging_Reservation lr ON tc.Lodging_Reservation_ID = lr.Reservation_ID
    INNER JOIN Lodging l ON lr.Lodging_ID = l.Lodging_ID
    WHERE tc.Trip_ID = p_trip_id;
END //

DELIMITER;

-- ============================================
-- TRIGGERS (Optional - for data integrity)
-- ============================================

DELIMITER / /

-- Trigger: Update Trip Total Cost
CREATE TRIGGER trg_update_trip_cost 
AFTER INSERT ON Trip_Component
FOR EACH ROW
BEGIN
    DECLARE flight_cost DECIMAL(10,2) DEFAULT 0;
    DECLARE lodging_cost DECIMAL(10,2) DEFAULT 0;
    
    -- Get flight cost if exists
    IF NEW.Flight_Booking_ID IS NOT NULL THEN
        SELECT Total_Cost INTO flight_cost
        FROM Flight_Booking
        WHERE Booking_ID = NEW.Flight_Booking_ID;
    END IF;
    
    -- Get lodging cost if exists
    IF NEW.Lodging_Reservation_ID IS NOT NULL THEN
        SELECT Total_Cost INTO lodging_cost
        FROM Lodging_Reservation
        WHERE Reservation_ID = NEW.Lodging_Reservation_ID;
    END IF;
    
    -- Update trip total cost
    UPDATE Trip
    SET Total_Cost = flight_cost + lodging_cost
    WHERE Trip_ID = NEW.Trip_ID;
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

-- ============================================
-- END OF DDL SCRIPT
-- ============================================

-- Script execution completed successfully
-- Tables Created: 11
-- Views Created: 5
-- Stored Procedures Created: 1
-- Triggers Created: 1