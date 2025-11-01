"use client";

import axios from "axios";
import { useEffect, useState } from "react";
import { Line } from "react-chartjs-2";
import {
  Chart as ChartJS,
  LineElement,
  CategoryScale,
  LinearScale,
  PointElement,
  Tooltip,
  Legend,
} from "chart.js";
import Navbar from "@/components/navbar";
import Link from "next/link";

ChartJS.register(
  LineElement,
  CategoryScale,
  LinearScale,
  PointElement,
  Tooltip,
  Legend
);

const SolarPage = () => {
  const [chartData, setChartData] = useState<{
    labels: string[];
    datasets: {
      label: string;
      data: number[];
      borderColor: string;
      borderWidth: number;
      backgroundColor: string;
      tension: number;
    }[];
  } | null>(null);

  const [latitude, setLatitude] = useState<number | null>(null);
  const [longitude, setLongitude] = useState<number | null>(null);
  // const [groupedForecastData, setGroupedForecastData] = useState<{
  //   [key: string]: number[];
  // }>({});

  // const intervalCount = 24;
  const staticLabels = [
    "0:00",
    "0:15",
    "0:30",
    "0:45",
    "1:00",
    "1:15",
    "1:30",
    "1:45",
    "2:00",
    "2:15",
    "2:30",
    "2:45",
    "3:00",
    "3:15",
    "3:30",
    "3:45",
    "4:00",
    "4:15",
    "4:30",
    "4:45",
    "5:00",
    "5:15",
    "5:30",
    "5:45",
    "6:00",
    "6:15",
    "6:30",
    "6:45",
    "7:00",
    "7:15",
    "7:30",
    "7:45",
    "8:00",
    "8:15",
    "8:30",
    "8:45",
    "9:00",
    "9:15",
    "9:30",
    "9:45",
    "10:00",
    "10:15",
    "10:30",
    "10:45",
    "11:00",
    "11:15",
    "11:30",
    "11:45",
    "12:00",
    "12:15",
    "12:30",
    "12:45",
    "13:00",
    "13:15",
    "13:30",
    "13:45",
    "14:00",
    "14:15",
    "14:30",
    "14:45",
    "15:00",
    "15:15",
    "15:30",
    "15:45",
    "16:00",
    "16:15",
    "16:30",
    "16:45",
    "17:00",
    "17:15",
    "17:30",
    "17:45",
    "18:00",
    "18:15",
    "18:30",
    "18:45",
    "19:00",
    "19:15",
    "19:30",
    "19:45",
    "20:00",
    "20:15",
    "20:30",
    "20:45",
    "21:00",
    "21:15",
    "21:30",
    "21:45",
    "22:00",
    "22:15",
    "22:30",
    "22:45",
    "23:00",
    "23:15",
    "23:30",
    "23:45",
  ];

  // Fetch user's geolocation
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
    if (latitude === null || longitude === null) return;

    // const intervalCount1 = 100;
    const fetchData = async () => {
      try {
        const [solarResponse, forecastResponse] = await Promise.all([
          axios.get("https://coding-relay-be.onrender.com/solar/csv"),
          axios.get("https://yantrahack.onrender.com/forecast", {
            params: {
              latitude,
              longitude,
              start_date: "2025-02-09",
              panel_area: 1.6,
            },
          }),
        ]);

        const processForecastData = (
          forecastData: {
            timestamp: string;
            predicted_energy_Wh: number;
            computed_energy_Wh: number;
          }[]
        ) => {
          return forecastData.reduce<number[]>(
            (acc, { predicted_energy_Wh }) => {
              acc.push(predicted_energy_Wh); // Convert efficiency to percentage
              return acc;
            },
            []
          );
        };

        const processForecastData2 = (
          forecastData: {
            timestamp: string;
            computed_energy_Wh: number;
          }[]
        ) => {
          return forecastData.reduce<number[]>(
            (acc, { computed_energy_Wh }) => {
              acc.push(computed_energy_Wh); // Convert efficiency to percentage
              return acc;
            },
            []
          );
        };

        const forecastData = processForecastData(forecastResponse.data);

        const forecastData2 = processForecastData2(forecastResponse.data);

        // Flatten all forecasted 24-hour data points into a single array
        const allForecastData = Object.values(forecastData).flat();

        // Solar Data Processing
        const solarData = solarResponse.data.data
          .slice(0, allForecastData.length) // Match forecast length
          .map((val: number) => val / 4);

        console.log(solarData, allForecastData);

        setChartData({
          labels: staticLabels.slice(0, allForecastData.length),
          datasets: [
            {
              label: "Solar Data",
              data: forecastData2,
              borderColor: "#ffa500",
              backgroundColor: "rgba(75, 192, 192, 0.2)",
              borderWidth: 2,
              tension: 0.4,
            },
            {
              label: "Predicted Solar Data",
              data: allForecastData,
              borderColor: "blue",
              backgroundColor: "rgba(255, 0, 0, 0.2)",
              borderWidth: 2,
              tension: 0.4,
            },
          ],
        });
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    };

    fetchData();
  });

  return (
    <>
      <Navbar />
      <div className="p-2">
        <div className="flex items-center justify-between px-4 text-3xl font-bold mt-20 mb-4 text-right">
          <h1>Solar Data</h1>
          <Link href="/dust-deposition">
            <span>Dust deposition</span>
          </Link>
        </div>
        <div className="w-full flex flex-col h-full bg-white p-1 rounded-lg shadow-lg">
          <div className="flex w-full h-fit">
            {chartData ? (
              <Line
                data={chartData}
                options={{
                  responsive: true,
                  plugins: { legend: { position: "top" } },
                }}
              />
            ) : (
              <p>Loading chart...</p>
            )}
          </div>
          <div className="w-full flex items-center justify-between"></div>
        </div>
      </div>
    </>
  );
};

export default SolarPage;
