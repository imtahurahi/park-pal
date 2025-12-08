"""
ParkPal - National Park Trip Planning Application
A comprehensive Streamlit app for exploring parks, booking lodging, and sharing reviews.
"""

import streamlit as st
import mysql.connector
from mysql.connector import Error
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from datetime import datetime, date, timedelta
import os
from dotenv import load_dotenv
import openai
import re
from typing import Optional, Dict, List, Any

# Load environment variables
load_dotenv()

# OpenAI API configuration
openai.api_key = os.getenv("OPENAI_API_KEY")

# Page configuration
st.set_page_config(
    page_title="ParkPal - National Park Planning",
    page_icon="🏞️",
    layout="wide",
    initial_sidebar_state="expanded",
)

# Custom CSS for earthy color scheme
st.markdown(
    """
    <style>
    .stButton>button {
        background-color: #4A7C59;
        color: white;
        border-radius: 5px;
        border: none;
        padding: 0.5rem 1rem;
    }
    .stButton>button:hover {
        background-color: #2D5016;
    }
    h1 {
        color: #2D5016;
    }
    h2 {
        color: #4A7C59;
    }
    h3 {
        color: #8B4513;
    }
    .sidebar .sidebar-content {
        background-color: #F5DEB3;
    }
    div[data-testid="stMetricValue"] {
        color: #2D5016;
    }
    .success-message {
        background-color: #4A7C59;
        color: white;
        padding: 1rem;
        border-radius: 5px;
        margin: 1rem 0;
    }
    .error-message {
        background-color: #FF6347;
        color: white;
        padding: 1rem;
        border-radius: 5px;
        margin: 1rem 0;
    }
    </style>
""",
    unsafe_allow_html=True,
)

# ==================== DATABASE FUNCTIONS ====================


def get_db_connection():
    """Create and return database connection using mysql-connector-python"""
    try:
        connection = mysql.connector.connect(
            host=os.getenv("DB_HOST"),
            port=int(os.getenv("DB_PORT", 3306)),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD"),
            database=os.getenv("DB_NAME"),
            ssl_disabled=(os.getenv("DB_SSL_MODE") == "DISABLED"),
        )
        return connection
    except Error as e:
        st.error(f"❌ Database connection error: {e}")
        return None


def execute_query(
    query: str, params: tuple = None, fetch: str = "all"
) -> Optional[List[Dict]]:
    """Execute SELECT query and return results as list of dictionaries"""
    connection = get_db_connection()
    if not connection:
        return None

    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute(query, params or ())

        if fetch == "all":
            result = cursor.fetchall()
        elif fetch == "one":
            result = cursor.fetchone()
        else:
            result = cursor.fetchmany(fetch)

        cursor.close()
        connection.close()
        return result
    except Error as e:
        st.error(f"❌ Query execution error: {e}")
        if connection:
            connection.close()
        return None


def execute_insert(query: str, params: tuple) -> Optional[int]:
    """Execute INSERT query and return last inserted ID"""
    connection = get_db_connection()
    if not connection:
        return None

    try:
        cursor = connection.cursor()
        cursor.execute(query, params)
        connection.commit()
        last_id = cursor.lastrowid
        cursor.close()
        connection.close()
        return last_id
    except Error as e:
        st.error(f"❌ Insert error: {e}")
        if connection:
            connection.rollback()
            connection.close()
        return None


def execute_update(query: str, params: tuple) -> bool:
    """Execute UPDATE query and return success status"""
    connection = get_db_connection()
    if not connection:
        return False

    try:
        cursor = connection.cursor()
        cursor.execute(query, params)
        connection.commit()
        cursor.close()
        connection.close()
        return True
    except Error as e:
        st.error(f"❌ Update error: {e}")
        if connection:
            connection.rollback()
            connection.close()
        return False


def execute_delete(query: str, params: tuple) -> bool:
    """Execute DELETE query and return success status"""
    connection = get_db_connection()
    if not connection:
        return False

    try:
        cursor = connection.cursor()
        cursor.execute(query, params)
        connection.commit()
        cursor.close()
        connection.close()
        return True
    except Error as e:
        st.error(f"❌ Delete error: {e}")
        if connection:
            connection.rollback()
            connection.close()
        return False


# ==================== DATA RETRIEVAL FUNCTIONS ====================


@st.cache_data(ttl=300)
def get_all_parks() -> pd.DataFrame:
    """Fetch all national parks"""
    query = """
        SELECT Park_ID, Park_Name, State, Region, Description, 
               Wildlife_Information, Plant_Information, Area_Square_Miles,
               Annual_Visitors, Best_Time_To_Visit, Entry_Fee, Official_Website,
               Latitude, Longitude, Park_Activities_Events, Popular_Park_Trails,
               Difficulty_Rating, Kid_Friendliness_Rating, Pet_Friendliness_Rating
        FROM National_Park
        ORDER BY Park_Name
    """
    results = execute_query(query)
    return pd.DataFrame(results) if results else pd.DataFrame()


@st.cache_data(ttl=300)
def get_park_with_rating(park_id: int) -> Optional[Dict]:
    """Get park details with average rating"""
    query = """
        SELECT np.*, 
               COALESCE(AVG(pr.Rating), 0) as Avg_Rating,
               COUNT(pr.Review_ID) as Review_Count
        FROM National_Park np
        LEFT JOIN Park_Review pr ON np.Park_ID = pr.Park_ID
        WHERE np.Park_ID = %s
        GROUP BY np.Park_ID
    """
    result = execute_query(query, (park_id,), fetch="one")
    return result


