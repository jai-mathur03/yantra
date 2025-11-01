package services

import (
	"fmt"

	"github.com/Oik17/yantra-hack/internal/database"
	"github.com/Oik17/yantra-hack/internal/models"
	"github.com/google/uuid"
)

func InputSolar(input models.SolarInput) error {
	db := database.DB.Db
	_, err := db.Exec(`INSERT INTO solar_inputs VALUES ($1, $2, $3, $4)`, uuid.New(), input.PanelArea, input.EfficiencyRating, input.PanelAge)
	if err != nil {
		return err
	}
	return nil
}

func GetAllSolar() ([]models.SolarInput, error) {
	// Initialize the DB connection
	db := database.DB.Db

	// Query to select all records from solar_inputs table
	rows, err := db.Query(`SELECT id, panel_area, efficiency_rating, panel_age FROM solar_inputs`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var solarInputs []models.SolarInput

	for rows.Next() {
		var solarInput models.SolarInput

		err := rows.Scan(&solarInput.ID, &solarInput.PanelArea, &solarInput.EfficiencyRating, &solarInput.PanelAge)
		if err != nil {
			return nil, fmt.Errorf("failed to scan row: %v", err)
		}

		solarInputs = append(solarInputs, solarInput)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("error while iterating rows: %v", err)
	}

	return solarInputs, nil
}
