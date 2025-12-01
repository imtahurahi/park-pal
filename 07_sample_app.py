import streamlit as st
import sqlite3
import pandas as pd
from datetime import datetime, timedelta
from openai import OpenAI
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Page configuration
st.set_page_config(page_title="National Park Travel Planner", layout="wide")

# Initialize session state
if "user_id" not in st.session_state:
    st.session_state.user_id = 1  # Demo user

# Database connection
db_path = "national_parks.db"

# Title
st.title("🏞️ National Park Travel Planner")

# Sidebar for navigation
page = st.sidebar.selectbox(
    "Navigation",
    ["Explore Parks", "Plan Trip", "My Trips", "Flight Analytics", "AI Assistant"],
)

# ===================================
# EXPLORE PARKS PAGE
# ===================================
if page == "Explore Parks":
    st.header("Explore National Parks")

    conn = sqlite3.connect(db_path)

    col1, col2 = st.columns([3, 1])

    with col1:
        # Get all parks
        parks_query = """
        SELECT park_id, park_name, state, description, difficulty_level, 
               family_friendly, entrance_fee, best_seasons
        FROM Parks
        ORDER BY park_name
        """
        df_parks = pd.read_sql_query(parks_query, conn)

        # Park filter
        selected_state = st.selectbox(
            "Filter by State", ["All"] + sorted(df_parks["state"].unique().tolist())
        )

        if selected_state != "All":
            df_filtered = df_parks[df_parks["state"] == selected_state]
        else:
            df_filtered = df_parks

        # Display parks
        for idx, row in df_filtered.iterrows():
            with st.expander(f"🏞️ {row['park_name']} - {row['state']}"):
                st.write(f"**Description:** {row['description']}")
                st.write(
                    f"**Difficulty:** {row['difficulty_level']} | **Entrance Fee:** ${row['entrance_fee']}"
                )
                st.write(
                    f"**Family Friendly:** {'Yes' if row['family_friendly'] else 'No'}"
                )
                st.write(f"**Best Seasons:** {row['best_seasons']}")

                # Get activities for this park
                activities_query = f"""
                SELECT a.activity_name
                FROM Activities a
                JOIN Park_Activities pa ON a.activity_id = pa.activity_id
                WHERE pa.park_id = {row['park_id']}
                """
                activities = pd.read_sql_query(activities_query, conn)
                st.write(
                    f"**Activities:** {', '.join(activities['activity_name'].tolist())}"
                )

                if st.button(f"Add to Wishlist", key=f"wish_{row['park_id']}"):
                    try:
                        cursor = conn.cursor()
                        cursor.execute(
                            """
                        INSERT INTO Wishlists (user_id, park_id, priority, visited)
                        VALUES (?, ?, 'medium', 0)
                        """,
                            (st.session_state.user_id, row["park_id"]),
                        )
                        conn.commit()
                        st.success("Added to wishlist!")
                    except:
                        st.warning("Already in wishlist")

    with col2:
        st.subheader("SQL Query")
        st.code(parks_query, language="sql")

    conn.close()

# ===================================
# PLAN TRIP PAGE
# ===================================
elif page == "Plan Trip":
    st.header("Plan Your Trip")

    conn = sqlite3.connect(db_path)

    # Get parks
    parks_df = pd.read_sql_query(
        "SELECT park_id, park_name, state FROM Parks ORDER BY park_name", conn
    )
    park_options = {
        f"{row['park_name']} ({row['state']})": row["park_id"]
        for _, row in parks_df.iterrows()
    }

    col1, col2 = st.columns(2)

    with col1:
        st.subheader("Trip Details")
        trip_title = st.text_input("Trip Title")
        selected_park = st.selectbox("Select Park", list(park_options.keys()))
        park_id = park_options[selected_park]

        arrival_date = st.date_input("Arrival Date", min_value=datetime.now())
        departure_date = st.date_input("Departure Date", min_value=arrival_date)

        trip_description = st.text_area("Trip Description (optional)")

    with col2:
        st.subheader("Select Flight")

        # Get flights to airports near selected park
        flights_query = f"""
        SELECT f.flight_id, a.airline_name, f.flight_number, 
               ap1.airport_code || ' → ' || ap2.airport_code as route,
               f.price, f.punctuality_score, f.flight_date
        FROM Flights f
        JOIN Airlines a ON f.airline_id = a.airline_id
        JOIN Airports ap1 ON f.origin_airport_id = ap1.airport_id
        JOIN Airports ap2 ON f.destination_airport_id = ap2.airport_id
        JOIN Park_Airports pa ON ap2.airport_id = pa.airport_id
        WHERE pa.park_id = {park_id}
        ORDER BY f.flight_date
        LIMIT 10
        """
        flights_df = pd.read_sql_query(flights_query, conn)

        if not flights_df.empty:
            flight_options = {
                f"{row['airline_name']} {row['flight_number']} - {row['route']} (${row['price']})": row[
                    "flight_id"
                ]
                for _, row in flights_df.iterrows()
            }
            selected_flight = st.selectbox(
                "Available Flights", ["None"] + list(flight_options.keys())
            )
            flight_id = (
                flight_options[selected_flight] if selected_flight != "None" else None
            )
        else:
            st.info("No flights available for this park")
            flight_id = None

    st.subheader("Select Lodging")
    lodging_query = f"""
    SELECT lodging_id, name, type, price_range, distance_from_park_miles
    FROM Lodging
    WHERE park_id = {park_id}
    ORDER BY distance_from_park_miles
    """
    lodging_df = pd.read_sql_query(lodging_query, conn)

    if not lodging_df.empty:
        lodging_options = {
            f"{row['name']} ({row['type']}) - {row['price_range']} - {row['distance_from_park_miles']}mi": row[
                "lodging_id"
            ]
            for _, row in lodging_df.iterrows()
        }
        selected_lodging = st.selectbox(
            "Available Lodging", ["None"] + list(lodging_options.keys())
        )
        lodging_id = (
            lodging_options[selected_lodging] if selected_lodging != "None" else None
        )
    else:
        st.info("No lodging available for this park")
        lodging_id = None

    # Save trip button
    if st.button("Save Trip"):
        if trip_title:
            cursor = conn.cursor()
            cursor.execute(
                """
            INSERT INTO Trips (user_id, park_id, flight_id, lodging_id, title, description, 
                             arrival_date, departure_date, status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'upcoming')
            """,
                (
                    st.session_state.user_id,
                    park_id,
                    flight_id,
                    lodging_id,
                    trip_title,
                    trip_description,
                    arrival_date,
                    departure_date,
                ),
            )
            conn.commit()
            st.success("Trip saved successfully!")
        else:
            st.error("Please enter a trip title")

    conn.close()