@st.cache_data(ttl=300)
def get_lodging_by_park(park_id: int) -> pd.DataFrame:
    """Get all lodging options for a specific park"""
    query = """
        SELECT Lodging_ID, Lodging_Name, Lodging_Type, Address, City, State,
               Description, Amenities, Price_Per_Night, Contact_Phone, Contact_Email,
               Distance_From_Park_Miles, Star_Rating
        FROM Lodging
        WHERE Park_ID = %s
        ORDER BY Price_Per_Night
    """
    results = execute_query(query, (park_id,))
    return pd.DataFrame(results) if results else pd.DataFrame()


@st.cache_data(ttl=60)
def get_all_users() -> List[Dict]:
    """Get all users for dropdown selection"""
    query = "SELECT User_ID, First_Name, Last_Name, Email FROM User ORDER BY First_Name"
    return execute_query(query) or []


@st.cache_data(ttl=60)
def get_user_reservations(user_id: int, filter_status: str = "all") -> pd.DataFrame:
    """Get reservations for a specific user"""
    base_query = """
        SELECT lr.Reservation_ID, lr.Confirmation_Number, lr.Check_In_Date, lr.Check_Out_Date,
               lr.Number_Of_Guests, lr.Number_Of_Rooms, lr.Reservation_Status, lr.Total_Cost,
               lr.Guest_Name, lr.Guest_Phone, lr.Guest_Email, lr.Created_At,
               l.Lodging_Name, l.Lodging_Type, l.Price_Per_Night,
               np.Park_Name, np.State
        FROM Lodging_Reservation lr
        JOIN Lodging l ON lr.Lodging_ID = l.Lodging_ID
        JOIN National_Park np ON l.Park_ID = np.Park_ID
        WHERE lr.User_ID = %s
    """

    if filter_status == "upcoming":
        base_query += (
            " AND lr.Check_In_Date >= CURDATE() AND lr.Reservation_Status = 'confirmed'"
        )
    elif filter_status == "past":
        base_query += " AND lr.Check_Out_Date < CURDATE()"
    elif filter_status == "cancelled":
        base_query += " AND lr.Reservation_Status = 'cancelled'"

    base_query += " ORDER BY lr.Check_In_Date DESC"

    results = execute_query(base_query, (user_id,))
    return pd.DataFrame(results) if results else pd.DataFrame()


@st.cache_data(ttl=60)
def get_all_reviews() -> pd.DataFrame:
    """Get all park reviews with user and park information"""
    query = """
        SELECT pr.Review_ID, pr.Rating, pr.Review_Text, pr.Visit_Date, pr.Review_Date,
               pr.Photo_URLs, pr.User_ID, pr.Park_ID,
               u.First_Name, u.Last_Name, u.Email,
               np.Park_Name, np.State
        FROM Park_Review pr
        JOIN User u ON pr.User_ID = u.User_ID
        JOIN National_Park np ON pr.Park_ID = np.Park_ID
        ORDER BY pr.Review_Date DESC
    """
    results = execute_query(query)
    return pd.DataFrame(results) if results else pd.DataFrame()


@st.cache_data(ttl=60)
def get_user_reviews(user_id: int) -> pd.DataFrame:
    """Get reviews for a specific user"""
    query = """
        SELECT pr.Review_ID, pr.Rating, pr.Review_Text, pr.Visit_Date, pr.Review_Date,
               pr.Photo_URLs, pr.Park_ID,
               np.Park_Name, np.State
        FROM Park_Review pr
        JOIN National_Park np ON pr.Park_ID = np.Park_ID
        WHERE pr.User_ID = %s
        ORDER BY pr.Review_Date DESC
    """
    results = execute_query(query, (user_id,))
    return pd.DataFrame(results) if results else pd.DataFrame()


# ==================== HELPER FUNCTIONS ====================


def generate_confirmation_number() -> str:
    """Generate confirmation number in format RES-YYYYMMDD-NNNNNN"""
    date_part = datetime.now().strftime("%Y%m%d")
    # Get last reservation to determine next ID
    query = "SELECT MAX(Reservation_ID) as max_id FROM Lodging_Reservation"
    result = execute_query(query, fetch="one")
    next_id = (result["max_id"] or 0) + 1 if result else 1
    return f"RES-{date_part}-{next_id:06d}"


def calculate_total_cost(
    price_per_night: float, check_in: date, check_out: date, num_rooms: int
) -> float:
    """Calculate total cost for reservation"""
    num_nights = (check_out - check_in).days
    return price_per_night * num_nights * num_rooms


def display_star_rating(rating: float) -> str:
    """Convert numeric rating to star display"""
    full_stars = int(rating)
    half_star = 1 if rating - full_stars >= 0.5 else 0
    empty_stars = 5 - full_stars - half_star
    return "⭐" * full_stars + "✨" * half_star + "☆" * empty_stars


def validate_sql_safety(sql: str) -> bool:
    """Check if SQL query is safe (SELECT only)"""
    sql_upper = sql.upper().strip()
    dangerous_keywords = [
        "INSERT",
        "UPDATE",
        "DELETE",
        "DROP",
        "ALTER",
        "CREATE",
        "TRUNCATE",
        "EXEC",
        "EXECUTE",
    ]

    # Must start with SELECT
    if not sql_upper.startswith("SELECT"):
        return False

    # Check for dangerous keywords
    for keyword in dangerous_keywords:
        if keyword in sql_upper:
            return False

    return True


# ==================== PAGE FUNCTIONS ====================


