# Core MVP Entities and Attributes

## 1. Users
- User_ID (PK)
- Email
- Password_Hash
- First_Name
- Last_Name
- Phone_Number
- Created_At
- Updated_At

## 2. National_Parks
- Park_ID (PK)
- Park_Name
- State
- Region
- Description
- Wildlife_Information
- Plant_Information
- Area_Square_Miles
- Annual_Visitors
- Best_Time_To_Visit
- Entry_Fee
- Free_Entry_Days
- Official_Website
- Latitude
- Longitude
- Park_Activities_Events
- Popular_Park_Trails
- Difficulty_Rating
- Kid_Friendliness_Rating
- Pet_Friendliness_Rating

## 3. Airports
- Airport_ID (PK)
- Airport_Code
- Airport_Name
- City
- State
- Latitude
- Longitude

## 4. Park_Airports
- Park_ID (PK, FK)
- Airport_ID (PK, FK)
- Distance_Miles

## 5. Flights
- Flight_ID (PK)
- Airline
- Flight_Number
- Departure_Airport_ID (FK)
- Arrival_Airport_ID (FK)
- Departure_Time
- Arrival_Time
- Duration_Minutes
- Number_Of_Stops
- Price
- Available_Seats

## 6. Flight_Bookings
- Booking_ID (PK)
- User_ID (FK)
- Flight_ID (FK)
- Passenger_First_Name
- Passenger_Last_Name
- Passenger_DOB
- Confirmation_Number
- Booking_Status
- Booking_Date
- Total_Cost

## 7. Lodging
- Lodging_ID (PK)
- Park_ID (FK)
- Lodging_Name
- Lodging_Type
- Address
- City
- State
- Zip_Code
- Description
- Amenities
- Price_Per_Night
- Contact_Phone
- Contact_Email
- Distance_From_Park_Miles
- Star_Rating

## 8. Lodging_Reservations
- Reservation_ID (PK)
- User_ID (FK)
- Lodging_ID (FK)
- Check_In_Date
- Check_Out_Date
- Number_Of_Guests
- Number_Of_Rooms
- Guest_Name
- Guest_Phone
- Guest_Email
- Confirmation_Number
- Reservation_Status
- Total_Cost
- Created_At

## 9. Trips
- Trip_ID (PK)
- User_ID (FK)
- Park_ID (FK)
- Trip_Start_Date
- Trip_End_Date
- Trip_Status
- Total_Cost
- Created_At
- Updated_At

## 10. Trip_Components
- Trip_ID (PK, FK)
- Flight_Booking_ID (FK)
- Lodging_Reservation_ID (FK)

## 11. Park_Reviews
- Review_ID (PK)
- User_ID (FK)
- Park_ID (FK)
- Rating
- Review_Text
- Visit_Date
- Review_Date
- Photo_URLs
