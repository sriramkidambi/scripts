import psycopg2
import os
from psycopg2 import OperationalError, Error

def get_database_url():
    # Try to get database URL from environment variable first
    db_url = os.environ.get('DATABASE_URL')

    # If not found in environment, prompt the user
    if not db_url:
        host = input("Enter PostgreSQL host: ")
        port = input("Enter PostgreSQL port (default 5432): ") or "5432"
        user = input("Enter PostgreSQL username: ")
        password = input("Enter PostgreSQL password: ")
        dbname = input("Enter PostgreSQL database name: ")

        # Construct the connection string
        db_url = f"postgresql://{user}:{password}@{host}:{port}/{dbname}"

    return db_url

# --- Test Table and Data ---
TEST_TABLE_NAME = "test_connection_table"
TEST_DATA = [
    (1, "Alice"),
    (2, "Bob"),
    (3, "Charlie")
]

def test_postgres_connection_uri():
    """Tests PostgreSQL connection and basic database operations using a URI DSN."""
    connection = None
    cursor = None

    # Get the database URL
    DATABASE_URL_DSN = get_database_url()

    print("Attempting to connect to the PostgreSQL database using the provided URI...")
    try:
        # Establish the connection using the DSN string
        connection = psycopg2.connect(DATABASE_URL_DSN)

        print("Connection successful!")

        # Create a cursor object to execute SQL commands
        cursor = connection.cursor()
        print("Cursor created.")

        # --- Test Database Operations ---
        print(f"\nTesting database operations using table: {TEST_TABLE_NAME}")

        # 1. Drop table if it exists (clean up from previous runs)
        print(f"Dropping table {TEST_TABLE_NAME} if it exists...")
        drop_table_query = f"DROP TABLE IF EXISTS {TEST_TABLE_NAME};"
        cursor.execute(drop_table_query)
        print(f"DROP TABLE IF EXISTS executed.")

        # 2. Create a test table
        print(f"Creating table {TEST_TABLE_NAME}...")
        create_table_query = f"""
        CREATE TABLE {TEST_TABLE_NAME} (
            id SERIAL PRIMARY KEY,
            name VARCHAR(255) NOT NULL
        );
        """
        cursor.execute(create_table_query)
        print(f"Table {TEST_TABLE_NAME} created successfully.")

        # 3. Insert data into the table
        print(f"Inserting data into {TEST_TABLE_NAME}...")
        insert_query = f"INSERT INTO {TEST_TABLE_NAME} (id, name) VALUES (%s, %s);"
        cursor.executemany(insert_query, TEST_DATA)
        print(f"{len(TEST_DATA)} rows inserted successfully.")

        # 4. Query data from the table
        print(f"Querying data from {TEST_TABLE_NAME}...")
        select_query = f"SELECT id, name FROM {TEST_TABLE_NAME};"
        cursor.execute(select_query)
        records = cursor.fetchall()
        print("Query executed successfully. Retrieved data:")
        if records:
            for row in records:
                print(row)
            print(f"Successfully retrieved {len(records)} rows.")
        else:
            print("No data retrieved (unexpected for this test).")

        # 5. Drop the test table (clean up)
        print(f"\nDropping table {TEST_TABLE_NAME}...")
        drop_table_query_final = f"DROP TABLE {TEST_TABLE_NAME};"
        cursor.execute(drop_table_query_final)
        print(f"Table {TEST_TABLE_NAME} dropped successfully.")

        # Commit the transaction to make changes persistent
        connection.commit()
        print("\nAll operations committed successfully!")

    except OperationalError as e:
        print(f"\nError during connection or operation:")
        print(f"SQLSTATE: {e.diag.sqlstate if e.diag else 'N/A'}")
        print(f"Message: {e.diag.message if e.diag else str(e)}")
        print("Please check your connection details, network, and database server status.")
        if connection:
             # Roll back in case of error after connection
            connection.rollback()
            print("Transaction rolled back.")
    except Error as e:
        print(f"\nDatabase Error: {e}")
        if connection:
            # Roll back in case of error after connection
            connection.rollback()
            print("Transaction rolled back.")
    except Exception as e:
        print(f"\nAn unexpected error occurred: {e}")
        if connection:
            # Roll back in case of error after connection
            connection.rollback()
            print("Transaction rolled back.")

    finally:
        # Close the cursor and connection
        if cursor:
            cursor.close()
            print("Cursor closed.")
        if connection:
            connection.close()
            print("Connection closed.")
        print("\nTest script finished.")

# --- Run the test ---
if __name__ == "__main__":
    test_postgres_connection_uri()