def home_page():
    """Display home page"""
    st.title("🏞️ ParkPal")
    st.subheader(
        "Your comprehensive guide to planning unforgettable trips to America's 63 National Parks"
    )

    st.markdown(
        """
    ### Welcome to ParkPal! 🌲
    
    Discover the natural wonders of the United States National Park system. Whether you're planning your first visit 
    or you're a seasoned park explorer, ParkPal makes it easy to:
    
    - 🔍 **Browse Parks**: Explore all 63 National Parks with detailed information and visitor analytics
    - 🏕️ **Book Lodging**: Reserve hotels, lodges, campgrounds, and cabins near your favorite parks
    - ⭐ **Read & Write Reviews**: Share your experiences and learn from fellow park visitors
    - 🤖 **Ask ParkBot**: Get instant answers about parks using natural language queries
    
    ### Quick Stats
    """
    )

    # Display quick statistics
    col1, col2, col3, col4 = st.columns(4)

    parks_df = get_all_parks()
    if not parks_df.empty:
        with col1:
            st.metric("🏞️ National Parks", len(parks_df))
        with col2:
            total_visitors = parks_df["Annual_Visitors"].sum()
            st.metric("👥 Annual Visitors", f"{total_visitors/1000000:.1f}M")

    query_lodging = "SELECT COUNT(*) as count FROM Lodging"
    lodging_count = execute_query(query_lodging, fetch="one")
    if lodging_count:
        with col3:
            st.metric("🏨 Lodging Options", lodging_count["count"])

    query_reviews = "SELECT COUNT(*) as count FROM Park_Review"
    review_count = execute_query(query_reviews, fetch="one")
    if review_count:
        with col4:
            st.metric("💬 Reviews", review_count["count"])

    st.markdown("---")
    st.markdown(
        """
    ### Getting Started
    
    Use the sidebar to navigate between pages:
    - Start by **browsing parks** to find your destination
    - **Make a reservation** to book your lodging
    - Check **my reservations** to manage your bookings
    - Share your experience in the **reviews** section
    - Ask **ParkBot** any questions about the parks
    
    Happy exploring! 🎒🌄
    """
    )


def browse_parks_page():
    """Display parks browsing and analytics page"""
    st.title("🏞️ Browse National Parks")

    tab1, tab2 = st.tabs(["📋 Park Directory", "📊 Analytics"])

    with tab1:
        parks_df = get_all_parks()

        if parks_df.empty:
            st.warning("No parks found in database.")
            return

        # Filters
        st.subheader("Filters")
        col1, col2, col3 = st.columns(3)

        with col1:
            states = ["All"] + sorted(parks_df["State"].unique().tolist())
            selected_state = st.selectbox("State", states)

        with col2:
            regions = ["All"] + sorted(parks_df["Region"].dropna().unique().tolist())
            selected_region = st.selectbox("Region", regions)

        with col3:
            seasons = ["All"] + sorted(
                parks_df["Best_Time_To_Visit"].dropna().unique().tolist()
            )
            selected_season = st.selectbox("Best Time to Visit", seasons)

        # Apply filters
        filtered_df = parks_df.copy()
        if selected_state != "All":
            filtered_df = filtered_df[
                filtered_df["State"].str.contains(selected_state, na=False)
            ]
        if selected_region != "All":
            filtered_df = filtered_df[filtered_df["Region"] == selected_region]
        if selected_season != "All":
            filtered_df = filtered_df[
                filtered_df["Best_Time_To_Visit"] == selected_season
            ]

        st.markdown(f"### Showing {len(filtered_df)} parks")

        # Display parks
        for idx, park in filtered_df.iterrows():
            with st.expander(f"🏔️ {park['Park_Name']} - {park['State']}"):
                col1, col2 = st.columns([2, 1])

                with col1:
                    # Get average rating
                    park_detail = get_park_with_rating(park["Park_ID"])
                    if park_detail:
                        avg_rating = park_detail["Avg_Rating"]
                        review_count = park_detail["Review_Count"]
                        st.markdown(
                            f"**Rating:** {display_star_rating(avg_rating)} ({avg_rating:.1f}/5.0 from {review_count} reviews)"
                        )

                    st.markdown(f"**Region:** {park['Region']}")
                    st.markdown(f"**Description:** {park['Description']}")
                    st.markdown(f"**Best Time to Visit:** {park['Best_Time_To_Visit']}")
                    st.markdown(
                        f"**Wildlife:** {park['Wildlife_Information'][:200]}..."
                    )
                    st.markdown(f"**Popular Trails:** {park['Popular_Park_Trails']}")

                with col2:
                    st.metric("Annual Visitors", f"{park['Annual_Visitors']:,}")
                    st.metric("Area (sq mi)", f"{park['Area_Square_Miles']:,.2f}")
                    st.metric("Entry Fee", f"${park['Entry_Fee']:.2f}")
                    st.metric("Difficulty", park["Difficulty_Rating"])
                    st.metric("Kid Friendly", f"{park['Kid_Friendliness_Rating']}/5")

                    if park["Official_Website"]:
                        st.markdown(
                            f"[🔗 Official Website]({park['Official_Website']})"
                        )

    with tab2:
        st.subheader("📊 Park Visitor Analytics")

        parks_df = get_all_parks()
        if parks_df.empty:
            st.warning("No data available for analytics.")
            return

        # Region filter for analytics
        regions_for_filter = ["All Regions"] + sorted(
            parks_df["Region"].dropna().unique().tolist()
        )
        selected_region_analytics = st.selectbox(
            "Filter by Region", regions_for_filter, key="analytics_region"
        )

        # Apply region filter
        if selected_region_analytics != "All Regions":
            parks_for_viz = parks_df[
                parks_df["Region"] == selected_region_analytics
            ].copy()
        else:
            parks_for_viz = parks_df.copy()

        # Top 20 most visited parks
        top_parks = parks_for_viz.nlargest(20, "Annual_Visitors")

        # Create visualization
        fig = px.bar(
            top_parks,
            x="Park_Name",
            y="Annual_Visitors",
            color="Region",
            title=f"Top 20 Most Visited National Parks ({selected_region_analytics})",
            labels={"Annual_Visitors": "Annual Visitors", "Park_Name": "Park"},
            hover_data=["State", "Best_Time_To_Visit"],
            color_discrete_sequence=px.colors.qualitative.Set2,
        )

        fig.update_layout(
            xaxis_tickangle=-45,
            height=600,
            showlegend=True,
            plot_bgcolor="#FAF8F3",
            paper_bgcolor="#FAF8F3",
        )

        st.plotly_chart(fig, use_container_width=True)

        # Seasonal distribution
        st.subheader("Best Time to Visit Distribution")
        season_counts = parks_for_viz["Best_Time_To_Visit"].value_counts()

        fig2 = px.pie(
            values=season_counts.values,
            names=season_counts.index,
            title="Parks by Best Time to Visit",
            color_discrete_sequence=px.colors.qualitative.G10,
        )
        fig2.update_layout(plot_bgcolor="#FAF8F3", paper_bgcolor="#FAF8F3")
        st.plotly_chart(fig2, use_container_width=True)


