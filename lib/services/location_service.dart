import 'package:flutter/foundation.dart'; // Necesario para debugPrint
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static const _cacheLatKey = 'cached_latitude';
  static const _cacheLonKey = 'cached_longitude';
  static const _cacheTimeKey = 'cached_location_time';
  static const _cacheDurationMinutes = 15;

  Future<Position> getCurrentLocation() async {
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();

    final cachedLat = prefs.getDouble(_cacheLatKey);
    final cachedLon = prefs.getDouble(_cacheLonKey);
    final cachedTimeStr = prefs.getString(_cacheTimeKey);

    if (cachedTimeStr != null && cachedLon != null && cachedLat != null) {
      final cachedTime = DateTime.parse(cachedTimeStr);

      if (now.difference(cachedTime).inMinutes < _cacheDurationMinutes) {
        return Position(
          longitude: cachedLon,
          latitude: cachedLat,
          timestamp: cachedTime,
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }
    }

    //if invalid cache, obtain a new one
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Los servicios de ubicación no están habilitados.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Permiso de ubicación denegado.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Permiso de ubicación denegado de forma permanente.");
    }

    try {
        Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      //save the location into cache
      await prefs.setDouble(_cacheLatKey, position.latitude);
      await prefs.setDouble(_cacheLonKey, position.longitude);
      await prefs.setString(_cacheTimeKey, now.toIso8601String());

      return position;
    } catch (e) {
      rethrow;
    }
  }
}
