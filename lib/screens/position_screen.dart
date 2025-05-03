import 'package:flutter/material.dart';
import 'package:app_climatica/widgets/weather_card.dart';
import 'package:app_climatica/widgets/forecast_chart.dart';
import 'package:app_climatica/services/location_service.dart';
import 'package:app_climatica/services/weather_service.dart';
import 'package:app_climatica/services/weather.dart';

import '../services/weather_forecast.dart';

class LocationInformationScreen extends StatefulWidget {
  const LocationInformationScreen({Key? key}) : super(key: key);

  @override
  _LocationInformationScreenState createState() => _LocationInformationScreenState();
}

class _LocationInformationScreenState extends State<LocationInformationScreen>
    with AutomaticKeepAliveClientMixin {
  Weather? _weatherData;
  List<ForecastPoint>? _forecastData;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final position = await LocationService().getCurrentLocation();
      print(position);
      final weather = await WeatherService().fetchWeatherByLocation(position);
      final forecast = await WeatherService().fetchForecastByLocation(position);

      setState(() {
        _weatherData = weather;
        _forecastData = forecast;
      });
    } catch (e, stacktrace) {
      debugPrint("[ERROR] $e\n$stacktrace");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_weatherData == null || _forecastData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Clima')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            WeatherCard(weather: _weatherData!),
            const SizedBox(height: 24),
            Text(
              "Próximas horas",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ForecastChart(forecastData: _forecastData!,),
            ),
          ],
        ),
      ),
    );
  }
}
