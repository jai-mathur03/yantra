import 'package:flutter/material.dart';
import 'package:yantra_blackspace/models/forecast_data.dart';
import 'package:yantra_blackspace/services/api_service.dart';
import 'package:fl_chart/fl_chart.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  late Future<ForecastModel> forecastFuture;
  final TextEditingController latController =
      TextEditingController(text: '12.97');
  final TextEditingController lonController =
      TextEditingController(text: '77.59');
  final TextEditingController dateController =
      TextEditingController(text: '2025-02-08');
  final TextEditingController panelSizeController =
      TextEditingController(text: '1.6');

  @override
  void initState() {
    super.initState();
    fetchForecastData();
  }

  void fetchForecastData() {
    setState(() {
      ApiService apiService = ApiService();
      forecastFuture = apiService.fetchForecast(
        latitude: double.parse(latController.text),
        longitude: double.parse(lonController.text),
        startDate: dateController.text,
        panelArea: double.parse(panelSizeController.text),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        elevation: 0,
        title: const Text('Predicted Energy Output',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: latController,
              decoration: InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: lonController,
              decoration: InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Start Date (YYYY-MM-DD)'),
            ),
            TextField(
              controller: panelSizeController,
              decoration: InputDecoration(labelText: 'Panel Size (sq. meters)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchForecastData,
              child: const Text('Update Chart'),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: FutureBuilder<ForecastModel>(
                future: forecastFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return _buildLineChart(snapshot.data!);
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(ForecastModel forecast) {
    List<FlSpot> spots = forecast.dailyForecasts.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.energyGeneration);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              // getTitlesWidget: (value, meta) {
              //   const days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
              //   return Text(days[value.toInt() % 7]);
              // },
              reservedSize: 22,
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: forecast.dailyForecasts.length.toDouble() - 1,
        minY: 0,
        maxY: forecast.dailyForecasts
            .map((e) => e.energyGeneration)
            .reduce((a, b) => a > b ? a : b),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.orange[400],
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData:
                BarAreaData(show: true, color: Colors.orange.withOpacity(0.3)),
          ),
        ],
      ),
    );
  }
}

Widget _buildEnergyCard({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.orange[50],
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.orange.withOpacity(0.2),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    ),
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 40, color: Colors.orange[400]),
        Text(label),
        Text(value, style: TextStyle(color: Colors.orange[400])),
      ],
    ),
  );
}

// import 'package:flutter/material.dart';
// import 'package:yantra_blackspace/models/forecast_data.dart';
// import 'package:yantra_blackspace/services/api_service.dart';
// import 'package:fl_chart/fl_chart.dart';

// class DataScreen extends StatefulWidget {
//   const DataScreen({Key? key}) : super(key: key);

//   @override
//   _DataScreenState createState() => _DataScreenState();
// }

// class _DataScreenState extends State<DataScreen> {
//   late Future<ForecastModel> forecastFuture;

//   @override
//   void initState() {
//     super.initState();
//     ApiService apiService = ApiService();
//     forecastFuture = apiService.fetchForecast(
//       latitude: 12.97,
//       longitude: 77.59,
//       startDate: '2025-02-08',
//       panelArea: 1.6,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.orange[400],
//         elevation: 0,
//         title: const Text('Predicted Energy Output',
//             style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text('Following week'),
//                 // TextButton(
//                 //     onPressed: () {
//                 //       print(forecastFuture);
//                 //     },
//                 //     child: Text('Fetch data')),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               flex: 2,
//               child: FutureBuilder<ForecastModel>(
//                 future: forecastFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (snapshot.hasData) {
//                     return _buildLineChart(snapshot.data!);
//                   } else {
//                     return Center(child: Text('No data available'));
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               flex: 3,
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 16.0,
//                 crossAxisSpacing: 16.0,
//                 childAspectRatio: 1.5,
//                 children: [
//                   _buildEnergyCard(
//                     icon: Icons.ac_unit,
//                     label: 'Air-Conditioning',
//                     value: '126 kw/h',
//                   ),
//                   _buildEnergyCard(
//                     icon: Icons.videocam,
//                     label: 'CCTV',
//                     value: '42.5 kw/h',
//                   ),
//                   _buildEnergyCard(
//                     icon: Icons.tv,
//                     label: 'Smart TV',
//                     value: '12 kw/h',
//                   ),
//                   _buildEnergyCard(
//                     icon: Icons.computer,
//                     label: 'Computer',
//                     value: '30.25 kw/h',
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLineChart(ForecastModel forecast) {
//     List<FlSpot> spots = [];
//     for (int i = 0; i < forecast.dailyForecasts.length; i++) {
//       spots.add(
//           FlSpot(i.toDouble(), forecast.dailyForecasts[i].energyGeneration));
//     }

//     return LineChart(
//       LineChartData(
//         gridData: FlGridData(show: false),
//         titlesData: FlTitlesData(
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 const days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
//                 return Text(days[value.toInt() % 7]);
//               },
//               reservedSize: 22,
//             ),
//           ),
//           leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         ),
//         borderData: FlBorderData(show: false),
//         minX: 0,
//         maxX: forecast.dailyForecasts.length.toDouble() - 1,
//         minY: 0,
//         maxY: forecast.dailyForecasts
//             .map((e) => e.energyGeneration)
//             .reduce((a, b) => a > b ? a : b),
//         lineBarsData: [
//           LineChartBarData(
//             spots: spots,
//             isCurved: true,
//             color: Colors.orange[400],
//             barWidth: 3,
//             isStrokeCapRound: true,
//             dotData: FlDotData(show: false),
//             belowBarData:
//                 BarAreaData(show: true, color: Colors.orange.withOpacity(0.3)),
//           ),
//         ],
//       ),
//     );
//   }
