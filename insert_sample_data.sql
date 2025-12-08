-- Insert Sample Data for ParkPal App Testing
-- This script inserts users, reservations, and reviews for full CRUD demo

USE group12;

-- Clean up existing sample data (optional - comment out if you want to keep existing data)
DELETE FROM Park_Review
WHERE
    User_ID IN (
        SELECT User_ID
        FROM User
        WHERE
            Email LIKE '%@email.com'
    );

DELETE FROM Lodging_Reservation
WHERE
    User_ID IN (
        SELECT User_ID
        FROM User
        WHERE
            Email LIKE '%@email.com'
    );

DELETE FROM User WHERE Email LIKE '%@email.com';

-- Insert Sample Users
-- Password_Hash is just a placeholder for demo purposes (in production, use proper bcrypt/argon2 hashing)
INSERT INTO
    User (
        First_Name,
        Last_Name,
        Email,
        Password_Hash,
        Phone_Number
    )
VALUES (
        'John',
        'Smith',
        'john.smith@email.com',
        'hashed_password_123',
        '214-555-0101'
    ),
    (
        'Sarah',
        'Johnson',
        'sarah.j@email.com',
        'hashed_password_456',
        '214-555-0102'
    ),
    (
        'Michael',
        'Williams',
        'mike.w@email.com',
        'hashed_password_789',
        '972-555-0103'
    ),
    (
        'Emily',
        'Davis',
        'emily.d@email.com',
        'hashed_password_321',
        '469-555-0104'
    ),
    (
        'David',
        'Brown',
        'david.b@email.com',
        'hashed_password_654',
        '817-555-0105'
    );

-- Insert Sample Reservations (using actual Lodging_IDs from your database)
-- Note: Using LAST_INSERT_ID() offset to reference newly created users
-- These are example reservations for Yellowstone, Grand Canyon, Yosemite, Zion, and Acadia lodging

SET
    @user1 = (
        SELECT User_ID
        FROM User
        WHERE
            Email = 'john.smith@email.com'
    );

SET
    @user2 = (
        SELECT User_ID
        FROM User
        WHERE
            Email = 'sarah.j@email.com'
    );

SET
    @user3 = (
        SELECT User_ID
        FROM User
        WHERE
            Email = 'mike.w@email.com'
    );

SET
    @user4 = (
        SELECT User_ID
        FROM User
        WHERE
            Email = 'emily.d@email.com'
    );

SET
    @user5 = (
        SELECT User_ID
        FROM User
        WHERE
            Email = 'david.b@email.com'
    );

INSERT INTO
    Lodging_Reservation (
        User_ID,
        Lodging_ID,
        Check_In_Date,
        Check_Out_Date,
        Number_Of_Guests,
        Number_Of_Rooms,
        Guest_Name,
        Guest_Phone,
        Guest_Email,
        Confirmation_Number,
        Reservation_Status,
        Total_Cost
    )
VALUES
    -- John Smith - Upcoming reservation at Yellowstone
    (
        @user1,
        1,
        DATE_ADD(CURDATE(), INTERVAL 30 DAY),
        DATE_ADD(CURDATE(), INTERVAL 33 DAY),
        2,
        1,
        'John Smith',
        '214-555-0101',
        'john.smith@email.com',
        'RES-20241208-000001',
        'confirmed',
        600.00
    ),

-- Sarah Johnson - Upcoming reservation at Grand Canyon
(
    @user2,
    6,
    DATE_ADD(CURDATE(), INTERVAL 15 DAY),
    DATE_ADD(CURDATE(), INTERVAL 18 DAY),
    4,
    2,
    'Sarah Johnson',
    '214-555-0102',
    'sarah.j@email.com',
    'RES-20241208-000002',
    'confirmed',
    900.00
),

-- Michael Williams - Upcoming reservation at Yosemite
(
    @user3,
    11,
    DATE_ADD(CURDATE(), INTERVAL 10 DAY),
    DATE_ADD(CURDATE(), INTERVAL 13 DAY),
    2,
    1,
    'Michael Williams',
    '972-555-0103',
    'mike.w@email.com',
    'RES-20241208-000003',
    'confirmed',
    450.00
),

