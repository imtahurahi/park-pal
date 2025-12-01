-- ===================================
-- National Park Travel Planner
-- SQLite Database Data (DML)
-- Version 1.0
-- ===================================

-- ===================================
-- USERS
-- ===================================

INSERT INTO
    Users (
        email,
        password_hash,
        name,
        budget_range_preference,
        activity_level_preference,
        accommodation_type_preference,
        email_verified
    )
VALUES (
        'sarah.johnson@email.com',
        '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5LS2LhQY9JXYy',
        'Sarah Johnson',
        'moderate',
        'moderate',
        'hotel',
        1
    ),
    (
        'james.chen@email.com',
        '$2b$12$92y4YcWxP8ZWIsvFc3K2duKMyeIjbNK1foJD6/VVl/LhQY5XgYZWu',
        'James Chen',
        'budget',
        'high',
        'campground',
        1
    ),
    (
        'linda.martinez@email.com',
        '$2b$12$eImiTXuWVxfM37uY4JANjQ4QfO3Dq2QZCmBZAvL0OP1/LhQY8HxAu',
        'Linda Martinez',
        'luxury',
        'low',
        'lodge',
        1
    ),
    (
        'robert.martinez@email.com',
        '$2b$12$kQvN4YvXuW5xkP0FBDJkZOWz5UyxPLJchB8/LdwZ6MT3LhRT6JwYu',
        'Robert Martinez',
        'luxury',
        'low',
        'lodge',
        1
    ),
    (
        'emily.davis@email.com',
        '$2b$12$tPvO5ZwWxVwfL26uK5BAhPVy7WyxQNJqiC9/MfxA7NS4MiSU7KyBv',
        'Emily Davis',
        'moderate',
        'high',
        'hotel',
        1
    ),
    (
        'michael.brown@email.com',
        '$2b$12$xRwP6AxXyWxgN37vL6CBkQXz8VzxRQKrjD0/NgxB8OT5NjTV8LzCw',
        'Michael Brown',
        'budget',
        'moderate',
        'campground',
        0
    );

-- ===================================
-- NATIONAL PARKS
-- ===================================

INSERT INTO
    Parks (
        park_name,
        state,
        latitude,
        longitude,
        description,
        highlights,
        difficulty_level,
        family_friendly,
        entrance_fee,
        best_seasons
    )
VALUES (
        'Yellowstone National Park',
        'Wyoming',
        44.427963,
        -110.588455,
        'America''s first national park, famous for geysers and wildlife',
        'Old Faithful, Grand Prismatic Spring, Wildlife viewing',
        'moderate',
        1,
        35.00,
        'Summer, Fall'
    ),
    (
        'Grand Canyon National Park',
        'Arizona',
        36.106965,
        -112.112997,
        'Massive canyon carved by the Colorado River',
        'South Rim views, Colorado River, Hiking trails',
        'moderate',
        1,
        35.00,
        'Spring, Fall'
    ),
    (
        'Yosemite National Park',
        'California',
        37.865101,
        -119.538330,
        'Known for granite cliffs, waterfalls, and giant sequoias',
        'Half Dome, El Capitan, Yosemite Falls',
        'challenging',
        1,
        35.00,
        'Spring, Summer, Fall'
    ),
    (
        'Zion National Park',
        'Utah',
        37.297817,
        -113.026161,
        'Red rock canyons and dramatic desert landscapes',
        'Angels Landing, The Narrows, Canyon Overlook',
        'challenging',
        0,
        35.00,
        'Spring, Fall'
    ),
    (
        'Great Smoky Mountains National Park',
        'Tennessee',
        35.611763,
        -83.489548,
        'Ancient mountains with diverse plant and animal life',
        'Cades Cove, Hiking trails, Fall foliage',
        'easy',
        1,
        0.00,
        'Spring, Summer, Fall'
    ),
    (
        'Acadia National Park',
        'Maine',
        44.338556,
        -68.273430,
        'Rocky beaches, woodland, and glacier-scoured peaks',
        'Cadillac Mountain, Jordan Pond, Park Loop Road',
        'moderate',
        1,
        30.00,
        'Summer, Fall'
    ),
    (
        'Glacier National Park',
        'Montana',
        48.759613,
        -113.787022,
        'Alpine meadows, pristine forests, and glacial lakes',
        'Going-to-the-Sun Road, Many Glacier, Hiking',
        'challenging',
        0,
        35.00,
        'Summer'
    ),
    (
        'Rocky Mountain National Park',
        'Colorado',
        40.342767,
        -105.683611,
        'High alpine peaks and diverse ecosystems',
        'Trail Ridge Road, Bear Lake, Wildlife viewing',
        'moderate',
        1,
        30.00,
        'Summer, Fall'
    ),
    (
        'Olympic National Park',
        'Washington',
        47.802085,
        -123.604290,
        'Diverse ecosystems from mountains to rainforest to coast',
        'Hoh Rain Forest, Hurricane Ridge, Beaches',
        'moderate',
        1,
        30.00,
        'Summer, Fall'
    ),
    (
        'Everglades National Park',
        'Florida',
        25.286615,
        -80.898651,
        'Largest tropical wilderness in the United States',
        'Airboat tours, Wildlife, Anhinga Trail',
        'easy',
        1,
        30.00,
        'Winter, Spring'
    );

