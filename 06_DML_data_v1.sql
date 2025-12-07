-- ============================================
-- ParkPal Database - DML Script
-- Database: MySQL Server (group12)
-- Version: 1.0
-- Date: December 6, 2025
-- Description: Data Manipulation Language (DML) script for ParkPal
--              Populates National_Park table with all 63 US National Parks
-- ============================================

USE group12;

-- ============================================
-- DROP EXISTING DATA (Clear tables before insertion)
-- ============================================
-- Drop in reverse dependency order to avoid foreign key constraint violations

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE Park_Airport;

TRUNCATE TABLE Lodging;

TRUNCATE TABLE Flight;

TRUNCATE TABLE Airport;

TRUNCATE TABLE National_Park;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- NATIONAL PARK DATA (All 63 US National Parks)
-- ============================================

INSERT INTO
    National_Park (
        Park_ID,
        Park_Name,
        State,
        Region,
        Description,
        Wildlife_Information,
        Plant_Information,
        Area_Square_Miles,
        Annual_Visitors,
        Best_Time_To_Visit,
        Entry_Fee,
        Free_Entry_Days,
        Official_Website,
        Latitude,
        Longitude,
        Park_Activities_Events,
        Popular_Park_Trails,
        Difficulty_Rating,
        Kid_Friendliness_Rating,
        Pet_Friendliness_Rating
    )
VALUES
    -- 1. Acadia National Park
    (
        1,
        'Acadia National Park',
        'Maine',
        'Northeast',
        'Acadia National Park protects the natural beauty of the highest rocky headlands along the Atlantic coastline, an abundance of habitats, and a rich cultural heritage.',
        'White-tailed deer, moose, black bears, peregrine falcons, bald eagles',
        'Spruce-fir forests, pitch pine, northern hardwoods, wildflowers',
        49.0,
        3970260,
        'May to October',
        30.00,
        'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
        'https://www.nps.gov/acad',
        44.35000000,
        -68.21000000,
        'Carriage road biking, rock climbing, kayaking, ranger programs, stargazing',
        'Precipice Trail, Beehive Trail, Jordan Pond Path, Cadillac Mountain Summit',
        'Moderate to Strenuous',
        4,
        3
    ),

-- 2. American Samoa National Park
(
    2,
    'American Samoa National Park',
    'American Samoa',
    'Pacific Islands',
    'The National Park of American Samoa welcomes you into the heart of the South Pacific, on islands with dramatic volcanic landscapes, tropical rainforests, and pristine coral reefs.',
    'Flying foxes (fruit bats), sea turtles, tropical fish, reef sharks',
    'Tropical rainforest, coconut palms, banyan trees, pandanus',
    13.5,
    8495,
    'Year-round (dry season: May to October)',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/npsa',
    -14.25833333,
    -170.68333333,
    'Snorkeling, hiking, cultural programs, village visits, wildlife watching',
    'Mount Alava Trail, Pola Island Trail, Tuafanua Trail',
    'Moderate to Strenuous',
    3,
    2
),

-- 3. Arches National Park
(
    3,
    'Arches National Park',
    'Utah',
    'Southwest',
    'Visit Arches to discover a landscape of contrasting colors, landforms, and textures unlike any other in the world. Over 2,000 natural stone arches invite you to explore this red rock wonderland.',
    'Desert bighorn sheep, mule deer, kangaroo rats, golden eagles',
    'Blackbrush, Indian ricegrass, yucca, cryptobiotic soil crusts',
    119.8,
    1663557,
    'April to May, September to October',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/arch',
    38.73333333,
    -109.59166667,
    'Hiking, photography, rock climbing, stargazing, ranger programs',
    'Delicate Arch Trail, Devils Garden, Landscape Arch, Windows Trail',
    'Easy to Strenuous',
    4,
    3
),

-- 4. Badlands National Park
(
    4,
    'Badlands National Park',
    'South Dakota',
    'Midwest',
    'The Badlands began forming about 75 million years ago. The layered rock formations reveal a dramatic landscape of sharply eroded buttes, pinnacles, and spires.',
    'Bison, bighorn sheep, black-footed ferrets, prairie dogs, pronghorn',
    'Mixed-grass prairie, yucca, prickly pear cactus, western wheatgrass',
    379.3,
    916932,
    'May to September',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/badl',
    43.85500000,
    -102.33900000,
    'Hiking, fossil hunting, wildlife viewing, photography, night sky programs',
    'Notch Trail, Castle Trail, Saddle Pass Trail, Door Trail',
    'Easy to Strenuous',
    4,
    3
),

-- 5. Big Bend National Park
(
    5,
    'Big Bend National Park',
    'Texas',
    'Southwest',
    'Big Bend is a land of borders, the Rio Grande Wild and Scenic River forming the boundary between Mexico and the United States, and a landscape of contrasts.',
    'Black bears, mountain lions, javelinas, roadrunners, Mexican long-nosed bats',
    'Desert plants, century plants, ocotillo, cottonwood trees in river areas',
    1252.0,
    581220,
    'November to April',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/bibe',
    29.25000000,
    -103.25000000,
    'Hiking, river rafting, birdwatching, hot springs soaking, backcountry camping',
    'South Rim, Lost Mine Trail, Santa Elena Canyon, Chisos Basin Loop',
    'Easy to Strenuous',
    3,
    3
),

-- 6. Biscayne National Park
(
    6,
    'Biscayne National Park',
    'Florida',
    'Southeast',
    'Within sight of Miami, yet a world away, Biscayne protects a rare combination of aquamarine waters, emerald islands, and fish-bejeweled coral reefs.',
    'Manatees, dolphins, sea turtles, tropical fish, crocodiles',
    'Mangroves, seagrass beds, coral reefs, tropical hardwood hammocks',
    270.3,
    705655,
    'December to April',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/bisc',
    25.65000000,
    -80.08333333,
    'Snorkeling, scuba diving, kayaking, boating, fishing, island camping',
    'Maritime Heritage Trail (underwater), Jones Lagoon Paddling Trail',
    'Easy to Moderate',
    5,
    2
),

-- 7. Black Canyon of the Gunnison National Park
(
    7,
    'Black Canyon of the Gunnison National Park',
    'Colorado',
    'Rocky Mountains',
    'Big enough to be overwhelming, still intimate enough to feel the pulse of time, Black Canyon of the Gunnison exposes you to some of the steepest cliffs, oldest rock, and craggiest spires in North America.',
    'Mule deer, elk, golden eagles, peregrine falcons, black bears',
    'Pinyon-juniper woodland, sagebrush, Gambel oak, Douglas fir',
    48.2,
    308962,
    'May to October',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/blca',
    38.57277778,
    -107.72166667,
    'Scenic drives, hiking, rock climbing, fishing, stargazing',
    'Warner Point Nature Trail, Oak Flat Loop, Rim Rock Trail, Painted Wall View',
    'Easy to Strenuous',
    4,
    3
),

-- 8. Bryce Canyon National Park
(
    8,
    'Bryce Canyon National Park',
    'Utah',
    'Southwest',
    'Hoodoos (irregular columns of rock) exist on every continent, but here is the largest concentration found anywhere on Earth. Explore the otherworldly landscape of Bryce Canyon.',
    'Mule deer, pronghorn, Utah prairie dogs, mountain lions, ravens',
    'Ponderosa pine, pinyon-juniper, aspen, bristlecone pine',
    56.0,
    2104600,
    'April to May, September to October',
    35.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/brca',
    37.59333333,
    -112.18666667,
    'Hiking, horseback riding, stargazing, photography, ranger programs',
    'Navajo Loop Trail, Queens Garden Trail, Peek-a-boo Loop, Fairyland Loop',
    'Moderate to Strenuous',
    4,
    3
),

-- 9. Canyonlands National Park
(
    9,
    'Canyonlands National Park',
    'Utah',
    'Southwest',
    'Canyonlands invites you to explore a wilderness of countless canyons and fantastically formed buttes carved by the Colorado River and its tributaries.',
    'Desert bighorn sheep, coyotes, gray foxes, peregrine falcons',
    'Blackbrush, pinyon-juniper, cryptobiotic soil, desert wildflowers',
    527.5,
    911594,
    'March to May, September to October',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/cany',
    38.32666667,
    -109.87833333,
    '4WD adventures, hiking, mountain biking, rafting, stargazing',
    'Mesa Arch Trail, Grand View Point, Upheaval Dome, Chesler Park Loop',
    'Easy to Strenuous',
    3,
    3
),

-- 10. Capitol Reef National Park
(
    10,
    'Capitol Reef National Park',
    'Utah',
    'Southwest',
    'Located in south-central Utah in the heart of red rock country, Capitol Reef National Park is a hidden treasure filled with cliffs, canyons, domes, and bridges in the Waterpocket Fold.',
    'Mule deer, desert bighorn sheep, mountain lions, golden eagles',
    'Pinyon-juniper, cottonwood, fruit orchards, desert plants',
    378.0,
    1405353,
    'April to May, September to October',
    20.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/care',
    38.36666667,
    -111.26166667,
    'Scenic drives, hiking, fruit picking, rock art viewing, stargazing',
    'Cassidy Arch, Hickman Bridge, Capitol Gorge, Cohab Canyon',
    'Easy to Strenuous',
    4,
    3
),

-- 11. Carlsbad Caverns National Park
(
    11,
    'Carlsbad Caverns National Park',
    'New Mexico',
    'Southwest',
    'High ancient sea ledges, deep rocky canyons, flowering cactus, and desert wildlife—this landscape is maze of hidden beauty. Beneath the surface are more than 119 caves formed when sulfuric acid dissolved limestone.',
    'Brazilian free-tailed bats, ringtails, rattlesnakes, mule deer',
    'Chihuahuan Desert plants, lechuguilla, sotol, ocotillo',
    73.0,
    440691,
    'Year-round (bat flight: May to October)',
    15.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/cave',
    32.17500000,
    -104.44388889,
    'Cave tours, bat flight programs, hiking, ranger-led tours, photography',
    'Big Room (cave), Natural Entrance Trail, Rattlesnake Springs',
    'Easy to Strenuous',
    4,
    2
),

-- 12. Channel Islands National Park
(
    12,
    'Channel Islands National Park',
    'California',
    'West Coast',
    'Channel Islands National Park encompasses five remarkable islands and their ocean environment, preserving and protecting a wealth of natural and cultural resources.',
    'Island foxes, sea lions, seals, blue whales, brown pelicans',
    'Island scrub oak, giant coreopsis, island cherry, coastal sage',
    389.5,
    319252,
    'April to May, September to October',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/chis',
    34.00583333,
    -119.77277778,
    'Kayaking, snorkeling, diving, hiking, whale watching, camping',
    'Cavern Point Loop, Potato Harbor, Anacapa Island Inspiration Point',
    'Easy to Strenuous',
    3,
    1
),

-- 13. Congaree National Park
(
    13,
    'Congaree National Park',
    'South Carolina',
    'Southeast',
    'Astonishing biodiversity exists in Congaree National Park, the largest intact expanse of old growth bottomland hardwood forest remaining in the southeastern United States.',
    'White-tailed deer, wild boar, otters, owls, woodpeckers',
    'Bald cypress, water tupelo, loblolly pine, bottomland hardwoods',
    41.4,
    215181,
    'March to May, September to November',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/cong',
    33.78333333,
    -80.78333333,
    'Canoeing, kayaking, hiking, birdwatching, ranger programs',
    'Boardwalk Loop, Weston Lake Loop, Kingsnake Trail, River Trail',
    'Easy to Moderate',
    5,
    3
),

-- 14. Crater Lake National Park
(
    14,
    'Crater Lake National Park',
    'Oregon',
    'West Coast',
    'Crater Lake inspires awe. Native Americans witnessed its formation 7,700 years ago, when a violent eruption triggered the collapse of a tall peak. The lake is the deepest in the United States.',
    'Black bears, elk, marmots, pika, bald eagles',
    'Mountain hemlock, whitebark pine, wildflowers, old-growth forests',
    286.3,
    720659,
    'July to September',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/crla',
    42.94833333,
    -122.10944444,
    'Scenic drives, hiking, boat tours, swimming, snowshoeing (winter)',
    'Cleetwood Cove Trail, Watchman Peak, Garfield Peak, Wizard Island Summit',
    'Moderate to Strenuous',
    4,
    3
),

-- 15. Cuyahoga Valley National Park
(
    15,
    'Cuyahoga Valley National Park',
    'Ohio',
    'Midwest',
    'Though a short distance from the urban areas of Cleveland and Akron, Cuyahoga Valley National Park seems worlds away. The park is a refuge for native plants and wildlife.',
    'White-tailed deer, beavers, great blue herons, bald eagles, coyotes',
    'Eastern deciduous forest, wetlands, meadows, wildflowers',
    51.0,
    2575275,
    'May to October',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/cuva',
    41.24055556,
    -81.55083333,
    'Hiking, biking, scenic railroad, kayaking, birdwatching',
    'Brandywine Gorge Trail, Ledges Trail, Towpath Trail, Blue Hen Falls',
    'Easy to Moderate',
    5,
    4
),

