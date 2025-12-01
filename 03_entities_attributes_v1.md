# Core MVP Entities and Attributes

## 1. Users
- user_id (PK)
- email
- password_hash
- name
- profile_picture
- budget_range_preference
- activity_level_preference
- accommodation_type_preference
- created_at
- last_login
- email_verified

## 2. Parks
- park_id (PK)
- park_name
- state
- latitude
- longitude
- description
- highlights
- difficulty_level
- family_friendly
- entrance_fee
- best_seasons
- created_at
- updated_at

## 3. Activities
- activity_id (PK)
- activity_name
- description

## 4. Park_Activities
- park_id (FK)
- activity_id (FK)

## 5. Amenities
- amenity_id (PK)
- amenity_name
- description

## 6. Park_Amenities
- park_id (FK)
- amenity_id (FK)

## 7. Airports
- airport_id (PK)
- airport_code
- airport_name
- city
- state
- latitude
- longitude

## 8. Park_Airports
- park_id (FK)
- airport_id (FK)
- distance_miles

## 9. Airlines
- airline_id (PK)
- airline_name
- airline_code

## 10. Flights
- flight_id (PK)
- airline_id (FK)
- flight_number
- origin_airport_id (FK)
- destination_airport_id (FK)
- departure_time
- arrival_time
- duration_minutes
- price
- punctuality_score
- average_delay_minutes
- number_of_stops
- flight_date
- created_at

## 11. Lodging
- lodging_id (PK)
- park_id (FK)
- name
- type
- address
- latitude
- longitude
- distance_from_park_miles
- price_range
- contact_phone
- contact_email
- website
- wifi_available
- pet_friendly
- accessibility_features

## 12. Trips
- trip_id (PK)
- user_id (FK)
- park_id (FK)
- flight_id (FK)
- lodging_id (FK)
- title
- description
- arrival_date
- departure_date
- status
- created_at
- updated_at
- is_deleted

## 13. Notes
- note_id (PK)
- user_id (FK)
- trip_id (FK)
- title
- content
- category
- created_at
- updated_at

## 14. Wishlists
- wishlist_id (PK)
- user_id (FK)
- park_id (FK)
- priority
- visited
- added_at
- visited_date