-- ===================================
-- ACTIVITIES
-- ===================================

INSERT INTO
    Activities (activity_name, description)
VALUES (
        'Hiking',
        'Trail hiking ranging from easy walks to challenging climbs'
    ),
    (
        'Camping',
        'Tent and RV camping in designated campgrounds'
    ),
    (
        'Wildlife Viewing',
        'Observing animals in their natural habitat'
    ),
    (
        'Photography',
        'Capturing scenic landscapes and wildlife'
    ),
    (
        'Rock Climbing',
        'Technical climbing on natural rock formations'
    ),
    (
        'Fishing',
        'Freshwater fishing in lakes and streams'
    ),
    (
        'Kayaking',
        'Paddling in lakes, rivers, and coastal areas'
    ),
    (
        'Backpacking',
        'Multi-day wilderness camping and hiking'
    ),
    (
        'Scenic Driving',
        'Touring parks via scenic roads and viewpoints'
    ),
    (
        'Ranger Programs',
        'Educational programs led by park rangers'
    ),
    (
        'Stargazing',
        'Night sky observation in low-light areas'
    ),
    (
        'Mountain Biking',
        'Off-road cycling on designated trails'
    );

-- ===================================
-- PARK ACTIVITIES (Many-to-Many)
-- ===================================

INSERT INTO
    Park_Activities (park_id, activity_id)
VALUES
    -- Yellowstone
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 6),
    (1, 8),
    (1, 9),
    (1, 10),
    (1, 11),
    -- Grand Canyon
    (2, 1),
    (2, 2),
    (2, 3),
    (2, 4),
    (2, 8),
    (2, 9),
    (2, 10),
    (2, 11),
    -- Yosemite
    (3, 1),
    (3, 2),
    (3, 3),
    (3, 4),
    (3, 5),
    (3, 6),
    (3, 8),
    (3, 9),
    (3, 10),
    (3, 11),
    -- Zion
    (4, 1),
    (4, 2),
    (4, 4),
    (4, 5),
    (4, 8),
    (4, 9),
    (4, 10),
    -- Great Smoky Mountains
    (5, 1),
    (5, 2),
    (5, 3),
    (5, 4),
    (5, 6),
    (5, 8),
    (5, 9),
    (5, 10),
    -- Acadia
    (6, 1),
    (6, 2),
    (6, 3),
    (6, 4),
    (6, 7),
    (6, 9),
    (6, 10),
    (6, 12),
    -- Glacier
    (7, 1),
    (7, 2),
    (7, 3),
    (7, 4),
    (7, 6),
    (7, 8),
    (7, 9),
    (7, 10),
    (7, 11),
    -- Rocky Mountain
    (8, 1),
    (8, 2),
    (8, 3),
    (8, 4),
    (8, 6),
    (8, 8),
    (8, 9),
    (8, 10),
    (8, 11),
    -- Olympic
    (9, 1),
    (9, 2),
    (9, 3),
    (9, 4),
    (9, 8),
    (9, 9),
    (9, 10),
    -- Everglades
    (10, 1),
    (10, 2),
    (10, 3),
    (10, 4),
    (10, 6),
    (10, 7),
    (10, 9),
    (10, 10);

-- ===================================
-- AMENITIES
-- ===================================

INSERT INTO
    Amenities (amenity_name, description)
VALUES (
        'Visitor Center',
        'Information center with exhibits and park rangers'
    ),
    (
        'Restrooms',
        'Public restroom facilities'
    ),
    (
        'Wheelchair Accessible',
        'Facilities and trails accessible to wheelchairs'
    ),
    (
        'Picnic Areas',
        'Designated areas for picnicking'
    ),
    (
        'Gift Shop',
        'Store selling souvenirs and park merchandise'
    ),
    (
        'Bookstore',
        'Educational books and maps'
    ),
    (
        'Food Service',
        'Restaurants or cafeterias within the park'
    ),
    (
        'Gas Station',
        'Fuel services available'
    ),
    (
        'Cell Service',
        'Mobile phone coverage available'
    ),
    (
        'WiFi',
        'Wireless internet access'
    ),
    (
        'Pet Friendly Areas',
        'Designated areas where pets are allowed'
    ),
    (
        'Shuttles',
        'Park shuttle bus services'
    );

