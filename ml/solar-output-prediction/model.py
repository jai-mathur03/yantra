import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.impute import SimpleImputer
import joblib
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score

data_file = r"C:\Users\rahul\OneDrive\Desktop\Hackathon\Yantra\API\Final Models\solar_dataset.csv"
df = pd.read_csv(data_file)

if "timestamp" in df.columns:
    df["timestamp"] = pd.to_datetime(df["timestamp"])
else:
    print("Warning: No 'timestamp' column found.")

if "energy_wh" in df.columns:
    initial_count = len(df)
    df = df.dropna(subset=["energy_wh"])
    dropped_count = initial_count - len(df)
    print(f"Dropped {dropped_count} rows due to missing energy_wh values.")
else:
    raise KeyError("The dataset does not contain the 'energy_wh' column.")

df["cloud_cover"] = df["cloud_cover"] + 5
df["temperature_2m"] = df["temperature_2m"] + 2

def prepare_features_for_training(df):
    required_features = ["ghi", "hour", "month", "cloud_cover", "temperature_2m"]
    for col in required_features:
        if col not in df.columns:
            df[col] = np.nan
    X_orig = df[required_features]
    imputer = SimpleImputer(strategy="mean")
    X_imputed = pd.DataFrame(imputer.fit_transform(X_orig), columns=X_orig.columns)
    return X_imputed

X_data = prepare_features_for_training(df)
noise = X_data.apply(lambda col: np.random.normal(0, 0.2 * col.std(), size=col.shape))
X_data = X_data + noise

y_data = df["energy_wh"]

X_train, X_test, y_train, y_test = train_test_split(X_data, y_data, test_size=0.2, random_state=42)
model = RandomForestRegressor(n_estimators=100, random_state=42)
model.fit(X_train, y_train)
y_pred = model.predict(X_test)
mse = mean_squared_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)
print("Model performance on test set:")
print("Mean Squared Error:", mse)
print("R² Score:", r2)
joblib.dump(model, "solar_model.pkl")
print("Model trained and saved as 'solar_model.pkl'")