-- 16. Death Valley National Park
(
    16,
    'Death Valley National Park',
    'California, Nevada',
    'Southwest',
    'In this below-sea-level basin, steady drought and record summer heat make Death Valley a land of extremes. Yet, each extreme has a striking contrast.',
    'Desert bighorn sheep, coyotes, kit foxes, roadrunners, pupfish',
    'Creosote bush, desert holly, mesquite, wildflowers (spring)',
    5270.0,
    1146551,
    'November to March',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/deva',
    36.50500000,
    -117.07944444,
    'Scenic drives, hiking, stargazing, photography, sand dune exploration',
    'Golden Canyon, Zabriskie Point, Badwater Basin, Dante''s View',
    'Easy to Strenuous',
    3,
    3
),

-- 17. Denali National Park
(
    17,
    'Denali National Park & Preserve',
    'Alaska',
    'Alaska',
    'Denali is six million acres of wild land, bisected by one ribbon of road. Travelers along it see the relatively low-elevation taiga forest give way to high alpine tundra and snowy mountains.',
    'Grizzly bears, wolves, moose, caribou, Dall sheep',
    'Tundra, spruce forests, willow shrubs, wildflowers',
    7408.0,
    229521,
    'June to September',
    15.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/dena',
    63.11500000,
    -151.00000000,
    'Wildlife viewing, bus tours, backpacking, mountaineering, flightseeing',
    'Savage River Loop, Mount Healy Overlook, Triple Lakes Trail',
    'Easy to Strenuous',
    4,
    3
),

-- 18. Dry Tortugas National Park
(
    18,
    'Dry Tortugas National Park',
    'Florida',
    'Southeast',
    'Almost 70 miles west of Key West lies the remote Dry Tortugas National Park. This 100-square mile park is mostly open water with seven small islands.',
    'Sea turtles, tropical fish, frigatebirds, brown noddies, nurse sharks',
    'Seagrass beds, coral reefs, mangroves (limited)',
    100.0,
    79200,
    'Year-round (best: October to April)',
    15.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/drto',
    24.62833333,
    -82.87333333,
    'Snorkeling, diving, fort tours, kayaking, birdwatching, camping',
    'Fort Jefferson Tour, Garden Key Moat Wall, Bush Key (closed in bird season)',
    'Easy to Moderate',
    4,
    1
),

-- 19. Everglades National Park
(
    19,
    'Everglades National Park',
    'Florida',
    'Southeast',
    'Everglades National Park protects an unparalleled landscape that provides important habitat for numerous rare and endangered species like the manatee, American crocodile, and the elusive Florida panther.',
    'American alligators, Florida panthers, manatees, roseate spoonbills, crocodiles',
    'Sawgrass marshes, mangroves, tropical hardwood hammocks, cypress swamps',
    2357.0,
    1110901,
    'December to April',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/ever',
    25.28638889,
    -80.89861111,
    'Kayaking, canoeing, birdwatching, ranger programs, airboat tours (outside park)',
    'Anhinga Trail, Gumbo Limbo Trail, Shark Valley Loop, Ten Thousand Islands',
    'Easy to Moderate',
    5,
    3
),

-- 20. Gates of the Arctic National Park
(
    20,
    'Gates of the Arctic National Park & Preserve',
    'Alaska',
    'Alaska',
    'This vast landscape does not contain any roads or trails. Visitors discover intact ecosystems where people have lived with the land for thousands of years.',
    'Caribou, grizzly bears, wolves, Dall sheep, golden eagles',
    'Tundra, boreal forest, willow shrubs, arctic wildflowers',
    13238.0,
    11045,
    'June to August',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/gaar',
    67.78333333,
    -153.30000000,
    'Backpacking, river trips, flightseeing, wildlife viewing, mountaineering',
    'No established trails - wilderness exploration',
    'Strenuous',
    1,
    2
),

-- 21. Gateway Arch National Park
(
    21,
    'Gateway Arch National Park',
    'Missouri',
    'Midwest',
    'The Gateway Arch reflects St. Louis'' role in the Westward Expansion of the United States during the nineteenth century. At 630 feet, the Arch is the tallest man-made monument in the Western Hemisphere.',
    'Urban wildlife, migratory birds',
    'Urban landscape, riverfront vegetation',
    0.14,
    2016180,
    'Year-round (best: Spring and Fall)',
    0.00,
    'Grounds free; tram to top has fee',
    'https://www.nps.gov/jeff',
    38.62444444,
    -90.18472222,
    'Arch tram ride, museum tours, riverfront walks, ranger programs',
    'Gateway Arch Tram Experience, Museum at the Gateway Arch',
    'Easy',
    5,
    4
),

-- 22. Glacier National Park
(
    22,
    'Glacier National Park',
    'Montana',
    'Rocky Mountains',
    'Come and experience Glacier''s pristine forests, alpine meadows, rugged mountains, and spectacular lakes. Relive the days of old through historic chalets, lodges, and the famous Going-to-the-Sun Road.',
    'Grizzly bears, mountain goats, bighorn sheep, elk, wolves',
    'Alpine wildflowers, cedar-hemlock forests, beargrass, huckleberries',
    1583.0,
    3081656,
    'June to September',
    35.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/glac',
    48.75972222,
    -113.78694444,
    'Scenic drives, hiking, backpacking, boat tours, wildlife viewing',
    'Highline Trail, Grinnell Glacier, Avalanche Lake, Hidden Lake Overlook',
    'Easy to Strenuous',
    4,
    3
),

-- 23. Glacier Bay National Park
(
    23,
    'Glacier Bay National Park & Preserve',
    'Alaska',
    'Alaska',
    'Covering 3.3 million acres of rugged mountains, dynamic glaciers, temperate rainforest, wild coastlines and deep sheltered fjords, Glacier Bay National Park is a highlight of Alaska''s Inside Passage.',
    'Humpback whales, sea otters, brown bears, harbor seals, mountain goats',
    'Temperate rainforest, spruce-hemlock forests, alpine tundra, wildflowers',
    5129.0,
    89768,
    'May to September',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/glba',
    58.66500000,
    -136.90000000,
    'Boat tours, kayaking, whale watching, glacier viewing, flightseeing',
    'Bartlett Cove Forest Loop, Bartlett River Trail (limited trail system)',
    'Easy to Moderate',
    3,
    2
),

-- 24. Grand Canyon National Park
(
    24,
    'Grand Canyon National Park',
    'Arizona',
    'Southwest',
    'Unique combinations of geologic color and erosional forms decorate a canyon that is 277 river miles long, up to 18 miles wide, and a mile deep. Grand Canyon overwhelms our senses through its immense size.',
    'California condors, bighorn sheep, elk, mule deer, mountain lions',
    'Pinyon-juniper, ponderosa pine, Douglas fir, desert scrub',
    1902.0,
    4732101,
    'March to May, September to November',
    35.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/grca',
    36.05694444,
    -112.13972222,
    'Hiking, mule rides, rafting, scenic drives, ranger programs',
    'Bright Angel Trail, South Kaibab Trail, Rim Trail, North Kaibab Trail',
    'Easy to Strenuous',
    4,
    3
),

-- 25. Grand Teton National Park
(
    25,
    'Grand Teton National Park',
    'Wyoming',
    'Rocky Mountains',
    'Rising above a scene rich with extraordinary wildlife, pristine lakes, and alpine terrain, the Teton Range stands monument to the people who fought to protect it.',
    'Grizzly bears, black bears, moose, elk, bison, pronghorn',
    'Sagebrush, cottonwood, aspen, wildflowers, lodgepole pine',
    485.0,
    3417406,
    'June to September',
    35.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/grte',
    43.79027778,
    -110.68166667,
    'Hiking, mountaineering, wildlife viewing, boating, scenic drives',
    'Cascade Canyon, Jenny Lake Loop, Paintbrush Canyon, Delta Lake',
    'Easy to Strenuous',
    4,
    3
),

-- 26. Great Basin National Park
(
    26,
    'Great Basin National Park',
    'Nevada',
    'Southwest',
    'From the 13,063-foot summit of Wheeler Peak, to the sage-covered foothills, Great Basin National Park is a place to sample the stunning diversity of the larger Great Basin region.',
    'Mule deer, mountain lions, bighorn sheep, marmots, bristlecone pines',
    'Sagebrush, pinyon-juniper, aspen, bristlecone pine, alpine plants',
    120.2,
    131802,
    'June to September',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/grba',
    38.98333333,
    -114.30000000,
    'Cave tours, hiking, stargazing, scenic drives, bristlecone pine viewing',
    'Bristlecone Pine Trail, Wheeler Peak Summit, Alpine Lakes Loop, Lehman Caves',
    'Easy to Strenuous',
    4,
    3
),

-- 27. Great Sand Dunes National Park
(
    27,
    'Great Sand Dunes National Park & Preserve',
    'Colorado',
    'Rocky Mountains',
    'The tallest dunes in North America are the centerpiece in a diverse landscape of grasslands, wetlands, conifer and aspen forests, alpine lakes, and tundra.',
    'Bighorn sheep, elk, black bears, kangaroo rats, prairie dogs',
    'Cottonwood forests, piñon-juniper, alpine tundra, wetland grasses',
    232.9,
    527546,
    'May to June, September to October',
    25.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/grsa',
    37.73166667,
    -105.51222222,
    'Sand sledding, sandboarding, hiking, splashing in Medano Creek (seasonal)',
    'High Dune Trail, Star Dune, Mosca Pass Trail, Medano Lake',
    'Moderate to Strenuous',
    5,
    4
),

-- 28. Great Smoky Mountains National Park
(
    28,
    'Great Smoky Mountains National Park',
    'North Carolina, Tennessee',
    'Southeast',
    'World renowned for its diversity of plant and animal life, the beauty of its ancient mountains, and the quality of its remnants of Southern Appalachian mountain culture, this is America''s most visited national park.',
    'Black bears, white-tailed deer, elk, wild turkeys, salamanders',
    'Old-growth forests, wildflowers, rhododendron, mountain laurel, cove hardwoods',
    816.0,
    14161548,
    'April to May, September to October',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/grsm',
    35.68333333,
    -83.53333333,
    'Hiking, scenic drives, wildlife viewing, historic buildings, waterfall viewing',
    'Alum Cave Trail, Clingmans Dome, Laurel Falls, Rainbow Falls, Abrams Falls',
    'Easy to Strenuous',
    5,
    3
),

-- 29. Guadalupe Mountains National Park
(
    29,
    'Guadalupe Mountains National Park',
    'Texas',
    'Southwest',
    'Guadalupe Mountains National Park contains Guadalupe Peak, the highest point in Texas at 8,749 feet, and the scenic McKittrick Canyon with its fall foliage.',
    'Mule deer, elk, mountain lions, golden eagles, rattlesnakes',
    'Chihuahuan Desert plants, Douglas fir, ponderosa pine, bigtooth maple',
    134.9,
    243291,
    'October to November, March to April',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/gumo',
    31.92305556,
    -104.86083333,
    'Hiking, backpacking, wildlife viewing, fall foliage, peak climbing',
    'Guadalupe Peak Trail, Devil''s Hall Trail, McKittrick Canyon, El Capitan',
    'Moderate to Strenuous',
    3,
    3
),

-- 30. Haleakalā National Park
(
    30,
    'Haleakalā National Park',
    'Hawaii',
    'Pacific Islands',
    'This special place vibrates with stories of ancient and modern Hawaiian culture and protects the bond between the land and its people. The park also cares for endangered species.',
    'Nēnē (Hawaiian goose), Hawaiian petrels, silversword plants (unique)',
    'Silversword, native ferns, shrublands, tropical rainforest',
    52.1,
    994394,
    'Year-round (sunrise popular)',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/hale',
    20.71666667,
    -156.25000000,
    'Sunrise viewing, hiking, stargazing, scenic drives, camping',
    'Sliding Sands Trail, Halemau''u Trail, Pipiwai Trail, Hosmer Grove',
    'Easy to Strenuous',
    4,
    3
),

-- 31. Hawaii Volcanoes National Park
(
    31,
    'Hawai''i Volcanoes National Park',
    'Hawaii',
    'Pacific Islands',
    'Hawai''i Volcanoes National Park protects some of the most unique geological, biological, and cherished cultural landscapes in the world. Extending from sea level to 13,681 feet, the park encompasses active volcanoes.',
    'Hawaiian honeycreepers, nēnē, Hawaiian hawk, sea turtles',
    'Tropical rainforest, tree ferns, ʻōhiʻa lehua, native shrubs',
    505.4,
    1116891,
    'Year-round (check volcanic activity)',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/havo',
    19.41972222,
    -155.28833333,
    'Volcano viewing, hiking, ranger programs, lava tube exploration, cultural sites',
    'Kīlauea Iki Trail, Devastation Trail, Thurston Lava Tube, Crater Rim Trail',
    'Easy to Strenuous',
    4,
    3
),

