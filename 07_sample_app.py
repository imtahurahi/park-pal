"""
ParkPal - National Park Trip Planning Dashboard
A Streamlit application for discovering and planning trips to US National Parks
"""

import streamlit as st
import pandas as pd

try:
    import mysql.connector

    MYSQL_AVAILABLE = True
except ImportError:
    MYSQL_AVAILABLE = False
    st.warning("MySQL connector not available. Database features will be limited.")
from datetime import datetime, date, timedelta
import os
from openai import OpenAI
from dotenv import load_dotenv
from pathlib import Path

# Load environment variables from .env file
env_path = Path(__file__).parent / ".env"
load_dotenv(dotenv_path=env_path, override=True)

# Page configuration
st.set_page_config(
    page_title="ParkPal - National Park Trip Planner",
    page_icon="🏞️",
    layout="wide",
    initial_sidebar_state="expanded",
)

# Custom CSS for better styling
st.markdown(
    """
    <style>
    .main {
        padding: 0rem 1rem;
    }
    .stButton>button {
        width: 100%;
        background-color: #2E7D32;
        color: white;
    }
    .stButton>button:hover {
        background-color: #1B5E20;
    }
    .park-card {
        padding: 1rem;
        border-radius: 0.5rem;
        background-color: #f0f2f6;
        margin-bottom: 1rem;
    }
    h1 {
        color: #2E7D32;
    }
    h2 {
        color: #388E3C;
    }
    </style>
""",
    unsafe_allow_html=True,
)

# Database configuration
DB_CONFIG = {
    "host": os.getenv(
        "DB_HOST", "db-mysql-itom-do-user-28250611-0.j.db.ondigitalocean.com"
    ),
    "port": int(os.getenv("DB_PORT", 25060)),
    "user": os.getenv("DB_USER", "group12"),
    "password": os.getenv("DB_PASSWORD", ""),
    "database": os.getenv("DB_NAME", "group12"),
}

# OpenAI API Key
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "")


# Database connection function
@st.cache_resource
def get_db_connection():
    """Create and cache database connection"""
    if not MYSQL_AVAILABLE:
        st.error(
            "MySQL connector package not installed. Please run: pip install mysql-connector-python"
        )
        return None
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        return conn
    except Exception as e:
        st.error(f"Database connection failed: {e}")
        return None


# Data loading functions
@st.cache_data(ttl=600)
def load_parks():
    """Load all national parks"""
    conn = get_db_connection()
    if conn:
        query = """
            SELECT Park_ID, Park_Name, State, Region, Description, 
                   Annual_Visitors, Best_Time_To_Visit, Entry_Fee,
                   Wildlife_Information, Park_Activities_Events,
                   Difficulty_Rating, Kid_Friendliness_Rating, Pet_Friendliness_Rating
            FROM National_Park
            ORDER BY Park_Name
        """
        df = pd.read_sql(query, conn)
        return df
    return pd.DataFrame()


@st.cache_data(ttl=600)
def load_park_details(park_id):
    """Load detailed information for a specific park"""
    conn = get_db_connection()
    if conn:
        query = """
            SELECT * FROM National_Park WHERE Park_ID = %s
        """
        df = pd.read_sql(query, conn, params=(park_id,))
        return df.iloc[0] if not df.empty else None
    return None


@st.cache_data(ttl=600)
def load_flights(origin_airport_id=1, destination_airport_id=None):
    """Load available flights"""
    conn = get_db_connection()
    if conn:
        query = """
            SELECT f.*, 
                   dep.Airport_Code as Departure_Code, dep.Airport_Name as Departure_Name,
                   arr.Airport_Code as Arrival_Code, arr.Airport_Name as Arrival_Name
            FROM Flight f
            JOIN Airport dep ON f.Departure_Airport_ID = dep.Airport_ID
            JOIN Airport arr ON f.Arrival_Airport_ID = arr.Airport_ID
            WHERE f.Departure_Airport_ID = %s
        """
        params = [origin_airport_id]
        if destination_airport_id:
            query += " AND f.Arrival_Airport_ID = %s"
            params.append(destination_airport_id)
        query += " ORDER BY f.Departure_Time"
        df = pd.read_sql(query, conn, params=tuple(params))
        return df
    return pd.DataFrame()


@st.cache_data(ttl=600)
def load_lodging(park_id=None):
    """Load lodging options"""
    conn = get_db_connection()
    if conn:
        query = """
            SELECT l.*, np.Park_Name
            FROM Lodging l
            JOIN National_Park np ON l.Park_ID = np.Park_ID
        """
        if park_id:
            query += " WHERE l.Park_ID = %s"
            params = (park_id,)
        else:
            params = None
        query += " ORDER BY l.Star_Rating DESC, l.Price_Per_Night"
        df = pd.read_sql(query, conn, params=params)
        return df
    return pd.DataFrame()


