import 'dart:isolate';
import 'package:geolocator/geolocator.dart';

void calculateDistanceIsolate(SendPort sendPort) {
  final port = ReceivePort();
  sendPort.send(port.sendPort);

  port.listen((message) {
    final double userLat = message['userLat'];
    final double userLng = message['userLng'];
    final double activeLat = message['activeLat'];
    final double activeLng = message['activeLng'];
    final SendPort replyTo = message['replyTo'];

    final double distance = Geolocator.distanceBetween(
      userLat,
      userLng,
      activeLat,
      activeLng,
    );

    replyTo.send(distance);
  });
}
