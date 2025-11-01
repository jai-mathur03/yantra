package services

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/Oik17/yantra-hack/internal/models"
)

func SendSolarData(url string, data models.SolarInput) error {
	payload := struct {
		PanelArea        uint `json:"panel_area"`
		EfficiencyRating uint `json:"efficiency_rating"`
		PanelAge         uint `json:"panel_age"`
	}{
		PanelArea:        data.PanelArea,
		EfficiencyRating: data.EfficiencyRating,
		PanelAge:         data.PanelAge,
	}

	jsonData, err := json.Marshal(payload)
	if err != nil {
		return fmt.Errorf("error marshaling JSON: %v", err)
	}

	client := &http.Client{Timeout: 10 * time.Second}

	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonData))
	if err != nil {
		return fmt.Errorf("error creating request: %v", err)
	}

	req.Header.Set("Content-Type", "application/json")

	resp, err := client.Do(req)
	if err != nil {
		return fmt.Errorf("error sending request: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK && resp.StatusCode != http.StatusCreated {
		return fmt.Errorf("unexpected response status: %d", resp.StatusCode)
	}

	fmt.Println("Request successful with status:", resp.Status)
	return nil
}