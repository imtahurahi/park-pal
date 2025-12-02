import streamlit as st
import sqlite3
import pandas as pd
from datetime import datetime, timedelta, date
from openai import OpenAI
import os
from dotenv import load_dotenv
import hashlib

# Load environment variables
load_dotenv()

# Page configuration
st.set_page_config(page_title="National Park Travel Planner", layout="wide")

# Database connection
db_path = "national_parks.db"

# Helper functions
def hash_password(password):
    """Hash password using SHA-256"""
    return hashlib.sha256(password.encode()).hexdigest()

def authenticate_user(email, password):
    """Authenticate user and return user_id if successful"""
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    hashed = hash_password(password)
    cursor.execute(
        "SELECT user_id, name FROM Users WHERE email = ? AND password_hash = ?",
        (email, hashed)
    )
    result = cursor.fetchone()
    conn.close()
    return result

def create_user(email, password, name, budget_pref, activity_pref, accommodation_pref):
    """Create a new user account"""
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    hashed = hash_password(password)
    try:
        cursor.execute(
            """INSERT INTO Users (email, password_hash, name, budget_range_preference, 
               activity_level_preference, accommodation_type_preference, email_verified)
               VALUES (?, ?, ?, ?, ?, ?, 1)""",
            (email, hashed, name, budget_pref, activity_pref, accommodation_pref)
        )
        conn.commit()
        user_id = cursor.lastrowid
        conn.close()
        return user_id
    except sqlite3.IntegrityError:
        conn.close()
        return None

# Initialize session state
if "logged_in" not in st.session_state:
    st.session_state.logged_in = False
if "user_id" not in st.session_state:
    st.session_state.user_id = None
if "user_name" not in st.session_state:
    st.session_state.user_name = None

# Authentication UI
if not st.session_state.logged_in:
    st.title("🏞️ National Park Travel Planner")
    
    tab1, tab2 = st.tabs(["Login", "Sign Up"])
    
    with tab1:
        st.subheader("Login to Your Account")
        email = st.text_input("Email", key="login_email")
        password = st.text_input("Password", type="password", key="login_password")
        
        if st.button("Login"):
            result = authenticate_user(email, password)
            if result:
                st.session_state.logged_in = True
                st.session_state.user_id = result[0]
                st.session_state.user_name = result[1]
                st.success(f"Welcome back, {result[1]}!")
                st.rerun()
            else:
                st.error("Invalid email or password")
    
    with tab2:
        st.subheader("Create New Account")
        new_email = st.text_input("Email", key="signup_email")
        new_password = st.text_input("Password", type="password", key="signup_password")
        new_password_confirm = st.text_input("Confirm Password", type="password", key="signup_password_confirm")
        new_name = st.text_input("Full Name")
        
        col1, col2, col3 = st.columns(3)
        with col1:
            budget_pref = st.selectbox("Budget Range", ["budget", "moderate", "luxury"])
        with col2:
            activity_pref = st.selectbox("Activity Level", ["low", "moderate", "high"])
        with col3:
            accommodation_pref = st.selectbox("Accommodation Type", ["campground", "hotel", "lodge", "cabin"])
        
        if st.button("Create Account"):
            if new_password != new_password_confirm:
                st.error("Passwords do not match")
            elif len(new_password) < 6:
                st.error("Password must be at least 6 characters")
            elif not new_email or not new_name:
                st.error("Please fill in all required fields")
            else:
                user_id = create_user(new_email, new_password, new_name, budget_pref, activity_pref, accommodation_pref)
                if user_id:
                    st.success("Account created successfully! Please log in.")
                else:
                    st.error("Email already exists")
    
    st.stop()

# Main App (for logged-in users)
st.title("🏞️ National Park Travel Planner")