-- 32. Hot Springs National Park
(
    32,
    'Hot Springs National Park',
    'Arkansas',
    'Southeast',
    'Hot Springs National Park has a rich cultural past. The park is based around the hot springs that flow from the western slope of Hot Springs Mountain.',
    'White-tailed deer, gray foxes, raccoons, various bird species',
    'Oak-hickory forest, shortleaf pine, wildflowers',
    9.0,
    1506887,
    'Year-round (best: Spring and Fall)',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/hosp',
    34.52138889,
    -93.04222222,
    'Bathhouse tours, hiking, hot spring bathing, historic architecture viewing',
    'Grand Promenade, Sunset Trail, Hot Springs Mountain Tower, Goat Rock Trail',
    'Easy to Moderate',
    5,
    4
),

-- 33. Indiana Dunes National Park
(
    33,
    'Indiana Dunes National Park',
    'Indiana',
    'Midwest',
    'Indiana Dunes National Park hugs 15 miles of the southern shore of Lake Michigan and has much to offer. Whether you enjoy scouting for rare species of birds or flying kites on the sandy beach, the national park has something for everyone.',
    'White-tailed deer, river otters, various bird species, migratory waterfowl',
    'Oak savannas, prairies, wetlands, dune vegetation, forests',
    24.3,
    2293106,
    'May to September',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/indu',
    41.65638889,
    -87.09444444,
    'Beach activities, hiking, birdwatching, cross-country skiing (winter)',
    'West Beach Trail, Cowles Bog Trail, Dune Ridge Trail, Miller Woods',
    'Easy to Moderate',
    5,
    4
),

-- 34. Isle Royale National Park
(
    34,
    'Isle Royale National Park',
    'Michigan',
    'Midwest',
    'Explore a rugged, isolated island, far from the sights and sounds of civilization. Surrounded by Lake Superior, Isle Royale offers unparalleled solitude and adventures for backpackers, hikers, boaters, kayakers, and scuba divers.',
    'Moose, gray wolves, red foxes, beavers, loons',
    'Boreal forest, spruce-fir, birch, wildflowers, aquatic vegetation',
    894.0,
    25844,
    'Mid-April to October',
    0.00,
    'Park access fee via boat/seaplane',
    'https://www.nps.gov/isro',
    47.99583333,
    -88.90916667,
    'Backpacking, kayaking, canoeing, scuba diving, fishing, wildlife viewing',
    'Greenstone Ridge Trail, Minong Ridge Trail, Feldtmann Loop',
    'Strenuous',
    2,
    2
),

-- 35. Joshua Tree National Park
(
    35,
    'Joshua Tree National Park',
    'California',
    'Southwest',
    'Two distinct desert ecosystems, the Mojave and the Colorado, come together in Joshua Tree National Park. A fascinating variety of plants and animals make their homes in a land sculpted by strong winds and occasional torrents of rain.',
    'Desert bighorn sheep, coyotes, roadrunners, desert tortoises, kangaroo rats',
    'Joshua trees, cholla cactus, ocotillo, creosote bush, wildflowers (spring)',
    1243.0,
    3064400,
    'October to April',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/jotr',
    33.87333333,
    -115.90083333,
    'Rock climbing, hiking, stargazing, photography, wildflower viewing (spring)',
    'Ryan Mountain, Barker Dam, Hidden Valley, Skull Rock, Keys View',
    'Easy to Strenuous',
    4,
    3
),

-- 36. Katmai National Park
(
    36,
    'Katmai National Park & Preserve',
    'Alaska',
    'Alaska',
    'A landscape is alive with lush green meadows, rugged mountains, lakes and streams. Here, brown bears fish for salmon and stunning volcanoes reflect in calm waters.',
    'Brown bears, salmon, moose, caribou, bald eagles',
    'Tundra, spruce forests, alder shrubs, wildflowers',
    6395.0,
    33908,
    'June to September',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/katm',
    58.50000000,
    -155.00000000,
    'Bear viewing, fishing, kayaking, volcano exploration, flightseeing',
    'Brooks Falls Trail, Valley of Ten Thousand Smokes, Dumpling Mountain',
    'Easy to Strenuous',
    3,
    2
),

-- 37. Kenai Fjords National Park
(
    37,
    'Kenai Fjords National Park',
    'Alaska',
    'Alaska',
    'At the edge of the Kenai Peninsula lies a land where the ice age lingers. Nearly 40 glaciers flow from the Harding Icefield, Kenai Fjords'' crowning feature.',
    'Sea otters, humpback whales, orcas, puffins, harbor seals, black bears',
    'Coastal rainforest, spruce-hemlock, alder, wildflowers',
    1047.0,
    411782,
    'May to September',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/kefj',
    59.91777778,
    -149.65777778,
    'Boat tours, kayaking, glacier viewing, wildlife watching, hiking',
    'Harding Icefield Trail, Exit Glacier Trail, Aialik Bay',
    'Moderate to Strenuous',
    3,
    2
),

-- 38. Kings Canyon National Park
(
    38,
    'Kings Canyon National Park',
    'California',
    'West Coast',
    'Kings Canyon National Park features terrain similar to Yosemite Valley, and is home to the largest remaining grove of sequoia trees in the world. This park forms a vast wilderness of high mountain peaks, deep canyons, and giant sequoias.',
    'Black bears, mule deer, bighorn sheep, marmots, mountain lions',
    'Giant sequoias, mixed conifer forests, alpine meadows, wildflowers',
    722.0,
    632110,
    'May to September',
    35.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/seki',
    36.88777778,
    -118.55527778,
    'Hiking, backpacking, sequoia viewing, rock climbing, scenic drives',
    'Mist Falls Trail, Zumwalt Meadow, Big Stump Trail, Rae Lakes Loop',
    'Easy to Strenuous',
    4,
    3
),

-- 39. Kobuk Valley National Park
(
    39,
    'Kobuk Valley National Park',
    'Alaska',
    'Alaska',
    'Caribou, sand dunes, and the Kobuk River are found in this Arctic park. Half a million caribou migrate through, their tracks crisscrossing sculpted dunes.',
    'Caribou, grizzly bears, wolves, moose, salmon',
    'Boreal forest, tundra, sand dunes, willow shrubs',
    2735.0,
    15500,
    'June to August',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/kova',
    67.35000000,
    -159.28333333,
    'River trips, caribou viewing, sand dune exploration, backpacking',
    'Great Kobuk Sand Dunes, Kobuk River float trips (no maintained trails)',
    'Strenuous',
    1,
    2
),

-- 40. Lake Clark National Park
(
    40,
    'Lake Clark National Park & Preserve',
    'Alaska',
    'Alaska',
    'Lake Clark National Park and Preserve is a land of stunning beauty where volcanoes steam, salmon run, bears forage, and craggy mountains reflect in shimmering turquoise lakes.',
    'Brown bears, moose, Dall sheep, salmon, caribou',
    'Boreal forest, tundra, coastal rainforest, wildflowers',
    6297.0,
    17157,
    'June to September',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/lacl',
    60.41666667,
    -154.31666667,
    'Bear viewing, fishing, kayaking, backpacking, flightseeing',
    'Tanalian Falls Trail, Tuxedni Bay, Telaquana Trail (backcountry)',
    'Moderate to Strenuous',
    2,
    2
),

-- 41. Lassen Volcanic National Park
(
    41,
    'Lassen Volcanic National Park',
    'California',
    'West Coast',
    'Lassen Volcanic National Park is home to steaming fumaroles, meadows freckled with wildflowers, clear mountain lakes, and numerous volcanoes. Jagged peaks tell the story of its eruptive past.',
    'Black bears, mule deer, mountain lions, Clark''s nutcrackers, pikas',
    'Red fir, lodgepole pine, Jeffrey pine, wildflowers, alpine vegetation',
    166.0,
    517039,
    'June to September',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/lavo',
    40.49777778,
    -121.42055556,
    'Hiking, hydrothermal viewing, camping, snowshoeing (winter), scenic drives',
    'Bumpass Hell Trail, Lassen Peak Summit, Cinder Cone, Kings Creek Falls',
    'Moderate to Strenuous',
    4,
    3
),

-- 42. Mammoth Cave National Park
(
    42,
    'Mammoth Cave National Park',
    'Kentucky',
    'Southeast',
    'Rolling hills, deep river valleys, and the world''s longest known cave system. Mammoth Cave National Park preserves this unique and historic natural wonder.',
    'White-tailed deer, raccoons, bats, cave crickets, river otters',
    'Oak-hickory forest, cedar trees, cave ecosystems, river vegetation',
    85.0,
    551590,
    'Year-round (cave tours available)',
    0.00,
    'Cave tours have fees',
    'https://www.nps.gov/maca',
    37.18638889,
    -86.09972222,
    'Cave tours, hiking, canoeing, horseback riding, ranger programs',
    'Historic Tour, Frozen Niagara Tour, Green River Bluffs Trail, Cedar Sink Trail',
    'Easy to Strenuous',
    5,
    3
),

-- 43. Mesa Verde National Park
(
    43,
    'Mesa Verde National Park',
    'Colorado',
    'Southwest',
    'Mesa Verde National Park preserves the archeological legacy of the Ancestral Pueblo people who made this place their home for over 700 years, from 600 to 1300 CE.',
    'Mule deer, elk, mountain lions, black bears, wild turkeys',
    'Piñon-juniper woodland, mountain shrubland, Douglas fir, Gambel oak',
    81.4,
    548477,
    'May to September',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/meve',
    37.18444444,
    -108.49111111,
    'Cliff dwelling tours, archaeological sites, museum visits, scenic drives',
    'Cliff Palace Tour, Balcony House Tour, Spruce Tree House, Petroglyph Point',
    'Moderate to Strenuous',
    4,
    3
),

-- 44. Mount Rainier National Park
(
    44,
    'Mount Rainier National Park',
    'Washington',
    'West Coast',
    'Ascending to 14,410 feet above sea level, Mount Rainier stands as an icon in the Washington landscape. An active volcano, Mount Rainier is the most glaciated peak in the contiguous U.S.A.',
    'Black bears, elk, mountain goats, marmots, spotted owls',
    'Old-growth forests, subalpine meadows, wildflowers, glaciers',
    369.3,
    1670063,
    'July to September',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/mora',
    46.85277778,
    -121.76055556,
    'Hiking, mountaineering, wildflower viewing, scenic drives, camping',
    'Skyline Trail, Wonderland Trail, Naches Peak Loop, Spray Park',
    'Easy to Strenuous',
    4,
    3
),

-- 45. New River Gorge National Park
(
    45,
    'New River Gorge National Park & Preserve',
    'West Virginia',
    'Southeast',
    'The New River Gorge has carved a deep and spectacular canyon through the Appalachian Mountains. This area is rich in cultural and natural history and offers an abundance of scenic and recreational opportunities.',
    'White-tailed deer, black bears, river otters, bald eagles, wild turkeys',
    'Mixed hardwood forests, rhododendron, mountain laurel, riverbank vegetation',
    12.9,
    1682720,
    'April to October',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/neri',
    37.99027778,
    -81.05805556,
    'Whitewater rafting, rock climbing, hiking, bridge walks, scenic overlooks',
    'Endless Wall Trail, Long Point Trail, Grandview Rim Trail, Kaymoor Trail',
    'Easy to Strenuous',
    4,
    3
),

-- 46. North Cascades National Park
(
    46,
    'North Cascades National Park',
    'Washington',
    'West Coast',
    'Less than three hours from Seattle, an alpine landscape beckons. Discover communities of life adapted to moisture in the west and recurring fire in the east. Explore jagged peaks crowned by more than 300 glaciers.',
    'Black bears, gray wolves, mountain goats, lynx, wolverines',
    'Old-growth forests, alpine meadows, wildflowers, glaciers',
    684.6,
    40089,
    'June to September',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/noca',
    48.77194444,
    -121.30027778,
    'Hiking, backpacking, mountaineering, boating on Ross Lake, scenic drives',
    'Cascade Pass Trail, Thornton Lakes, Maple Pass Loop, Hidden Lake Peaks',
    'Moderate to Strenuous',
    3,
    3
),

-- 47. Olympic National Park
(
    47,
    'Olympic National Park',
    'Washington',
    'West Coast',
    'With its incredible range of precipitation and elevation, diversity is the hallmark of Olympic National Park. Encompassing nearly a million acres, the park protects a vast wilderness, thousands of years of human history, and several ecosystems.',
    'Roosevelt elk, black bears, mountain goats, sea otters, gray whales',
    'Temperate rainforest, old-growth forests, alpine meadows, coastal ecosystems',
    1442.0,
    2718925,
    'July to September',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/olym',
    47.80194444,
    -123.60444444,
    'Hiking, backpacking, tide pooling, scenic drives, rainforest exploration',
    'Hoh Rain Forest Trail, Hurricane Ridge, Sol Duc Falls, Rialto Beach',
    'Easy to Strenuous',
    4,
    3
),