-- Emily Davis - Upcoming reservation at Zion
(
    @user4,
    16,
    DATE_ADD(CURDATE(), INTERVAL 45 DAY),
    DATE_ADD(CURDATE(), INTERVAL 49 DAY),
    3,
    1,
    'Emily Davis',
    '469-555-0104',
    'emily.d@email.com',
    'RES-20241208-000004',
    'confirmed',
    720.00
),

-- David Brown - Upcoming reservation at Acadia
(
    @user5,
    21,
    DATE_ADD(CURDATE(), INTERVAL 20 DAY),
    DATE_ADD(CURDATE(), INTERVAL 23 DAY),
    2,
    1,
    'David Brown',
    '817-555-0105',
    'david.b@email.com',
    'RES-20241208-000005',
    'confirmed',
    0.00
),

-- John Smith - Another upcoming reservation at Grand Canyon (for multiple bookings demo)
(
    @user1,
    6,
    DATE_ADD(CURDATE(), INTERVAL 60 DAY),
    DATE_ADD(CURDATE(), INTERVAL 63 DAY),
    2,
    1,
    'John Smith',
    '214-555-0101',
    'john.smith@email.com',
    'RES-20241208-000006',
    'confirmed',
    450.00
);

-- Insert Sample Reviews
-- These reviews are for parks where users have completed stays or general visits

INSERT INTO
    Park_Review (
        User_ID,
        Park_ID,
        Rating,
        Review_Text,
        Visit_Date
    )
VALUES
    -- Michael Williams reviews Yosemite (after his stay)
    (
        @user3,
        11,
        5,
        'Absolutely breathtaking! The waterfalls in spring are incredible. Half Dome hike was challenging but worth every step. The lodging was comfortable and the park rangers were very helpful.',
        DATE_SUB(CURDATE(), INTERVAL 58 DAY)
    ),

-- John Smith reviews Yellowstone
(
    @user1,
    1,
    5,
    'Old Faithful never disappoints! Saw bison, elk, and even a grizzly bear from a safe distance. The geothermal features are otherworldly. Great family destination with excellent facilities.',
    DATE_SUB(CURDATE(), INTERVAL 120 DAY)
),

-- Sarah Johnson reviews Grand Canyon
(
    @user2,
    6,
    4,
    'The views are spectacular, especially at sunset. South Rim has great viewpoints and hiking trails. It gets crowded in summer but totally worth it. Wish we had more time to explore.',
    DATE_SUB(CURDATE(), INTERVAL 180 DAY)
),

-- Emily Davis reviews Zion
(
    @user4,
    16,
    5,
    'Angels Landing is a must-do if you are not afraid of heights! The Narrows hike through the river was unique and refreshing. Beautiful red rock formations everywhere you look.',
    DATE_SUB(CURDATE(), INTERVAL 200 DAY)
),

-- David Brown reviews Acadia
(
    @user5,
    21,
    4,
    'Cadillac Mountain sunrise is worth waking up early for! Great mix of ocean and mountain scenery. Jordan Pond Path is perfect for families. Lobster rolls in nearby Bar Harbor are amazing!',
    DATE_SUB(CURDATE(), INTERVAL 150 DAY)
),

-- John Smith reviews Grand Canyon (he is a frequent traveler)
(
    @user1,
    6,
    5,
    'Second visit here and it is just as amazing. Took the mule ride down to Phantom Ranch this time. Sunrise at Mather Point is incredible. The visitor center has great educational exhibits.',
    DATE_SUB(CURDATE(), INTERVAL 88 DAY)
),

-- Sarah Johnson reviews Yellowstone
(
    @user2,
    1,
    5,
    'Wildlife viewing was fantastic! Morning and evening are best times. The Grand Prismatic Spring is even more colorful in person. Lamar Valley is the Serengeti of North America!',
    DATE_SUB(CURDATE(), INTERVAL 30 DAY)
),

-- Michael Williams reviews Zion
(
    @user3,
    16,
    4,
    'Great park but very busy in peak season. Shuttle system works well. The Emerald Pools trail is beautiful and not too strenuous. Kolob Canyons section is underrated and less crowded.',
    DATE_SUB(CURDATE(), INTERVAL 20 DAY)
);

-- Verify data insertion
SELECT 'Users inserted:' as Status, COUNT(*) as Count FROM User;

SELECT 'Reservations inserted:' as Status, COUNT(*) as Count
FROM Lodging_Reservation;

SELECT 'Reviews inserted:' as Status, COUNT(*) as Count
FROM Park_Review;