# Sidebar
with st.sidebar:
    st.write(f"👤 {st.session_state.user_name}")
    if st.button("Logout"):
        st.session_state.logged_in = False
        st.session_state.user_id = None
        st.session_state.user_name = None
        st.rerun()
    
    st.divider()
    
    page = st.selectbox(
        "Navigation",
        ["Explore Parks", "My Profile", "Plan Trip", "My Trips", "My Reviews", "Flights & Lodging", "Flight Analytics", "AI Assistant"],
    )

# ===================================
# MY PROFILE PAGE
# ===================================
if page == "My Profile":
    st.header("My Profile")
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Get current user info
    cursor.execute(
        """SELECT name, email, budget_range_preference, activity_level_preference, 
           accommodation_type_preference, created_at 
           FROM Users WHERE user_id = ?""",
        (st.session_state.user_id,)
    )
    user_data = cursor.fetchone()
    
    if user_data:
        st.subheader("Account Information")
        st.write(f"**Member Since:** {user_data[5][:10]}")
        
        with st.form("profile_form"):
            st.subheader("Update Your Profile")
            name = st.text_input("Name", value=user_data[0])
            email = st.text_input("Email", value=user_data[1], disabled=True)
            
            col1, col2, col3 = st.columns(3)
            with col1:
                budget_pref = st.selectbox("Budget Range", ["budget", "moderate", "luxury"], 
                                          index=["budget", "moderate", "luxury"].index(user_data[2]))
            with col2:
                activity_pref = st.selectbox("Activity Level", ["low", "moderate", "high"],
                                            index=["low", "moderate", "high"].index(user_data[3]))
            with col3:
                accommodation_pref = st.selectbox("Accommodation Type", ["campground", "hotel", "lodge", "cabin"],
                                                 index=["campground", "hotel", "lodge", "cabin"].index(user_data[4]))
            
            if st.form_submit_button("Update Profile"):
                cursor.execute(
                    """UPDATE Users SET name = ?, budget_range_preference = ?, 
                       activity_level_preference = ?, accommodation_type_preference = ?
                       WHERE user_id = ?""",
                    (name, budget_pref, activity_pref, accommodation_pref, st.session_state.user_id)
                )
                conn.commit()
                st.session_state.user_name = name
                st.success("Profile updated successfully!")
                st.rerun()
    
    conn.close()

# ===================================
# EXPLORE PARKS PAGE
# ===================================
elif page == "Explore Parks":
    st.header("Explore National Parks")

    conn = sqlite3.connect(db_path)

    col1, col2 = st.columns([3, 1])

    with col1:
        # Get all parks with average ratings
        parks_query = """
        SELECT p.park_id, p.park_name, p.state, p.description, p.difficulty_level, 
               p.family_friendly, p.entrance_fee, p.best_seasons,
               COALESCE(AVG(r.rating), 0) as avg_rating,
               COUNT(r.review_id) as review_count
        FROM Parks p
        LEFT JOIN Park_Reviews r ON p.park_id = r.park_id
        GROUP BY p.park_id
        ORDER BY p.park_name
        """
        df_parks = pd.read_sql_query(parks_query, conn)

        # Filters
        state_filter = st.multiselect("Filter by State", options=sorted(df_parks['state'].unique()))
        difficulty_filter = st.multiselect("Difficulty Level", options=df_parks['difficulty_level'].unique())
        
        # Apply filters
        filtered_df = df_parks.copy()
        if state_filter:
            filtered_df = filtered_df[filtered_df['state'].isin(state_filter)]
        if difficulty_filter:
            filtered_df = filtered_df[filtered_df['difficulty_level'].isin(difficulty_filter)]
        
        # Display parks
        for _, park in filtered_df.iterrows():
            with st.expander(f"⛰️ {park['park_name']} - {park['state']}"):
                col_a, col_b = st.columns([2, 1])
                with col_a:
                    st.write(f"**Description:** {park['description']}")
                    st.write(f"**Difficulty:** {park['difficulty_level'].title()}")
                    st.write(f"**Best Seasons:** {park['best_seasons']}")
                    st.write(f"**Entrance Fee:** ${park['entrance_fee']:.2f}")
                    st.write(f"**⭐ Rating:** {park['avg_rating']:.1f}/5.0 ({int(park['review_count'])} reviews)")
                
                with col_b:
                    if st.button(f"📝 Write Review", key=f"review_{park['park_id']}"):
                        st.session_state[f"show_review_form_{park['park_id']}"] = True
                
                # Review form
                if st.session_state.get(f"show_review_form_{park['park_id']}", False):
                    with st.form(f"review_form_{park['park_id']}"):
                        rating = st.slider("Rating", 1, 5, 3)
                        review_title = st.text_input("Title")
                        review_text = st.text_area("Your Review")
                        visit_date = st.date_input("Visit Date", max_value=date.today())
                        
                        submitted = st.form_submit_button("Submit Review")
                        if submitted:
                            cursor = conn.cursor()
                            cursor.execute(
                                """INSERT INTO Park_Reviews (user_id, park_id, rating, title, review_text, visit_date)
                                   VALUES (?, ?, ?, ?, ?, ?)""",
                                (st.session_state.user_id, park['park_id'], rating, review_title, review_text, visit_date)
                            )
                            conn.commit()
                            st.success("Review submitted successfully!")
                            st.session_state[f"show_review_form_{park['park_id']}"] = False
                            st.rerun()

    with col2:
        st.subheader("Quick Stats")
        st.metric("Total Parks", len(df_parks))
        st.metric("Showing", len(filtered_df))

    conn.close()