@st.cache_data(ttl=600)
def load_park_airports(park_id):
    """Load nearby airports for a park"""
    conn = get_db_connection()
    if conn:
        query = """
            SELECT a.*, pa.Distance_Miles
            FROM Park_Airport pa
            JOIN Airport a ON pa.Airport_ID = a.Airport_ID
            WHERE pa.Park_ID = %s
            ORDER BY pa.Distance_Miles
        """
        df = pd.read_sql(query, conn, params=(park_id,))
        return df
    return pd.DataFrame()


# ParkBot Chat Interface
def parkbot_chat():
    """OpenAI-powered chatbot for park recommendations"""
    st.header("🤖 ParkBot - Your National Park Assistant")
    st.write(
        "Ask me anything about national parks, planning your trip, or get personalized recommendations!"
    )

    # Initialize chat history
    if "messages" not in st.session_state:
        st.session_state.messages = []

    # Display chat messages
    for message in st.session_state.messages:
        with st.chat_message(message["role"]):
            st.markdown(message["content"])

    # Chat input
    if prompt := st.chat_input("Ask ParkBot..."):
        # Add user message to chat history
        st.session_state.messages.append({"role": "user", "content": prompt})
        with st.chat_message("user"):
            st.markdown(prompt)

        # Get park data for context
        parks_df = load_parks()
        park_context = f"""
        Available National Parks ({len(parks_df)} total):
        {parks_df[['Park_Name', 'State', 'Region', 'Best_Time_To_Visit']].to_string(index=False)}
        """

        # Generate assistant response
        with st.chat_message("assistant"):
            try:
                client = OpenAI(api_key=OPENAI_API_KEY)

                # Build conversation context
                messages = [
                    {
                        "role": "system",
                        "content": f"""You are ParkBot, a helpful assistant for ParkPal - a national park trip planning platform. 
                        You help users discover and plan trips to US National Parks. You have access to information about all 63 US National Parks.
                        Provide friendly, informative responses about parks, activities, best times to visit, and trip planning advice.
                        
                        {park_context}
                        
                        When recommending parks, consider the user's interests, preferred activities, difficulty level, and time of year.
                        Be enthusiastic about nature and outdoor adventures!""",
                    }
                ]

                # Add conversation history
                for msg in st.session_state.messages[
                    -10:
                ]:  # Last 10 messages for context
                    messages.append({"role": msg["role"], "content": msg["content"]})

                # Stream the response
                stream = client.chat.completions.create(
                    model="gpt-4o",  # Latest GPT-4 model
                    messages=messages,
                    stream=True,
                    max_tokens=1000,
                    temperature=0.7,
                )

                response_placeholder = st.empty()
                full_response = ""

                for chunk in stream:
                    if chunk.choices[0].delta.content is not None:
                        full_response += chunk.choices[0].delta.content
                        response_placeholder.markdown(full_response + "▌")

                response_placeholder.markdown(full_response)

                # Add assistant response to chat history
                st.session_state.messages.append(
                    {"role": "assistant", "content": full_response}
                )

            except Exception as e:
                error_msg = f"Sorry, I encountered an error: {str(e)}"
                st.error(error_msg)
                st.session_state.messages.append(
                    {"role": "assistant", "content": error_msg}
                )

    # Clear chat button
    if st.button("Clear Chat History"):
        st.session_state.messages = []
        st.rerun()