-- 48. Petrified Forest National Park
(
    48,
    'Petrified Forest National Park',
    'Arizona',
    'Southwest',
    'Did you know that Petrified Forest is more spectacular than ever? While the park has all the wonders known for a century, there are many new adventures and discoveries to be made.',
    'Pronghorn, coyotes, bobcats, ravens, lizards',
    'Desert grassland, petrified wood, wildflowers (spring), sparse vegetation',
    346.0,
    643588,
    'September to November, March to May',
    25.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/pefo',
    34.90972222,
    -109.89222222,
    'Scenic drives, hiking, paleontology, petroglyph viewing, photography',
    'Blue Mesa Trail, Painted Desert Rim Trail, Crystal Forest, Agate House',
    'Easy to Moderate',
    4,
    3
),

-- 49. Pinnacles National Park
(
    49,
    'Pinnacles National Park',
    'California',
    'West Coast',
    'Some 23 million years ago multiple volcanoes erupted, flowed, and slid to form what would become Pinnacles National Park. What remains is a unique landscape.',
    'California condors, bobcats, bats, prairie falcons, tarantulas',
    'Chaparral, oak woodlands, wildflowers, California buckeye',
    42.2,
    348857,
    'March to May, September to November',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/pinn',
    36.48166667,
    -121.18277778,
    'Rock climbing, hiking, cave exploration, condor viewing, birdwatching',
    'High Peaks Trail, Bear Gulch Cave, Balconies Cave, Condor Gulch',
    'Moderate to Strenuous',
    3,
    3
),

-- 50. Redwood National Park
(
    50,
    'Redwood National and State Parks',
    'California',
    'West Coast',
    'Most people know Redwood as home to the tallest trees on Earth. But the parks also protect vast prairies, oak woodlands, wild river-ways, and nearly 40 miles of rugged coastline.',
    'Roosevelt elk, black bears, gray whales, sea lions, marbled murrelets',
    'Coast redwoods, Douglas fir, Sitka spruce, ferns, coastal vegetation',
    221.2,
    435879,
    'May to September',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/redw',
    41.21305556,
    -124.00472222,
    'Hiking, scenic drives, tidepooling, wildlife viewing, photography',
    'Lady Bird Johnson Grove, Tall Trees Grove, Fern Canyon, James Irvine Trail',
    'Easy to Moderate',
    5,
    4
),

-- 51. Rocky Mountain National Park
(
    51,
    'Rocky Mountain National Park',
    'Colorado',
    'Rocky Mountains',
    'Rocky Mountain National Park''s 415 square miles encompass and protect spectacular mountain environments. Enjoy Trail Ridge Road – which crests over 12,000 feet including many overlooks to experience the subalpine and alpine worlds.',
    'Elk, bighorn sheep, moose, black bears, marmots, pikas',
    'Ponderosa pine, aspen, subalpine forests, alpine tundra, wildflowers',
    415.0,
    4434848,
    'June to September',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/romo',
    40.34277778,
    -105.68833333,
    'Hiking, scenic drives, wildlife viewing, mountaineering, fishing',
    'Emerald Lake Trail, Sky Pond, Chasm Lake, Longs Peak, Bear Lake Loop',
    'Easy to Strenuous',
    4,
    3
),

-- 52. Saguaro National Park
(
    52,
    'Saguaro National Park',
    'Arizona',
    'Southwest',
    'Tucson, Arizona is home to the nation''s largest cacti. The massive saguaro is the universal symbol of the American west. These majestic plants, found only in a small portion of the United States, are protected by Saguaro National Park.',
    'Coyotes, javelinas, Gila monsters, roadrunners, desert tortoises',
    'Saguaro cacti, prickly pear, ocotillo, mesquite, palo verde',
    143.3,
    1020226,
    'October to April',
    25.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/sagu',
    32.24972222,
    -111.16666667,
    'Hiking, scenic drives, photography, wildlife viewing, cactus forest exploration',
    'Hugh Norris Trail, Valley View Overlook, King Canyon Trail, Desert Discovery Trail',
    'Easy to Strenuous',
    4,
    3
),

-- 53. Sequoia National Park
(
    53,
    'Sequoia National Park',
    'California',
    'West Coast',
    'This park in the southern Sierra Nevada mountains protects giant sequoia forests, including the world''s largest tree, General Sherman, and a beautiful wilderness of foothills, canyons, and granite peaks.',
    'Black bears, mule deer, bighorn sheep, mountain lions, marmots',
    'Giant sequoias, mixed conifer forests, alpine meadows, wildflowers',
    631.0,
    1059548,
    'May to September',
    35.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/seki',
    36.48638889,
    -118.56555556,
    'Hiking, sequoia viewing, cave tours, backpacking, scenic drives',
    'General Sherman Tree, Moro Rock, Tokopah Falls, High Sierra Trail, Congress Trail',
    'Easy to Strenuous',
    4,
    3
),

-- 54. Shenandoah National Park
(
    54,
    'Shenandoah National Park',
    'Virginia',
    'Southeast',
    'Just 75 miles from the bustle of Washington, D.C., Shenandoah National Park is a land bursting with cascading waterfalls, spectacular vistas, and quiet wooded hollows.',
    'White-tailed deer, black bears, wild turkeys, salamanders, bobcats',
    'Oak-hickory forests, mountain laurel, wildflowers, hemlock groves',
    311.0,
    1592312,
    'May to June, September to October',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/shen',
    38.29277778,
    -78.67944444,
    'Scenic drives (Skyline Drive), hiking, waterfall viewing, wildlife watching',
    'Old Rag Mountain, Dark Hollow Falls, Hawksbill Summit, Whiteoak Canyon',
    'Easy to Strenuous',
    5,
    3
),

-- 55. Theodore Roosevelt National Park
(
    55,
    'Theodore Roosevelt National Park',
    'North Dakota',
    'Midwest',
    'When Theodore Roosevelt came to Dakota Territory to hunt bison in 1883, he was a skinny, young, spectacled dude from New York. He could not have imagined how his adventure in this remote place would forever alter the course of the nation.',
    'Bison, wild horses, elk, prairie dogs, golden eagles',
    'Mixed-grass prairie, cottonwood groves, badlands formations, juniper',
    110.1,
    749389,
    'May to September',
    30.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/thro',
    46.97888889,
    -103.53805556,
    'Scenic drives, hiking, wildlife viewing, horseback riding, camping',
    'Wind Canyon Trail, Painted Canyon, Buckhorn Trail, Petrified Forest Loop',
    'Easy to Moderate',
    4,
    3
),

-- 56. Virgin Islands National Park
(
    56,
    'Virgin Islands National Park',
    'U.S. Virgin Islands',
    'Caribbean',
    'Virgin Islands National Park is more than just beautiful beaches. Hike to plantation ruins to learn about a time when sugar dominated the island. Visit the ancient petroglyphs carved by the Taino Indians.',
    'Sea turtles, tropical fish, pelicans, iguanas, hermit crabs',
    'Tropical forests, mangroves, seagrass beds, coral reefs, bay trees',
    23.1,
    323999,
    'December to April',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/viis',
    18.34305556,
    -64.72944444,
    'Snorkeling, diving, hiking, beach activities, historical tours, kayaking',
    'Reef Bay Trail, Ram Head Trail, Cinnamon Bay Nature Trail, Francis Bay Trail',
    'Easy to Moderate',
    5,
    3
),

-- 57. Voyageurs National Park
(
    57,
    'Voyageurs National Park',
    'Minnesota',
    'Midwest',
    'Voyageurs is a water-based park, meaning the best way to explore it is by boat. The park''s lakes and waterways were once the highways for fur traders, logging companies, and gold seekers.',
    'Black bears, beavers, loons, bald eagles, wolves, moose',
    'Boreal forest, pine, spruce, birch, wetlands, lake ecosystems',
    340.9,
    232974,
    'May to September',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/voya',
    48.50000000,
    -92.83333333,
    'Boating, kayaking, canoeing, fishing, camping, Northern Lights viewing (winter)',
    'Locator Lake Trail, Echo Bay Trail, Oberholtzer Trail, Cruiser Lake Trail',
    'Easy to Moderate',
    4,
    3
),

-- 58. White Sands National Park
(
    58,
    'White Sands National Park',
    'New Mexico',
    'Southwest',
    'Rising from the heart of the Tularosa Basin is one of the world''s great natural wonders - the glistening white sands of New Mexico. Great wave-like dunes of gypsum sand have engulfed 275 square miles of desert.',
    'Kit foxes, roadrunners, bleached earless lizards, oryx',
    'Yucca, cottonwood, Rio Grande cottonwood, salt-tolerant plants',
    230.0,
    629424,
    'October to April',
    25.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/whsa',
    32.77972222,
    -106.32527778,
    'Hiking, sand sledding, photography, ranger programs, full moon events',
    'Dune Life Nature Trail, Interdune Boardwalk, Alkali Flat Trail, Backcountry Camping Trail',
    'Easy to Moderate',
    5,
    4
),

-- 59. Wind Cave National Park
(
    59,
    'Wind Cave National Park',
    'South Dakota',
    'Midwest',
    'Wind Cave is one of the longest and most complex caves in the world. Above ground, the park is a mixed-grass prairie with animals like bison, elk, and prairie dogs.',
    'Bison, elk, pronghorn, prairie dogs, black-footed ferrets',
    'Mixed-grass prairie, ponderosa pine forests, bur oak',
    52.8,
    709001,
    'Year-round (cave tours seasonal)',
    0.00,
    'Cave tours have fees',
    'https://www.nps.gov/wica',
    43.57277778,
    -103.48472222,
    'Cave tours, hiking, wildlife viewing, ranger programs, scenic drives',
    'Wind Cave Tour, Rankin Ridge Trail, Centennial Trail, Prairie Vista Trail',
    'Easy to Moderate',
    5,
    3
),

-- 60. Wrangell-St. Elias National Park
(
    60,
    'Wrangell-St. Elias National Park & Preserve',
    'Alaska',
    'Alaska',
    'Wrangell-St. Elias is the nation''s largest national park, the same size as Yellowstone National Park, Yosemite National Park, and Switzerland combined. This mountainous landscape is home to Mt. St. Elias, the second tallest peak in the U.S.',
    'Grizzly bears, black bears, Dall sheep, caribou, moose, wolves',
    'Boreal forests, alpine tundra, glaciers, spruce, willow',
    20625.0,
    74518,
    'May to September',
    0.00,
    'All federal fee-free days',
    'https://www.nps.gov/wrst',
    61.71027778,
    -142.98583333,
    'Backpacking, mountaineering, flightseeing, glacier trekking, historic mining sites',
    'Root Glacier Trail, Bonanza Mine Trail, Kennecott Mines Tour',
    'Moderate to Strenuous',
    2,
    2
),

-- 61. Yellowstone National Park
(
    61,
    'Yellowstone National Park',
    'Wyoming, Montana, Idaho',
    'Rocky Mountains',
    'On March 1, 1872, Yellowstone became the first national park for all to enjoy the unique hydrothermal and geologic features. Today, millions of people come here each year to camp, hike, and enjoy the majesty of the park.',
    'Grizzly bears, wolves, bison, elk, moose, bighorn sheep, bald eagles',
    'Lodgepole pine, whitebark pine, sagebrush, wildflowers, geothermal areas',
    3472.0,
    4860242,
    'April to May, September to October',
    35.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/yell',
    44.42777778,
    -110.58833333,
    'Geyser viewing, wildlife watching, hiking, camping, fishing, scenic drives',
    'Old Faithful, Grand Prismatic Spring, Grand Canyon of Yellowstone, Lamar Valley',
    'Easy to Strenuous',
    4,
    3
),

-- 62. Yosemite National Park
(
    62,
    'Yosemite National Park',
    'California',
    'West Coast',
    'Not just a great valley, but a shrine to human foresight, the strength of granite, the power of glaciers, the persistence of life, and the tranquility of the High Sierra. First protected in 1864, Yosemite National Park is best known for its waterfalls.',
    'Black bears, mule deer, bighorn sheep, coyotes, bobcats',
    'Giant sequoias, mixed conifer forests, alpine meadows, oak woodlands',
    1187.0,
    3667550,
    'April to May, September to October',
    35.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/yose',
    37.86555556,
    -119.53833333,
    'Hiking, rock climbing, waterfall viewing, scenic drives, backpacking',
    'Half Dome, Mist Trail, Nevada Fall, Yosemite Falls, Glacier Point',
    'Easy to Strenuous',
    4,
    3
),