# ===================================
# MY TRIPS PAGE
# ===================================
elif page == "My Trips":
    st.header("My Trips")

    conn = sqlite3.connect(db_path)

    trips_query = f"""
    SELECT t.trip_id, t.title, p.park_name, t.arrival_date, t.departure_date, 
           t.status, t.description
    FROM Trips t
    JOIN Parks p ON t.park_id = p.park_id
    WHERE t.user_id = {st.session_state.user_id} AND t.is_deleted = 0
    ORDER BY t.arrival_date DESC
    """
    trips_df = pd.read_sql_query(trips_query, conn)

    col1, col2 = st.columns([3, 1])

    with col1:
        if not trips_df.empty:
            for _, trip in trips_df.iterrows():
                with st.expander(f"✈️ {trip['title']} - {trip['park_name']}"):
                    st.write(
                        f"**Dates:** {trip['arrival_date']} to {trip['departure_date']}"
                    )
                    st.write(f"**Status:** {trip['status']}")
                    if trip["description"]:
                        st.write(f"**Description:** {trip['description']}")

                    # Add note to trip
                    note_title = st.text_input(
                        "Note Title", key=f"note_title_{trip['trip_id']}"
                    )
                    note_content = st.text_area(
                        "Note Content", key=f"note_content_{trip['trip_id']}"
                    )
                    note_category = st.selectbox(
                        "Category",
                        ["Tips", "Packing List", "Review", "Planning"],
                        key=f"note_cat_{trip['trip_id']}",
                    )

                    if st.button("Add Note", key=f"add_note_{trip['trip_id']}"):
                        cursor = conn.cursor()
                        cursor.execute(
                            """
                        INSERT INTO Notes (user_id, trip_id, title, content, category)
                        VALUES (?, ?, ?, ?, ?)
                        """,
                            (
                                st.session_state.user_id,
                                trip["trip_id"],
                                note_title,
                                note_content,
                                note_category,
                            ),
                        )
                        conn.commit()
                        st.success("Note added!")

                    # Show notes for this trip
                    notes_query = f"""
                    SELECT title, content, category, created_at
                    FROM Notes
                    WHERE trip_id = {trip['trip_id']}
                    ORDER BY created_at DESC
                    """
                    notes_df = pd.read_sql_query(notes_query, conn)
                    if not notes_df.empty:
                        st.write("**Notes:**")
                        st.dataframe(notes_df, use_container_width=True)
        else:
            st.info("No trips planned yet. Go to 'Plan Trip' to create one!")

    with col2:
        st.subheader("SQL Query")
        st.code(trips_query, language="sql")

    conn.close()

# ===================================
# FLIGHT ANALYTICS PAGE
# ===================================
elif page == "Flight Analytics":
    st.header("Flight Analytics & Visualization")

    conn = sqlite3.connect(db_path)

    col1, col2 = st.columns([3, 1])

    with col1:
        # Punctuality by Airline
        st.subheader("Average Punctuality Score by Airline")

        punctuality_query = """
        SELECT a.airline_name, 
               AVG(f.punctuality_score) as avg_punctuality,
               AVG(f.average_delay_minutes) as avg_delay,
               COUNT(*) as flight_count
        FROM Flights f
        JOIN Airlines a ON f.airline_id = a.airline_id
        GROUP BY a.airline_name
        ORDER BY avg_punctuality DESC
        """
        punctuality_df = pd.read_sql_query(punctuality_query, conn)

        st.bar_chart(punctuality_df.set_index("airline_name")["avg_punctuality"])
        st.dataframe(punctuality_df, use_container_width=True)

        # Price trends
        st.subheader("Flight Prices Over Time")

        price_query = """
        SELECT flight_date, AVG(price) as avg_price
        FROM Flights
        GROUP BY flight_date
        ORDER BY flight_date
        """
        price_df = pd.read_sql_query(price_query, conn)
        st.line_chart(price_df.set_index("flight_date")["avg_price"])

    with col2:
        st.subheader("SQL Queries")
        st.write("**Punctuality Query:**")
        st.code(punctuality_query, language="sql")
        st.write("**Price Query:**")
        st.code(price_query, language="sql")

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