def make_reservation_page():
    """Display reservation creation page"""
    st.title("🏕️ Make a Reservation")

    # Step 1: Select Park
    st.subheader("Step 1: Select a National Park")
    parks_df = get_all_parks()

    if parks_df.empty:
        st.error("No parks available.")
        return

    park_options = {
        f"{row['Park_Name']} ({row['State']})": row["Park_ID"]
        for _, row in parks_df.iterrows()
    }
    selected_park_name = st.selectbox("Choose a park", list(park_options.keys()))
    selected_park_id = park_options[selected_park_name]

    # Step 2: View and Select Lodging
    st.subheader("Step 2: Select Lodging")
    lodging_df = get_lodging_by_park(selected_park_id)

    if lodging_df.empty:
        st.warning("No lodging options available for this park.")
        return

    # Lodging filters
    col1, col2 = st.columns(2)
    with col1:
        lodging_types = ["All Types"] + sorted(
            lodging_df["Lodging_Type"].unique().tolist()
        )
        selected_type = st.selectbox("Lodging Type", lodging_types)

    with col2:
        max_price = float(lodging_df["Price_Per_Night"].max())
        price_range = st.slider(
            "Max Price Per Night", 0, int(max_price), int(max_price)
        )

    # Apply filters
    filtered_lodging = lodging_df.copy()
    if selected_type != "All Types":
        filtered_lodging = filtered_lodging[
            filtered_lodging["Lodging_Type"] == selected_type
        ]
    filtered_lodging = filtered_lodging[
        filtered_lodging["Price_Per_Night"] <= price_range
    ]

    # Display lodging options
    if filtered_lodging.empty:
        st.warning("No lodging matches your filters.")
        return

    lodging_display = filtered_lodging.apply(
        lambda x: f"{x['Lodging_Name']} - {x['Lodging_Type']} - ${x['Price_Per_Night']:.2f}/night - {display_star_rating(x['Star_Rating'] or 0)}",
        axis=1,
    )

    selected_lodging_idx = st.selectbox(
        "Choose lodging",
        range(len(filtered_lodging)),
        format_func=lambda x: lodging_display.iloc[x],
    )
    selected_lodging = filtered_lodging.iloc[selected_lodging_idx]

    # Show lodging details
    with st.expander("📋 Lodging Details"):
        st.write(f"**Name:** {selected_lodging['Lodging_Name']}")
        st.write(f"**Type:** {selected_lodging['Lodging_Type']}")
        st.write(
            f"**Address:** {selected_lodging['Address']}, {selected_lodging['City']}, {selected_lodging['State']}"
        )
        st.write(f"**Description:** {selected_lodging['Description']}")
        st.write(f"**Amenities:** {selected_lodging['Amenities']}")
        st.write(
            f"**Distance from Park:** {selected_lodging['Distance_From_Park_Miles']} miles"
        )
        st.write(
            f"**Contact:** {selected_lodging['Contact_Phone']} | {selected_lodging['Contact_Email']}"
        )

    # Step 3: Reservation Form
    st.subheader("Step 3: Complete Your Reservation")

    with st.form("reservation_form"):
        col1, col2 = st.columns(2)

        with col1:
            # User selection
            users = get_all_users()
            user_options = {
                f"{u['First_Name']} {u['Last_Name']} ({u['Email']})": u["User_ID"]
                for u in users
            }
            selected_user_name = st.selectbox(
                "Select User",
                list(user_options.keys()),
                index=0 if user_options else None,
            )
            selected_user_id = (
                user_options.get(selected_user_name) if selected_user_name else None
            )

            check_in = st.date_input("Check-in Date", min_value=date.today())
            check_out = st.date_input(
                "Check-out Date", min_value=date.today() + timedelta(days=1)
            )

            num_guests = st.number_input(
                "Number of Guests", min_value=1, max_value=20, value=2
            )
            num_rooms = st.number_input(
                "Number of Rooms", min_value=1, max_value=10, value=1
            )

        with col2:
            guest_name = st.text_input("Guest Name (Primary)")
            guest_phone = st.text_input("Guest Phone", placeholder="123-456-7890")
            guest_email = st.text_input("Guest Email", placeholder="guest@example.com")

            # Calculate and display cost
            if check_out > check_in:
                total_cost = calculate_total_cost(
                    selected_lodging["Price_Per_Night"], check_in, check_out, num_rooms
                )
                num_nights = (check_out - check_in).days
                st.metric(
                    "Total Cost",
                    f"${total_cost:.2f}",
                    help=f"{num_nights} nights × {num_rooms} room(s) × ${selected_lodging['Price_Per_Night']:.2f}/night",
                )

        submitted = st.form_submit_button("🎯 Confirm Reservation")

    if submitted:
        # Validation
        errors = []
        if check_out <= check_in:
            errors.append("Check-out date must be after check-in date")
        if check_in < date.today():
            errors.append("Check-in date cannot be in the past")
        if not guest_name:
            errors.append("Guest name is required")
        if not guest_phone:
            errors.append("Guest phone is required")
        if not guest_email or "@" not in guest_email:
            errors.append("Valid guest email is required")

        if errors:
            for error in errors:
                st.error(f"❌ {error}")
        else:
            # Create reservation
            confirmation_number = generate_confirmation_number()

            insert_query = """
                INSERT INTO Lodging_Reservation 
                (User_ID, Lodging_ID, Check_In_Date, Check_Out_Date, Number_Of_Guests, 
                 Number_Of_Rooms, Guest_Name, Guest_Phone, Guest_Email, Confirmation_Number, 
                 Reservation_Status, Total_Cost)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """

            params = (
                int(selected_user_id) if selected_user_id else None,
                int(selected_lodging["Lodging_ID"]),
                check_in,
                check_out,
                int(num_guests),
                int(num_rooms),
                guest_name,
                guest_phone,
                guest_email,
                confirmation_number,
                "confirmed",
                float(total_cost),
            )

            reservation_id = execute_insert(insert_query, params)

            if reservation_id:
                st.success(f"✅ Reservation created successfully!")
                st.balloons()
                st.info(f"**Confirmation Number:** {confirmation_number}")
                st.info(f"**Total Cost:** ${total_cost:.2f}")
                get_user_reservations.clear()  # Clear cache


