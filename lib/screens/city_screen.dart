import 'package:flutter/material.dart';
import '../services/weather.dart';
import '../services/weather_service.dart';
import '../widgets/weather_card.dart';

class CityInformationScreen extends StatefulWidget {
  const CityInformationScreen({super.key});

  @override
  State<CityInformationScreen> createState() => _CityInformationScreenState();
}

class _CityInformationScreenState extends State<CityInformationScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _controller = TextEditingController();

  Future<Weather>? _weatherFuture;
  String _currentCity = "Barcelona";

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  void _loadWeather() {
    setState(() {
      _weatherFuture = _weatherService.fetchWeatherByCity(_currentCity);
    });
  }

  void _searchCity() {
    final city = _controller.text.trim();
    if (city.isNotEmpty) {
      setState(() {
        _currentCity = city;
        _loadWeather();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiempo Actual'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Buscar ciudad...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _searchCity(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchCity,
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<Weather>(
              future: _weatherFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return WeatherCard(weather: snapshot.data!);
                } else {
                  return const Center(child: Text('No hay datos disponibles'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
