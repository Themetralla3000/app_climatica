import 'package:flutter/material.dart';
import '../services/weather.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Card(
      elevation: 6,
      color: Colors.black12,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(

          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              weather.city,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Column(
                  children:[
                    const SizedBox(height: 8),
                    Image.network(
                      'https://openweathermap.org/img/wn/${weather.iconCode}@2x.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      weather.description[0].toUpperCase() + weather.description.substring(1),
                      style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  ]

                ),

                Text(
                  '${weather.temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w500),
                ),

              ]
            ),




            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoTile(Icons.thermostat, 'Sensación', '${weather.feelsLike}°C'),
                _buildInfoTile(Icons.water_drop, 'Humedad', '${weather.humidity}%'),
                _buildInfoTile(Icons.air, 'Viento', '${weather.windSpeed} m/s'),

              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoTile(Icons.arrow_downward, 'Mín', '${weather.minTemp}°C'),

                _buildInfoTile(Icons.arrow_upward, 'Máx', '${weather.maxTemp}°C'),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.blueGrey),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
      ],
    );
  }
}