-- ===================================
-- PARK AMENITIES (Many-to-Many)
-- ===================================

INSERT INTO
    Park_Amenities (park_id, amenity_id)
VALUES
    -- Yellowstone
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6),
    (1, 7),
    (1, 8),
    (1, 11),
    (1, 12),
    -- Grand Canyon
    (2, 1),
    (2, 2),
    (2, 3),
    (2, 4),
    (2, 5),
    (2, 6),
    (2, 7),
    (2, 11),
    (2, 12),
    -- Yosemite
    (3, 1),
    (3, 2),
    (3, 3),
    (3, 4),
    (3, 5),
    (3, 6),
    (3, 7),
    (3, 11),
    (3, 12),
    -- Zion
    (4, 1),
    (4, 2),
    (4, 3),
    (4, 4),
    (4, 5),
    (4, 6),
    (4, 11),
    (4, 12),
    -- Great Smoky Mountains
    (5, 1),
    (5, 2),
    (5, 3),
    (5, 4),
    (5, 5),
    (5, 6),
    (5, 11),
    -- Acadia
    (6, 1),
    (6, 2),
    (6, 3),
    (6, 4),
    (6, 5),
    (6, 6),
    (6, 11),
    (6, 12),
    -- Glacier
    (7, 1),
    (7, 2),
    (7, 3),
    (7, 4),
    (7, 5),
    (7, 6),
    (7, 11),
    (7, 12),
    -- Rocky Mountain
    (8, 1),
    (8, 2),
    (8, 3),
    (8, 4),
    (8, 5),
    (8, 6),
    (8, 11),
    (8, 12),
    -- Olympic
    (9, 1),
    (9, 2),
    (9, 3),
    (9, 4),
    (9, 5),
    (9, 6),
    (9, 11),
    -- Everglades
    (10, 1),
    (10, 2),
    (10, 3),
    (10, 4),
    (10, 5),
    (10, 6),
    (10, 11);

-- ===================================
-- AIRPORTS
-- ===================================

INSERT INTO
    Airports (
        airport_code,
        airport_name,
        city,
        state,
        latitude,
        longitude
    )
VALUES (
        'BZN',
        'Bozeman Yellowstone International Airport',
        'Bozeman',
        'Montana',
        45.777643,
        -111.160151
    ),
    (
        'JAC',
        'Jackson Hole Airport',
        'Jackson',
        'Wyoming',
        43.607333,
        -110.737500
    ),
    (
        'FLG',
        'Flagstaff Pulliam Airport',
        'Flagstaff',
        'Arizona',
        35.138500,
        -111.671667
    ),
    (
        'PHX',
        'Phoenix Sky Harbor International Airport',
        'Phoenix',
        'Arizona',
        33.434278,
        -112.011583
    ),
    (
        'FAT',
        'Fresno Yosemite International Airport',
        'Fresno',
        'California',
        36.776194,
        -119.718056
    ),
    (
        'SFO',
        'San Francisco International Airport',
        'San Francisco',
        'California',
        37.618972,
        -122.374889
    ),
    (
        'LAS',
        'Harry Reid International Airport',
        'Las Vegas',
        'Nevada',
        36.080056,
        -115.152222
    ),
    (
        'SLC',
        'Salt Lake City International Airport',
        'Salt Lake City',
        'Utah',
        40.788389,
        -111.977778
    ),
    (
        'TYS',
        'McGhee Tyson Airport',
        'Knoxville',
        'Tennessee',
        35.810972,
        -83.994028
    ),
    (
        'BGR',
        'Bangor International Airport',
        'Bangor',
        'Maine',
        44.807444,
        -68.828139
    ),
    (
        'PWM',
        'Portland International Jetport',
        'Portland',
        'Maine',
        43.645833,
        -70.309444
    ),
    (
        'FCA',
        'Glacier Park International Airport',
        'Kalispell',
        'Montana',
        48.310556,
        -114.256111
    ),
    (
        'DEN',
        'Denver International Airport',
        'Denver',
        'Colorado',
        39.861656,
        -104.673178
    ),
    (
        'SEA',
        'Seattle-Tacoma International Airport',
        'Seattle',
        'Washington',
        47.449,
        -122.309306
    ),
    (
        'MIA',
        'Miami International Airport',
        'Miami',
        'Florida',
        25.795865,
        -80.287046
    ),
    (
        'FLL',
        'Fort Lauderdale-Hollywood International Airport',
        'Fort Lauderdale',
        'Florida',
        26.072583,
        -80.152778
    );

