import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../services/weather_forecast.dart';

class ForecastChart extends StatelessWidget {
  final List<ForecastPoint> forecastData;

  const ForecastChart({Key? key, required this.forecastData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: forecastData.length * 60,
        height: 250,
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1, //number of tags per point
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < forecastData.length) {
                      final hour = forecastData[index].timestamp.hour.toString().padLeft(2, '0');
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('$hour h', style: const TextStyle(fontSize: 10)),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: forecastData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final point = entry.value;
                  return FlSpot(index.toDouble(), point.temperature);
                }).toList(),
                isCurved: true,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ),
            ],
            minY: forecastData.map((e) => e.temperature).reduce((a, b) => a < b ? a : b) - 2,
            maxY: forecastData.map((e) => e.temperature).reduce((a, b) => a > b ? a : b) + 2,
          ),
        ),
      ),
    );
  }
}
