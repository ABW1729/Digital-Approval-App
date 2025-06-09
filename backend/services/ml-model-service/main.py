from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import shap
import pandas as pd
import numpy as np
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Enable CORS for testing from frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load trained model and SHAP explainer
model = joblib.load("models/fraud_model.pkl")
explainer = joblib.load("models/shap_explainer.pkl")  # Precomputed SHAP TreeExplainer

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

@app.post("/predict")
def predict(transaction: TransactionInput):
    # Prepare input for model
    input_data = pd.DataFrame([{
        "Amount": transaction.Amount,
        "AvgTransactionAmount": transaction.AvgTransactionAmount,
        "TransactionFrequency": transaction.TransactionFrequency,
        "UnusualLocation": transaction.UnusualLocation,
        "UnusualAmount": transaction.UnusualAmount,
        "NewDevice": transaction.NewDevice,
        "FailedAttempts": transaction.FailedAttempts,
        "Latitude": transaction.Latitude,
        "Longitude": transaction.Longitude
    }])

    # Prediction
    fraud_proba = model.predict_proba(input_data)[0][1]
    risk_level = 2 if fraud_proba > 0.75 else (1 if fraud_proba > 0.4 else 0)

    # SHAP explanation
    shap_values = explainer.shap_values(input_data)[1]  # Class 1 for fraud
    top_features = sorted(
        zip(input_data.columns, shap_values[0]),
        key=lambda x: abs(x[1]), reverse=True
    )[:5]

    return {
        "fraud_probability": round(float(fraud_proba), 4),
        "risk_level": risk_level,
        "top_contributors": [
            {"feature": feat, "shap_value": round(float(val), 4)} for feat, val in top_features
        ]
    }
