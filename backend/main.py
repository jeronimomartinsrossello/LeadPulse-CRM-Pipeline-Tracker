import os
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
import psycopg

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

app = FastAPI(title= "LeadPulse CRM API", version = "0.1.0")

def get_db_connection():
    if not DATABASE_URL:
        raise RuntimeError('DATABASE_URL is not configured')
    return psycopg.connect(DATABASE_URL)

@app.get('/health')
def health_check():
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute('SELECT 1')
                result = cur.fetchone()
        return {"status": "ok",
                "database": "connected",
                'db_check': result[0],
                }
    
    except Exception as exc:
        raise HTTPException(
            status_code = 500,
            detail = f"Database connection failed: {str(exc)}",
        )
        
        