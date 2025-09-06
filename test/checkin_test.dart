import 'package:flutter_test/flutter_test.dart';
import 'package:next_check/app/modules/checkin/controllers/checkin_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  late CheckinController controller;

  setUp(() {
    controller = CheckinController();
    // Setup an active point
    controller.activePointLocation = LatLng(23.777, 90.421);
    controller.activeRadius = 100; // meters
  });

  test('distance to active point calculates correctly', () {
    controller.lattitude.value = 23.776;
    controller.longitude.value = 90.420;
    double distance = controller.distanceToActivePoint();

    expect(distance, greaterThan(0));
  });

  test('distance to active point from specific coordinates', () {
    double distance = controller.distanceToActivePointFrom(23.776, 90.420);
    expect(distance, greaterThan(0));
    expect(distance, lessThan(200)); // within reasonable range
  });

  test('update distance sets distanceFromActive', () {
    controller.lattitude.value = 23.776;
    controller.longitude.value = 90.420;
    controller.updateDistanceFromActive();

    expect(controller.distanceFromActive.value, greaterThan(0));
  });
}
