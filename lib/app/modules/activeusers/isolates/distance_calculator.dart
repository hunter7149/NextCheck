import 'dart:isolate';

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

// Top-level function for isolate
void calculateDistances(SendPort sendPort) {
  final port = ReceivePort();
  sendPort.send(port.sendPort);

  port.listen((message) {
    final List<Map<String, dynamic>> participants = message['participants'];
    final double activeLat = message['activeLat'];
    final double activeLng = message['activeLng'];
    final SendPort replyTo = message['replyTo'];

    final List<ParticipantDistance> result = participants.map((p) {
      double distance = Geolocator.distanceBetween(
        p['lat'],
        p['lng'],
        activeLat,
        activeLng,
      );
      return ParticipantDistance(
        id: p['id'],
        lat: p['lat'],
        lng: p['lng'],
        distance: distance,
      );
    }).toList();

    replyTo.send(result);
  });
}
