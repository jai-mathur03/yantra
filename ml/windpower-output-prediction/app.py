import requests
import pandas as pd
import pickle
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Allow all origins, or restrict to specific ones
origins = [
    "*",  # Allows requests from any frontend (use caution in production)
    # "https://your-frontend-domain.com"  # Replace with your frontend URL for better security
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],  # Allows all HTTP methods (GET, POST, etc.)
    allow_headers=["*"],
    expose_headers=["*"],# Allows all headers
)

@app.get("/")
def read_root():
    return {"message": "CORS enabled API is working!"}


# Load saved model and scaler
with open("wind_power_model.pkl", "rb") as f:
    model = pickle.load(f)

with open("scaler.pkl", "rb") as f:
    scaler = pickle.load(f)

def get_wind_data(latitude: float, longitude: float, start_date: str, end_date: str) -> pd.DataFrame:
    """ Fetch wind data from Open-Meteo API. """
    url = "https://api.open-meteo.com/v1/forecast"
    params = {
        "latitude": latitude,
        "longitude": longitude,
        "start_date": start_date,
        "end_date": end_date,
        "hourly": "temperature_2m,relative_humidity_2m,dew_point_2m,wind_speed_10m,wind_speed_80m,wind_direction_10m,wind_direction_80m,wind_gusts_10m",
        "timezone": "auto",
    }

    response = requests.get(url, params=params)
    data = response.json()

    if 'hourly' not in data or 'time' not in data['hourly']:
        return None

    # Fetch values without conversion (API data is already in the correct format)
    df = pd.DataFrame({
        'timestamp': pd.to_datetime(data['hourly']['time']),
        'temperature_2m': data['hourly'].get('temperature_2m'),
        'relativehumidity_2m': data['hourly'].get('relative_humidity_2m'),
        'dewpoint_2m': data['hourly'].get('dew_point_2m'),
        'windspeed_10m': data['hourly'].get('wind_speed_10m'),
        'windspeed_100m': data['hourly'].get('wind_speed_80m'),  # Approximate for 100m
        'winddirection_10m': data['hourly'].get('wind_direction_10m'),
        'winddirection_100m': data['hourly'].get('wind_direction_80m'),
        'windgusts_10m': data['hourly'].get('wind_gusts_10m'),
    })

    return df

@app.get("/predict")
def predict_wind_power(latitude: float, longitude: float, start_date: str, end_date: str):
    """ API endpoint for predicting wind power (Now uses GET request) """
    df = get_wind_data(latitude, longitude, start_date, end_date)

    if df is None:
        return {"error": "No data available from API"}

    # Select model features
    features = ['temperature_2m', 'relativehumidity_2m', 'dewpoint_2m',
                'windspeed_10m', 'windspeed_100m', 'windgusts_10m',
                'winddirection_10m', 'winddirection_100m']

    X_scaled = scaler.transform(df[features])
    df['Predicted_Power'] = model.predict(X_scaled)

    # Clip values between 0 and 1
    df['Predicted_Power'] = df['Predicted_Power'].clip(0, 1) * 100

    return {
        "predictions": df[['timestamp', 'Predicted_Power']].to_dict(orient="records")
    }
