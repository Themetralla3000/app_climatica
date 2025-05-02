import 'package:app_climatica/widgets/weather_card.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather.dart';
import '../services/weather_service.dart';

class LocationInformationScreen extends StatefulWidget {
  const LocationInformationScreen({Key? key}) : super(key: key);

  @override
  _LocationInformationScreenState createState() => _LocationInformationScreenState();
}

class _LocationInformationScreenState extends State<LocationInformationScreen>
    with AutomaticKeepAliveClientMixin {

  Weather? _weatherData;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final weather = await WeatherService().fetchWeatherByLocation(position);

      setState(() {
        _weatherData = weather;
      });
    } catch (e, stacktrace) {

      debugPrint("[WEATHER ERROR] $stacktrace");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ CORRECTO para usar AutomaticKeepAliveClientMixin
    return Scaffold(
      appBar: AppBar(title: const Text('Clima')),
      body: _weatherData == null
          ? const Center(child: CircularProgressIndicator())
          : WeatherCard(weather: _weatherData!),
    );
  }
}
