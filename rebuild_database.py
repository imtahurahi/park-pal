"""
Rebuild SQLite database for National Park Travel Planner
"""
import sqlite3
import os

# Database path in the project directory
db_path = "national_parks.db"

# Connect to database (creates if doesn't exist)
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

print(f"Rebuilding database: {db_path}")

# Drop all existing tables
cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
tables = cursor.fetchall()
for table in tables:
    if table[0] != 'sqlite_sequence':  # Skip system table
        print(f"  Dropping table: {table[0]}")
        cursor.execute(f"DROP TABLE IF EXISTS {table[0]};")
conn.commit()

# Read and execute DDL schema
print("\nCreating new schema...")
with open("05_DDL_schema_v1.sql", "r", encoding="utf-8") as f:
    ddl_script = f.read()
    cursor.executescript(ddl_script)
    print("✓ Schema created successfully")

# Read and execute DML data
print("\nInserting data...")
with open("06_DML_data_v1.sql", "r", encoding="utf-8") as f:
    dml_script = f.read()
    cursor.executescript(dml_script)
    print("✓ Data inserted successfully")

# Verify parks count
cursor.execute("SELECT COUNT(*) FROM Parks;")
count = cursor.fetchone()[0]
print(f"\n✓ Total parks in database: {count}")

# Commit and close
conn.commit()
conn.close()

print(f"\n✓ Database rebuilt successfully: {db_path}")
print(f"  Location: {os.path.abspath(db_path)}")
