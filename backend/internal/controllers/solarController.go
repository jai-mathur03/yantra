package controllers

import (
	"fmt"
	"log"
	"net/http"

	"github.com/Oik17/yantra-hack/internal/models"
	"github.com/Oik17/yantra-hack/internal/services"
	"github.com/Oik17/yantra-hack/internal/utils"
	"github.com/labstack/echo/v4"
)

//Panel area(size)
//Efficiency reating
//Age of panel

func SolarInput(c echo.Context) error {
	var input models.SolarInput
	if err := c.Bind(&input); err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{
			"message": "Failed to input",
			"data":    err.Error(),
			"status":  "false",
		})
	}

	err := services.InputSolar(input)
	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{
			"message": "Failed to input",
			"data":    err.Error(),
			"status":  "false",
		})
	}
	return c.JSON(http.StatusOK, map[string]string{
		"message": "Successfully updated data",
		"data":    "Successfully updated data",
		"status":  "True",
	})

}

func GetAllSolar(c echo.Context) error {
	solar, err := services.GetAllSolar()
	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{
			"message": "Failed to input",
			"data":    err.Error(),
			"status":  "false",
		})
	}
	return c.JSON(http.StatusOK, solar)

}

func CalcSolar(c echo.Context) error {
	var input struct {
		T      float64 `json:"t"`
		D      float64 `json:"D"`
		I      float64 `json:"I"`
		RH     float64 `json:"RH"`
		P      float64 `json:"P"`
		Prated float64 `json:"p_rated"`
	}
	if err := c.Bind(&input); err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{
			"message": "Bad input request",
			"data":    err.Error(),
			"status":  "false",
		})
	}
	log.Println(input.T, input.D, input.I, input.RH, input.P, input.Prated)
	Pactual := utils.EvaluateConstant(input.T, input.D, input.I, input.RH, input.P, input.Prated)
	log.Println(Pactual)
	return c.JSON(http.StatusOK, map[string]float64{
		"data": Pactual,
	})
}



func CSV(c echo.Context) error {
	// List of file paths
	filePaths := []string{
		"./public/realistic_panel_1_7days_sensor_data.csv",
		"./public/realistic_panel_2_7days_sensor_data.csv",
		"./public/realistic_panel_3_7days_sensor_data.csv",
		"./public/realistic_panel_4_7days_sensor_data.csv",
		"./public/realistic_panel_5_7days_sensor_data.csv",
		"./public/realistic_panel_6_7days_sensor_data.csv",
		"./public/realistic_panel_7_7days_sensor_data.csv",
		"./public/realistic_panel_8_7days_sensor_data.csv",
		"./public/realistic_panel_9_7days_sensor_data.csv",
		"./public/realistic_panel_10_7days_sensor_data.csv",
		
		
	}

	// Container to store all results
	var allResults [][]float64

	// Loop through each file
	for _, filePath := range filePaths {
		// Read CSV data
		data, err := utils.ReadCSV(filePath)
		if err != nil {
			log.Fatalf("Error reading %s: %v", filePath, err)
		}

		// Store results for this panel
		var panelResults []float64

		// Iterate over rows in CSV
		for i, row := range data {
			T, _ := utils.StringToFloat(row["Temperature (°C)"])
			D, _ := utils.StringToFloat(row["Dust (µg/m³)"])
			I, _ := utils.StringToFloat(row["Luminosity (lux)"])
			RH, _ := utils.StringToFloat(row["Humidity (%)"])
			P, _ := utils.StringToFloat(row["Pressure (hPa)"])
			Prated := 300.0 // Constant

			// Compute Pactual
			Pactual := utils.EvaluateConstant(T, D, I, RH, P, Prated) * (-1)
			panelResults = append(panelResults, Pactual)

			fmt.Printf("File: %s | Row %d: Pactual = %.2f\n", filePath, i+2, Pactual)
		}

		// Append panel results to overall result
		allResults = append(allResults, panelResults)
	}

	// Return results as array of arrays
	return c.JSON(http.StatusAccepted, map[string]interface{}{
		"message": "Successfully updated data",
		"data":    allResults,
		"status":  "true",
	})
}

//Efficiency=(p/(625*1.6))*100