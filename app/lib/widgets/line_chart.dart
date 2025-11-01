import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:yantra_blackspace/constants.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

Widget buildChart(
    List<List<double>> solarDataList, int startIndex, int endIndex) {
  List<FlSpot> powerData = [];
  //
  // solarDataList[0] = Solarvalues;
  for (int i = 0; i < 96; i++) {
    double hour = i / 4; // Convert 15-minute intervals to hours
    powerData.add(FlSpot(hour, solarDataList[0][startIndex + i].toDouble()));
  }

  return Container(
    height: 250,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return Text('12 AM',
                        style: TextStyle(color: textDark, fontSize: 12));
                  case 6:
                    return Text('6 AM',
                        style: TextStyle(color: textDark, fontSize: 12));
                  case 12:
                    return Text('12 PM',
                        style: TextStyle(color: textDark, fontSize: 12));
                  case 18:
                    return Text('6 PM',
                        style: TextStyle(color: textDark, fontSize: 12));
                  case 24:
                    return Text('12 AM',
                        style: TextStyle(color: textDark, fontSize: 12));
                  default:
                    return Text('');
                }
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 24,
        lineBarsData: [
          LineChartBarData(
            spots: powerData,
            isCurved: true,
            color: primaryOrange,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: primaryOrange.withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            // tooltipBgColor: Colors.blueAccent,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                final time = DateFormat('h:mm a').format(DateTime(
                    2022, 1, 1, flSpot.x.toInt(), (flSpot.x % 1 * 60).toInt()));
                return LineTooltipItem(
                  '${time}\n${flSpot.y.toInt()} W',
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),
      ),
    ),
  );
}