-- 63. Zion National Park
(
    63,
    'Zion National Park',
    'Utah',
    'Southwest',
    'Follow the paths where ancient native people and pioneers walked. Gaze up at massive sandstone cliffs of cream, pink, and red that soar into a brilliant blue sky. Experience wilderness in a narrow slot canyon.',
    'Mule deer, bighorn sheep, California condors, peregrine falcons, mountain lions',
    'Pinyon-juniper, cottonwood, box elder, hanging gardens, desert plants',
    229.0,
    5039835,
    'March to May, September to November',
    35.00,
    'MLK Day, First Day of National Park Week, NPS Birthday, National Public Lands Day, Veterans Day',
    'https://www.nps.gov/zion',
    37.29833333,
    -113.02638889,
    'Hiking, canyoneering, rock climbing, scenic drives, river wading',
    'Angels Landing, The Narrows, Emerald Pools, Observation Point, Canyon Overlook',
    'Easy to Strenuous',
    4,
    3
);

-- ============================================
-- AIRPORT DATA
-- ============================================
-- 5 nearest airports for: Yellowstone, Yosemite, Great Smoky Mountains, Grand Canyon, Rocky Mountain
-- Plus DFW as the departure airport for all flights

INSERT INTO
    Airport (
        Airport_ID,
        Airport_Code,
        Airport_Name,
        City,
        State,
        Latitude,
        Longitude
    )
VALUES
    -- Airport_ID 1: DFW - Departure Airport for all flights
    (
        1,
        'DFW',
        'Dallas/Fort Worth International Airport',
        'Dallas',
        'Texas',
        32.89694444,
        -97.03805556
    ),

-- Yellowstone National Park - 5 Nearest Airports
(
    2,
    'BZN',
    'Bozeman Yellowstone International Airport',
    'Bozeman',
    'Montana',
    45.77750000,
    -111.15305556
),
(
    3,
    'WYS',
    'Yellowstone Airport',
    'West Yellowstone',
    'Montana',
    44.68833333,
    -111.11777778
),
(
    4,
    'JAC',
    'Jackson Hole Airport',
    'Jackson',
    'Wyoming',
    43.60722222,
    -110.73777778
),
(
    5,
    'IDA',
    'Idaho Falls Regional Airport',
    'Idaho Falls',
    'Idaho',
    43.51444444,
    -112.07055556
),
(
    6,
    'BIL',
    'Billings Logan International Airport',
    'Billings',
    'Montana',
    45.80777778,
    -108.54277778
),

-- Yosemite National Park - 5 Nearest Airports
(
    7,
    'FAT',
    'Fresno Yosemite International Airport',
    'Fresno',
    'California',
    36.77611111,
    -119.71805556
),
(
    8,
    'MMH',
    'Mammoth Yosemite Airport',
    'Mammoth Lakes',
    'California',
    37.62416667,
    -118.83777778
),
(
    9,
    'MER',
    'Castle Airport',
    'Merced',
    'California',
    37.38055556,
    -120.56833333
),
(
    10,
    'MOD',
    'Modesto City-County Airport',
    'Modesto',
    'California',
    37.62583333,
    -120.95444444
),
(
    11,
    'SJC',
    'San Jose International Airport',
    'San Jose',
    'California',
    37.36277778,
    -121.92916667
),

-- Great Smoky Mountains National Park - 5 Nearest Airports
(
    12,
    'TYS',
    'McGhee Tyson Airport',
    'Knoxville',
    'Tennessee',
    35.81111111,
    -83.99416667
),
(
    13,
    'AVL',
    'Asheville Regional Airport',
    'Asheville',
    'North Carolina',
    35.43611111,
    -82.54194444
),
(
    14,
    'TRI',
    'Tri-Cities Airport',
    'Blountville',
    'Tennessee',
    36.47527778,
    -82.40722222
),
(
    15,
    'GSO',
    'Piedmont Triad International Airport',
    'Greensboro',
    'North Carolina',
    36.09777778,
    -79.93722222
),
(
    16,
    'CHA',
    'Chattanooga Metropolitan Airport',
    'Chattanooga',
    'Tennessee',
    35.03527778,
    -85.20388889
),

-- Grand Canyon National Park - 5 Nearest Airports
(
    17,
    'FLG',
    'Flagstaff Pulliam Airport',
    'Flagstaff',
    'Arizona',
    35.13833333,
    -111.67138889
),
(
    18,
    'GCN',
    'Grand Canyon National Park Airport',
    'Tusayan',
    'Arizona',
    35.95250000,
    -112.14694444
),
(
    19,
    'PGA',
    'Page Municipal Airport',
    'Page',
    'Arizona',
    36.92611111,
    -111.44833333
),
(
    20,
    'PHX',
    'Phoenix Sky Harbor International Airport',
    'Phoenix',
    'Arizona',
    33.43416667,
    -112.01194444
),
(
    21,
    'LAS',
    'Harry Reid International Airport',
    'Las Vegas',
    'Nevada',
    36.08000000,
    -115.15222222
),

-- Rocky Mountain National Park - 5 Nearest Airports
(
    22,
    'DEN',
    'Denver International Airport',
    'Denver',
    'Colorado',
    39.86166667,
    -104.67305556
),
(
    23,
    'FNL',
    'Northern Colorado Regional Airport',
    'Fort Collins',
    'Colorado',
    40.45166667,
    -105.01138889
),
(
    24,
    'GXY',
    'Greeley-Weld County Airport',
    'Greeley',
    'Colorado',
    40.43722222,
    -104.63305556
),
(
    25,
    'BDU',
    'Boulder Municipal Airport',
    'Boulder',
    'Colorado',
    40.03944444,
    -105.22611111
),
(
    26,
    'EGE',
    'Eagle County Regional Airport',
    'Eagle',
    'Colorado',
    39.64250000,
    -106.91777778
);

-- ============================================
-- FLIGHT DATA
-- ============================================
-- 10 fictional flights to each of 5 national parks (50 total flights)
-- Plus 50 return flights back to DFW (100 total flights)
-- All departures from DFW (Airport_ID = 1)
-- Flights scheduled for January 2026

INSERT INTO
    Flight (
        Airline,
        Flight_Number,
        Departure_Airport_ID,
        Arrival_Airport_ID,
        Departure_Time,
        Arrival_Time,
        Duration_Minutes,
        Number_Of_Stops,
        Price,
        Available_Seats
    )
VALUES
    -- ============================================
    -- YELLOWSTONE FLIGHTS (DFW to various airports)
    -- ============================================
    -- Flights to Bozeman (BZN) - Airport_ID 2
    (
        'United Airlines',
        'UA1234',
        1,
        2,
        '2026-01-15 08:00:00',
        '2026-01-15 11:30:00',
        210,
        0,
        425.00,
        45
    ),
    (
        'American Airlines',
        'AA5678',
        1,
        2,
        '2026-01-22 14:30:00',
        '2026-01-22 18:00:00',
        210,
        0,
        389.00,
        38
    ),

-- Flights to West Yellowstone (WYS) - Airport_ID 3
(
    'Delta Air Lines',
    'DL2345',
    1,
    3,
    '2026-01-10 09:15:00',
    '2026-01-10 13:15:00',
    240,
    1,
    495.00,
    25
),
(
    'United Airlines',
    'UA3456',
    1,
    3,
    '2026-01-25 16:00:00',
    '2026-01-25 20:00:00',
    240,
    1,
    510.00,
    22
),

-- Flights to Jackson Hole (JAC) - Airport_ID 4
(
    'American Airlines',
    'AA7890',
    1,
    4,
    '2026-01-12 07:45:00',
    '2026-01-12 11:15:00',
    210,
    0,
    445.00,
    42
),
(
    'United Airlines',
    'UA4567',
    1,
    4,
    '2026-01-28 13:00:00',
    '2026-01-28 16:30:00',
    210,
    0,
    475.00,
    35
),

-- Flights to Idaho Falls (IDA) - Airport_ID 5
(
    'Delta Air Lines',
    'DL5678',
    1,
    5,
    '2026-01-08 10:30:00',
    '2026-01-08 14:15:00',
    225,
    1,
    420.00,
    48
),
(
    'Southwest Airlines',
    'WN1234',
    1,
    5,
    '2026-01-30 15:45:00',
    '2026-01-30 19:30:00',
    225,
    1,
    399.00,
    50
),

-- Flights to Billings (BIL) - Airport_ID 6
(
    'United Airlines',
    'UA6789',
    1,
    6,
    '2026-01-18 11:00:00',
    '2026-01-18 14:15:00',
    195,
    0,
    395.00,
    44
),
(
    'American Airlines',
    'AA9012',
    1,
    6,
    '2026-01-27 17:30:00',
    '2026-01-27 20:45:00',
    195,
    0,
    410.00,
    40
),

-- ============================================
-- YOSEMITE FLIGHTS (DFW to various airports)
-- ============================================
-- Flights to Fresno (FAT) - Airport_ID 7
(
    'American Airlines',
    'AA1357',
    1,
    7,
    '2026-01-05 08:30:00',
    '2026-01-05 11:45:00',
    195,
    0,
    325.00,
    52
),
(
    'United Airlines',
    'UA2468',
    1,
    7,
    '2026-01-20 14:15:00',
    '2026-01-20 17:30:00',
    195,
    0,
    349.00,
    48
),

-- Flights to Mammoth Yosemite (MMH) - Airport_ID 8
(
    'United Airlines',
    'UA7531',
    1,
    8,
    '2026-01-09 09:00:00',
    '2026-01-09 12:45:00',
    225,
    1,
    465.00,
    30
),
(
    'Alaska Airlines',
    'AS1122',
    1,
    8,
    '2026-01-23 16:30:00',
    '2026-01-23 20:15:00',
    225,
    1,
    485.00,
    28
),

-- Flights to Merced (MER) - Airport_ID 9
(
    'American Airlines',
    'AA8642',
    1,
    9,
    '2026-01-11 10:45:00',
    '2026-01-11 14:15:00',
    210,
    1,
    379.00,
    35
),
(
    'United Airlines',
    'UA9753',
    1,
    9,
    '2026-01-26 15:00:00',
    '2026-01-26 18:30:00',
    210,
    1,
    395.00,
    32
),

-- Flights to Modesto (MOD) - Airport_ID 10
(
    'Southwest Airlines',
    'WN2468',
    1,
    10,
    '2026-01-14 11:30:00',
    '2026-01-14 15:00:00',
    210,
    1,
    359.00,
    40
),
(
    'Delta Air Lines',
    'DL1357',
    1,
    10,
    '2026-01-29 13:45:00',
    '2026-01-29 17:15:00',
    210,
    1,
    375.00,
    38
),

-- Flights to San Jose (SJC) - Airport_ID 11
(
    'American Airlines',
    'AA3691',
    1,
    11,
    '2026-01-07 07:00:00',
    '2026-01-07 10:15:00',
    195,
    0,
    315.00,
    55
),
(
    'United Airlines',
    'UA4802',
    1,
    11,
    '2026-01-31 18:00:00',
    '2026-01-31 21:15:00',
    195,
    0,
    335.00,
    50
),

-- ============================================
-- GREAT SMOKY MOUNTAINS FLIGHTS (DFW to various airports)
-- ============================================
-- Flights to Knoxville (TYS) - Airport_ID 12
(
    'American Airlines',
    'AA5913',
    1,
    12,
    '2026-01-06 08:15:00',
    '2026-01-06 11:30:00',
    135,
    0,
    245.00,
    60
),
(
    'Delta Air Lines',
    'DL6024',
    1,
    12,
    '2026-01-21 14:00:00',
    '2026-01-21 17:15:00',
    135,
    0,
    259.00,
    58
),

-- Flights to Asheville (AVL) - Airport_ID 13
(
    'United Airlines',
    'UA7135',
    1,
    13,
    '2026-01-13 09:30:00',
    '2026-01-13 12:50:00',
    140,
    0,
    265.00,
    55
),
(
    'American Airlines',
    'AA8246',
    1,
    13,
    '2026-01-24 15:45:00',
    '2026-01-24 19:05:00',
    140,
    0,
    275.00,
    52
),

-- Flights to Tri-Cities (TRI) - Airport_ID 14
(
    'Delta Air Lines',
    'DL9357',
    1,
    14,
    '2026-01-16 10:00:00',
    '2026-01-16 13:25:00',
    145,
    1,
    285.00,
    45
),
(
    'United Airlines',
    'UA1468',
    1,
    14,
    '2026-01-28 16:15:00',
    '2026-01-28 19:40:00',
    145,
    1,
    295.00,
    42
),

-- Flights to Greensboro (GSO) - Airport_ID 15
(
    'American Airlines',
    'AA2579',
    1,
    15,
    '2026-01-17 11:45:00',
    '2026-01-17 15:00:00',
    135,
    0,
    255.00,
    57
),
(
    'Southwest Airlines',
    'WN3680',
    1,
    15,
    '2026-01-30 17:00:00',
    '2026-01-30 20:15:00',
    135,
    0,
    239.00,
    62
),

