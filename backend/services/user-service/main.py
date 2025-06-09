from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, EmailStr
from typing import Dict
import smtplib
from email.message import EmailMessage
from dotenv import load_dotenv
import uuid
import random
import time
import os

from databases import Database
from sqlalchemy import Table, Column, String, MetaData
import sqlalchemy

# Load environment variables
load_dotenv()

# Constants
OTP_EXPIRY_SECONDS = 300
MAX_RESENDS = 3

# Database URL
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql+asyncpg://aniket:1234@localhost:5432/digirakshak")

# Database setup
database = Database(DATABASE_URL)
metadata = MetaData()

users = Table(
    "users",
    metadata,
    Column("id", String, primary_key=True),
    Column("phone", String, unique=True, nullable=False),
    Column("email", String, nullable=False)
)

# Create table
engine = sqlalchemy.create_engine(DATABASE_URL.replace("asyncpg", "psycopg2"))
metadata.create_all(engine)

# App
app = FastAPI()

@app.on_event("startup")
async def startup():
    await database.connect()

@app.on_event("shutdown")
async def shutdown():
    await database.disconnect()

# In-memory storage
otp_store: Dict[str, dict] = {}             # For login OTPs
pending_registrations: Dict[str, dict] = {} # For unverified users

# --- Models ---
class RegisterRequest(BaseModel):
    phone: str
    email: EmailStr

class LoginRequest(BaseModel):
    phone: str

class OTPVerifyRequest(BaseModel):
    phone: str
    otp: str

class AuthResponse(BaseModel):
    user_id: str
    message: str

# --- Registration: Send OTP ---
@app.post("/send-otp")
async def send_otp(req: RegisterRequest):
    query = users.select().where(users.c.phone == req.phone)
    existing = await database.fetch_one(query)

    if existing:
        raise HTTPException(status_code=400, detail="User already registered")

    otp = f"{random.randint(100000, 999999)}"
    pending_registrations[req.phone] = {
        "email": req.email,
        "otp": otp,
        "timestamp": time.time(),
        "resends": 1
    }

    send_email(
        to_email=req.email,
        subject="DigiRakshak Registration OTP",
        body=f"Your OTP for DigiRakshak registration is: {otp}"
    )

    return {"message": "OTP sent to email for registration."}

# --- Verify Registration OTP & Register User ---
@app.post("/verify-otp", response_model=AuthResponse)
async def verify_otp(req: OTPVerifyRequest):
    entry = pending_registrations.get(req.phone)
    if not entry:
        raise HTTPException(status_code=400, detail="No OTP request found for this phone")

    if time.time() - entry["timestamp"] > OTP_EXPIRY_SECONDS:
        del pending_registrations[req.phone]
        raise HTTPException(status_code=408, detail="OTP expired")

    if req.otp != entry["otp"]:
        raise HTTPException(status_code=401, detail="Invalid OTP")

    # Double-check user not already created
    query = users.select().where(users.c.phone == req.phone)
    existing = await database.fetch_one(query)
    if existing:
        del pending_registrations[req.phone]
        return AuthResponse(user_id=existing["id"], message="Already registered.")

    # Register user
    user_id = str(uuid.uuid4())
    insert_query = users.insert().values(id=user_id, phone=req.phone, email=entry["email"])
    await database.execute(insert_query)

    del pending_registrations[req.phone]
    return AuthResponse(user_id=user_id, message="User registered and OTP verified successfully.")

# --- Login OTP ---
@app.post("/login", response_model=AuthResponse)
async def login_user(req: LoginRequest):
    query = users.select().where(users.c.phone == req.phone)
    user = await database.fetch_one(query)

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    otp = f"{random.randint(100000, 999999)}"
    otp_store[req.phone] = {
        "otp": otp,
        "timestamp": time.time(),
        "resends": 1
    }

    send_email(
        to_email=user["email"],
        subject="DigiRakshak Login OTP",
        body=f"Your OTP for login is: {otp}"
    )

    return AuthResponse(user_id=user["id"], message="OTP sent to email.")

# --- Resend Login OTP ---
@app.post("/resend-otp")
async def resend_otp(req: LoginRequest):
    query = users.select().where(users.c.phone == req.phone)
    user = await database.fetch_one(query)

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    otp_entry = otp_store.get(req.phone)
    if otp_entry and otp_entry["resends"] >= MAX_RESENDS:
        raise HTTPException(status_code=429, detail="OTP resend limit reached")

    otp = f"{random.randint(100000, 999999)}"
    otp_store[req.phone] = {
        "otp": otp,
        "timestamp": time.time(),
        "resends": (otp_entry["resends"] + 1) if otp_entry else 1
    }

    send_email(
        to_email=user["email"],
        subject="DigiRakshak OTP Resend",
        body=f"Your new OTP is: {otp}"
    )

    return {"message": "OTP resent to email."}

# --- Verify Login OTP ---
@app.post("/verify-login-otp", response_model=AuthResponse)
async def verify_login_otp(req: OTPVerifyRequest):
    entry = otp_store.get(req.phone)
    query = users.select().where(users.c.phone == req.phone)
    user = await database.fetch_one(query)

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    if not entry:
        raise HTTPException(status_code=400, detail="No OTP requested")

    if time.time() - entry["timestamp"] > OTP_EXPIRY_SECONDS:
        del otp_store[req.phone]
        raise HTTPException(status_code=408, detail="OTP expired")

    if req.otp != entry["otp"]:
        raise HTTPException(status_code=401, detail="Invalid OTP")

    del otp_store[req.phone]
    return AuthResponse(user_id=user["id"], message="Login OTP verified successfully.")

# --- Email Function ---
def send_email(to_email: str, subject: str, body: str):
    msg = EmailMessage()
    msg["Subject"] = subject
    msg["From"] = "aniketwani1729@gmail.com"
    msg["To"] = to_email
    msg.set_content(body)

    with smtplib.SMTP(os.getenv("EMAIL_HOST"), int(os.getenv("EMAIL_PORT"))) as smtp:
        smtp.starttls()
        smtp.login("aniketwani1729@gmail.com", "mcxrnqhmgpxygxwn")
        smtp.send_message(msg)