# ===================================
# MY REVIEWS PAGE
# ===================================
elif page == "My Reviews":
    st.header("My Park Reviews")
    
    conn = sqlite3.connect(db_path)
    
    reviews_query = """
    SELECT r.review_id, p.park_name, p.state, r.rating, r.title, r.review_text, 
           r.visit_date, r.created_at
    FROM Park_Reviews r
    JOIN Parks p ON r.park_id = p.park_id
    WHERE r.user_id = ?
    ORDER BY r.created_at DESC
    """
    df_reviews = pd.read_sql_query(reviews_query, conn, params=(st.session_state.user_id,))
    
    if len(df_reviews) == 0:
        st.info("You haven't written any reviews yet. Visit the 'Explore Parks' page to write your first review!")
    else:
        for _, review in df_reviews.iterrows():
            with st.expander(f"{'⭐' * review['rating']} {review['park_name']} - {review['title']}"):
                st.write(f"**Park:** {review['park_name']}, {review['state']}")
                st.write(f"**Visited:** {review['visit_date']}")
                st.write(f"**Review:** {review['review_text']}")
                
                col1, col2 = st.columns([1, 1])
                with col1:
                    if st.button(f"✏️ Edit", key=f"edit_review_{review['review_id']}"):
                        st.session_state[f"editing_review_{review['review_id']}"] = True
                        st.rerun()
                
                with col2:
                    if st.button(f"🗑️ Delete", key=f"delete_review_{review['review_id']}"):
                        cursor = conn.cursor()
                        cursor.execute("DELETE FROM Park_Reviews WHERE review_id = ?", (review['review_id'],))
                        conn.commit()
                        st.success("Review deleted!")
                        st.rerun()
                
                # Edit form
                if st.session_state.get(f"editing_review_{review['review_id']}", False):
                    with st.form(f"edit_form_{review['review_id']}"):
                        new_rating = st.slider("Rating", 1, 5, review['rating'])
                        new_title = st.text_input("Title", value=review['title'])
                        new_text = st.text_area("Review", value=review['review_text'])
                        
                        col_a, col_b = st.columns(2)
                        with col_a:
                            if st.form_submit_button("Save Changes"):
                                cursor = conn.cursor()
                                cursor.execute(
                                    """UPDATE Park_Reviews 
                                       SET rating = ?, title = ?, review_text = ?
                                       WHERE review_id = ?""",
                                    (new_rating, new_title, new_text, review['review_id'])
                                )
                                conn.commit()
                                st.success("Review updated!")
                                st.session_state[f"editing_review_{review['review_id']}"] = False
                                st.rerun()
                        
                        with col_b:
                            if st.form_submit_button("Cancel"):
                                st.session_state[f"editing_review_{review['review_id']}"] = False
                                st.rerun()
    
    conn.close()