# Park Discovery Page
def park_discovery():
    """Main park discovery and search interface"""
    st.header("🏞️ Discover National Parks")

    parks_df = load_parks()

    if parks_df.empty:
        st.warning("No park data available. Please check database connection.")
        return

    # Filters in sidebar
    st.sidebar.header("Filters")

    # Region filter
    regions = ["All"] + sorted(parks_df["Region"].unique().tolist())
    selected_region = st.sidebar.selectbox("Region", regions)

    # State filter
    states = ["All"] + sorted(parks_df["State"].unique().tolist())
    selected_state = st.sidebar.selectbox("State", states)

    # Difficulty filter
    difficulty_options = [
        "All",
        "Easy to Moderate",
        "Moderate",
        "Moderate to Strenuous",
        "Strenuous",
    ]
    selected_difficulty = st.sidebar.selectbox("Difficulty Level", difficulty_options)

    # Kid-friendly filter
    kid_friendly = st.sidebar.slider("Min Kid-Friendliness Rating", 1, 5, 1)

    # Apply filters
    filtered_df = parks_df.copy()
    if selected_region != "All":
        filtered_df = filtered_df[filtered_df["Region"] == selected_region]
    if selected_state != "All":
        filtered_df = filtered_df[filtered_df["State"] == selected_state]
    if selected_difficulty != "All":
        filtered_df = filtered_df[
            filtered_df["Difficulty_Rating"] == selected_difficulty
        ]
    filtered_df = filtered_df[filtered_df["Kid_Friendliness_Rating"] >= kid_friendly]

    # Search box
    search_term = st.text_input("🔍 Search parks by name", "")
    if search_term:
        filtered_df = filtered_df[
            filtered_df["Park_Name"].str.contains(search_term, case=False, na=False)
        ]

    # Display results
    st.write(f"**{len(filtered_df)} parks found**")

    # Sort options
    sort_by = st.selectbox("Sort by", ["Park Name", "Most Popular", "Kid-Friendly"])
    if sort_by == "Most Popular":
        filtered_df = filtered_df.sort_values("Annual_Visitors", ascending=False)
    elif sort_by == "Kid-Friendly":
        filtered_df = filtered_df.sort_values(
            "Kid_Friendliness_Rating", ascending=False
        )

    # Display parks in grid
    cols = st.columns(3)
    for idx, (_, park) in enumerate(filtered_df.iterrows()):
        with cols[idx % 3]:
            with st.container():
                st.markdown(f"### {park['Park_Name']}")
                st.write(f"📍 **{park['State']}** | {park['Region']}")
                st.write(f"👥 **{park['Annual_Visitors']:,}** visitors/year")
                st.write(f"⭐ Kid-Friendly: {park['Kid_Friendliness_Rating']}/5")
                st.write(f"🐾 Pet-Friendly: {park['Pet_Friendliness_Rating']}/5")
                st.write(f"💰 Entry Fee: ${park['Entry_Fee']:.2f}")

                if st.button(f"View Details", key=f"park_{park['Park_ID']}"):
                    st.session_state.selected_park_id = park["Park_ID"]
                    st.session_state.page = "Park Details"
                    st.rerun()

                st.markdown("---")


# Park Details Page
def park_details():
    """Detailed park information page"""
    if "selected_park_id" not in st.session_state:
        st.warning("Please select a park first")
        return

    park = load_park_details(st.session_state.selected_park_id)

    if park is None:
        st.error("Park details not found")
        return

    st.header(f"🏞️ {park['Park_Name']}")

    # Back button
    if st.button("← Back to Park Discovery"):
        st.session_state.page = "Park Discovery"
        st.rerun()

    # Tabs for different information
    tab1, tab2, tab3, tab4 = st.tabs(
        ["Overview", "Activities & Trails", "Plan Your Trip", "Nearby Airports"]
    )

    with tab1:
        col1, col2 = st.columns([2, 1])

        with col1:
            st.subheader("About")
            st.write(park["Description"])

            st.subheader("🦌 Wildlife")
            st.write(park["Wildlife_Information"])

            st.subheader("🌲 Plant Life")
            st.write(park["Plant_Information"])

        with col2:
            st.metric("Annual Visitors", f"{park['Annual_Visitors']:,}")
            st.metric("Area (sq miles)", f"{park['Area_Square_Miles']:,}")
            st.metric("Entry Fee", f"${park['Entry_Fee']:.2f}")

            st.write("**Best Time to Visit:**")
            st.info(park["Best_Time_To_Visit"])

            st.write("**Free Entry Days:**")
            st.write(park["Free_Entry_Days"])

            st.write("**Ratings:**")
            st.write(f"⚡ Difficulty: {park['Difficulty_Rating']}")
            st.write(f"👨‍👩‍👧‍👦 Kid-Friendly: {park['Kid_Friendliness_Rating']}/5")
            st.write(f"🐾 Pet-Friendly: {park['Pet_Friendliness_Rating']}/5")

    with tab2:
        st.subheader("🎯 Activities & Events")
        st.write(park["Park_Activities_Events"])

        st.subheader("🥾 Popular Trails")
        st.write(park["Popular_Park_Trails"])

    with tab3:
        st.subheader("✈️ Flights")

        # Load nearby airports
        airports_df = load_park_airports(park["Park_ID"])

        if not airports_df.empty:
            st.write("**Nearby Airports:**")
            for _, airport in airports_df.iterrows():
                st.write(
                    f"✈️ **{airport['Airport_Name']}** ({airport['Airport_Code']}) - {airport['Distance_Miles']:.1f} miles"
                )

            # Flight search
            selected_airport = st.selectbox(
                "Select destination airport",
                airports_df["Airport_ID"].tolist(),
                format_func=lambda x: airports_df[airports_df["Airport_ID"] == x][
                    "Airport_Name"
                ].iloc[0],
            )

            flights_df = load_flights(
                origin_airport_id=1, destination_airport_id=selected_airport
            )

            if not flights_df.empty:
                st.write(f"**Available Flights from DFW:**")
                for _, flight in flights_df.iterrows():
                    col1, col2, col3 = st.columns([2, 2, 1])
                    with col1:
                        st.write(f"✈️ {flight['Airline']} {flight['Flight_Number']}")
                        st.write(f"🛫 {flight['Departure_Time']}")
                    with col2:
                        st.write(f"Duration: {flight['Duration_Minutes']} min")
                        st.write(f"Stops: {flight['Number_Of_Stops']}")
                    with col3:
                        st.write(f"**${flight['Price']:.2f}**")
                        st.write(f"Seats: {flight['Available_Seats']}")
                    st.markdown("---")

        st.subheader("🏨 Lodging Options")
        lodging_df = load_lodging(park["Park_ID"])

        if not lodging_df.empty:
            for _, lodging in lodging_df.iterrows():
                with st.expander(
                    f"⭐ {lodging['Star_Rating']}/5 - {lodging['Lodging_Name']} ({lodging['Lodging_Type']})"
                ):
                    col1, col2 = st.columns([2, 1])
                    with col1:
                        st.write(f"**Description:** {lodging['Description']}")
                        st.write(f"**Amenities:** {lodging['Amenities']}")
                        st.write(
                            f"📍 {lodging['Address']}, {lodging['City']}, {lodging['State']} {lodging['Zip_Code']}"
                        )
                        st.write(f"📞 {lodging['Contact_Phone']}")
                        st.write(f"✉️ {lodging['Contact_Email']}")
                    with col2:
                        st.metric("Price/Night", f"${lodging['Price_Per_Night']:.2f}")
                        st.write(
                            f"**Distance:** {lodging['Distance_From_Park_Miles']:.1f} miles"
                        )

    with tab4:
        airports_df = load_park_airports(park["Park_ID"])
        if not airports_df.empty:
            st.dataframe(
                airports_df[
                    ["Airport_Code", "Airport_Name", "City", "State", "Distance_Miles"]
                ],
                use_container_width=True,
                hide_index=True,
            )
        else:
            st.info("No nearby airports data available")


