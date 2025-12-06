import streamlit as st
import mysql.connector
from mysql.connector import Error
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Page config
st.set_page_config(page_title="National Park Planner", layout="wide")

# Database configuration
DB_CONFIG = {
    'host': os.getenv('DB_HOST'),
    'port': int(os.getenv('DB_PORT', 25060)),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'database': os.getenv('DB_NAME'),
}

def get_db_connection():
    """Create MySQL database connection"""
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        return conn
    except Error as e:
        st.error(f"Database connection failed: {e}")
        return None

# Main app
st.title("🏞️ National Park Travel Planner")

# Test database connection
st.header("Database Connection Test")
conn = get_db_connection()
if conn:
    st.success("✓ Connected to database successfully!")
    cursor = conn.cursor()
    
    # Show available tables
    cursor.execute("SHOW TABLES")
    tables = cursor.fetchall()
    
    if tables:
        st.write(f"**Found {len(tables)} tables:**")
        for table in tables:
            st.write(f"- {table[0]}")
    else:
        st.info("Database is empty. You need to create tables.")
    
    cursor.close()
    conn.close()
else:
    st.error("Could not connect to database. Check your .env file settings.")

st.divider()
st.info("**Next steps:** Create your database schema and start building features!")
