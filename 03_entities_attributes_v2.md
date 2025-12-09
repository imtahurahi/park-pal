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

## 3. Lodging
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

## 4. Lodging_Reservations
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

## 5. Park_Reviews
- Review_ID (PK)
- User_ID (FK)
- Park_ID (FK)
- Rating
- Review_Text
- Visit_Date
- Review_Date
- Photo_URLs
