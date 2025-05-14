import os
from dotenv import load_dotenv
import mysql.connector

load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), ".env.local"))

class Config:
    SECRET_KEY = os.getenv("SECURE_KEY", "fixed-key-USE_ONLY_IN_DEV_ENV")
    
def get_db_connection():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME")
    )
