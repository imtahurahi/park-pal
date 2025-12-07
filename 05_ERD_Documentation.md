# ParkPal Database Entity Relationship Diagram (ERD)
## Documentation

**Version:** 1.0  
**Date:** December 6, 2025  
**Project:** ParkPal - National Park Trip Planning Platform  
**Database Type:** MySQL Server
---

## Table of Contents
1. [Overview](#overview)
2. [Entity Definitions](#entity-definitions)
3. [Relationships and Cardinality](#relationships-and-cardinality)
4. [ERD Diagram](#erd-diagram)
5. [Detailed Table Specifications](#detailed-table-specifications)

---

## Overview

This document provides comprehensive documentation for the ParkPal database schema, including all entities, relationships, primary keys, foreign keys, and cardinality notations.

**Total Entities:** 11 tables  
**Junction Tables:** 2 (Park_Airport, Trip_Component)  
**Database Model:** Relational (3NF Normalized)

---

## Entity Definitions

### Core Entities

1. **User** - User accounts and authentication
2. **National_Park** - US National Parks information (63 parks)
3. **Airport** - Airport data including DFW and destination airports
4. **Flight** - Flight schedules and availability
5. **Flight_Booking** - User flight reservations
6. **Lodging** - Accommodation options near parks
7. **Lodging_Reservation** - User lodging bookings
8. **Trip** - User trip planning records
9. **Park_Review** - User reviews for national parks

### Junction Entities

10. **Park_Airport** - Links parks to nearby airports (Many-to-Many)
11. **Trip_Component** - Links trips to bookings and reservations

---

## Relationships and Cardinality

### Relationship Legend
- **1:1** = One-to-One relationship
- **1:N** = One-to-Many relationship
- **M:N** = Many-to-Many relationship
- **PK** = Primary Key
- **FK** = Foreign Key

---

### 1. User Relationships

#### User → Flight_Booking (1:N)
- **Relationship Name:** "makes" or "books"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One user can make many flight bookings
- **Foreign Key:** Flight_Booking.User_ID references User.User_ID
- **Business Rule:** Users must be authenticated to book flights

#### User → Lodging_Reservation (1:N)
- **Relationship Name:** "reserves" or "books"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One user can make many lodging reservations
- **Foreign Key:** Lodging_Reservation.User_ID references User.User_ID
- **Business Rule:** Users must be authenticated to make reservations

#### User → Trip (1:N)
- **Relationship Name:** "creates" or "plans"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One user can create many trips
- **Foreign Key:** Trip.User_ID references User.User_ID
- **Business Rule:** Each trip belongs to exactly one user

#### User → Park_Review (1:N)
- **Relationship Name:** "writes" or "submits"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One user can write many park reviews
- **Foreign Key:** Park_Review.User_ID references User.User_ID
- **Business Rule:** Users can review parks they have visited

---

### 2. National_Park Relationships

#### National_Park ↔ Airport (M:N via Park_Airport)
- **Relationship Name:** "served by" / "serves"
- **Cardinality:** Many-to-Many (M:N)
- **Description:** Many parks are served by many airports
- **Junction Table:** Park_Airport
- **Foreign Keys:**
  - Park_Airport.Park_ID references National_Park.Park_ID
  - Park_Airport.Airport_ID references Airport.Airport_ID
- **Additional Data:** Distance_Miles stored in junction table
- **Business Rule:** Each park has multiple nearby airports; airports can serve multiple parks

#### National_Park → Lodging (1:N)
- **Relationship Name:** "has nearby" or "offers"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One park can have many nearby lodging options
- **Foreign Key:** Lodging.Park_ID references National_Park.Park_ID
- **Business Rule:** Lodging is associated with the nearest park

#### National_Park → Trip (1:N)
- **Relationship Name:** "is destination for"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One park can be the destination for many trips
- **Foreign Key:** Trip.Park_ID references National_Park.Park_ID
- **Business Rule:** Each trip has exactly one park as destination

#### National_Park → Park_Review (1:N)
- **Relationship Name:** "receives" or "has"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One park can have many reviews
- **Foreign Key:** Park_Review.Park_ID references National_Park.Park_ID
- **Business Rule:** Reviews are specific to one park

---

### 3. Airport Relationships

#### Airport → Flight (Departure) (1:N)
- **Relationship Name:** "departure point for"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One airport serves as departure for many flights
- **Foreign Key:** Flight.Departure_Airport_ID references Airport.Airport_ID
- **Business Rule:** Each flight has one departure airport

#### Airport → Flight (Arrival) (1:N)
- **Relationship Name:** "arrival point for"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One airport serves as arrival for many flights
- **Foreign Key:** Flight.Arrival_Airport_ID references Airport.Airport_ID
- **Business Rule:** Each flight has one arrival airport

---

### 4. Flight Relationships

#### Flight → Flight_Booking (1:N)
- **Relationship Name:** "has" or "includes"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One flight can have many bookings
- **Foreign Key:** Flight_Booking.Flight_ID references Flight.Flight_ID
- **Business Rule:** Bookings cannot exceed available seats

---

### 5. Flight_Booking Relationships

#### Flight_Booking → Trip_Component (1:N)
- **Relationship Name:** "part of"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One flight booking can be part of one trip component
- **Foreign Key:** Trip_Component.Flight_Booking_ID references Flight_Booking.Booking_ID
- **Business Rule:** Flight booking is optional in a trip

---

### 6. Lodging Relationships

#### Lodging → Lodging_Reservation (1:N)
- **Relationship Name:** "has" or "receives"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One lodging can have many reservations
- **Foreign Key:** Lodging_Reservation.Lodging_ID references Lodging.Lodging_ID
- **Business Rule:** Reservations must check availability

---

### 7. Lodging_Reservation Relationships

#### Lodging_Reservation → Trip_Component (1:N)
- **Relationship Name:** "part of"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One lodging reservation can be part of one trip component
- **Foreign Key:** Trip_Component.Lodging_Reservation_ID references Lodging_Reservation.Reservation_ID
- **Business Rule:** Lodging reservation is optional in a trip

---

### 8. Trip Relationships

#### Trip → Trip_Component (1:1)
- **Relationship Name:** "has" or "consists of"
- **Cardinality:** One-to-One (1:1)
- **Description:** One trip has one trip component record
- **Foreign Key:** Trip_Component.Trip_ID references Trip.Trip_ID
- **Business Rule:** Trip component links flight and lodging to trip

---

## ERD Diagram

![ERD Diagram](erd_diagram_screenshot.png)

*The diagram above shows all entities with their relationships, cardinalities, and key attributes.*

---

## Detailed Table Specifications

### 1. User Table

**Purpose:** Store user account information and authentication credentials

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| **User_ID** | INT | **PK**, Auto-increment | Unique user identifier |
| Email | VARCHAR(255) | NOT NULL, UNIQUE | User email address |
| Password_Hash | VARCHAR(255) | NOT NULL | Hashed password |
| First_Name | VARCHAR(100) | NOT NULL | User first name |
| Last_Name | VARCHAR(100) | NOT NULL | User last name |
| Phone_Number | VARCHAR(20) | NULL | User contact number |
| Created_At | TIMESTAMP | NOT NULL, DEFAULT NOW() | Account creation timestamp |
| Updated_At | TIMESTAMP | NOT NULL, DEFAULT NOW() | Last update timestamp |

**Primary Key:** User_ID  
**Foreign Keys:** None  
**Indexes:** Email (UNIQUE)

---

### 2. National_Park Table

**Purpose:** Store comprehensive information about all 63 US National Parks

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| **Park_ID** | INT | **PK**, Auto-increment | Unique park identifier |
| Park_Name | VARCHAR(255) | NOT NULL, UNIQUE | Official park name |
| State | VARCHAR(100) | NOT NULL | State location |
| Region | VARCHAR(100) | NULL | Geographic region |
| Description | TEXT | NULL | Park description |
| Wildlife_Information | TEXT | NULL | Wildlife details |
| Plant_Information | TEXT | NULL | Flora information |
| Area_Square_Miles | DECIMAL(10,2) | NULL | Park area |
| Annual_Visitors | INT | NULL | Yearly visitor count |
| Best_Time_To_Visit | VARCHAR(100) | NULL | Recommended season |
| Entry_Fee | DECIMAL(10,2) | NULL | Entrance fee |
| Free_Entry_Days | TEXT | NULL | Free admission dates |
| Official_Website | VARCHAR(500) | NULL | Park website URL |
| Latitude | DECIMAL(10,8) | NULL | GPS latitude |
| Longitude | DECIMAL(11,8) | NULL | GPS longitude |
| Park_Activities_Events | TEXT | NULL | Available activities |
| Popular_Park_Trails | TEXT | NULL | Trail information |
| Difficulty_Rating | VARCHAR(50) | NULL | Overall difficulty |
| Kid_Friendliness_Rating | INT | NULL | Family-friendly rating |
| Pet_Friendliness_Rating | INT | NULL | Pet-friendly rating |

**Primary Key:** Park_ID  
**Foreign Keys:** None  
**Indexes:** Park_Name (UNIQUE)

---

### 3. Airport Table

**Purpose:** Store airport information for flight operations

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| **Airport_ID** | INT | **PK**, Auto-increment | Unique airport identifier |
| Airport_Code | VARCHAR(3) | NOT NULL, UNIQUE | IATA 3-letter code |
| Airport_Name | VARCHAR(255) | NOT NULL | Official airport name |
| City | VARCHAR(100) | NOT NULL | Airport city |
| State | VARCHAR(100) | NOT NULL | Airport state |
| Latitude | DECIMAL(10,8) | NULL | GPS latitude |
| Longitude | DECIMAL(11,8) | NULL | GPS longitude |

**Primary Key:** Airport_ID  
**Foreign Keys:** None  
**Indexes:** Airport_Code (UNIQUE)

---

### 4. Park_Airport Table (Junction Table)

**Purpose:** Link national parks to nearby airports with distance information

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| **Park_ID** | INT | **PK, FK** | References National_Park |
| **Airport_ID** | INT | **PK, FK** | References Airport |
| Distance_Miles | DECIMAL(10,2) | NULL | Distance from park to airport |

**Primary Key:** Composite (Park_ID, Airport_ID)  
**Foreign Keys:**
- Park_ID → National_Park.Park_ID
- Airport_ID → Airport.Airport_ID

**Relationship Type:** Many-to-Many resolver

---

### 5. Flight Table

**Purpose:** Store flight schedules, routes, and availability

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| **Flight_ID** | INT | **PK**, Auto-increment | Unique flight identifier |
| Airline | VARCHAR(100) | NOT NULL | Airline name |
| Flight_Number | VARCHAR(20) | NOT NULL | Flight number |
| **Departure_Airport_ID** | INT | NOT NULL, **FK** | Departure airport |
| **Arrival_Airport_ID** | INT | NOT NULL, **FK** | Arrival airport |
| Departure_Time | TIMESTAMP | NOT NULL | Departure time |
| Arrival_Time | TIMESTAMP | NOT NULL | Arrival time |
| Duration_Minutes | INT | NULL | Flight duration |
| Number_Of_Stops | INT | DEFAULT 0 | Number of stops |
| Price | DECIMAL(10,2) | NOT NULL | Flight price |
| Available_Seats | INT | NOT NULL | Available seats |

**Primary Key:** Flight_ID  
**Foreign Keys:**
- Departure_Airport_ID → Airport.Airport_ID
- Arrival_Airport_ID → Airport.Airport_ID

---

### 6. Flight_Booking Table

**Purpose:** Store user flight booking records

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| **Booking_ID** | INT | **PK**, Auto-increment | Unique booking identifier |
| **User_ID** | INT | NOT NULL, **FK** | References User |
| **Flight_ID** | INT | NOT NULL, **FK** | References Flight |
| Passenger_First_Name | VARCHAR(100) | NOT NULL | Passenger first name |
| Passenger_Last_Name | VARCHAR(100) | NOT NULL | Passenger last name |
| Passenger_DOB | DATE | NOT NULL | Passenger date of birth |
| Confirmation_Number | VARCHAR(50) | NOT NULL, UNIQUE | Booking confirmation |
| Booking_Status | VARCHAR(50) | NOT NULL | Status (confirmed, cancelled) |
| Booking_Date | TIMESTAMP | NOT NULL, DEFAULT NOW() | Booking timestamp |
| Total_Cost | DECIMAL(10,2) | NOT NULL | Total booking cost |

**Primary Key:** Booking_ID  
**Foreign Keys:**
- User_ID → User.User_ID
- Flight_ID → Flight.Flight_ID

**Indexes:** Confirmation_Number (UNIQUE)

---

### 7. Lodging Table

**Purpose:** Store lodging options near national parks

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| **Lodging_ID** | INT | **PK**, Auto-increment | Unique lodging identifier |
| **Park_ID** | INT | NOT NULL, **FK** | References National_Park |
| Lodging_Name | VARCHAR(255) | NOT NULL | Lodging name |
| Lodging_Type | VARCHAR(50) | NOT NULL | Type (hotel, lodge, cabin, campground) |
| Address | VARCHAR(255) | NULL | Street address |
| City | VARCHAR(100) | NULL | City |
| State | VARCHAR(100) | NULL | State |
| Zip_Code | VARCHAR(10) | NULL | ZIP code |
| Description | TEXT | NULL | Lodging description |
| Amenities | TEXT | NULL | Available amenities |
| Price_Per_Night | DECIMAL(10,2) | NOT NULL | Nightly rate |
| Contact_Phone | VARCHAR(20) | NULL | Contact phone |
| Contact_Email | VARCHAR(255) | NULL | Contact email |
| Distance_From_Park_Miles | DECIMAL(10,2) | NULL | Distance from park entrance |
| Star_Rating | DECIMAL(2,1) | NULL | Star rating (0.0-5.0) |

**Primary Key:** Lodging_ID  
**Foreign Keys:**
- Park_ID → National_Park.Park_ID

---

### 8. Lodging_Reservation Table

**Purpose:** Store user lodging reservation records

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| **Reservation_ID** | INT | **PK**, Auto-increment | Unique reservation identifier |
| **User_ID** | INT | NOT NULL, **FK** | References User |
| **Lodging_ID** | INT | NOT NULL, **FK** | References Lodging |
| Check_In_Date | DATE | NOT NULL | Check-in date |
| Check_Out_Date | DATE | NOT NULL | Check-out date |
| Number_Of_Guests | INT | NOT NULL | Guest count |
| Number_Of_Rooms | INT | NOT NULL | Room/site count |
| Guest_Name | VARCHAR(200) | NOT NULL | Primary guest name |
| Guest_Phone | VARCHAR(20) | NOT NULL | Guest phone |
| Guest_Email | VARCHAR(255) | NOT NULL | Guest email |
| Confirmation_Number | VARCHAR(50) | NOT NULL, UNIQUE | Reservation confirmation |
| Reservation_Status | VARCHAR(50) | NOT NULL | Status (confirmed, cancelled) |
| Total_Cost | DECIMAL(10,2) | NOT NULL | Total reservation cost |
| Created_At | TIMESTAMP | NOT NULL, DEFAULT NOW() | Creation timestamp |

**Primary Key:** Reservation_ID  
**Foreign Keys:**
- User_ID → User.User_ID
- Lodging_ID → Lodging.Lodging_ID

**Indexes:** Confirmation_Number (UNIQUE)

---

### 9. Trip Table

**Purpose:** Store user trip planning records

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| **Trip_ID** | INT | **PK**, Auto-increment | Unique trip identifier |
| **User_ID** | INT | NOT NULL, **FK** | References User |
| **Park_ID** | INT | NOT NULL, **FK** | References National_Park |
| Trip_Start_Date | DATE | NOT NULL | Trip start date |
| Trip_End_Date | DATE | NOT NULL | Trip end date |
| Trip_Status | VARCHAR(50) | NOT NULL | Status (planned, booked, completed) |
| Total_Cost | DECIMAL(10,2) | NULL | Total trip cost |
| Created_At | TIMESTAMP | NOT NULL, DEFAULT NOW() | Creation timestamp |
| Updated_At | TIMESTAMP | NOT NULL, DEFAULT NOW() | Last update timestamp |

**Primary Key:** Trip_ID  
**Foreign Keys:**
- User_ID → User.User_ID
- Park_ID → National_Park.Park_ID

---

### 10. Trip_Component Table (Junction Table)

**Purpose:** Link trips to their flight bookings and lodging reservations

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| **Trip_ID** | INT | **PK, FK** | References Trip |
| **Flight_Booking_ID** | INT | **FK**, NULL | References Flight_Booking |
| **Lodging_Reservation_ID** | INT | **FK**, NULL | References Lodging_Reservation |

**Primary Key:** Trip_ID  
**Foreign Keys:**
- Trip_ID → Trip.Trip_ID
- Flight_Booking_ID → Flight_Booking.Booking_ID (Optional)
- Lodging_Reservation_ID → Lodging_Reservation.Reservation_ID (Optional)

**Note:** Flight and lodging are optional; users can book separately

---

### 11. Park_Review Table

**Purpose:** Store user reviews and ratings for national parks

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| **Review_ID** | INT | **PK**, Auto-increment | Unique review identifier |
| **User_ID** | INT | NOT NULL, **FK** | References User |
| **Park_ID** | INT | NOT NULL, **FK** | References National_Park |
| Rating | INT | NOT NULL | Star rating (1-5) |
| Review_Text | TEXT | NOT NULL | Review content |
| Visit_Date | DATE | NOT NULL | Date of park visit |
| Review_Date | TIMESTAMP | NOT NULL, DEFAULT NOW() | Review submission date |
| Photo_URLs | TEXT | NULL | Review photo URLs (JSON/CSV) |

**Primary Key:** Review_ID  
**Foreign Keys:**
- User_ID → User.User_ID
- Park_ID → National_Park.Park_ID

---

## Complete Relationship Summary

### Cardinality Overview

| Relationship | From Entity | To Entity | Cardinality | Foreign Key Location |
|--------------|-------------|-----------|-------------|---------------------|
| 1 | User | Flight_Booking | 1:N | Flight_Booking.User_ID |
| 2 | User | Lodging_Reservation | 1:N | Lodging_Reservation.User_ID |
| 3 | User | Trip | 1:N | Trip.User_ID |
| 4 | User | Park_Review | 1:N | Park_Review.User_ID |
| 5 | National_Park | Park_Airport | 1:N | Park_Airport.Park_ID |
| 6 | National_Park | Lodging | 1:N | Lodging.Park_ID |
| 7 | National_Park | Trip | 1:N | Trip.Park_ID |
| 8 | National_Park | Park_Review | 1:N | Park_Review.Park_ID |
| 9 | Airport | Park_Airport | 1:N | Park_Airport.Airport_ID |
| 10 | Airport | Flight (Departure) | 1:N | Flight.Departure_Airport_ID |
| 11 | Airport | Flight (Arrival) | 1:N | Flight.Arrival_Airport_ID |
| 12 | Flight | Flight_Booking | 1:N | Flight_Booking.Flight_ID |
| 13 | Flight_Booking | Trip_Component | 1:N | Trip_Component.Flight_Booking_ID |
| 14 | Lodging | Lodging_Reservation | 1:N | Lodging_Reservation.Lodging_ID |
| 15 | Lodging_Reservation | Trip_Component | 1:N | Trip_Component.Lodging_Reservation_ID |
| 16 | Trip | Trip_Component | 1:1 | Trip_Component.Trip_ID |

**Total Relationships:** 16  
**One-to-Many (1:N):** 15 relationships  
**One-to-One (1:1):** 1 relationship  
**Many-to-Many (M:N):** 1 relationship (National_Park ↔ Airport via Park_Airport)

---

## Database Constraints and Business Rules

### Referential Integrity
- All foreign key relationships enforce CASCADE on update
- DELETE behavior varies by relationship:
  - User deletion: RESTRICT (prevent if bookings exist)
  - Park deletion: RESTRICT (prevent if trips/reviews exist)
  - Flight deletion: RESTRICT (prevent if bookings exist)
  - Booking/Reservation deletion: SET NULL in Trip_Component

### Data Validation Rules
1. **Email Uniqueness:** User emails must be unique across the system
2. **Date Consistency:** Trip end date must be >= start date
3. **Seat Availability:** Flight bookings cannot exceed available seats
4. **Rating Range:** Review ratings must be between 1 and 5
5. **Confirmation Numbers:** Must be unique for all bookings and reservations
6. **Password Security:** Passwords must be hashed (bcrypt/Argon2)

### Indexing Strategy
- Primary keys: Automatically indexed
- Foreign keys: Indexed for join performance
- Email addresses: Unique index
- Confirmation numbers: Unique index
- Date fields: Consider indexing for range queries

---

## Normalization Notes

The database schema is designed to **Third Normal Form (3NF)**:

1. **First Normal Form (1NF):** All attributes contain atomic values
2. **Second Normal Form (2NF):** No partial dependencies on composite keys
3. **Third Normal Form (3NF):** No transitive dependencies

**Denormalization Considerations:**
- Aggregate ratings could be cached in National_Park table for performance
- Total costs stored in Trip table for quick retrieval
- Distance information stored in Park_Airport junction table

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | December 6, 2025 | Database Team | Initial ERD documentation |

---

*End of ERD Documentation*
