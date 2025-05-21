import time
import os
import mysql.connector
from mysql.connector import Error

MAX_RETRIES = 30
SLEEP_TIME = 2

print("[PY] Starting run-tests.py...")

os.system("ps aux")  # List all running processes
os.system("ls -al")  # List files
os.system("which pytest")  # Where is pytest coming from

def wait_for_mysql():
    attempt = 0
    while attempt < MAX_RETRIES:
        try:
            connection = mysql.connector.connect(
                host=os.getenv("DB_HOST", "db"),
                user=os.getenv("DB_USER", "app_user"),
                password=os.getenv("DB_PASSWORD", "123456"),
                database=os.getenv("DB_NAME", "todo_app")
            )
            if connection.is_connected():
                print("[PY] MySQL is ready.")
                connection.close()
                return True
        except Error as e:
            print(f"[PY] Attempt {attempt+1}/{MAX_RETRIES} failed: {e}")
        attempt += 1
        time.sleep(SLEEP_TIME)

    print("[PY] MySQL did not become ready in time.")
    return False

if __name__ == "__main__":
    if wait_for_mysql():
        print("[PY] Running tests...")
        exit(os.system("pytest tests/"))
    else:
        exit(1)