-- ===================================
-- PARK AIRPORTS (Many-to-Many)
-- ===================================

INSERT INTO
    Park_Airports (
        park_id,
        airport_id,
        distance_miles
    )
VALUES
    -- Yellowstone
    (1, 1, 90.5),
    (1, 2, 60.2),
    -- Grand Canyon
    (2, 3, 81.3),
    (2, 4, 145.7),
    -- Yosemite
    (3, 5, 65.4),
    (3, 6, 170.3),
    -- Zion
    (4, 7, 160.5),
    (4, 8, 308.2),
    -- Great Smoky Mountains
    (5, 9, 42.8),
    -- Acadia
    (6, 10, 48.5),
    (6, 11, 160.2),
    -- Glacier
    (7, 12, 30.1),
    -- Rocky Mountain
    (8, 13, 65.8),
    -- Olympic
    (9, 14, 62.4),
    -- Everglades
    (10, 15, 45.3),
    (10, 16, 32.8);

-- ===================================
-- AIRLINES
-- ===================================

INSERT INTO
    Airlines (airline_name, airline_code)
VALUES ('United Airlines', 'UA'),
    ('Delta Air Lines', 'DL'),
    ('American Airlines', 'AA'),
    ('Southwest Airlines', 'WN'),
    ('Alaska Airlines', 'AS'),
    ('JetBlue Airways', 'B6'),
    ('Spirit Airlines', 'NK'),
    ('Frontier Airlines', 'F9');

-- ===================================
-- FLIGHTS
-- ===================================

INSERT INTO
    Flights (
        airline_id,
        flight_number,
        origin_airport_id,
        destination_airport_id,
        departure_time,
        arrival_time,
        duration_minutes,
        price,
        punctuality_score,
        average_delay_minutes,
        number_of_stops,
        flight_date
    )
VALUES
    -- Flights to Yellowstone area
    (
        1,
        'UA1234',
        13,
        1,
        '08:00',
        '09:45',
        105,
        245.00,
        85.5,
        12,
        0,
        '2025-07-15'
    ),
    (
        1,
        'UA1235',
        13,
        1,
        '14:30',
        '16:15',
        105,
        280.00,
        82.3,
        15,
        0,
        '2025-07-20'
    ),
    (
        2,
        'DL5678',
        9,
        1,
        '10:15',
        '12:30',
        135,
        310.00,
        88.7,
        8,
        0,
        '2025-07-15'
    ),
    (
        1,
        'UA2345',
        8,
        2,
        '07:00',
        '08:15',
        75,
        195.00,
        90.2,
        5,
        0,
        '2025-08-10'
    ),
    -- Flights to Grand Canyon area
    (
        3,
        'AA3456',
        4,
        3,
        '06:30',
        '07:15',
        45,
        125.00,
        92.1,
        4,
        0,
        '2025-06-10'
    ),
    (
        2,
        'DL4567',
        13,
        4,
        '09:00',
        '10:45',
        105,
        185.00,
        86.4,
        10,
        0,
        '2025-06-15'
    ),
    (
        4,
        'WN7890',
        7,
        4,
        '11:20',
        '12:05',
        45,
        89.00,
        78.5,
        18,
        0,
        '2025-09-20'
    ),
    -- Flights to Yosemite area
    (
        1,
        'UA5678',
        6,
        5,
        '08:45',
        '09:45',
        60,
        150.00,
        87.2,
        11,
        0,
        '2025-08-05'
    ),
    (
        2,
        'DL6789',
        14,
        5,
        '13:15',
        '15:30',
        135,
        295.00,
        83.9,
        13,
        0,
        '2025-08-12'
    ),
    (
        5,
        'AS1234',
        14,
        6,
        '07:30',
        '09:15',
        105,
        225.00,
        91.5,
        6,
        0,
        '2025-05-22'
    ),
    -- Flights to Zion area
    (
        4,
        'WN2345',
        13,
        7,
        '10:00',
        '11:15',
        75,
        110.00,
        80.1,
        16,
        0,
        '2025-09-05'
    ),
    (
        7,
        'NK3456',
        6,
        7,
        '15:45',
        '17:00',
        75,
        75.00,
        72.3,
        22,
        0,
        '2025-09-08'
    ),
    -- Flights to Great Smoky Mountains
    (
        3,
        'AA6789',
        15,
        9,
        '08:00',
        '10:45',
        165,
        285.00,
        84.6,
        12,
        0,
        '2025-10-01'
    ),
    (
        2,
        'DL7890',
        4,
        9,
        '12:30',
        '16:15',
        225,
        340.00,
        79.8,
        19,
        1,
        '2025-10-05'
    ),
    -- Flights to Acadia
    (
        6,
        'B62345',
        11,
        10,
        '09:15',
        '10:30',
        75,
        165.00,
        88.3,
        9,
        0,
        '2025-09-15'
    ),
    (
        2,
        'DL8901',
        11,
        10,
        '14:00',
        '15:15',
        75,
        180.00,
        85.7,
        11,
        0,
        '2025-09-18'
    ),
    -- Flights to Glacier
    (
        5,
        'AS3456',
        14,
        12,
        '06:45',
        '08:30',
        105,
        265.00,
        89.4,
        8,
        0,
        '2025-07-25'
    ),
    (
        1,
        'UA6789',
        8,
        12,
        '11:00',
        '14:45',
        225,
        385.00,
        81.2,
        14,
        1,
        '2025-07-28'
    ),
    -- Flights to Rocky Mountain
    (
        4,
        'WN4567',
        6,
        13,
        '07:00',
        '09:15',
        135,
        195.00,
        86.8,
        10,
        0,
        '2025-08-15'
    ),
    (
        1,
        'UA7890',
        4,
        13,
        '13:45',
        '15:30',
        105,
        215.00,
        88.1,
        9,
        0,
        '2025-08-18'
    ),
    (
        8,
        'F98901',
        7,
        13,
        '16:30',
        '18:15',
        105,
        125.00,
        75.6,
        20,
        0,
        '2025-08-20'
    ),
    -- Flights to Olympic
    (
        5,
        'AS5678',
        6,
        14,
        '08:30',
        '10:15',
        105,
        185.00,
        92.3,
        5,
        0,
        '2025-07-10'
    ),
    (
        5,
        'AS6789',
        13,
        14,
        '12:00',
        '13:45',
        105,
        205.00,
        90.7,
        7,
        0,
        '2025-07-12'
    ),
    -- Flights to Everglades
    (
        6,
        'B63456',
        4,
        15,
        '09:00',
        '14:15',
        315,
        295.00,
        83.5,
        13,
        1,
        '2025-02-10'
    ),
    (
        3,
        'AA8901',
        13,
        15,
        '07:15',
        '13:45',
        390,
        385.00,
        80.9,
        15,
        1,
        '2025-02-15'
    ),
    (
        7,
        'NK4567',
        11,
        16,
        '14:30',
        '17:45',
        195,
        165.00,
        76.4,
        21,
        0,
        '2025-03-01'
    );

