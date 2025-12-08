# ParkPal Database Entity Relationship Diagram (ERD)
## Documentation

**Version:** 2.0  
**Date:** December 7, 2025  
**Project:** ParkPal - National Park Lodging & Review Platform  
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

**Total Entities:** 5 tables  
**Junction Tables:** 0  
**Database Model:** Relational (3NF Normalized)  
**Focus:** Lodging reservations and park reviews only

---

## Entity Definitions

### Core Entities

1. **User** - User accounts and authentication
2. **National_Park** - US National Parks information (all 63 parks)
3. **Lodging** - Accommodation options near parks (hotels, lodges, campgrounds, cabins)
4. **Lodging_Reservation** - User lodging bookings
5. **Park_Review** - User reviews and ratings for national parks

---

## Relationships and Cardinality

### Relationship Legend
- **1:N** = One-to-Many relationship
- **PK** = Primary Key
- **FK** = Foreign Key

---

### 1. User Relationships

#### User → Lodging_Reservation (1:N)
- **Relationship Name:** "reserves" or "books"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One user can make many lodging reservations
- **Foreign Key:** Lodging_Reservation.User_ID references User.User_ID
- **Business Rule:** Users must be authenticated to make reservations

#### User → Park_Review (1:N)
- **Relationship Name:** "writes" or "submits"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One user can write many park reviews
- **Foreign Key:** Park_Review.User_ID references User.User_ID
- **Business Rule:** Users can review parks they have visited

---

### 2. National_Park Relationships

#### National_Park → Lodging (1:N)
- **Relationship Name:** "has nearby" or "offers"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One park can have many nearby lodging options
- **Foreign Key:** Lodging.Park_ID references National_Park.Park_ID
- **Business Rule:** Lodging is associated with the nearest park

#### National_Park → Park_Review (1:N)
- **Relationship Name:** "receives" or "has"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One park can have many reviews
- **Foreign Key:** Park_Review.Park_ID references National_Park.Park_ID
- **Business Rule:** Reviews are specific to one park

---

### 3. Lodging Relationships

#### Lodging → Lodging_Reservation (1:N)
- **Relationship Name:** "has" or "receives"
- **Cardinality:** One-to-Many (1:N)
- **Description:** One lodging can have many reservations
- **Foreign Key:** Lodging_Reservation.Lodging_ID references Lodging.Lodging_ID
- **Business Rule:** Reservations must check availability

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
**Indexes:** Park_Name (UNIQUE), State, Region

---

### 3. Lodging Table

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

**Indexes:** Park_ID, Lodging_Type, Price_Per_Night

---

### 4. Lodging_Reservation Table

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
| Reservation_Status | VARCHAR(50) | NOT NULL | Status (confirmed, pending, cancelled) |
| Total_Cost | DECIMAL(10,2) | NOT NULL | Total reservation cost |
| Created_At | TIMESTAMP | NOT NULL, DEFAULT NOW() | Creation timestamp |

**Primary Key:** Reservation_ID  
**Foreign Keys:**
- User_ID → User.User_ID
- Lodging_ID → Lodging.Lodging_ID

**Indexes:** Confirmation_Number (UNIQUE), User_ID, Lodging_ID, Check_In_Date, Reservation_Status

---

### 5. Park_Review Table

**Purpose:** Store user reviews and ratings for national parks

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| **Review_ID** | INT | **PK**, Auto-increment | Unique review identifier |
| **User_ID** | INT | NOT NULL, **FK** | References User |
| **Park_ID** | INT | NOT NULL, **FK** | References National_Park |
| Rating | INT | NOT NULL, CHECK (1-5) | Star rating (1-5) |
| Review_Text | TEXT | NOT NULL | Review content |
| Visit_Date | DATE | NOT NULL | Date of park visit |
| Review_Date | TIMESTAMP | NOT NULL, DEFAULT NOW() | Review submission date |
| Photo_URLs | TEXT | NULL | Review photo URLs (JSON/CSV) |

**Primary Key:** Review_ID  
**Foreign Keys:**
- User_ID → User.User_ID
- Park_ID → National_Park.Park_ID

**Indexes:** User_ID, Park_ID, Rating, Review_Date  
**Constraints:** Rating CHECK (Rating BETWEEN 1 AND 5)

---

## Complete Relationship Summary

### Cardinality Overview

| Relationship | From Entity | To Entity | Cardinality | Foreign Key Location |
|--------------|-------------|-----------|-------------|---------------------|
| 1 | User | Lodging_Reservation | 1:N | Lodging_Reservation.User_ID |
| 2 | User | Park_Review | 1:N | Park_Review.User_ID |
| 3 | National_Park | Lodging | 1:N | Lodging.Park_ID |
| 4 | National_Park | Park_Review | 1:N | Park_Review.Park_ID |
| 5 | Lodging | Lodging_Reservation | 1:N | Lodging_Reservation.Lodging_ID |

**Total Relationships:** 5  
**One-to-Many (1:N):** 5 relationships  

---

## Database Constraints and Business Rules

### Referential Integrity
- All foreign key relationships enforce CASCADE on update
- DELETE behavior:
  - User deletion: RESTRICT (prevent if reservations or reviews exist)
  - Park deletion: RESTRICT (prevent if lodging or reviews exist)
  - Lodging deletion: RESTRICT (prevent if reservations exist)

### Data Validation Rules
1. **Email Uniqueness:** User emails must be unique across the system
2. **Date Consistency:** 
   - Check-out date must be after check-in date
   - Check-in date cannot be in the past
3. **Rating Range:** Review ratings must be between 1 and 5
4. **Confirmation Numbers:** Must be unique for all reservations
5. **Password Security:** Passwords must be hashed (bcrypt/Argon2)
6. **Automatic Confirmation Numbers:** Trigger generates confirmation numbers if not provided

### Triggers
1. **trg_validate_reservation_dates:** Validates check-in and check-out dates before insert
2. **trg_generate_confirmation_number:** Auto-generates confirmation numbers for reservations

### Views
1. **v_park_reviews:** Park reviews with user information
2. **v_park_ratings:** Park average ratings and review counts
3. **v_lodging_by_park:** Lodging options with park information
4. **v_user_reservations:** User reservation history with full details

### Stored Procedures
1. **sp_get_park_details(park_id):** Returns park info, ratings, lodging, and recent reviews
2. **sp_get_user_dashboard(user_id):** Returns user info, upcoming/past reservations, and reviews

### Indexing Strategy
- Primary keys: Automatically indexed
- Foreign keys: Indexed for join performance
- Email addresses: Unique index
- Confirmation numbers: Unique index
- Date fields: Indexed for range queries (Check_In_Date, Review_Date)
- Search fields: Indexed (State, Region, Lodging_Type, Price_Per_Night, Rating)

---

## Normalization Notes

The database schema is designed to **Third Normal Form (3NF)**:

1. **First Normal Form (1NF):** All attributes contain atomic values
2. **Second Normal Form (2NF):** No partial dependencies on composite keys
3. **Third Normal Form (3NF):** No transitive dependencies

**Design Simplifications:**
- Direct booking model: Users book lodging directly without trip planning layer
- Focused scope: Only lodging and reviews (no flight booking)
- Efficient queries: Views provide pre-joined data for common queries

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | December 6, 2025 | Database Team | Initial ERD documentation (11 tables) |
| 2.0 | December 7, 2025 | Database Team | Simplified schema (5 tables) - removed flights, airports, trips |

---

*End of ERD Documentation*
