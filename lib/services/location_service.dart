import 'package:flutter/foundation.dart'; // Necesario para debugPrint
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    debugPrint("[LocationService] Verificando si los servicios de ubicación están habilitados...");
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("[LocationService] ❌ Los servicios de ubicación están desactivados.");
      throw Exception("Los servicios de ubicación no están habilitados.");
    }
    debugPrint("[LocationService] ✅ Servicios de ubicación habilitados.");

    debugPrint("[LocationService] Comprobando permisos...");
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      debugPrint("[LocationService] ⚠️ Permiso denegado, solicitando...");
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        debugPrint("[LocationService] ❌ Permiso de ubicación denegado después de solicitar.");
        throw Exception("Permiso de ubicación denegado.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("[LocationService] ❌ Permiso de ubicación denegado permanentemente.");
      throw Exception("Permiso de ubicación denegado de forma permanente.");
    }

    debugPrint("[LocationService] ✅ Permisos concedidos. Obteniendo ubicación...");

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      debugPrint("[LocationService] 📍 Ubicación obtenida: (${position.latitude}, ${position.longitude})");
      return position;
    } catch (e) {
      debugPrint("[LocationService] ❌ Error al obtener la ubicación: $e");
      rethrow;
    }
  }
}
