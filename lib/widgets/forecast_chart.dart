import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../services/weather_forecast.dart';

class ForecastChart extends StatelessWidget {
  final List<ForecastPoint> forecastData;

  const ForecastChart({Key? key, required this.forecastData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spots = forecastData
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.temperature))
        .toList();

    final lineChartBarData = LineChartBarData(
      spots: spots,
      isCurved: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      barWidth: 2,
      color: Colors.blue,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: forecastData.length * 60,
        height: 250,
        child: LineChart(
          LineChartData(
            lineBarsData: [lineChartBarData],
            minY: forecastData.map((e) => e.temperature).reduce((a, b) => a < b ? a : b) - 2,
            maxY: forecastData.map((e) => e.temperature).reduce((a, b) => a > b ? a : b) + 2,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
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
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: true),
            showingTooltipIndicators: List.generate(
              spots.length,
                  (index) => ShowingTooltipIndicators([
                LineBarSpot(
                  lineChartBarData,
                  0,
                  spots[index],
                ),
              ]),
            ),
            lineTouchData: LineTouchData(
              enabled: true,
              handleBuiltInTouches: false, 
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.white.withOpacity(0.9),
                tooltipRoundedRadius: 6,
                tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${spot.y.toStringAsFixed(1)}°C',
                    const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
            ),

          ),
        ),
      ),
    );
  }
}
