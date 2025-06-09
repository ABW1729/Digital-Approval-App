from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, EmailStr
import requests
import os

app = FastAPI()

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ENV or fallback service URLs
ML_MODEL_URL = os.getenv("ML_MODEL_URL", "http://localhost:9000/predict")
USER_SERVICE_URL = os.getenv("USER_SERVICE_URL", "http://localhost:8010")

# --- Request Models ---

class TransactionInput(BaseModel):
    TransactionID: str
    UserID: str
    Amount: float
    Timestamp: str
    MerchantCategory: str
    TransactionType: str
    DeviceID: str
    IPAddress: str
    Latitude: float
    Longitude: float
    AvgTransactionAmount: float
    TransactionFrequency: int
    UnusualLocation: int
    UnusualAmount: int
    NewDevice: int
    FailedAttempts: int
    PhoneNumber: str
    BankName: str

class RegisterRequest(BaseModel):
    phone: str
    email: EmailStr

class LoginRequest(BaseModel):
    phone: str

class OTPVerifyRequest(BaseModel):
    phone: str
    otp: str
# --- Routes ---

@app.post("/predict")
def predict(transaction: TransactionInput):
    try:
        response = requests.post(ML_MODEL_URL, json=transaction.dict())
        response.raise_for_status()
        return response.json()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")

@app.post("/send-otp")
def register_user(req: RegisterRequest):
    try:
        response = requests.post(f"{USER_SERVICE_URL}/send-otp", json=req.dict())
        response.raise_for_status()
        return response.json()
    except requests.HTTPError as e:
        raise HTTPException(status_code=e.response.status_code, detail=e.response.json()["detail"])

@app.post("/login")
def login_user(req: LoginRequest):
    try:
        response = requests.post(f"{USER_SERVICE_URL}/login", json=req.dict())
        response.raise_for_status()
        return response.json()
    except requests.HTTPError as e:
        raise HTTPException(status_code=e.response.status_code, detail=e.response.json()["detail"])
        
@app.post("/verify-otp")
def verifyOtp(req: OTPVerifyRequest):
    try:
        response = requests.post(f"{USER_SERVICE_URL}/verify-otp", json=req.dict())
        response.raise_for_status()
        return response.json()
    except requests.HTTPError as e:
        raise HTTPException(status_code=e.response.status_code, detail=e.response.json()["detail"])
        
@app.post("/verify-login-otp")
def verifyLoginOtp(req: OTPVerifyRequest):
    try:
        response = requests.post(f"{USER_SERVICE_URL}/verify-login-otp", json=req.dict())
        response.raise_for_status()
        return response.json()
    except requests.HTTPError as e:
        raise HTTPException(status_code=e.response.status_code, detail=e.response.json()["detail"])
