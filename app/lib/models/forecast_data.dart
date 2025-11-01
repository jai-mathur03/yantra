// forecast_data.dart
class ForecastModel {
  final List<DailyForecast> dailyForecasts;

  ForecastModel({required this.dailyForecasts});

  factory ForecastModel.fromJson(List<dynamic> json) {
    try {
      List<DailyForecast> dailyForecastList = json.map((i) {
        if (i == null) {
          throw FormatException('Null forecast entry found in JSON data');
        }
        return DailyForecast.fromJson(i as Map<String, dynamic>);
      }).toList();

      return ForecastModel(dailyForecasts: dailyForecastList);
    } catch (e) {
      throw FormatException('Error parsing ForecastModel: $e');
    }
  }
}

// class DailyForecast {
//   final DateTime date; // ✅ Ensure it's DateTime
//   final double energyGeneration;

//   DailyForecast({required this.date, required this.energyGeneration});

//   factory DailyForecast.fromJson(Map<String, dynamic> json) {
//     return DailyForecast(
//       date: DateTime.parse(json['timestamp']), // ✅ Convert String to DateTime
//       energyGeneration: json['energyGeneration'].toDouble(),
//     );
//   }
// }

class DailyForecast {
  final String date;
  final double energyGeneration;

  DailyForecast({
    required this.date,
    required this.energyGeneration,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    if (json['timestamp'] == null) {
      throw FormatException('Date field is missing or null');
    }

    if (json['predicted_energy_Wh'] == null) {
      throw FormatException('Predicted energy field is missing or null');
    }

    return DailyForecast(
      date: json['timestamp'].toString(),
      energyGeneration: (json['predicted_energy_Wh'] is int)
          ? json['predicted_energy_Wh'].toDouble()
          : double.parse(json['predicted_energy_Wh'].toString()),
    );
  }
}
