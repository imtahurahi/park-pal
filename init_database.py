"""
Initialize SQLite database for National Park Travel Planner
"""

import sqlite3
import os

# Database path in the project directory
db_path = "national_parks.db"

# Remove existing database if it exists
if os.path.exists(db_path):
    os.remove(db_path)
    print(f"Removed existing database: {db_path}")

# Create new database connection
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

print(f"Creating database: {db_path}")

# Read and execute DDL schema
with open("05_DDL_schema_v1.sql", "r", encoding="utf-8") as f:
    ddl_script = f.read()
    cursor.executescript(ddl_script)
    print("✓ Schema created successfully")

# Read and execute DML data
with open("06_DML_data_v1.sql", "r", encoding="utf-8") as f:
    dml_script = f.read()
    cursor.executescript(dml_script)
    print("✓ Data inserted successfully")

# Commit and close
conn.commit()
conn.close()

print(f"\n✓ Database initialized successfully: {db_path}")
print(f"  Location: {os.path.abspath(db_path)}")
