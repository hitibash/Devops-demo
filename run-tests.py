import time
import os
import mysql.connector
from mysql.connector import Error


MAX_RETRIES = 30
SLEEP_TIME = 2

def wait_for_mysql():
    for attempt in range(1, MAX_RETRIES + 1):
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
        except Error:
            pass
        time.sleep(SLEEP_TIME)
    print("[PY] MySQL did not become ready in time.")
    return False

if __name__ == "__main__":
    print("[PY] Starting test runner...")
    if wait_for_mysql():
        os.system("pytest tests/")
    else:
        exit(1)