# ===================================
# PLAN TRIP PAGE
# ===================================
elif page == "Plan Trip":
    st.header("Plan a New Trip")
    
    conn = sqlite3.connect(db_path)
    
    # Get parks list
    parks_df = pd.read_sql_query("SELECT park_id, park_name, state FROM Parks ORDER BY park_name", conn)
    park_options = {f"{row['park_name']} ({row['state']})": row['park_id'] 
                   for _, row in parks_df.iterrows()}
    
    # Get flights list
    flights_df = pd.read_sql_query(
        """SELECT f.flight_id, a.airline_name, f.flight_number, f.price, f.flight_date
           FROM Flights f
           JOIN Airlines a ON f.airline_id = a.airline_id
           ORDER BY f.flight_date""",
        conn
    )
    flight_options = {f"{row['airline_name']} {row['flight_number']} - ${row['price']:.0f} ({row['flight_date']})": row['flight_id'] 
                     for _, row in flights_df.iterrows()}
    flight_options["None (I'll arrange my own travel)"] = None
    
    with st.form("new_trip_form"):
        trip_title = st.text_input("Trip Title")
        selected_park = st.selectbox("Select Park", options=list(park_options.keys()))
        
        col1, col2 = st.columns(2)
        with col1:
            arrival_date = st.date_input("Arrival Date", min_value=date.today())
        with col2:
            departure_date = st.date_input("Departure Date", min_value=date.today())
        
        # Optional flight selection
        selected_flight = st.selectbox("Select Flight (optional)", options=list(flight_options.keys()))
        
        trip_description = st.text_area("Trip Notes")
        status = st.selectbox("Status", ["draft", "planned", "confirmed"])
        
        if st.form_submit_button("Create Trip"):
            if departure_date < arrival_date:
                st.error("Departure date must be after arrival date")
            else:
                cursor = conn.cursor()
                park_id = park_options[selected_park]
                flight_id = flight_options[selected_flight]
                
                cursor.execute(
                    """INSERT INTO Trips (user_id, park_id, flight_id, title, description, 
                       arrival_date, departure_date, status)
                       VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
                    (st.session_state.user_id, park_id, flight_id, trip_title, trip_description,
                     arrival_date, departure_date, status)
                )
                conn.commit()
                st.success("Trip created successfully! You can add lodging from the 'Flights & Lodging' page.")
                st.rerun()
    
    conn.close()

# ===================================
# MY TRIPS PAGE
# ===================================
elif page == "My Trips":
    st.header("My Trips")
    
    conn = sqlite3.connect(db_path)
    
    trips_query = """
    SELECT t.trip_id, t.title, p.park_name, p.state, t.arrival_date, 
           t.departure_date, t.status, t.description, t.flight_id, t.lodging_id,
           a.airline_name, f.flight_number, f.price as flight_price,
           l.name as lodging_name, l.type as lodging_type
    FROM Trips t
    JOIN Parks p ON t.park_id = p.park_id
    LEFT JOIN Flights f ON t.flight_id = f.flight_id
    LEFT JOIN Airlines a ON f.airline_id = a.airline_id
    LEFT JOIN Lodging l ON t.lodging_id = l.lodging_id
    WHERE t.user_id = ? AND t.is_deleted = 0
    ORDER BY t.arrival_date DESC
    """
    df_trips = pd.read_sql_query(trips_query, conn, params=(st.session_state.user_id,))
    
    if len(df_trips) == 0:
        st.info("No trips planned yet. Go to 'Plan Trip' to create your first trip!")
    else:
        # Filter by status
        status_filter = st.multiselect("Filter by Status", 
                                       options=df_trips['status'].unique(),
                                       default=df_trips['status'].unique())
        filtered_trips = df_trips[df_trips['status'].isin(status_filter)] if status_filter else df_trips
        
        for _, trip in filtered_trips.iterrows():
            with st.expander(f"🎒 {trip['title']} - {trip['park_name']}"):
                col1, col2 = st.columns([2, 1])
                
                with col1:
                    st.write(f"**Park:** {trip['park_name']}, {trip['state']}")
                    st.write(f"**Dates:** {trip['arrival_date']} to {trip['departure_date']}")
                    st.write(f"**Status:** {trip['status'].title()}")
                    if trip['description']:
                        st.write(f"**Notes:** {trip['description']}")
                    
                    # Show flight info if available
                    if trip['flight_id']:
                        st.write(f"✈️ **Flight:** {trip['airline_name']} {trip['flight_number']} (${trip['flight_price']:.2f})")
                    
                    # Show lodging info if available
                    if trip['lodging_id']:
                        st.write(f"🏨 **Lodging:** {trip['lodging_name']} ({trip['lodging_type']})")

                
                with col2:
                    if st.button("✏️ Edit Trip", key=f"edit_trip_{trip['trip_id']}"):
                        st.session_state[f"editing_trip_{trip['trip_id']}"] = True
                        st.rerun()
                    
                    if st.button("🗑️ Delete Trip", key=f"delete_trip_{trip['trip_id']}"):
                        cursor = conn.cursor()
                        cursor.execute("UPDATE Trips SET is_deleted = 1 WHERE trip_id = ?", 
                                     (trip['trip_id'],))
                        conn.commit()
                        st.success("Trip deleted!")
                        st.rerun()
                
                # Edit form
                if st.session_state.get(f"editing_trip_{trip['trip_id']}", False):
                    with st.form(f"edit_trip_form_{trip['trip_id']}"):
                        st.subheader("Edit Trip")
                        new_title = st.text_input("Title", value=trip['title'])
                        
                        col_a, col_b = st.columns(2)
                        with col_a:
                            new_arrival = st.date_input("Arrival", value=pd.to_datetime(trip['arrival_date']).date())
                        with col_b:
                            new_departure = st.date_input("Departure", value=pd.to_datetime(trip['departure_date']).date())
                        
                        new_status = st.selectbox("Status", ["draft", "planned", "confirmed"], 
                                                 index=["draft", "planned", "confirmed"].index(trip['status']))
                        new_description = st.text_area("Notes", value=trip['description'] or "")
                        
                        col_x, col_y = st.columns(2)
                        with col_x:
                            if st.form_submit_button("Save Changes"):
                                cursor = conn.cursor()
                                cursor.execute(
                                    """UPDATE Trips 
                                       SET title = ?, arrival_date = ?, departure_date = ?, 
                                           status = ?, description = ?
                                       WHERE trip_id = ?""",
                                    (new_title, new_arrival, new_departure, new_status, 
                                     new_description, trip['trip_id'])
                                )
                                conn.commit()
                                st.success("Trip updated!")
                                st.session_state[f"editing_trip_{trip['trip_id']}"] = False
                                st.rerun()
                        
                        with col_y:
                            if st.form_submit_button("Cancel"):
                                st.session_state[f"editing_trip_{trip['trip_id']}"] = False
                                st.rerun()
    
    conn.close()

# ===================================
# FLIGHT ANALYTICS PAGE
# ===================================
elif page == "Flight Analytics":
    st.header("Flight Analytics")
    
    conn = sqlite3.connect(db_path)
    
    st.subheader("Most Punctual Airlines")
    punctuality_query = """
    SELECT a.airline_name, 
           AVG(f.punctuality_score) as avg_punctuality,
           COUNT(*) as flight_count
    FROM Flights f
    JOIN Airlines a ON f.airline_id = a.airline_id
    GROUP BY a.airline_id
    HAVING flight_count >= 5
    ORDER BY avg_punctuality DESC
    LIMIT 10
    """
    df_punctuality = pd.read_sql_query(punctuality_query, conn)
    st.bar_chart(df_punctuality.set_index('airline_name')['avg_punctuality'])
    
    conn.close()

# ===================================
# FLIGHTS & LODGING PAGE
# ===================================
elif page == "Flights & Lodging":
    st.header("🛫 Flights & 🏨 Lodging")
    
    conn = sqlite3.connect(db_path)
    
    tab1, tab2 = st.tabs(["Search Flights", "Find Lodging"])
    
    with tab1:
        st.subheader("Search Flights to National Parks")
        
        # Get airports near parks
        airports_query = """
        SELECT DISTINCT a.airport_id, a.airport_code, a.airport_name, a.city, a.state
        FROM Airports a
        JOIN Park_Airports pa ON a.airport_id = pa.airport_id
        ORDER BY a.airport_name
        """
        df_airports = pd.read_sql_query(airports_query, conn)
        
        col1, col2 = st.columns(2)
        
        with col1:
            origin_options = {f"{row['airport_code']} - {row['airport_name']}": row['airport_id'] 
                            for _, row in df_airports.iterrows()}
            origin_airport = st.selectbox("From", options=list(origin_options.keys()), key="origin")
        
        with col2:
            dest_airport = st.selectbox("To", options=list(origin_options.keys()), key="dest")
        
        flight_date = st.date_input("Departure Date", min_value=date.today())
        
        if st.button("Search Flights"):
            if origin_airport and dest_airport:
                origin_id = origin_options[origin_airport]
                dest_id = origin_options[dest_airport]
                
                flights_query = """
                SELECT f.flight_id, a.airline_name, f.flight_number, 
                       f.departure_time, f.arrival_time, f.duration_minutes,
                       f.price, f.punctuality_score, f.number_of_stops
                FROM Flights f
                JOIN Airlines a ON f.airline_id = a.airline_id
                WHERE f.origin_airport_id = ? AND f.destination_airport_id = ?
                  AND f.flight_date = ?
                ORDER BY f.price
                """
                df_flights = pd.read_sql_query(
                    flights_query, 
                    conn, 
                    params=(origin_id, dest_id, flight_date)
                )
                
                if len(df_flights) > 0:
                    st.success(f"Found {len(df_flights)} flights")
                    
                    for _, flight in df_flights.iterrows():
                        with st.container():
                            col_a, col_b, col_c = st.columns([2, 2, 1])
                            
                            with col_a:
                                st.write(f"**{flight['airline_name']}** {flight['flight_number']}")
                                st.write(f"⏰ {flight['departure_time']} → {flight['arrival_time']}")
                                st.write(f"⏱️ {flight['duration_minutes']} min | 🔄 {flight['number_of_stops']} stops")
                            
                            with col_b:
                                st.write(f"**${flight['price']:.2f}**")
                                st.write(f"⭐ Punctuality: {flight['punctuality_score']:.1f}/100")
                            
                            with col_c:
                                if st.button("Book", key=f"book_flight_{flight['flight_id']}"):
                                    st.info("Flight booking would be added to your trip")
                            
                            st.divider()
                else:
                    st.warning("No flights found for this route and date")
    
    with tab2:
        st.subheader("Find Lodging Near Parks")
        
        # Get parks list
        parks_df = pd.read_sql_query(
            "SELECT park_id, park_name, state FROM Parks ORDER BY park_name", 
            conn
        )
        park_options = {f"{row['park_name']} ({row['state']})": row['park_id'] 
                       for _, row in parks_df.iterrows()}
        
        selected_park = st.selectbox("Select Park", options=list(park_options.keys()))
        
        if selected_park:
            park_id = park_options[selected_park]
            
            # Lodging filters
            col1, col2 = st.columns(2)
            with col1:
                lodging_type = st.multiselect(
                    "Type", 
                    options=["hotel", "lodge", "campground", "cabin", "resort"],
                    default=[]
                )
            with col2:
                price_range = st.multiselect(
                    "Price Range",
                    options=["$", "$$", "$$$", "$$$$"],
                    default=[]
                )
            
            # Build query
            lodging_query = """
            SELECT l.lodging_id, l.name, l.type, l.address, 
                   l.distance_from_park_miles, l.price_range,
                   l.contact_phone, l.website, l.wifi_available, 
                   l.pet_friendly, l.accessibility_features
            FROM Lodging l
            WHERE l.park_id = ?
            """
            params = [park_id]
            
            if lodging_type:
                placeholders = ','.join(['?' for _ in lodging_type])
                lodging_query += f" AND l.type IN ({placeholders})"
                params.extend(lodging_type)
            
            if price_range:
                placeholders = ','.join(['?' for _ in price_range])
                lodging_query += f" AND l.price_range IN ({placeholders})"
                params.extend(price_range)
            
            lodging_query += " ORDER BY l.distance_from_park_miles"
            
            df_lodging = pd.read_sql_query(lodging_query, conn, params=params)
            
            if len(df_lodging) > 0:
                st.success(f"Found {len(df_lodging)} lodging options")
                
                for _, lodging in df_lodging.iterrows():
                    with st.expander(f"🏨 {lodging['name']} - {lodging['type'].title()}"):
                        col_x, col_y = st.columns([2, 1])
                        
                        with col_x:
                            st.write(f"**Address:** {lodging['address']}")
                            st.write(f"**Distance from Park:** {lodging['distance_from_park_miles']:.1f} miles")
                            st.write(f"**Price Range:** {lodging['price_range']}")
                            
                            amenities = []
                            if lodging['wifi_available']:
                                amenities.append("📶 WiFi")
                            if lodging['pet_friendly']:
                                amenities.append("🐕 Pet-Friendly")
                            if lodging['accessibility_features']:
                                amenities.append("♿ Accessible")
                            
                            if amenities:
                                st.write(f"**Amenities:** {' | '.join(amenities)}")
                            
                            if lodging['contact_phone']:
                                st.write(f"**Phone:** {lodging['contact_phone']}")
                            if lodging['website']:
                                st.write(f"**Website:** {lodging['website']}")
                        
                        with col_y:
                            if st.button("Add to Trip", key=f"book_lodging_{lodging['lodging_id']}"):
                                st.info("Lodging would be added to your trip")
            else:
                st.info("No lodging options found with the selected filters")
    
    conn.close()

# ===================================
# AI ASSISTANT PAGE
# ===================================
elif page == "AI Assistant":
    st.header("🤖 AI Travel Assistant")

    st.write("Ask questions about national parks and get personalized recommendations!")

    # Initialize chat history
    if "messages" not in st.session_state:
        st.session_state.messages = []

    # Display chat history
    for message in st.session_state.messages:
        with st.chat_message(message["role"]):
            st.write(message["content"])

    # Chat input
    user_question = st.chat_input("Ask me about national parks...")

    if user_question:
        # Add user message to chat
        st.session_state.messages.append({"role": "user", "content": user_question})

        with st.chat_message("user"):
            st.write(user_question)

        # Get context from database (RAG)
        conn = sqlite3.connect(db_path)

        # Retrieve relevant park data
        context_query = """
        SELECT p.park_name, p.state, p.description, p.difficulty_level, 
               p.family_friendly, p.entrance_fee,
               GROUP_CONCAT(DISTINCT a.activity_name) as activities
        FROM Parks p
        LEFT JOIN Park_Activities pa ON p.park_id = pa.park_id
        LEFT JOIN Activities a ON pa.activity_id = a.activity_id
        GROUP BY p.park_id
        """
        parks_context = pd.read_sql_query(context_query, conn)
        conn.close()

        # Create context string
        context = "National Parks Database:\n"
        for _, park in parks_context.iterrows():
            context += (
                f"\n{park['park_name']} ({park['state']}): {park['description']}\n"
            )
            context += f"Difficulty: {park['difficulty_level']}, Family-friendly: {park['family_friendly']}\n"
            context += f"Activities: {park['activities']}\n"

        # Generate AI response (using OpenAI API)
        api_key = os.getenv("OPENAI_API_KEY")
        
        with st.chat_message("assistant"):
            message_placeholder = st.empty()
            
            if not api_key:
                assistant_response = f"""⚠️ OpenAI API key not found. Please set OPENAI_API_KEY in your .env file.

I'm running in demo mode. Based on the parks in our database:

For family-friendly parks, I recommend:
- Great Smoky Mountains (Tennessee) - Easy difficulty, free entry
- Yellowstone (Wyoming) - Moderate difficulty, great for wildlife viewing
- Acadia (Maine) - Beautiful coastal scenery

For challenging adventures:
- Yosemite (California) - Rock climbing, challenging hikes
- Zion (Utah) - Angels Landing, The Narrows
- Glacier (Montana) - Alpine hiking

Your question: {user_question}
"""
                message_placeholder.write(assistant_response)
            else:
                try:
                    client = OpenAI(api_key=api_key)
                    
                    stream = client.chat.completions.create(
                        model="gpt-5.1-2025-11-13",
                        messages=[
                            {
                                "role": "system",
                                "content": f"""You are an enthusiastic and knowledgeable national park travel advisor who loves helping people discover amazing outdoor experiences. Your goal is to provide personalized, practical recommendations that match each visitor's interests and abilities.

When answering questions:
- Be warm, encouraging, and conversational
- Share specific details from the database to make recommendations concrete and actionable
- Consider factors like difficulty level, family-friendliness, activities, and entrance fees
- Offer insider tips and highlight unique features of each park
- Ask clarifying questions when helpful to give better recommendations
- Be honest about challenges while staying positive and solution-focused

Database Context:
{context}

Make your responses feel like advice from a friend who's an expert park ranger, not a robotic database query.""",
                            },
                            {"role": "user", "content": user_question},
                        ],
                        stream=True,
                    )

                    assistant_response = ""
                    for chunk in stream:
                        if chunk.choices[0].delta.content is not None:
                            assistant_response += chunk.choices[0].delta.content
                            message_placeholder.write(assistant_response + "▌")
                    
                    message_placeholder.write(assistant_response)

                except Exception as e:
                    assistant_response = f"""❌ Error calling OpenAI API: {str(e)}

Running in fallback mode. Based on the parks in our database:

For family-friendly parks, I recommend:
- Great Smoky Mountains (Tennessee) - Easy difficulty, free entry
- Yellowstone (Wyoming) - Moderate difficulty, great for wildlife viewing
- Acadia (Maine) - Beautiful coastal scenery

For challenging adventures:
- Yosemite (California) - Rock climbing, challenging hikes
- Zion (Utah) - Angels Landing, The Narrows
- Glacier (Montana) - Alpine hiking

Your question: {user_question}
"""
                    message_placeholder.write(assistant_response)

        # Add assistant response to chat
        st.session_state.messages.append(
            {"role": "assistant", "content": assistant_response}
        )

        # Show database context
        with st.expander("View Database Context (RAG)"):
            conn = sqlite3.connect(db_path)
            st.write("Parks data being used for AI responses:")
            st.code(context_query, language="sql")
            parks_df = pd.read_sql_query(context_query, conn)
            st.dataframe(parks_df, use_container_width=True)
            conn.close()
