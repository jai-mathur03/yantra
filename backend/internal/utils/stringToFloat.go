package utils

import (
	"strconv"
)

func StringToFloat(value string) (float64, error) {
	return strconv.ParseFloat(value, 64)
}
func FloatToString(value float64) string {
	return strconv.FormatFloat(value, 'f', -1, 64)
}