def my_reservations_page():
    """Display and manage user reservations"""
    st.title("📅 My Reservations")

    # User selection
    users = get_all_users()
    if not users:
        st.error("No users found.")
        return

    user_options = {
        f"{u['First_Name']} {u['Last_Name']} ({u['Email']})": u["User_ID"]
        for u in users
    }
    selected_user_name = st.selectbox("Select User", list(user_options.keys()))
    selected_user_id = user_options[selected_user_name]

    # Filter options
    filter_option = st.radio(
        "Filter Reservations", ["All", "Upcoming", "Past", "Cancelled"], horizontal=True
    )

    filter_map = {
        "All": "all",
        "Upcoming": "upcoming",
        "Past": "past",
        "Cancelled": "cancelled",
    }

    reservations_df = get_user_reservations(selected_user_id, filter_map[filter_option])

    if reservations_df.empty:
        st.info("No reservations found.")
        return

    st.markdown(f"### Found {len(reservations_df)} reservation(s)")

    # Display reservations
    for idx, reservation in reservations_df.iterrows():
        status_emoji = {"confirmed": "✅", "pending": "⏳", "cancelled": "❌"}.get(
            reservation["Reservation_Status"], "❓"
        )

        with st.expander(
            f"{status_emoji} {reservation['Park_Name']} - {reservation['Lodging_Name']} (#{reservation['Confirmation_Number']})"
        ):
            col1, col2, col3 = st.columns(3)

            with col1:
                st.markdown("**Reservation Details**")
                st.write(f"Confirmation: {reservation['Confirmation_Number']}")
                st.write(f"Status: {reservation['Reservation_Status'].title()}")
                st.write(f"Created: {reservation['Created_At'].strftime('%Y-%m-%d')}")
                st.write(f"Total Cost: ${reservation['Total_Cost']:.2f}")

            with col2:
                st.markdown("**Stay Information**")
                st.write(f"Check-in: {reservation['Check_In_Date']}")
                st.write(f"Check-out: {reservation['Check_Out_Date']}")
                st.write(f"Guests: {reservation['Number_Of_Guests']}")
                st.write(f"Rooms: {reservation['Number_Of_Rooms']}")

            with col3:
                st.markdown("**Guest Information**")
                st.write(f"Name: {reservation['Guest_Name']}")
                st.write(f"Phone: {reservation['Guest_Phone']}")
                st.write(f"Email: {reservation['Guest_Email']}")

            st.markdown("---")

            # Action buttons
            if reservation["Reservation_Status"] == "confirmed":
                col_edit, col_cancel = st.columns(2)

                with col_edit:
                    if st.button(
                        f"✏️ Edit", key=f"edit_{reservation['Reservation_ID']}"
                    ):
                        st.session_state[f'editing_{reservation["Reservation_ID"]}'] = (
                            True
                        )

                with col_cancel:
                    if st.button(
                        f"❌ Cancel", key=f"cancel_{reservation['Reservation_ID']}"
                    ):
                        st.session_state[
                            f'confirming_cancel_{reservation["Reservation_ID"]}'
                        ] = True

                # Edit form
                if st.session_state.get(
                    f'editing_{reservation["Reservation_ID"]}', False
                ):
                    with st.form(f"edit_form_{reservation['Reservation_ID']}"):
                        st.subheader("Edit Reservation")

                        new_check_in = st.date_input(
                            "New Check-in", value=reservation["Check_In_Date"]
                        )
                        new_check_out = st.date_input(
                            "New Check-out", value=reservation["Check_Out_Date"]
                        )
                        new_guests = st.number_input(
                            "Guests", value=int(reservation["Number_Of_Guests"])
                        )
                        new_rooms = st.number_input(
                            "Rooms", value=int(reservation["Number_Of_Rooms"])
                        )

                        col_save, col_cancel_edit = st.columns(2)
                        with col_save:
                            save_edit = st.form_submit_button("💾 Save Changes")
                        with col_cancel_edit:
                            cancel_edit = st.form_submit_button("❌ Cancel Edit")

                        if save_edit:
                            # Validation
                            if new_check_out <= new_check_in:
                                st.error("Check-out must be after check-in")
                            elif new_check_in < date.today():
                                st.error("Check-in cannot be in the past")
                            else:
                                # Recalculate cost
                                new_total = calculate_total_cost(
                                    reservation["Price_Per_Night"],
                                    new_check_in,
                                    new_check_out,
                                    new_rooms,
                                )

                                update_query = """
                                    UPDATE Lodging_Reservation
                                    SET Check_In_Date = %s, Check_Out_Date = %s,
                                        Number_Of_Guests = %s, Number_Of_Rooms = %s,
                                        Total_Cost = %s
                                    WHERE Reservation_ID = %s
                                """

                                if execute_update(
                                    update_query,
                                    (
                                        new_check_in,
                                        new_check_out,
                                        new_guests,
                                        new_rooms,
                                        new_total,
                                        reservation["Reservation_ID"],
                                    ),
                                ):
                                    st.success("✅ Reservation updated successfully!")
                                    st.session_state[
                                        f'editing_{reservation["Reservation_ID"]}'
                                    ] = False
                                    get_user_reservations.clear()
                                    st.rerun()

                        if cancel_edit:
                            st.session_state[
                                f'editing_{reservation["Reservation_ID"]}'
                            ] = False
                            st.rerun()

                # Cancel confirmation
                if st.session_state.get(
                    f'confirming_cancel_{reservation["Reservation_ID"]}', False
                ):
                    st.warning("⚠️ Are you sure you want to delete this reservation?")
                    col_yes, col_no = st.columns(2)

                    with col_yes:
                        if st.button(
                            "Yes, Delete",
                            key=f"yes_cancel_{reservation['Reservation_ID']}",
                        ):
                            delete_query = """
                                DELETE FROM Lodging_Reservation
                                WHERE Reservation_ID = %s
                            """

                            if execute_delete(
                                delete_query, (reservation["Reservation_ID"],)
                            ):
                                st.success("✅ Reservation deleted")
                                st.session_state[
                                    f'confirming_cancel_{reservation["Reservation_ID"]}'
                                ] = False
                                get_user_reservations.clear()
                                st.rerun()

                    with col_no:
                        if st.button(
                            "No, Keep It",
                            key=f"no_cancel_{reservation['Reservation_ID']}",
                        ):
                            st.session_state[
                                f'confirming_cancel_{reservation["Reservation_ID"]}'
                            ] = False
                            st.rerun()


