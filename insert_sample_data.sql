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
    ),
    (
        'Jennifer',
        'Martinez',
        'jennifer.m@email.com',
        'hashed_password_111',
        '214-555-0106'
    ),
    (
        'Robert',
        'Garcia',
        'robert.g@email.com',
        'hashed_password_222',
        '972-555-0107'
    ),
    (
        'Lisa',
        'Anderson',
        'lisa.a@email.com',
        'hashed_password_333',
        '469-555-0108'
    ),
    (
        'James',
        'Wilson',
        'james.w@email.com',
        'hashed_password_444',
        '817-555-0109'
    ),
    (
        'Maria',
        'Rodriguez',
        'maria.r@email.com',
        'hashed_password_555',
        '214-555-0110'
    ),
    (
        'Christopher',
        'Taylor',
        'chris.t@email.com',
        'hashed_password_666',
        '972-555-0111'
    ),
    (
        'Amanda',
        'Moore',
        'amanda.m@email.com',
        'hashed_password_777',
        '469-555-0112'
    ),
    (
        'Daniel',
        'Thomas',
        'daniel.t@email.com',
        'hashed_password_888',
        '817-555-0113'
    ),
    (
        'Jessica',
        'Jackson',
        'jessica.j@email.com',
        'hashed_password_999',
        '214-555-0114'
    ),
    (
        'Matthew',
        'White',
        'matthew.w@email.com',
        'hashed_password_000',
        '972-555-0115'
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

SET
    @user6 = (
        SELECT User_ID
        FROM User
        WHERE
            Email = 'jennifer.m@email.com'
    );

SET
    @user7 = (
        SELECT User_ID
        FROM User
        WHERE
            Email = 'robert.g@email.com'
    );

SET
    @user8 = (
        SELECT User_ID
        FROM User
        WHERE
            Email = 'lisa.a@email.com'
    );

SET
    @user9 = (
        SELECT User_ID
        FROM User
        WHERE
            Email = 'james.w@email.com'
    );

SET
    @user10 = (
        SELECT User_ID
        FROM User
        WHERE
            Email = 'maria.r@email.com'
    );

SET
    @user11 = (
        SELECT User_ID
        FROM User
        WHERE
            Email = 'chris.t@email.com'
    );

SET
    @user12 = (
        SELECT User_ID
        FROM User
        WHERE
            Email = 'amanda.m@email.com'
    );

SET
    @user13 = (
        SELECT User_ID
        FROM User
        WHERE
            Email = 'daniel.t@email.com'
    );

SET
    @user14 = (
        SELECT User_ID
        FROM User
        WHERE
            Email = 'jessica.j@email.com'
    );

SET
    @user15 = (
        SELECT User_ID
        FROM User
        WHERE
            Email = 'matthew.w@email.com'
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
),

-- Jennifer Martinez - Upcoming reservation at Yellowstone
(
    @user6,
    2,
    DATE_ADD(CURDATE(), INTERVAL 25 DAY),
    DATE_ADD(CURDATE(), INTERVAL 28 DAY),
    3,
    1,
    'Jennifer Martinez',
    '214-555-0106',
    'jennifer.m@email.com',
    'RES-20241208-000007',
    'confirmed',
    480.00
),

-- Robert Garcia - Upcoming reservation at Grand Canyon
(
    @user7,
    7,
    DATE_ADD(CURDATE(), INTERVAL 35 DAY),
    DATE_ADD(CURDATE(), INTERVAL 40 DAY),
    4,
    2,
    'Robert Garcia',
    '972-555-0107',
    'robert.g@email.com',
    'RES-20241208-000008',
    'confirmed',
    1000.00
),

-- Lisa Anderson - Upcoming reservation at Yosemite
(
    @user8,
    12,
    DATE_ADD(CURDATE(), INTERVAL 18 DAY),
    DATE_ADD(CURDATE(), INTERVAL 21 DAY),
    2,
    1,
    'Lisa Anderson',
    '469-555-0108',
    'lisa.a@email.com',
    'RES-20241208-000009',
    'confirmed',
    540.00
),

-- James Wilson - Upcoming reservation at Zion
(
    @user9,
    17,
    DATE_ADD(CURDATE(), INTERVAL 50 DAY),
    DATE_ADD(CURDATE(), INTERVAL 54 DAY),
    2,
    1,
    'James Wilson',
    '817-555-0109',
    'james.w@email.com',
    'RES-20241208-000010',
    'confirmed',
    640.00
),

-- Maria Rodriguez - Upcoming reservation at Acadia
(
    @user10,
    22,
    DATE_ADD(CURDATE(), INTERVAL 28 DAY),
    DATE_ADD(CURDATE(), INTERVAL 31 DAY),
    3,
    1,
    'Maria Rodriguez',
    '214-555-0110',
    'maria.r@email.com',
    'RES-20241208-000011',
    'confirmed',
    510.00
),

-- Christopher Taylor - Upcoming reservation at Yellowstone
(
    @user11,
    3,
    DATE_ADD(CURDATE(), INTERVAL 40 DAY),
    DATE_ADD(CURDATE(), INTERVAL 44 DAY),
    2,
    1,
    'Christopher Taylor',
    '972-555-0111',
    'chris.t@email.com',
    'RES-20241208-000012',
    'confirmed',
    680.00
),

-- Amanda Moore - Upcoming reservation at Grand Canyon
(
    @user12,
    8,
    DATE_ADD(CURDATE(), INTERVAL 22 DAY),
    DATE_ADD(CURDATE(), INTERVAL 25 DAY),
    4,
    2,
    'Amanda Moore',
    '469-555-0112',
    'amanda.m@email.com',
    'RES-20241208-000013',
    'confirmed',
    720.00
),

-- Daniel Thomas - Upcoming reservation at Yosemite
(
    @user13,
    13,
    DATE_ADD(CURDATE(), INTERVAL 32 DAY),
    DATE_ADD(CURDATE(), INTERVAL 36 DAY),
    3,
    1,
    'Daniel Thomas',
    '817-555-0113',
    'daniel.t@email.com',
    'RES-20241208-000014',
    'confirmed',
    680.00
),

-- Jessica Jackson - Upcoming reservation at Zion
(
    @user14,
    18,
    DATE_ADD(CURDATE(), INTERVAL 55 DAY),
    DATE_ADD(CURDATE(), INTERVAL 59 DAY),
    2,
    1,
    'Jessica Jackson',
    '214-555-0114',
    'jessica.j@email.com',
    'RES-20241208-000015',
    'confirmed',
    640.00
),

-- Matthew White - Upcoming reservation at Acadia
(
    @user15,
    23,
    DATE_ADD(CURDATE(), INTERVAL 38 DAY),
    DATE_ADD(CURDATE(), INTERVAL 42 DAY),
    4,
    2,
    'Matthew White',
    '972-555-0115',
    'matthew.w@email.com',
    'RES-20241208-000016',
    'confirmed',
    880.00
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
),

-- Jennifer Martinez reviews Yellowstone
(
    @user6,
    1,
    5,
    'Best family vacation ever! The kids loved seeing the geysers and wildlife. Old Faithful Lodge was perfect. Ranger programs were educational and fun. Would definitely come back!',
    DATE_SUB(CURDATE(), INTERVAL 45 DAY)
),

-- Robert Garcia reviews Grand Canyon
(
    @user7,
    6,
    5,
    'Bucket list item checked! The magnitude of the canyon is impossible to describe. Hiked Bright Angel Trail and stayed at Phantom Ranch. Incredible experience from start to finish.',
    DATE_SUB(CURDATE(), INTERVAL 65 DAY)
),

-- Lisa Anderson reviews Yosemite
(
    @user8,
    11,
    4,
    'Stunning natural beauty! El Capitan and Half Dome are magnificent. The valley can get crowded but there are plenty of less traveled trails. Mirror Lake is a hidden gem.',
    DATE_SUB(CURDATE(), INTERVAL 40 DAY)
),

-- James Wilson reviews Zion
(
    @user9,
    16,
    5,
    'The Narrows hike is unforgettable! Wading through the Virgin River with towering canyon walls was magical. Bring a walking stick and water shoes. Best hike I have ever done.',
    DATE_SUB(CURDATE(), INTERVAL 75 DAY)
),

-- Maria Rodriguez reviews Acadia
(
    @user10,
    21,
    4,
    'Gorgeous coastal park! The carriage roads are perfect for biking. Thunder Hole during high tide is spectacular. Jordan Pond House popovers are a must-try. Great fall colors too!',
    DATE_SUB(CURDATE(), INTERVAL 100 DAY)
),

-- Christopher Taylor reviews Yellowstone
(
    @user11,
    1,
    5,
    'Unbelievable geothermal features! Grand Prismatic Spring photos do not do it justice. Saw wolves in Lamar Valley at dawn. Hayden Valley had hundreds of bison. Nature at its finest.',
    DATE_SUB(CURDATE(), INTERVAL 35 DAY)
),

-- Amanda Moore reviews Grand Canyon
(
    @user12,
    6,
    5,
    'Sunrise at Mather Point took my breath away! Desert View Watchtower has amazing panoramic views. The Rim Trail is an easy walk with incredible vistas. Cannot wait to return.',
    DATE_SUB(CURDATE(), INTERVAL 50 DAY)
),

-- Daniel Thomas reviews Yosemite
(
    @user13,
    11,
    5,
    'Vernal Fall hike via Mist Trail was challenging but rewarding. The spray from the waterfall was refreshing on a hot day. Glacier Point at sunset is absolutely stunning. Highly recommend!',
    DATE_SUB(CURDATE(), INTERVAL 28 DAY)
),

-- Jessica Jackson reviews Zion
(
    @user14,
    16,
    4,
    'Angels Landing lived up to the hype! The chains section gets your adrenaline pumping. Views from the top are worth every nerve-wracking moment. Not for those afraid of heights!',
    DATE_SUB(CURDATE(), INTERVAL 60 DAY)
),

-- Matthew White reviews Acadia
(
    @user15,
    21,
    5,
    'Cadillac Mountain for sunrise was incredible! First place to see sunrise in the US. Park Loop Road is scenic and well-maintained. Sand Beach is beautiful even in cooler weather.',
    DATE_SUB(CURDATE(), INTERVAL 80 DAY)
);

-- Verify data insertion
SELECT 'Users inserted:' as Status, COUNT(*) as Count FROM User;

SELECT 'Reservations inserted:' as Status, COUNT(*) as Count
FROM Lodging_Reservation;

SELECT 'Reviews inserted:' as Status, COUNT(*) as Count
FROM Park_Review;