-- ===================================
-- LODGING
-- ===================================

INSERT INTO
    Lodging (
        park_id,
        name,
        type,
        address,
        latitude,
        longitude,
        distance_from_park_miles,
        price_range,
        contact_phone,
        contact_email,
        website,
        wifi_available,
        pet_friendly,
        accessibility_features
    )
VALUES
    -- Yellowstone
    (
        1,
        'Old Faithful Inn',
        'lodge',
        'Old Faithful, Yellowstone National Park, WY 82190',
        44.460361,
        -110.828889,
        0.3,
        '$$$',
        '307-344-7311',
        'reservations@yellowstone.com',
        'www.yellowstonenationalparklodges.com',
        0,
        0,
        1
    ),
    (
        1,
        'Canyon Campground',
        'campground',
        'Canyon Village, Yellowstone National Park, WY 82190',
        44.729722,
        -110.480556,
        0.1,
        '$',
        '307-344-7311',
        'camping@yellowstone.com',
        'www.nps.gov/yell',
        0,
        1,
        1
    ),
    (
        1,
        'Under Canvas Yellowstone',
        'hotel',
        '890 Buttermilk Creek Rd, West Yellowstone, MT 59758',
        44.663889,
        -111.103333,
        12.5,
        '$$$',
        '406-219-0441',
        'info@undercanvas.com',
        'www.undercanvas.com',
        1,
        0,
        0
    ),
    -- Grand Canyon
    (
        2,
        'El Tovar Hotel',
        'lodge',
        'South Rim, Grand Canyon, AZ 86023',
        36.054167,
        -112.142778,
        0.2,
        '$$$',
        '928-638-2631',
        'reservations@grandcanyon.com',
        'www.grandcanyonlodges.com',
        1,
        0,
        1
    ),
    (
        2,
        'Mather Campground',
        'campground',
        'South Rim, Grand Canyon, AZ 86023',
        36.053056,
        -112.140556,
        0.5,
        '$',
        '877-444-6777',
        'camping@grandcanyon.com',
        'www.nps.gov/grca',
        0,
        0,
        1
    ),
    (
        2,
        'Best Western Grand Canyon Squire Inn',
        'hotel',
        '74 State Route 64, Tusayan, AZ 86023',
        35.975278,
        -112.128056,
        7.2,
        '$$',
        '928-638-2681',
        'info@grandcanyonsquire.com',
        'www.grandcanyonsquire.com',
        1,
        1,
        1
    ),
    -- Yosemite
    (
        3,
        'The Ahwahnee',
        'lodge',
        '1 Ahwahnee Dr, Yosemite Valley, CA 95389',
        37.746389,
        -119.575278,
        0.4,
        '$$$',
        '209-372-1407',
        'reservations@yosemite.com',
        'www.travelyosemite.com',
        1,
        0,
        1
    ),
    (
        3,
        'Upper Pines Campground',
        'campground',
        'Yosemite Valley, CA 95389',
        37.736111,
        -119.558333,
        0.8,
        '$',
        '877-444-6777',
        'camping@yosemite.com',
        'www.nps.gov/yose',
        0,
        0,
        1
    ),
    (
        3,
        'Yosemite View Lodge',
        'hotel',
        '11136 CA-140, El Portal, CA 95318',
        37.671667,
        -119.785833,
        8.3,
        '$$',
        '209-379-2681',
        'info@yosemiteviewlodge.com',
        'www.yosemiteviewlodge.com',
        1,
        1,
        1
    ),
    -- Zion
    (
        4,
        'Zion Lodge',
        'lodge',
        'Zion Canyon Scenic Dr, Springdale, UT 84767',
        37.207222,
        -112.988333,
        0.5,
        '$$$',
        '435-772-7700',
        'reservations@zionlodge.com',
        'www.zionlodge.com',
        1,
        0,
        1
    ),
    (
        4,
        'Watchman Campground',
        'campground',
        'Zion National Park, UT 84767',
        37.200556,
        -112.987500,
        0.3,
        '$',
        '877-444-6777',
        'camping@zion.com',
        'www.nps.gov/zion',
        0,
        1,
        1
    ),
    (
        4,
        'Hampton Inn & Suites Springdale',
        'hotel',
        '1127 Zion Park Blvd, Springdale, UT 84767',
        37.188889,
        -112.998056,
        2.1,
        '$$',
        '435-772-3200',
        'info@hamptonzion.com',
        'www.hamptoninn.com',
        1,
        0,
        1
    ),
    -- Great Smoky Mountains
    (
        5,
        'LeConte Lodge',
        'lodge',
        'Mt. LeConte Trail, Gatlinburg, TN 37738',
        35.654444,
        -83.437500,
        5.5,
        '$$$',
        '865-429-5704',
        'reservations@lecontelodge.com',
        'www.lecontelodge.com',
        0,
        0,
        0
    ),
    (
        5,
        'Cades Cove Campground',
        'campground',
        'Cades Cove Loop Rd, Townsend, TN 37882',
        35.594722,
        -83.837222,
        0.2,
        '$',
        '877-444-6777',
        'camping@smokies.com',
        'www.nps.gov/grsm',
        0,
        0,
        1
    ),
    (
        5,
        'The Park Vista Hotel',
        'hotel',
        '705 Cherokee Orchard Rd, Gatlinburg, TN 37738',
        35.714167,
        -83.510278,
        3.8,
        '$$',
        '865-436-9211',
        'info@parkvista.com',
        'www.parkvista.com',
        1,
        1,
        1
    ),
    -- Acadia
    (
        6,
        'Jordan Pond House',
        'lodge',
        'Park Loop Rd, Acadia National Park, ME 04609',
        44.320556,
        -68.251389,
        0.5,
        '$$',
        '207-276-3316',
        'reservations@jordanpondhouse.com',
        'www.jordanpond.com',
        1,
        0,
        1
    ),
    (
        6,
        'Blackwoods Campground',
        'campground',
        'Acadia National Park, ME 04609',
        44.311389,
        -68.227778,
        1.2,
        '$',
        '877-444-6777',
        'camping@acadia.com',
        'www.nps.gov/acad',
        0,
        1,
        1
    ),
    (
        6,
        'Bar Harbor Inn',
        'hotel',
        '1 Newport Dr, Bar Harbor, ME 04609',
        44.387222,
        -68.203056,
        5.4,
        '$$$',
        '207-288-3351',
        'info@barharborinn.com',
        'www.barharborinn.com',
        1,
        1,
        1
    ),
    -- Glacier
    (
        7,
        'Many Glacier Hotel',
        'lodge',
        'Many Glacier Rd, Babb, MT 59411',
        48.795278,
        -113.669722,
        0.8,
        '$$$',
        '406-892-2525',
        'reservations@glacierparkinc.com',
        'www.glaciernationalparklodges.com',
        0,
        0,
        1
    ),
    (
        7,
        'Apgar Campground',
        'campground',
        'Glacier National Park, West Glacier, MT 59936',
        48.515278,
        -113.997500,
        0.3,
        '$',
        '877-444-6777',
        'camping@glacier.com',
        'www.nps.gov/glac',
        0,
        0,
        1
    ),
    (
        7,
        'Glacier Guides Lodge',
        'hotel',
        '11957 US-2, West Glacier, MT 59936',
        48.494167,
        -113.977222,
        5.2,
        '$$',
        '406-387-5555',
        'info@glacierguides.com',
        'www.glacierguides.com',
        1,
        1,
        1
    ),
    -- Rocky Mountain
    (
        8,
        'YMCA of the Rockies',
        'lodge',
        '2515 Tunnel Rd, Estes Park, CO 80511',
        40.374722,
        -105.556944,
        8.5,
        '$$',
        '970-586-3341',
        'reservations@ymcarockies.org',
        'www.ymcarockies.org',
        1,
        0,
        1
    ),
    (
        8,
        'Moraine Park Campground',
        'campground',
        'Rocky Mountain National Park, CO 80517',
        40.361111,
        -105.604722,
        0.5,
        '$',
        '877-444-6777',
        'camping@rockymountain.com',
        'www.nps.gov/romo',
        0,
        0,
        1
    ),
    (
        8,
        'Stanley Hotel',
        'hotel',
        '333 E Wonderview Ave, Estes Park, CO 80517',
        40.382778,
        -105.518611,
        6.8,
        '$$$',
        '970-577-4000',
        'info@stanleyhotel.com',
        'www.stanleyhotel.com',
        1,
        1,
        1
    ),
    -- Olympic
    (
        9,
        'Lake Crescent Lodge',
        'lodge',
        '416 Lake Crescent Rd, Port Angeles, WA 98363',
        48.055000,
        -123.803056,
        0.2,
        '$$$',
        '360-928-3211',
        'reservations@olympicnationalparks.com',
        'www.olympicnationalparks.com',
        0,
        0,
        1
    ),
    (
        9,
        'Kalaloch Campground',
        'campground',
        'Olympic National Park, Forks, WA 98331',
        47.610556,
        -124.374167,
        0.1,
        '$',
        '877-444-6777',
        'camping@olympic.com',
        'www.nps.gov/olym',
        0,
        0,
        1
    ),
    (
        9,
        'Lake Quinault Lodge',
        'hotel',
        '345 S Shore Rd, Quinault, WA 98575',
        47.462222,
        -123.853056,
        28.3,
        '$$',
        '360-288-2900',
        'info@olympicnationalparks.com',
        'www.olympicnationalparks.com',
        1,
        1,
        1
    ),
    -- Everglades
    (
        10,
        'Flamingo Lodge (Historic)',
        'lodge',
        'Flamingo, Everglades National Park, FL 33034',
        25.141111,
        -80.920833,
        0.3,
        '$$',
        '239-695-3101',
        'reservations@flamingolodge.com',
        'www.flamingolodge.com',
        1,
        0,
        1
    ),
    (
        10,
        'Long Pine Key Campground',
        'campground',
        'Everglades National Park, FL 33034',
        25.382222,
        -80.680556,
        0.5,
        '$',
        '877-444-6777',
        'camping@everglades.com',
        'www.nps.gov/ever',
        0,
        0,
        1
    ),
    (
        10,
        'Ivey House',
        'hotel',
        '107 Camellia St, Everglades City, FL 34139',
        25.857500,
        -81.385000,
        12.8,
        '$$',
        '239-695-3299',
        'info@iveyhouse.com',
        'www.iveyhouse.com',
        1,
        0,
        1
    );

