import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Worker function (must be a top-level or static function)
double calculateDistance(Map<String, double> coords) {
  return Geolocator.distanceBetween(
    coords['userLat']!,
    coords['userLng']!,
    coords['activeLat']!,
    coords['activeLng']!,
  );
}

/// Call this instead of manual isolate
Future<double> calculateDistanceInIsolate({
  required double userLat,
  required double userLng,
  required double activeLat,
  required double activeLng,
}) async {
  return await compute(calculateDistance, {
    'userLat': userLat,
    'userLng': userLng,
    'activeLat': activeLat,
    'activeLng': activeLng,
  });
}
