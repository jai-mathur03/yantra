"use client";

import axios from "axios";
import { useEffect, useState } from "react";
import Navbar from "@/components/navbar";

type DustData = {
  pm2_5_ug_per_m3: number;
  deposition_flux_ug_per_m2_s: number;
  deposited_mass_per_area_ug_per_m2: number;
  deposited_mass_per_area_mg_per_m2: number;
  total_dust_deposited_mg: number;
  estimated_power_drop_percent: number;
  absolute_power_drop_watts: number;
};

const DustDepositionPage = () => {
  const [lat, setLatitude] = useState<number | null>(null);
  const [lon, setLongitude] = useState<number | null>(null);
  const [dustData, setDustData] = useState<DustData | null>(null);
  const [loading, setLoading] = useState<boolean>(true);

  useEffect(() => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          setLatitude(position.coords.latitude);
          setLongitude(position.coords.longitude);
        },
        (error) => console.error("Geolocation error:", error.message),
        { enableHighAccuracy: true, timeout: 5000, maximumAge: 0 }
      );
    } else {
      console.log("Geolocation is not supported by this browser.");
    }
  }, []);

  useEffect(() => {
    if (lat === null || lon === null) return;

    const fetchData = async () => {
      try {
        setLoading(true);
        const response = await axios.get(
          "https://tantradust.onrender.com/deposit",
          {
            params: { lat, lon },
          }
        );
        setDustData(response.data);
      } catch (error) {
        console.error("Error fetching data:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [lat, lon]);

  return (
    <>
      <Navbar />
      <div className="p-4 max-w-3xl mx-auto mt-10 bg-white shadow-md rounded-lg">
        <h1 className="text-3xl font-bold mb-6 mt-10">Dust Deposition Data</h1>
        {loading ? (
          <p className="text-gray-500">Loading data...</p>
        ) : dustData ? (
          <div className="space-y-4">
            <p>
              <strong>PM2.5 Concentration:</strong> {dustData.pm2_5_ug_per_m3}{" "}
              µg/m³
            </p>
            <p>
              <strong>Deposition Flux:</strong>{" "}
              {dustData.deposition_flux_ug_per_m2_s} µg/m²/s
            </p>
            <p>
              <strong>Deposited Mass per Area:</strong>{" "}
              {dustData.deposited_mass_per_area_ug_per_m2} µg/m²
            </p>
            <p>
              <strong>Deposited Mass per Area (mg/m²):</strong>{" "}
              {dustData.deposited_mass_per_area_mg_per_m2} mg/m²
            </p>
            <p>
              <strong>Total Dust Deposited:</strong>{" "}
              {dustData.total_dust_deposited_mg} mg
            </p>
            <p>
              <strong>Estimated Power Drop:</strong>{" "}
              {dustData.estimated_power_drop_percent / 10}%
            </p>
            <p>
              <strong>Absolute Power Drop:</strong>{" "}
              {dustData.absolute_power_drop_watts / 10} W
            </p>
          </div>
        ) : (
          <p className="text-red-500">Failed to load data.</p>
        )}
      </div>
    </>
  );
};

export default DustDepositionPage;