def reviews_page():
    """Display and manage park reviews"""
    st.title("⭐ Park Reviews")

    tab1, tab2 = st.tabs(["📖 Browse Reviews", "✍️ My Reviews"])

    with tab1:
        st.subheader("All Park Reviews")

        reviews_df = get_all_reviews()

        if reviews_df.empty:
            st.info("No reviews yet. Be the first to share your experience!")
            return

        # Filters
        col1, col2, col3 = st.columns(3)

        with col1:
            parks = ["All Parks"] + sorted(reviews_df["Park_Name"].unique().tolist())
            selected_park_filter = st.selectbox("Filter by Park", parks)

        with col2:
            ratings = [
                "All Ratings",
                "5 Stars",
                "4 Stars",
                "3 Stars",
                "2 Stars",
                "1 Star",
            ]
            selected_rating = st.selectbox("Filter by Rating", ratings)

        with col3:
            sort_options = ["Most Recent", "Highest Rated", "Lowest Rated"]
            sort_by = st.selectbox("Sort by", sort_options)

        # Apply filters
        filtered_reviews = reviews_df.copy()

        if selected_park_filter != "All Parks":
            filtered_reviews = filtered_reviews[
                filtered_reviews["Park_Name"] == selected_park_filter
            ]

        if selected_rating != "All Ratings":
            rating_value = int(selected_rating.split()[0])
            filtered_reviews = filtered_reviews[
                filtered_reviews["Rating"] == rating_value
            ]

        # Apply sorting
        if sort_by == "Most Recent":
            filtered_reviews = filtered_reviews.sort_values(
                "Review_Date", ascending=False
            )
        elif sort_by == "Highest Rated":
            filtered_reviews = filtered_reviews.sort_values("Rating", ascending=False)
        elif sort_by == "Lowest Rated":
            filtered_reviews = filtered_reviews.sort_values("Rating", ascending=True)

        st.markdown(f"### Showing {len(filtered_reviews)} review(s)")

        # Display reviews
        for idx, review in filtered_reviews.iterrows():
            with st.container():
                st.markdown(f"#### {review['Park_Name']}, {review['State']}")
                st.markdown(
                    f"{display_star_rating(review['Rating'])} by **{review['First_Name']} {review['Last_Name']}**"
                )
                st.markdown(
                    f"Visited: {review['Visit_Date']} | Reviewed: {review['Review_Date'].strftime('%Y-%m-%d')}"
                )
                st.markdown(f"_{review['Review_Text']}_")

                if review["Photo_URLs"]:
                    st.caption(f"📸 Photos: {review['Photo_URLs']}")

                st.markdown("---")

    with tab2:
        st.subheader("My Reviews")

        # User selection
        users = get_all_users()
        if not users:
            st.error("No users found.")
            return

        user_options = {
            f"{u['First_Name']} {u['Last_Name']} ({u['Email']})": u["User_ID"]
            for u in users
        }
        selected_user_name = st.selectbox(
            "Select User", list(user_options.keys()), key="review_user"
        )
        selected_user_id = user_options[selected_user_name]

        # Create new review
        st.markdown("### ✍️ Write a New Review")

        with st.form("create_review_form"):
            parks_df = get_all_parks()
            park_options = {
                row["Park_Name"]: row["Park_ID"] for _, row in parks_df.iterrows()
            }
            selected_park_name = st.selectbox("Select Park", list(park_options.keys()))
            selected_park_id = park_options[selected_park_name]

            rating = st.select_slider(
                "Rating",
                options=[1, 2, 3, 4, 5],
                value=5,
                format_func=lambda x: display_star_rating(x),
            )

            review_text = st.text_area(
                "Your Review",
                placeholder="Share your experience (min 50 characters)...",
                height=150,
            )

            visit_date = st.date_input("Visit Date", max_value=date.today())

            photo_urls = st.text_input("Photo URLs (optional, comma-separated)")

            submit_review = st.form_submit_button("📝 Submit Review")

            if submit_review:
                if len(review_text) < 50:
                    st.error("❌ Review must be at least 50 characters long")
                else:
                    insert_query = """
                        INSERT INTO Park_Review (User_ID, Park_ID, Rating, Review_Text, Visit_Date, Photo_URLs)
                        VALUES (%s, %s, %s, %s, %s, %s)
                    """

                    params = (
                        selected_user_id,
                        selected_park_id,
                        rating,
                        review_text,
                        visit_date,
                        photo_urls or None,
                    )

                    review_id = execute_insert(insert_query, params)

                    if review_id:
                        st.success("✅ Review submitted successfully!")
                        get_all_reviews.clear()
                        get_user_reviews.clear()

        # Display user's reviews
        st.markdown("### Your Reviews")
        user_reviews_df = get_user_reviews(selected_user_id)

        if user_reviews_df.empty:
            st.info("You haven't written any reviews yet.")
        else:
            for idx, review in user_reviews_df.iterrows():
                with st.expander(
                    f"{review['Park_Name']} - {display_star_rating(review['Rating'])} ({review['Review_Date'].strftime('%Y-%m-%d')})"
                ):
                    st.write(f"**Visit Date:** {review['Visit_Date']}")
                    st.write(f"**Review:** {review['Review_Text']}")

                    if review["Photo_URLs"]:
                        st.write(f"**Photos:** {review['Photo_URLs']}")

                    # Check if review can be edited (within 30 days)
                    days_since_review = (datetime.now() - review["Review_Date"]).days
                    can_edit = days_since_review <= 30

                    col1, col2 = st.columns(2)

                    with col1:
                        if can_edit:
                            if st.button(
                                f"✏️ Edit", key=f"edit_review_{review['Review_ID']}"
                            ):
                                st.session_state[
                                    f'editing_review_{review["Review_ID"]}'
                                ] = True
                        else:
                            st.caption("⚠️ Reviews can only be edited within 30 days")

                    with col2:
                        if st.button(
                            f"🗑️ Delete", key=f"delete_review_{review['Review_ID']}"
                        ):
                            st.session_state[
                                f'deleting_review_{review["Review_ID"]}'
                            ] = True

                    # Edit form
                    if st.session_state.get(
                        f'editing_review_{review["Review_ID"]}', False
                    ):
                        with st.form(f"edit_review_form_{review['Review_ID']}"):
                            new_rating = st.select_slider(
                                "New Rating",
                                options=[1, 2, 3, 4, 5],
                                value=int(review["Rating"]),
                                format_func=lambda x: display_star_rating(x),
                                key=f"edit_rating_{review['Review_ID']}",
                            )

                            new_text = st.text_area(
                                "Updated Review",
                                value=review["Review_Text"],
                                key=f"edit_text_{review['Review_ID']}",
                            )

                            new_photos = st.text_input(
                                "Photo URLs",
                                value=review["Photo_URLs"] or "",
                                key=f"edit_photos_{review['Review_ID']}",
                            )

                            col_save, col_cancel = st.columns(2)

                            with col_save:
                                save_edit = st.form_submit_button("💾 Save")
                            with col_cancel:
                                cancel_edit = st.form_submit_button("❌ Cancel")

                            if save_edit:
                                if len(new_text) < 50:
                                    st.error("Review must be at least 50 characters")
                                else:
                                    update_query = """
                                        UPDATE Park_Review
                                        SET Rating = %s, Review_Text = %s, Photo_URLs = %s
                                        WHERE Review_ID = %s
                                    """

                                    if execute_update(
                                        update_query,
                                        (
                                            new_rating,
                                            new_text,
                                            new_photos or None,
                                            review["Review_ID"],
                                        ),
                                    ):
                                        st.success("✅ Review updated!")
                                        st.session_state[
                                            f'editing_review_{review["Review_ID"]}'
                                        ] = False
                                        get_all_reviews.clear()
                                        get_user_reviews.clear()
                                        st.rerun()

                            if cancel_edit:
                                st.session_state[
                                    f'editing_review_{review["Review_ID"]}'
                                ] = False
                                st.rerun()

                    # Delete confirmation
                    if st.session_state.get(
                        f'deleting_review_{review["Review_ID"]}', False
                    ):
                        st.warning("⚠️ Delete this review permanently?")
                        col_yes, col_no = st.columns(2)

                        with col_yes:
                            if st.button(
                                "Yes, Delete",
                                key=f"confirm_delete_{review['Review_ID']}",
                            ):
                                delete_query = (
                                    "DELETE FROM Park_Review WHERE Review_ID = %s"
                                )

                                if execute_delete(delete_query, (review["Review_ID"],)):
                                    st.success("✅ Review deleted")
                                    st.session_state[
                                        f'deleting_review_{review["Review_ID"]}'
                                    ] = False
                                    get_all_reviews.clear()
                                    get_user_reviews.clear()
                                    st.rerun()

                        with col_no:
                            if st.button(
                                "No, Keep", key=f"cancel_delete_{review['Review_ID']}"
                            ):
                                st.session_state[
                                    f'deleting_review_{review["Review_ID"]}'
                                ] = False
                                st.rerun()