# Main app navigation
def main():
    """Main application navigation"""

    # Initialize session state
    if "page" not in st.session_state:
        st.session_state.page = "Home"

    # Sidebar navigation
    st.sidebar.title("🏞️ ParkPal")
    st.sidebar.markdown("---")

    page = st.sidebar.radio(
        "Navigation",
        ["Home", "Park Discovery", "Park Details", "ParkBot Chat", "About"],
    )

    # Update page in session state
    if page != st.session_state.page:
        st.session_state.page = page

    # Render selected page
    if st.session_state.page == "Home":
        st.title("🏞️ Welcome to ParkPal")
        st.write("### Your Ultimate National Park Trip Planning Companion")

        st.markdown(
            """
        ParkPal helps you discover, explore, and plan unforgettable trips to all 63 US National Parks.
        
        **Features:**
        - 🔍 Discover all 63 US National Parks
        - ✈️ Search and book flights from DFW
        - 🏨 Find lodging near your favorite parks
        - 🤖 Get personalized recommendations from ParkBot
        - 📊 Compare parks by difficulty, activities, and ratings
        
        **Get Started:**
        1. Explore parks in the **Park Discovery** page
        2. View detailed information about each park
        3. Ask **ParkBot** for personalized recommendations
        4. Plan your trip with flights and lodging options
        """
        )

        # Quick stats
        parks_df = load_parks()
        if not parks_df.empty:
            col1, col2, col3 = st.columns(3)
            with col1:
                st.metric("Total Parks", len(parks_df))
            with col2:
                st.metric("Regions Covered", parks_df["Region"].nunique())
            with col3:
                st.metric("States", parks_df["State"].nunique())

    elif st.session_state.page == "Park Discovery":
        park_discovery()

    elif st.session_state.page == "Park Details":
        park_details()

    elif st.session_state.page == "ParkBot Chat":
        parkbot_chat()

    elif st.session_state.page == "About":
        st.title("About ParkPal")
        st.write(
            """
        **ParkPal** is a comprehensive trip planning platform for US National Park enthusiasts.
        
        ### Mission
        To make exploring America's national parks accessible, easy, and enjoyable for everyone.
        
        ### Technology
        - Built with Streamlit
        - MySQL Database
        - OpenAI GPT-4 for ParkBot
        
        ### Data
        - All 63 US National Parks
        - Flights from Dallas/Fort Worth International Airport (DFW)
        - Lodging options near major parks
        - Real-time availability and pricing
        
        ### Version
        1.0 - December 2025
        
        ### Contact
        For questions or feedback, please contact the development team.
        """
        )


# Run the app
if __name__ == "__main__":
    main()
