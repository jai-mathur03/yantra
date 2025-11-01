package controllers

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"

	"github.com/Oik17/yantra-hack/internal/utils"
	"github.com/labstack/echo/v4"
)

func WeatherController(c echo.Context) error {
	key := utils.Config("WEATHER_API_KEY")
	url := utils.Config("WEATHER_API_URL")
	q := c.QueryParam("q") 

	if q == "" {
		return c.JSON(http.StatusBadRequest, map[string]string{
			"error": "Parameter 'q' is required",
		})
	}

	apiURL := fmt.Sprintf("%s?key=%s&q=%s", url, key, q)

	resp, err := http.Get(apiURL)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"error": "Failed to fetch weather data",
		})
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"error": "Failed to read response body",
		})
	}

	var weatherData map[string]interface{}
	if err := json.Unmarshal(body, &weatherData); err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"error": "Failed to parse JSON",
		})
	}

	return c.JSON(http.StatusOK, weatherData)
}