def parkbot_page():
    """ParkBot SQL Chat interface"""
    st.title("🤖 ParkBot - Ask Me Anything!")

    st.markdown(
        """
    Ask questions about national parks in plain English, and I'll generate SQL queries to find the answers.
    
    **Example questions:**
    """
    )

    # Example question buttons
    col1, col2 = st.columns(2)

    example_questions = [
        "What are the top 5 most visited national parks?",
        "Show me all lodging options under $150 per night",
        "Which parks have the highest average ratings?",
        "Find all campgrounds in Utah",
        "What are the best parks to visit in summer?",
        "Show me reviews for Yellowstone with ratings above 4",
    ]

    for i, question in enumerate(example_questions):
        col = col1 if i % 2 == 0 else col2
        with col:
            if st.button(f"📌 {question}", key=f"example_{i}"):
                st.session_state["user_question"] = question

    # User input
    user_question = st.text_input(
        "Your Question:",
        value=st.session_state.get("user_question", ""),
        placeholder="Ask about parks, lodging, or reviews...",
    )

    if st.button("🔍 Ask ParkBot"):
        if not user_question:
            st.warning("Please enter a question")
            return

        with st.spinner("Thinking..."):
            try:
                # Create system prompt with schema
                system_prompt = """
You are a helpful SQL query generator for the ParkPal database.

Database schema:
- National_Park: Park_ID, Park_Name, State, Region, Description, Annual_Visitors, Best_Time_To_Visit, Entry_Fee, Difficulty_Rating, Kid_Friendliness_Rating, Pet_Friendliness_Rating, and more
- Lodging: Lodging_ID, Park_ID, Lodging_Name, Lodging_Type, Price_Per_Night, Distance_From_Park_Miles, Star_Rating, Amenities, and more
- Park_Review: Review_ID, User_ID, Park_ID, Rating, Review_Text, Visit_Date, Review_Date
- Lodging_Reservation: Reservation_ID, User_ID, Lodging_ID, Check_In_Date, Check_Out_Date, Reservation_Status, Total_Cost
- User: User_ID, First_Name, Last_Name, Email

Generate ONLY SELECT queries. Never use INSERT, UPDATE, DELETE, DROP, or other modifying commands.
Return valid MySQL syntax. Join tables when needed for better results.
Limit results to 100 rows maximum.

Return only the SQL query without explanation or markdown formatting.
"""

                # Call OpenAI API
                response = openai.chat.completions.create(
                    model="gpt-4-turbo-preview",
                    messages=[
                        {"role": "system", "content": system_prompt},
                        {
                            "role": "user",
                            "content": f"Generate SQL query for: {user_question}",
                        },
                    ],
                    temperature=0.3,
                    max_tokens=500,
                )

                generated_sql = response.choices[0].message.content.strip()

                # Remove markdown code blocks if present
                generated_sql = re.sub(r"^```sql\s*", "", generated_sql)
                generated_sql = re.sub(r"^```\s*", "", generated_sql)
                generated_sql = re.sub(r"\s*```$", "", generated_sql)
                generated_sql = generated_sql.strip()

                # Display the question
                st.markdown("### Your Question:")
                st.info(user_question)

                # Display generated SQL
                st.markdown("### Generated SQL Query:")
                st.code(generated_sql, language="sql")

                # Validate SQL safety
                if not validate_sql_safety(generated_sql):
                    st.error(
                        "❌ Query rejected: Only SELECT statements are allowed for safety reasons."
                    )
                    return

                # Execute the query
                with st.spinner("Executing query..."):
                    results = execute_query(generated_sql)

                    if results is None:
                        st.error(
                            "Query execution failed. Please check the generated SQL."
                        )
                    elif len(results) == 0:
                        st.warning("No results found.")
                    else:
                        st.markdown("### Results:")
                        results_df = pd.DataFrame(results)
                        st.dataframe(results_df, use_container_width=True)
                        st.caption(f"Showing {len(results_df)} rows")

                        # Get explanation
                        explanation_response = openai.chat.completions.create(
                            model="gpt-4-turbo-preview",
                            messages=[
                                {
                                    "role": "system",
                                    "content": "Explain what this SQL query does in simple terms.",
                                },
                                {"role": "user", "content": generated_sql},
                            ],
                            temperature=0.3,
                            max_tokens=200,
                        )

                        explanation = explanation_response.choices[0].message.content

                        st.markdown("### Explanation:")
                        st.success(explanation)

            except Exception as e:
                st.error(f"❌ Error: {str(e)}")
                st.caption("Please try rephrasing your question or contact support.")