-- ===================================
-- TRIPS
-- ===================================

INSERT INTO
    Trips (
        user_id,
        park_id,
        flight_id,
        lodging_id,
        title,
        description,
        arrival_date,
        departure_date,
        status
    )
VALUES (
        1,
        1,
        1,
        1,
        'Yellowstone Family Adventure',
        'Summer vacation to see Old Faithful and wildlife',
        '2025-07-15',
        '2025-07-20',
        'upcoming'
    ),
    (
        1,
        5,
        13,
        15,
        'Fall Colors in the Smokies',
        'Experience beautiful autumn foliage',
        '2025-10-01',
        '2025-10-05',
        'upcoming'
    ),
    (
        2,
        3,
        8,
        8,
        'Yosemite Solo Backpacking',
        'Challenging hike to Half Dome',
        '2025-08-05',
        '2025-08-10',
        'upcoming'
    ),
    (
        2,
        2,
        5,
        5,
        'Grand Canyon Budget Trip',
        'Hiking and camping at the canyon',
        '2025-06-10',
        '2025-06-14',
        'draft'
    ),
    (
        3,
        6,
        15,
        18,
        'Acadia Coastal Retreat',
        'Relaxing trip to see Cadillac Mountain sunrise',
        '2025-09-15',
        '2025-09-20',
        'upcoming'
    ),
    (
        4,
        6,
        15,
        18,
        'Acadia Coastal Retreat',
        'Relaxing trip to see Cadillac Mountain sunrise',
        '2025-09-15',
        '2025-09-20',
        'upcoming'
    ),
    (
        5,
        7,
        17,
        20,
        'Glacier Photography Expedition',
        'Capture stunning mountain landscapes',
        '2025-07-25',
        '2025-07-31',
        'upcoming'
    ),
    (
        5,
        8,
        19,
        23,
        'Rocky Mountain High Adventure',
        'High altitude hiking and wildlife viewing',
        '2025-08-15',
        '2025-08-20',
        'draft'
    ),
    (
        6,
        10,
        NULL,
        NULL,
        'Everglades Winter Escape',
        'Planning phase for winter trip',
        '2025-02-15',
        '2025-02-20',
        'draft'
    );