-- Flights to Chattanooga (CHA) - Airport_ID 16
(
    'United Airlines',
    'UA4791',
    1,
    16,
    '2026-01-19 07:30:00',
    '2026-01-19 10:45:00',
    135,
    0,
    249.00,
    59
),
(
    'Delta Air Lines',
    'DL5802',
    1,
    16,
    '2026-01-31 13:30:00',
    '2026-01-31 16:45:00',
    135,
    0,
    265.00,
    56
),

-- ============================================
-- GRAND CANYON FLIGHTS (DFW to various airports)
-- ============================================
-- Flights to Flagstaff (FLG) - Airport_ID 17
(
    'American Airlines',
    'AA6913',
    1,
    17,
    '2026-01-04 08:00:00',
    '2026-01-04 10:15:00',
    135,
    0,
    285.00,
    48
),
(
    'United Airlines',
    'UA8024',
    1,
    17,
    '2026-01-19 14:30:00',
    '2026-01-19 16:45:00',
    135,
    0,
    295.00,
    45
),

-- Flights to Grand Canyon (GCN) - Airport_ID 18
(
    'Delta Air Lines',
    'DL9135',
    1,
    18,
    '2026-01-11 09:15:00',
    '2026-01-11 11:45:00',
    150,
    1,
    345.00,
    35
),
(
    'American Airlines',
    'AA1246',
    1,
    18,
    '2026-01-22 15:00:00',
    '2026-01-22 17:30:00',
    150,
    1,
    359.00,
    32
),

-- Flights to Page (PGA) - Airport_ID 19
(
    'United Airlines',
    'UA2357',
    1,
    19,
    '2026-01-14 10:30:00',
    '2026-01-14 13:00:00',
    150,
    1,
    335.00,
    38
),
(
    'Southwest Airlines',
    'WN4468',
    1,
    19,
    '2026-01-25 16:45:00',
    '2026-01-25 19:15:00',
    150,
    1,
    325.00,
    40
),

-- Flights to Phoenix (PHX) - Airport_ID 20
(
    'American Airlines',
    'AA5579',
    1,
    20,
    '2026-01-02 07:45:00',
    '2026-01-02 09:45:00',
    120,
    0,
    215.00,
    65
),
(
    'Southwest Airlines',
    'WN6680',
    1,
    20,
    '2026-01-16 13:15:00',
    '2026-01-16 15:15:00',
    120,
    0,
    199.00,
    70
),

-- Flights to Las Vegas (LAS) - Airport_ID 21
(
    'United Airlines',
    'UA7791',
    1,
    21,
    '2026-01-08 11:00:00',
    '2026-01-08 12:45:00',
    105,
    0,
    225.00,
    68
),
(
    'Delta Air Lines',
    'DL8802',
    1,
    21,
    '2026-01-20 17:30:00',
    '2026-01-20 19:15:00',
    105,
    0,
    239.00,
    64
),

-- ============================================
-- ROCKY MOUNTAIN FLIGHTS (DFW to various airports)
-- ============================================
-- Flights to Denver (DEN) - Airport_ID 22
(
    'United Airlines',
    'UA9913',
    1,
    22,
    '2026-01-03 08:30:00',
    '2026-01-03 10:15:00',
    105,
    0,
    189.00,
    72
),
(
    'Southwest Airlines',
    'WN1024',
    1,
    22,
    '2026-01-17 14:00:00',
    '2026-01-17 15:45:00',
    105,
    0,
    175.00,
    75
),

-- Flights to Fort Collins (FNL) - Airport_ID 23
(
    'American Airlines',
    'AA2135',
    1,
    23,
    '2026-01-10 09:45:00',
    '2026-01-10 11:45:00',
    120,
    1,
    225.00,
    45
),
(
    'United Airlines',
    'UA3246',
    1,
    23,
    '2026-01-23 15:30:00',
    '2026-01-23 17:30:00',
    120,
    1,
    235.00,
    42
),

-- Flights to Greeley (GXY) - Airport_ID 24
(
    'Delta Air Lines',
    'DL4357',
    1,
    24,
    '2026-01-12 10:15:00',
    '2026-01-12 12:30:00',
    135,
    1,
    245.00,
    38
),
(
    'American Airlines',
    'AA5468',
    1,
    24,
    '2026-01-26 16:00:00',
    '2026-01-26 18:15:00',
    135,
    1,
    255.00,
    35
),

-- Flights to Boulder (BDU) - Airport_ID 25
(
    'United Airlines',
    'UA6579',
    1,
    25,
    '2026-01-15 11:30:00',
    '2026-01-15 13:45:00',
    135,
    1,
    249.00,
    40
),
(
    'Southwest Airlines',
    'WN7680',
    1,
    25,
    '2026-01-29 17:15:00',
    '2026-01-29 19:30:00',
    135,
    1,
    239.00,
    43
),

-- Flights to Eagle (EGE) - Airport_ID 26
(
    'American Airlines',
    'AA8791',
    1,
    26,
    '2026-01-18 07:00:00',
    '2026-01-18 09:30:00',
    150,
    0,
    275.00,
    50
),
(
    'United Airlines',
    'UA9802',
    1,
    26,
    '2026-01-31 13:45:00',
    '2026-01-31 16:15:00',
    150,
    0,
    289.00,
    48
),

-- ============================================
-- RETURN FLIGHTS (Park airports back to DFW)
-- ============================================

-- YELLOWSTONE RETURN FLIGHTS
-- Returns from Bozeman (BZN) - Airport_ID 2 to DFW
(
    'United Airlines',
    'UA1235',
    2,
    1,
    '2026-01-18 13:00:00',
    '2026-01-18 16:30:00',
    210,
    0,
    425.00,
    45
),
(
    'American Airlines',
    'AA5679',
    2,
    1,
    '2026-01-25 19:30:00',
    '2026-01-25 23:00:00',
    210,
    0,
    389.00,
    38
),

-- Returns from West Yellowstone (WYS) - Airport_ID 3 to DFW
(
    'Delta Air Lines',
    'DL2346',
    3,
    1,
    '2026-01-13 14:45:00',
    '2026-01-13 18:45:00',
    240,
    1,
    495.00,
    25
),
(
    'United Airlines',
    'UA3457',
    3,
    1,
    '2026-01-28 21:30:00',
    '2026-01-29 01:30:00',
    240,
    1,
    510.00,
    22
),

-- Returns from Jackson Hole (JAC) - Airport_ID 4 to DFW
(
    'American Airlines',
    'AA7891',
    4,
    1,
    '2026-01-15 12:45:00',
    '2026-01-15 16:15:00',
    210,
    0,
    445.00,
    42
),
(
    'United Airlines',
    'UA4568',
    4,
    1,
    '2026-01-31 18:00:00',
    '2026-01-31 21:30:00',
    210,
    0,
    475.00,
    35
),

-- Returns from Idaho Falls (IDA) - Airport_ID 5 to DFW
(
    'Delta Air Lines',
    'DL5679',
    5,
    1,
    '2026-01-11 15:45:00',
    '2026-01-11 19:30:00',
    225,
    1,
    420.00,
    48
),
(
    'Southwest Airlines',
    'WN1235',
    5,
    1,
    '2026-01-31 21:00:00',
    '2026-02-01 00:45:00',
    225,
    1,
    399.00,
    50
),

-- Returns from Billings (BIL) - Airport_ID 6 to DFW
(
    'United Airlines',
    'UA6790',
    6,
    1,
    '2026-01-21 15:45:00',
    '2026-01-21 19:00:00',
    195,
    0,
    395.00,
    44
),
(
    'American Airlines',
    'AA9013',
    6,
    1,
    '2026-01-30 22:15:00',
    '2026-01-31 01:30:00',
    195,
    0,
    410.00,
    40
),

-- YOSEMITE RETURN FLIGHTS
-- Returns from Fresno (FAT) - Airport_ID 7 to DFW
(
    'American Airlines',
    'AA1358',
    7,
    1,
    '2026-01-08 13:15:00',
    '2026-01-08 16:30:00',
    195,
    0,
    325.00,
    52
),
(
    'United Airlines',
    'UA2469',
    7,
    1,
    '2026-01-23 19:00:00',
    '2026-01-23 22:15:00',
    195,
    0,
    349.00,
    48
),

-- Returns from Mammoth Yosemite (MMH) - Airport_ID 8 to DFW
(
    'United Airlines',
    'UA7532',
    8,
    1,
    '2026-01-12 14:15:00',
    '2026-01-12 18:00:00',
    225,
    1,
    465.00,
    30
),
(
    'Alaska Airlines',
    'AS1123',
    8,
    1,
    '2026-01-26 21:45:00',
    '2026-01-27 01:30:00',
    225,
    1,
    485.00,
    28
),

-- Returns from Merced (MER) - Airport_ID 9 to DFW
(
    'American Airlines',
    'AA8643',
    9,
    1,
    '2026-01-14 15:45:00',
    '2026-01-14 19:15:00',
    210,
    1,
    379.00,
    35
),
(
    'United Airlines',
    'UA9754',
    9,
    1,
    '2026-01-29 20:00:00',
    '2026-01-29 23:30:00',
    210,
    1,
    395.00,
    32
),

-- Returns from Modesto (MOD) - Airport_ID 10 to DFW
(
    'Southwest Airlines',
    'WN2469',
    10,
    1,
    '2026-01-17 16:30:00',
    '2026-01-17 20:00:00',
    210,
    1,
    359.00,
    40
),
(
    'Delta Air Lines',
    'DL1358',
    10,
    1,
    '2026-01-31 18:45:00',
    '2026-01-31 22:15:00',
    210,
    1,
    375.00,
    38
),

-- Returns from San Jose (SJC) - Airport_ID 11 to DFW
(
    'American Airlines',
    'AA3692',
    11,
    1,
    '2026-01-10 11:45:00',
    '2026-01-10 15:00:00',
    195,
    0,
    315.00,
    55
),
(
    'United Airlines',
    'UA4803',
    11,
    1,
    '2026-01-31 22:45:00',
    '2026-02-01 02:00:00',
    195,
    0,
    335.00,
    50
),

-- GREAT SMOKY MOUNTAINS RETURN FLIGHTS
-- Returns from Knoxville (TYS) - Airport_ID 12 to DFW
(
    'American Airlines',
    'AA5914',
    12,
    1,
    '2026-01-09 13:00:00',
    '2026-01-09 16:15:00',
    135,
    0,
    245.00,
    60
),
(
    'Delta Air Lines',
    'DL6025',
    12,
    1,
    '2026-01-24 18:45:00',
    '2026-01-24 22:00:00',
    135,
    0,
    259.00,
    58
),

-- Returns from Asheville (AVL) - Airport_ID 13 to DFW
(
    'United Airlines',
    'UA7136',
    13,
    1,
    '2026-01-16 14:20:00',
    '2026-01-16 17:40:00',
    140,
    0,
    265.00,
    55
),
(
    'American Airlines',
    'AA8247',
    13,
    1,
    '2026-01-27 20:35:00',
    '2026-01-27 23:55:00',
    140,
    0,
    275.00,
    52
),

-- Returns from Tri-Cities (TRI) - Airport_ID 14 to DFW
(
    'Delta Air Lines',
    'DL9358',
    14,
    1,
    '2026-01-19 14:55:00',
    '2026-01-19 18:20:00',
    145,
    1,
    285.00,
    45
),
(
    'United Airlines',
    'UA1469',
    14,
    1,
    '2026-01-31 21:10:00',
    '2026-02-01 00:35:00',
    145,
    1,
    295.00,
    42
),

-- Returns from Greensboro (GSO) - Airport_ID 15 to DFW
(
    'American Airlines',
    'AA2580',
    15,
    1,
    '2026-01-20 16:30:00',
    '2026-01-20 19:45:00',
    135,
    0,
    255.00,
    57
),
(
    'Southwest Airlines',
    'WN3681',
    15,
    1,
    '2026-01-31 21:45:00',
    '2026-02-01 01:00:00',
    135,
    0,
    239.00,
    62
),

-- Returns from Chattanooga (CHA) - Airport_ID 16 to DFW
(
    'United Airlines',
    'UA4792',
    16,
    1,
    '2026-01-22 12:15:00',
    '2026-01-22 15:30:00',
    135,
    0,
    249.00,
    59
),
(
    'Delta Air Lines',
    'DL5803',
    16,
    1,
    '2026-01-31 18:15:00',
    '2026-01-31 21:30:00',
    135,
    0,
    265.00,
    56
),

