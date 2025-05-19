import os
from dotenv import load_dotenv
import mysql.connector

root_env = os.path.join(os.path.dirname(os.path.dirname(__file__)), ".env")
load_dotenv(dotenv_path=root_env)

class Config:
    SECRET_KEY = os.getenv("SECURE_KEY", "fixed-key-USE_ONLY_IN_DEV_ENV")
    
def get_db_connection():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME"),
        port=int(os.getenv("DB_PORT"))
    )
