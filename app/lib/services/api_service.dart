import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yantra_blackspace/models/forecast_data.dart';
import '../models/solar_data.dart';

class ApiService {
  final String baseUrlSolarActual =
      'https://coding-relay-be.onrender.com/solar/csv';
  final String baseUrlSolarPredicted =
      'https://yantrahack.onrender.com/forecast';

  List<List<double>> solarDataList =
      []; // Declare a global or class-level variable

  Future<SolarData?> fetchSolarData() async {
    try {
      final response = await http.get(Uri.parse(baseUrlSolarActual));

      if (response.statusCode == 200 || response.statusCode == 202) {
        final jsonData = jsonDecode(response.body);

        // Store data in the list variable
        solarDataList = (jsonData['data'] as List<dynamic>)
            .map((innerList) => (innerList as List<dynamic>)
                .map((item) => item as double)
                .toList())
            .toList();

        // print('Stored Solar Data: $solarDataList'); // Print stored data

        return SolarData(
            data: solarDataList, message: "Received", status: true);
      } else {
        throw Exception(
            'Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
    }
  }

  Future<ForecastModel> fetchForecast({
    required double latitude,
    required double longitude,
    required String startDate,
    required double panelArea,
  }) async {
    final Uri uri = Uri.parse(baseUrlSolarPredicted).replace(queryParameters: {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'start_date': startDate,
      'panel_area': panelArea.toString(),
    });

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final String responseBody = response.body;
        if (responseBody.isEmpty) {
          throw Exception('Empty response received from server');
        }

        final dynamic decodedData = json.decode(responseBody);
        if (decodedData is! List) {
          throw FormatException(
              'Expected JSON array but got ${decodedData.runtimeType}');
        }

        return ForecastModel.fromJson(decodedData);
      } else {
        throw Exception(
            'Failed to load forecast. Status code: ${response.statusCode}. Response: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching forecast: $e');
    }
  }
}