-- GRAND CANYON RETURN FLIGHTS
-- Returns from Flagstaff (FLG) - Airport_ID 17 to DFW
(
    'American Airlines',
    'AA6914',
    17,
    1,
    '2026-01-07 11:45:00',
    '2026-01-07 14:00:00',
    135,
    0,
    285.00,
    48
),
(
    'United Airlines',
    'UA8025',
    17,
    1,
    '2026-01-22 18:15:00',
    '2026-01-22 20:30:00',
    135,
    0,
    295.00,
    45
),

-- Returns from Grand Canyon (GCN) - Airport_ID 18 to DFW
(
    'Delta Air Lines',
    'DL9136',
    18,
    1,
    '2026-01-14 13:15:00',
    '2026-01-14 15:45:00',
    150,
    1,
    345.00,
    35
),
(
    'American Airlines',
    'AA1247',
    18,
    1,
    '2026-01-25 19:00:00',
    '2026-01-25 21:30:00',
    150,
    1,
    359.00,
    32
),

-- Returns from Page (PGA) - Airport_ID 19 to DFW
(
    'United Airlines',
    'UA2358',
    19,
    1,
    '2026-01-17 14:30:00',
    '2026-01-17 17:00:00',
    150,
    1,
    335.00,
    38
),
(
    'Southwest Airlines',
    'WN4469',
    19,
    1,
    '2026-01-28 20:45:00',
    '2026-01-28 23:15:00',
    150,
    1,
    325.00,
    40
),

-- Returns from Phoenix (PHX) - Airport_ID 20 to DFW
(
    'American Airlines',
    'AA5580',
    20,
    1,
    '2026-01-05 11:15:00',
    '2026-01-05 13:15:00',
    120,
    0,
    215.00,
    65
),
(
    'Southwest Airlines',
    'WN6681',
    20,
    1,
    '2026-01-19 16:45:00',
    '2026-01-19 18:45:00',
    120,
    0,
    199.00,
    70
),

-- Returns from Las Vegas (LAS) - Airport_ID 21 to DFW
(
    'United Airlines',
    'UA7792',
    21,
    1,
    '2026-01-11 14:15:00',
    '2026-01-11 16:00:00',
    105,
    0,
    225.00,
    68
),
(
    'Delta Air Lines',
    'DL8803',
    21,
    1,
    '2026-01-23 20:45:00',
    '2026-01-23 22:30:00',
    105,
    0,
    239.00,
    64
),

-- ROCKY MOUNTAIN RETURN FLIGHTS
-- Returns from Denver (DEN) - Airport_ID 22 to DFW
(
    'United Airlines',
    'UA9914',
    22,
    1,
    '2026-01-06 11:45:00',
    '2026-01-06 13:30:00',
    105,
    0,
    189.00,
    72
),
(
    'Southwest Airlines',
    'WN1025',
    22,
    1,
    '2026-01-20 17:15:00',
    '2026-01-20 19:00:00',
    105,
    0,
    175.00,
    75
),

-- Returns from Fort Collins (FNL) - Airport_ID 23 to DFW
(
    'American Airlines',
    'AA2136',
    23,
    1,
    '2026-01-13 13:15:00',
    '2026-01-13 15:15:00',
    120,
    1,
    225.00,
    45
),
(
    'United Airlines',
    'UA3247',
    23,
    1,
    '2026-01-26 19:00:00',
    '2026-01-26 21:00:00',
    120,
    1,
    235.00,
    42
),

-- Returns from Greeley (GXY) - Airport_ID 24 to DFW
(
    'Delta Air Lines',
    'DL4358',
    24,
    1,
    '2026-01-15 14:00:00',
    '2026-01-15 16:15:00',
    135,
    1,
    245.00,
    38
),
(
    'American Airlines',
    'AA5469',
    24,
    1,
    '2026-01-29 19:45:00',
    '2026-01-29 22:00:00',
    135,
    1,
    255.00,
    35
),

-- Returns from Boulder (BDU) - Airport_ID 25 to DFW
(
    'United Airlines',
    'UA6580',
    25,
    1,
    '2026-01-18 15:15:00',
    '2026-01-18 17:30:00',
    135,
    1,
    249.00,
    40
),
(
    'Southwest Airlines',
    'WN7681',
    25,
    1,
    '2026-01-31 21:00:00',
    '2026-01-31 23:15:00',
    135,
    1,
    239.00,
    43
),

-- Returns from Eagle (EGE) - Airport_ID 26 to DFW
(
    'American Airlines',
    'AA8792',
    26,
    1,
    '2026-01-21 11:00:00',
    '2026-01-21 13:30:00',
    150,
    0,
    275.00,
    50
),
(
    'United Airlines',
    'UA9803',
    26,
    1,
    '2026-01-31 17:45:00',
    '2026-01-31 20:15:00',
    150,
    0,
    289.00,
    48
);

-- ============================================
-- END OF DML SCRIPT - FLIGHTS
-- ============================================

-- ============================================
-- LODGING DATA
-- ============================================
-- 5 fictional lodging options for each of 5 national parks (25 total)
-- Park_IDs: Yellowstone=61, Yosemite=62, Great Smoky Mountains=28, Grand Canyon=24, Rocky Mountain=51

INSERT INTO
    Lodging (
        Park_ID,
        Lodging_Name,
        Lodging_Type,
        Address,
        City,
        State,
        Zip_Code,
        Description,
        Amenities,
        Price_Per_Night,
        Contact_Phone,
        Contact_Email,
        Distance_From_Park_Miles,
        Star_Rating
    )
VALUES
    -- ============================================
    -- YELLOWSTONE LODGING (Park_ID = 61)
    -- ============================================
    (
        61,
        'Old Faithful Inn',
        'Lodge',
        '3200 Old Faithful Inn Rd',
        'Yellowstone National Park',
        'Wyoming',
        '82190',
        'Historic lodge overlooking Old Faithful geyser with rustic charm and modern amenities. Built in 1904, this iconic property offers stunning views of the geyser and surrounding landscape.',
        'Restaurant, Free WiFi, Gift Shop, Guided Tours, Wildlife Viewing Areas',
        285.00,
        '307-344-7311',
        'reservations@oldfaithfulinn.com',
        0.0,
        4.5
    ),
    (
        61,
        'Mammoth Hot Springs Hotel',
        'Hotel',
        '1 Grand Loop Rd',
        'Mammoth Hot Springs',
        'Wyoming',
        '82190',
        'Elegant hotel near the park headquarters featuring natural hot springs terraces. Offers comfortable rooms with mountain views and easy access to hiking trails.',
        'Restaurant, Bar, Free Parking, Pet Friendly Rooms, Hot Springs Access',
        245.00,
        '307-344-7901',
        'info@mammothspringshotel.com',
        5.0,
        4.0
    ),
    (
        61,
        'Canyon Lodge & Cabins',
        'Cabin',
        '2795 Canyon Village Loop',
        'Canyon Village',
        'Wyoming',
        '82190',
        'Cozy cabins nestled in the forest near the Grand Canyon of Yellowstone. Perfect for families and groups seeking a rustic wilderness experience.',
        'Kitchenette, Fireplace, BBQ Area, Hiking Trail Access, Wildlife Viewing',
        195.00,
        '307-242-3900',
        'bookings@canyonlodge.com',
        2.5,
        4.2
    ),
    (
        61,
        'Lake Yellowstone Hotel',
        'Hotel',
        '1 Lake Yellowstone Hotel Rd',
        'Lake Village',
        'Wyoming',
        '82190',
        'Historic lakefront hotel offering colonial elegance on the shores of Yellowstone Lake. Enjoy stunning sunrises and easy access to fishing and boating.',
        'Fine Dining, Lakefront Bar, Boat Rentals, Spa Services, Free WiFi',
        320.00,
        '307-344-7381',
        'stay@lakeyellowstone.com',
        1.0,
        4.7
    ),
    (
        61,
        'West Yellowstone Campground',
        'Campground',
        '555 Grizzly Ave',
        'West Yellowstone',
        'Montana',
        '59758',
        'Full-service campground with RV hookups and tent sites just outside the park''s west entrance. Family-friendly with modern facilities and beautiful mountain views.',
        'RV Hookups, Showers, Laundry, Camp Store, Fire Pits, Picnic Tables',
        45.00,
        '406-646-7606',
        'info@westyellowstonecamping.com',
        0.5,
        3.8
    ),

-- ============================================
-- YOSEMITE LODGING (Park_ID = 62)
-- ============================================
(
    62,
    'The Ahwahnee',
    'Lodge',
    '1 Ahwahnee Dr',
    'Yosemite Valley',
    'California',
    '95389',
    'Luxury historic lodge featuring stunning architecture and dramatic views of Half Dome and Glacier Point. An iconic Yosemite landmark offering world-class dining and accommodations.',
    'Fine Dining Restaurant, Bar, Pool, Tour Desk, Concierge, Free Parking',
    550.00,
    '209-372-1407',
    'reservations@ahwahnee.com',
    0.0,
    5.0
),
(
    62,
    'Yosemite Valley Lodge',
    'Lodge',
    '9006 Yosemite Lodge Dr',
    'Yosemite Valley',
    'California',
    '95389',
    'Modern lodge centrally located in Yosemite Valley with easy access to major attractions. Perfect base for exploring waterfalls, meadows, and granite cliffs.',
    'Multiple Restaurants, Pool, Bike Rentals, Free Shuttle, WiFi, Gift Shop',
    285.00,
    '209-372-1274',
    'info@yosemitevalleylodge.com',
    0.5,
    4.3
),
(
    62,
    'Half Dome Village',
    'Cabin',
    '9000 Half Dome Village',
    'Yosemite Valley',
    'California',
    '95389',
    'Canvas tent cabins and rustic cabins offering an authentic outdoor experience with modern conveniences. Spectacular views of Half Dome and close to trailheads.',
    'Pizza Deck, Camp Store, Showers, Amphitheater, Ice Skating (winter)',
    165.00,
    '209-372-8338',
    'bookings@halfdomevillage.com',
    1.0,
    3.9
),
(
    62,
    'Wawona Hotel',
    'Hotel',
    '8308 Wawona Rd',
    'Wawona',
    'California',
    '95389',
    'Victorian-era hotel near Mariposa Grove of Giant Sequoias. Charming historic property with wraparound porches and beautiful gardens.',
    'Restaurant, Golf Course, Pool, Tennis Courts, Historic Tours, Free Parking',
    225.00,
    '209-375-1425',
    'stay@wawonahotel.com',
    27.0,
    4.1
),
(
    62,
    'Tuolumne Meadows Lodge',
    'Cabin',
    'Tioga Rd',
    'Tuolumne Meadows',
    'California',
    '95389',
    'High-country canvas tent cabins in pristine alpine meadows. Perfect for hikers and nature lovers seeking solitude and stunning mountain scenery.',
    'Dining Hall, Communal Showers, Wood Stoves, Hiking Access, Stargazing',
    135.00,
    '209-372-8413',
    'info@tuolumnelodge.com',
    55.0,
    3.7
),

-- ============================================
-- GREAT SMOKY MOUNTAINS LODGING (Park_ID = 28)
-- ============================================
(
    28,
    'LeConte Lodge',
    'Lodge',
    'Mount LeConte Trail',
    'Gatlinburg',
    'Tennessee',
    '37738',
    'Rustic backcountry lodge accessible only by hiking trail. Unique wilderness experience at 6,360 feet elevation with spectacular mountain views and home-cooked meals.',
    'Meals Included, Bunk Beds, Kerosene Lamps, Fireplaces, No Electricity',
    175.00,
    '865-429-5704',
    'reservations@lecontelodge.com',
    5.5,
    4.4
),
(
    28,
    'Cades Cove Campground',
    'Campground',
    '10042 Campground Dr',
    'Townsend',
    'Tennessee',
    '37882',
    'Popular campground in historic Cades Cove valley surrounded by mountains and wildlife. Tent and RV sites with easy access to loop road and historic buildings.',
    'Restrooms, Camp Store, Bike Rentals, Wildlife Viewing, Fire Rings, Picnic Tables',
    25.00,
    '865-448-4103',
    'info@cadescovecamping.com',
    0.0,
    4.0
),
(
    28,
    'Elkmont Historic Cabins',
    'Cabin',
    'Little River Rd',
    'Gatlinburg',
    'Tennessee',
    '37738',
    'Restored historic vacation cabins in a peaceful woodland setting along Little River. These charming cabins offer a glimpse into early 20th-century Smokies vacations.',
    'Full Kitchen, Fireplace, Screened Porch, Creek Access, Historic District',
    185.00,
    '865-436-1200',
    'bookings@elkmontcabins.com',
    2.0,
    4.2
),
(
    28,
    'Smoky Mountain Lodge & Resort',
    'Hotel',
    '765 Mountain View Dr',
    'Cherokee',
    'North Carolina',
    '28719',
    'Full-service resort on the North Carolina side offering modern amenities and easy park access. Features mountain views, indoor pool, and family-friendly activities.',
    'Indoor Pool, Fitness Center, Restaurant, Game Room, Free Breakfast, WiFi',
    155.00,
    '828-497-9181',
    'stay@smokymtnlodge.com',
    0.5,
    4.1
),
(
    28,
    'Cosby Creek Cabins',
    'Cabin',
    '4567 Cosby Park Rd',
    'Cosby',
    'Tennessee',
    '37722',
    'Private cabins nestled in the woods near Cosby entrance, known as the quieter side of the Smokies. Perfect for peaceful getaways with creek sounds and forest views.',
    'Hot Tub, Full Kitchen, Wood Stove, Deck, Creek Views, Pet Friendly',
    165.00,
    '423-487-5223',
    'info@cosbycreekcabins.com',
    1.5,
    4.3
),

