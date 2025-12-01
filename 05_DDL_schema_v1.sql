-- ===================================
-- National Park Travel Planner
-- SQLite Database Schema (DDL)
-- Version 1.0
-- ===================================

-- ===================================
-- USER MANAGEMENT
-- ===================================

CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100),
    profile_picture VARCHAR(500),
    budget_range_preference VARCHAR(50),
    activity_level_preference VARCHAR(50),
    accommodation_type_preference VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    email_verified BOOLEAN DEFAULT 0
);

-- ===================================
-- NATIONAL PARKS
-- ===================================

CREATE TABLE Parks (
    park_id INTEGER PRIMARY KEY AUTOINCREMENT,
    park_name VARCHAR(200) NOT NULL,
    state VARCHAR(50) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    description TEXT,
    highlights TEXT,
    difficulty_level VARCHAR(50),
    family_friendly BOOLEAN DEFAULT 0,
    entrance_fee DECIMAL(10, 2),
    best_seasons VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Activities (
    activity_id INTEGER PRIMARY KEY AUTOINCREMENT,
    activity_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE Park_Activities (
    park_id INTEGER NOT NULL,
    activity_id INTEGER NOT NULL,
    PRIMARY KEY (park_id, activity_id),
    FOREIGN KEY (park_id) REFERENCES Parks (park_id) ON DELETE CASCADE,
    FOREIGN KEY (activity_id) REFERENCES Activities (activity_id) ON DELETE CASCADE
);

CREATE TABLE Amenities (
    amenity_id INTEGER PRIMARY KEY AUTOINCREMENT,
    amenity_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE Park_Amenities (
    park_id INTEGER NOT NULL,
    amenity_id INTEGER NOT NULL,
    PRIMARY KEY (park_id, amenity_id),
    FOREIGN KEY (park_id) REFERENCES Parks (park_id) ON DELETE CASCADE,
    FOREIGN KEY (amenity_id) REFERENCES Amenities (amenity_id) ON DELETE CASCADE
);

-- ===================================
-- FLIGHTS & AIRPORTS
-- ===================================

CREATE TABLE Airports (
    airport_id INTEGER PRIMARY KEY AUTOINCREMENT,
    airport_code VARCHAR(10) UNIQUE NOT NULL,
    airport_name VARCHAR(200) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(50),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8)
);

CREATE TABLE Park_Airports (
    park_id INTEGER NOT NULL,
    airport_id INTEGER NOT NULL,
    distance_miles DECIMAL(10, 2),
    PRIMARY KEY (park_id, airport_id),
    FOREIGN KEY (park_id) REFERENCES Parks (park_id) ON DELETE CASCADE,
    FOREIGN KEY (airport_id) REFERENCES Airports (airport_id) ON DELETE CASCADE
);

CREATE TABLE Airlines (
    airline_id INTEGER PRIMARY KEY AUTOINCREMENT,
    airline_name VARCHAR(100) NOT NULL,
    airline_code VARCHAR(10) UNIQUE
);

CREATE TABLE Flights (
    flight_id INTEGER PRIMARY KEY AUTOINCREMENT,
    airline_id INTEGER NOT NULL,
    flight_number VARCHAR(20) NOT NULL,
    origin_airport_id INTEGER NOT NULL,
    destination_airport_id INTEGER NOT NULL,
    departure_time TIME,
    arrival_time TIME,
    duration_minutes INTEGER,
    price DECIMAL(10, 2),
    punctuality_score DECIMAL(5, 2),
    average_delay_minutes INTEGER,
    number_of_stops INTEGER DEFAULT 0,
    flight_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (airline_id) REFERENCES Airlines (airline_id) ON DELETE RESTRICT,
    FOREIGN KEY (origin_airport_id) REFERENCES Airports (airport_id) ON DELETE RESTRICT,
    FOREIGN KEY (destination_airport_id) REFERENCES Airports (airport_id) ON DELETE RESTRICT
);

-- ===================================
-- LODGING
-- ===================================

CREATE TABLE Lodging (
    lodging_id INTEGER PRIMARY KEY AUTOINCREMENT,
    park_id INTEGER NOT NULL,
    name VARCHAR(200) NOT NULL,
    type VARCHAR(50),
    address VARCHAR(500),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    distance_from_park_miles DECIMAL(10, 2),
    price_range VARCHAR(10),
    contact_phone VARCHAR(20),
    contact_email VARCHAR(100),
    website VARCHAR(500),
    wifi_available BOOLEAN DEFAULT 0,
    pet_friendly BOOLEAN DEFAULT 0,
    accessibility_features BOOLEAN DEFAULT 0,
    FOREIGN KEY (park_id) REFERENCES Parks (park_id) ON DELETE CASCADE
);

-- ===================================
-- TRIP PLANNING
-- ===================================

CREATE TABLE Trips (
    trip_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    park_id INTEGER NOT NULL,
    flight_id INTEGER,
    lodging_id INTEGER,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    arrival_date DATE NOT NULL,
    departure_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (park_id) REFERENCES Parks (park_id) ON DELETE RESTRICT,
    FOREIGN KEY (flight_id) REFERENCES Flights (flight_id) ON DELETE SET NULL,
    FOREIGN KEY (lodging_id) REFERENCES Lodging (lodging_id) ON DELETE SET NULL,
    CHECK (
        departure_date >= arrival_date
    )
);

CREATE TABLE Notes (
    note_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    trip_id INTEGER,
    title VARCHAR(200),
    content TEXT,
    category VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (trip_id) REFERENCES Trips (trip_id) ON DELETE SET NULL
);

CREATE TABLE Wishlists (
    wishlist_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    park_id INTEGER NOT NULL,
    priority VARCHAR(20),
    visited BOOLEAN DEFAULT 0,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    visited_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (park_id) REFERENCES Parks (park_id) ON DELETE CASCADE,
    UNIQUE (user_id, park_id)
);

CREATE TABLE Park_Reviews (
    review_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    park_id INTEGER NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(200),
    review_text TEXT,
    visit_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (park_id) REFERENCES Parks (park_id) ON DELETE CASCADE
);

-- ===================================
-- INDEXES FOR PERFORMANCE
-- ===================================

CREATE INDEX idx_users_email ON Users (email);

CREATE INDEX idx_parks_state ON Parks (state);

CREATE INDEX idx_parks_name ON Parks (park_name);

CREATE INDEX idx_trips_user ON Trips (user_id);

CREATE INDEX idx_trips_park ON Trips (park_id);

CREATE INDEX idx_trips_status ON Trips (status);

CREATE INDEX idx_trips_dates ON Trips (arrival_date, departure_date);

CREATE INDEX idx_notes_user ON Notes (user_id);

CREATE INDEX idx_notes_trip ON Notes (trip_id);

CREATE INDEX idx_wishlists_user ON Wishlists (user_id);

CREATE INDEX idx_flights_date ON Flights (flight_date);

CREATE INDEX idx_flights_airline ON Flights (airline_id);

CREATE INDEX idx_flights_origin ON Flights (origin_airport_id);

CREATE INDEX idx_flights_destination ON Flights (destination_airport_id);

CREATE INDEX idx_lodging_park ON Lodging (park_id);

CREATE INDEX idx_reviews_user ON Park_Reviews (user_id);

CREATE INDEX idx_reviews_park ON Park_Reviews (park_id);

-- ===================================
-- TRIGGERS FOR UPDATED_AT
-- ===================================

CREATE TRIGGER update_parks_timestamp 
AFTER UPDATE ON Parks
FOR EACH ROW
BEGIN
    UPDATE Parks SET updated_at = CURRENT_TIMESTAMP WHERE park_id = NEW.park_id;
END;

CREATE TRIGGER update_trips_timestamp 
AFTER UPDATE ON Trips
FOR EACH ROW
BEGIN
    UPDATE Trips SET updated_at = CURRENT_TIMESTAMP WHERE trip_id = NEW.trip_id;
END;

CREATE TRIGGER update_notes_timestamp 
AFTER UPDATE ON Notes
FOR EACH ROW
BEGIN
    UPDATE Notes SET updated_at = CURRENT_TIMESTAMP WHERE note_id = NEW.note_id;
END;

CREATE TRIGGER update_reviews_timestamp 
AFTER UPDATE ON Park_Reviews
FOR EACH ROW
BEGIN
    UPDATE Park_Reviews SET updated_at = CURRENT_TIMESTAMP WHERE review_id = NEW.review_id;
END;