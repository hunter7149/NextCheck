import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class ParticipantDistance {
  final String id;
  final double lat;
  final double lng;
  final double distance;

  ParticipantDistance({
    required this.id,
    required this.lat,
    required this.lng,
    required this.distance,
  });
}

List<ParticipantDistance> calculateDistances(Map<String, dynamic> args) {
  final List<Map<String, dynamic>> participants =
      (args['participants'] as List).cast<Map<String, dynamic>>();
  final double activeLat = args['activeLat'];
  final double activeLng = args['activeLng'];

  return participants.map((p) {
    final distance = Geolocator.distanceBetween(
      p['lat'] as double,
      p['lng'] as double,
      activeLat,
      activeLng,
    );
    return ParticipantDistance(
      id: p['id'] as String,
      lat: p['lat'] as double,
      lng: p['lng'] as double,
      distance: distance,
    );
  }).toList();
}