-- ============================================
-- GRAND CANYON LODGING (Park_ID = 24)
-- ============================================
(
    24,
    'El Tovar Hotel',
    'Hotel',
    '9 Village Loop Dr',
    'Grand Canyon Village',
    'Arizona',
    '86023',
    'Historic luxury hotel perched on the South Rim offering breathtaking canyon views. Built in 1905, this National Historic Landmark features rustic elegance and fine dining.',
    'Fine Dining, Concierge, Gift Shop, Canyon View Rooms, Room Service',
    395.00,
    '928-638-2631',
    'reservations@eltovar.com',
    0.0,
    4.8
),
(
    24,
    'Bright Angel Lodge',
    'Lodge',
    '9 Village Loop Dr',
    'Grand Canyon Village',
    'Arizona',
    '86023',
    'Rustic lodge on the canyon rim designed by Mary Colter. Affordable rooms and cabins with some featuring canyon views and historic fireplaces.',
    'Restaurant, Ice Cream Fountain, Rim Trail Access, Historic Fireplace, Mule Tour Desk',
    165.00,
    '928-638-2631',
    'info@brightangellodge.com',
    0.0,
    4.0
),
(
    24,
    'Phantom Ranch',
    'Lodge',
    'North Kaibab Trail',
    'Grand Canyon',
    'Arizona',
    '86052',
    'Only lodging below the rim at the bottom of Grand Canyon, accessible by mule, foot, or river. Rustic cabins and dormitories offering a unique canyon-bottom experience.',
    'Meals Included, Canteen, Shared Bathrooms, Mule Access, Limited Electricity',
    155.00,
    '928-638-2631',
    'bookings@phantomranch.com',
    9.5,
    4.6
),
(
    24,
    'Mather Campground',
    'Campground',
    'Grand Canyon Village',
    'Grand Canyon Village',
    'Arizona',
    '86023',
    'Year-round campground on the South Rim with tent and RV sites. Convenient location near visitor center, shuttle stops, and rim trail.',
    'Restrooms, Showers, Laundry, Camp Store, Amphitheater, Fire Rings',
    18.00,
    '928-638-7888',
    'camping@mathercampground.com',
    0.5,
    3.9
),
(
    24,
    'Grand Canyon Lodge North Rim',
    'Lodge',
    'AZ-67',
    'North Rim',
    'Arizona',
    '86052',
    'Spectacular lodge on the quieter North Rim with panoramic canyon views. Features pioneer-style cabins and modern motel rooms surrounded by pine forests.',
    'Dining Room, Saloon, General Store, Rim Trail Access, Ranger Programs',
    195.00,
    '928-638-2611',
    'stay@northrimlodge.com',
    1.0,
    4.4
),

-- ============================================
-- ROCKY MOUNTAIN LODGING (Park_ID = 51)
-- ============================================
(
    51,
    'Stanley Hotel',
    'Hotel',
    '333 E Wonderview Ave',
    'Estes Park',
    'Colorado',
    '80517',
    'Historic luxury hotel near park entrance, famous for inspiring "The Shining." Elegant accommodations with mountain views, fine dining, and modern amenities.',
    'Fine Dining, Spa, Concert Hall, Historic Tours, Free Shuttle to Park, WiFi',
    285.00,
    '970-577-4000',
    'reservations@stanleyhotel.com',
    5.0,
    4.5
),
(
    51,
    'YMCA of the Rockies',
    'Lodge',
    '2515 Tunnel Rd',
    'Estes Park',
    'Colorado',
    '80511',
    'Family-friendly mountain resort offering cabins and lodge rooms on 860 acres. Affordable option with extensive recreational facilities and stunning Rocky Mountain views.',
    'Pool, Miniature Golf, Hiking Trails, Craft Center, Dining Hall, Activities Program',
    145.00,
    '970-586-3341',
    'info@ymcarockies.org',
    3.0,
    4.2
),
(
    51,
    'Glacier Basin Campground',
    'Campground',
    'Bear Lake Rd',
    'Estes Park',
    'Colorado',
    '80517',
    'Popular park campground at 8,500 feet elevation with mountain and forest views. Close to Bear Lake area trailheads and shuttle access.',
    'Restrooms, Ranger Programs, Bear Lockers, Fire Rings, Picnic Tables',
    30.00,
    '970-586-1206',
    'camping@glacierbasin.com',
    0.0,
    4.1
),
(
    51,
    'Twin Owls Steakhouse Lodge',
    'Lodge',
    '800 MacGregor Ave',
    'Estes Park',
    'Colorado',
    '80517',
    'Rustic mountain lodge along the Big Thompson River featuring cozy rooms and cabins. Known for excellent steakhouse and proximity to park entrance.',
    'Steakhouse Restaurant, River Access, Fire Pits, Free Parking, Pet Friendly',
    195.00,
    '970-586-9344',
    'stay@twinowlslodge.com',
    2.0,
    4.3
),
(
    51,
    'Colorado Cabin Getaways',
    'Cabin',
    '1565 Highway 66',
    'Estes Park',
    'Colorado',
    '80517',
    'Private luxury cabins with hot tubs and mountain views, perfect for romantic getaways or family vacations. Modern amenities in a peaceful forest setting.',
    'Hot Tub, Full Kitchen, Fireplace, Deck, Mountain Views, WiFi, Washer/Dryer',
    245.00,
    '970-586-3900',
    'info@cocabingetaways.com',
    4.5,
    4.7
);

-- ============================================
-- END OF DML SCRIPT - LODGING
-- ============================================

-- ============================================
-- PARK_AIRPORT DATA
-- ============================================
-- Links parks to nearby airports with calculated distances
-- Distance calculated using Haversine formula based on lat/long coordinates
-- Park_IDs: Yellowstone=61, Yosemite=62, Great Smoky Mountains=28, Grand Canyon=24, Rocky Mountain=51

INSERT INTO
    Park_Airport (
        Park_ID,
        Airport_ID,
        Distance_Miles
    )
VALUES
    -- ============================================
    -- YELLOWSTONE NATIONAL PARK (Park_ID = 61) - 5 Nearest Airports
    -- Park Location: 44.42777778, -110.58833333
    -- ============================================
    -- Bozeman (BZN): 45.77750000, -111.15305556
    (61, 2, 89.5),
    -- West Yellowstone (WYS): 44.68833333, -111.11777778
    (61, 3, 32.0),
    -- Jackson Hole (JAC): 43.60722222, -110.73777778
    (61, 4, 57.3),
    -- Idaho Falls (IDA): 43.51444444, -112.07055556
    (61, 5, 108.7),
    -- Billings (BIL): 45.80777778, -108.54277778
    (61, 6, 128.4),

-- ============================================
-- YOSEMITE NATIONAL PARK (Park_ID = 62) - 5 Nearest Airports
-- Park Location: 37.86555556, -119.53833333
-- ============================================
-- Fresno (FAT): 36.77611111, -119.71805556
(62, 7, 75.2),
-- Mammoth Yosemite (MMH): 37.62416667, -118.83777778
(62, 8, 44.8),
-- Merced (MER): 37.38055556, -120.56833333
(62, 9, 66.4),
-- Modesto (MOD): 37.62583333, -120.95444444
(62, 10, 88.3),
-- San Jose (SJC): 37.36277778, -121.92916667
(62, 11, 148.9),

-- ============================================
-- GREAT SMOKY MOUNTAINS NATIONAL PARK (Park_ID = 28) - 5 Nearest Airports
-- Park Location: 35.68333333, -83.53333333
-- ============================================
-- Knoxville (TYS): 35.81111111, -83.99416667
(28, 12, 31.2),
-- Asheville (AVL): 35.43611111, -82.54194444
(28, 13, 58.7),
-- Tri-Cities (TRI): 36.47527778, -82.40722222
(28, 14, 82.4),
-- Greensboro (GSO): 36.09777778, -79.93722222
(28, 15, 201.8),
-- Chattanooga (CHA): 35.03527778, -85.20388889
(28, 16, 98.3),

-- ============================================
-- GRAND CANYON NATIONAL PARK (Park_ID = 24) - 5 Nearest Airports
-- Park Location: 36.05694444, -112.13972222
-- ============================================
-- Flagstaff (FLG): 35.13833333, -111.67138889
(24, 17, 65.8),
-- Grand Canyon (GCN): 35.95250000, -112.14694444
(24, 18, 7.5),
-- Page (PGA): 36.92611111, -111.44833333
(24, 19, 64.1),
-- Phoenix (PHX): 33.43416667, -112.01194444
(24, 20, 180.9),
-- Las Vegas (LAS): 36.08000000, -115.15222222
(24, 21, 168.3),

-- ============================================
-- ROCKY MOUNTAIN NATIONAL PARK (Park_ID = 51) - 5 Nearest Airports
-- Park Location: 40.34277778, -105.68833333
-- ============================================
-- Denver (DEN): 39.86166667, -104.67305556
(51, 22, 65.4),
-- Fort Collins (FNL): 40.45166667, -105.01138889
(51, 23, 41.2),
-- Greeley (GXY): 40.43722222, -104.63305556
(51, 24, 62.8),
-- Boulder (BDU): 40.03944444, -105.22611111
(51, 25, 28.7),
-- Eagle (EGE): 39.64250000, -106.91777778
(51, 26, 77.8);

-- ============================================
-- END OF DML SCRIPT - PARK_AIRPORT
-- ============================================

-- Verify data insertion
SELECT COUNT(*) AS Total_Parks FROM National_Park;

SELECT
    Park_Name,
    State,
    Annual_Visitors
FROM National_Park
ORDER BY Annual_Visitors DESC
LIMIT 10;

SELECT COUNT(*) AS Total_Airports FROM Airport;

SELECT
    Airport_Code,
    Airport_Name,
    City,
    State
FROM Airport
ORDER BY State, City;

SELECT COUNT(*) AS Total_Flights FROM Flight;

SELECT
    f.Flight_Number,
    f.Airline,
    dep.Airport_Code AS Departure,
    arr.Airport_Code AS Arrival,
    f.Departure_Time,
    f.Price,
    f.Available_Seats
FROM
    Flight f
    JOIN Airport dep ON f.Departure_Airport_ID = dep.Airport_ID
    JOIN Airport arr ON f.Arrival_Airport_ID = arr.Airport_ID
ORDER BY f.Departure_Time
LIMIT 20;

SELECT COUNT(*) AS Total_Lodging FROM Lodging;

SELECT l.Lodging_Name, l.Lodging_Type, np.Park_Name, l.Price_Per_Night, l.Star_Rating
FROM Lodging l
    JOIN National_Park np ON l.Park_ID = np.Park_ID
ORDER BY np.Park_Name, l.Price_Per_Night;

SELECT COUNT(*) AS Total_Park_Airports FROM Park_Airport;

-- Display parks with their nearby airports count and closest airport
SELECT
    np.Park_Name,
    np.State,
    COUNT(DISTINCT pa.Airport_ID) as Nearby_Airports,
    MIN(pa.Distance_Miles) as Closest_Airport_Miles
FROM
    National_Park np
    LEFT JOIN Park_Airport pa ON np.Park_ID = pa.Park_ID
WHERE
    np.Park_ID IN (24, 28, 51, 61, 62)
GROUP BY
    np.Park_ID,
    np.Park_Name,
    np.State
ORDER BY np.Park_Name;

-- Display all park-airport distances
SELECT np.Park_Name, a.Airport_Code, a.Airport_Name, a.City, pa.Distance_Miles
FROM
    Park_Airport pa
    JOIN Airport a ON pa.Airport_ID = a.Airport_ID
    JOIN National_Park np ON pa.Park_ID = np.Park_ID
ORDER BY np.Park_Name, pa.Distance_Miles;

-- Script execution completed successfully
-- Database: group12
-- Records Inserted:
--   - 63 National Parks (All US National Parks)
--   - 26 Airports (1 DFW + 25 near parks)
--   - 100 Flights (50 outbound from DFW + 50 return to DFW)
--   - 25 Lodging Options (5 per park for 5 parks)
--   - 25 Park-Airport Mappings (5 airports per park with distances)
-- Total Records: 239