-- ===================================
-- NOTES
-- ===================================

INSERT INTO
    Notes (
        user_id,
        trip_id,
        title,
        content,
        category
    )
VALUES (
        1,
        1,
        'Packing List',
        'Don''t forget: sunscreen, binoculars, bear spray, hiking boots, warm layers for morning',
        'Packing List'
    ),
    (
        1,
        1,
        'Old Faithful Timing',
        'Ranger said Old Faithful erupts every 90 minutes. Best viewing is early morning or sunset.',
        'Tips'
    ),
    (
        1,
        2,
        'Trail Recommendations',
        'Locals recommend Alum Cave Trail and Clingmans Dome for best fall colors',
        'Tips'
    ),
    (
        2,
        3,
        'Half Dome Permit',
        'Successfully got Half Dome permit for August 7th! Start early - 3am recommended.',
        'Planning'
    ),
    (
        2,
        3,
        'Gear Checklist',
        'Need to bring: rope, harness, gloves for cables, plenty of water, energy bars',
        'Packing List'
    ),
    (
        2,
        4,
        'Budget Notes',
        'Camping at Mather saves $200 vs hotel. Cook own meals to save another $100.',
        'Budget'
    ),
    (
        3,
        5,
        'Sunrise at Cadillac Mountain',
        'Cadillac Mountain is first place to see sunrise in US. Arrive 45 min early to get parking.',
        'Tips'
    ),
    (
        3,
        5,
        'Restaurant Recommendation',
        'Jordan Pond House famous for popovers and tea. Make reservation in advance!',
        'Review'
    ),
    (
        5,
        7,
        'Photography Spots',
        'Best locations: Many Glacier, Going-to-the-Sun Road, Lake McDonald. Golden hour is magical.',
        'Photography'
    ),
    (
        5,
        8,
        'Altitude Preparation',
        'Trail Ridge Road reaches 12,000 ft. Drink lots of water and take it slow to avoid altitude sickness.',
        'Tips'
    ),
    (
        1,
        NULL,
        'General Travel Tip',
        'Always book national park lodging 6+ months in advance, especially for summer travel',
        'Tips'
    ),
    (
        2,
        NULL,
        'Hiking Safety',
        'Ten essentials: map, compass, sunglasses, first aid, knife, fire, shelter, food, water, clothes',
        'Safety'
    );

-- ===================================
-- WISHLISTS
-- ===================================

INSERT INTO
    Wishlists (
        user_id,
        park_id,
        priority,
        visited,
        visited_date
    )
VALUES (1, 1, 'high', 0, NULL),
    (1, 2, 'high', 0, NULL),
    (1, 3, 'medium', 0, NULL),
    (1, 5, 'high', 0, NULL),
    (2, 3, 'high', 0, NULL),
    (2, 4, 'high', 0, NULL),
    (2, 7, 'medium', 0, NULL),
    (2, 8, 'medium', 0, NULL),
    (3, 6, 'high', 0, NULL),
    (3, 9, 'medium', 0, NULL),
    (3, 1, 'low', 0, NULL),
    (4, 6, 'high', 0, NULL),
    (4, 5, 'medium', 0, NULL),
    (4, 2, 'medium', 0, NULL),
    (5, 7, 'high', 0, NULL),
    (5, 8, 'high', 0, NULL),
    (5, 3, 'medium', 0, NULL),
    (5, 1, 'low', 0, NULL),
    (6, 10, 'high', 0, NULL),
    (6, 5, 'medium', 0, NULL),
    (6, 9, 'low', 0, NULL);