# ==================== MAIN APP ====================


def main():
    """Main application"""

    # Sidebar navigation
    st.sidebar.title("🏞️ ParkPal Navigation")
    st.sidebar.markdown("---")

    page = st.sidebar.radio(
        "Go to",
        [
            "🏠 Home",
            "🏞️ Browse Parks",
            "🏕️ Make Reservation",
            "📅 My Reservations",
            "⭐ Reviews",
            "🤖 ParkBot",
        ],
        label_visibility="collapsed",
    )

    st.sidebar.markdown("---")
    st.sidebar.markdown("### About ParkPal")
    st.sidebar.info(
        """
    ParkPal helps you discover and plan trips to America's 63 National Parks.
    
    - Browse park information
    - Book lodging
    - Share reviews
    - Get instant answers
    """
    )

    # Cache refresh button
    st.sidebar.markdown("---")
    if st.sidebar.button("🔄 Refresh Data"):
        st.cache_data.clear()
        st.success("✅ Cache cleared! Data refreshed.")
        st.rerun()

    # Route to pages
    if page == "🏠 Home":
        home_page()
    elif page == "🏞️ Browse Parks":
        browse_parks_page()
    elif page == "🏕️ Make Reservation":
        make_reservation_page()
    elif page == "📅 My Reservations":
        my_reservations_page()
    elif page == "⭐ Reviews":
        reviews_page()
    elif page == "🤖 ParkBot":
        parkbot_page()


if __name__ == "__main__":
    main()
