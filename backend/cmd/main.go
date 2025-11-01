package main

import (
	"net/http"

	"github.com/Oik17/yantra-hack/internal/database"
	routes "github.com/Oik17/yantra-hack/internal/routers"
	"github.com/Oik17/yantra-hack/internal/utils"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	utils.PrintYantraBanner()
	database.Connect()
	e := echo.New()
	e.Use(middleware.LoggerWithConfig(middleware.LoggerConfig{
		Format: `{"time":"${time_custom}","remote_ip":"${remote_ip}",` +
			`"host":"${host}","method":"${method}","uri":"${uri}","user_agent":"${user_agent}",` +
			`"status":${status},"error":"${error}","latency":${latency},"latency_human":"${latency_human}"}` + "\n",
		CustomTimeFormat: "02/01/2006 15:04:05",
	}))

	e.Use(middleware.Recover())
	e.Use(middleware.CORS())

	e.GET("/ping", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{"message": "pong"})
	})

	routes.WeatherRoutes(e)
	routes.SolarRoutes(e)
	e.Start(":8080")
}
