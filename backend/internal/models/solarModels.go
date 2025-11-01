package models

import "github.com/google/uuid"

type SolarInput struct {
	ID               uuid.UUID `json:"id"`
	PanelArea        uint      `json:"panel_area"`
	EfficiencyRating uint      `json:"efficiency_rating"`
	PanelAge         uint      `json:"panel_age"` //in years
}

//Efficiency rating:
// Polycrystalline	13-16%
// Monocrystalline	18-24%
// Thin-film			7-13%
// Transparent	1-10%
// Solar tiles	10-20%
// Perovskite	24-27%
