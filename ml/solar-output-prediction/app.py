import requests
import pandas as pd
import numpy as np
import joblib
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# CORS setup
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["*"],
)

@app.get("/")
def read_root():
    return {"message": "Solar Prediction API is working!"}

# Load pre-trained model
model = joblib.load("solar_model.pkl")

def get_solar_data(latitude: float, longitude: float, start_date: str, end_date: str) -> pd.DataFrame:
    """Fetch solar data from Open-Meteo API."""
    url = "https://api.open-meteo.com/v1/forecast"
    params = {
        "latitude": latitude,
        "longitude": longitude,
        "start_date": start_date,
        "end_date": end_date,
        "hourly": "temperature_2m,cloud_cover,direct_radiation",
        "timezone": "auto",
    }

    response = requests.get(url, params=params)
    data = response.json()

    if 'hourly' not in data or 'time' not in data['hourly']:
        return None

    df = pd.DataFrame({
        'timestamp': pd.to_datetime(data['hourly']['time']),
        'temperature_2m': data['hourly'].get('temperature_2m', []),
        'cloud_cover': data['hourly'].get('cloud_cover', []),
        'direct_radiation': data['hourly'].get('direct_radiation', []),
    })

    # Add hour and month features (like your model.py does)
    df['hour'] = df['timestamp'].dt.hour
    df['month'] = df['timestamp'].dt.month
    
    # Use direct_radiation as ghi proxy
    df['ghi'] = df['direct_radiation']

    return df

@app.get("/predict")
def predict_solar_power(latitude: float, longitude: float, start_date: str, end_date: str):
    """API endpoint for predicting solar power."""
    df = get_solar_data(latitude, longitude, start_date, end_date)

    if df is None:
        return {"error": "No data available from API"}

    # Features your model was trained on
    features = ['ghi', 'hour', 'month', 'cloud_cover', 'temperature_2m']
    
    # Handle missing values same way as model.py
    for col in features:
        if col not in df.columns:
            df[col] = df[features].mean()  # Fill with mean
    
    X = df[features].fillna(df[features].mean())
    df['Predicted_Power'] = model.predict(X)

    # Clip to reasonable range
    df['Predicted_Power'] = df['Predicted_Power'].clip(0, 10000)

    return {
        "predictions": df[['timestamp', 'Predicted_Power']].to_dict(orient="records")
    }
