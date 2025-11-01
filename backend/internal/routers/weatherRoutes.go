package routes

import (
	"github.com/Oik17/yantra-hack/internal/controllers"
	"github.com/labstack/echo/v4"
)

func WeatherRoutes(e *echo.Echo) {
	r := e.Group("/weather")
	r.GET("/getWeather", controllers.WeatherController)
}
