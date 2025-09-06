import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:next_check/app/Widgets/customwidgets.dart';
import 'package:next_check/app/modules/activeusers/isolates/distance_calculator.dart';

class ActiveusersController extends GetxController {
  RxBool isParticipantLoading = true.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> activeParticipants =
      <Map<String, dynamic>>[].obs;

  RxDouble activeLat = 0.0.obs;
  RxDouble activeLng = 0.0.obs;

  void setActive(double lat, double lng) {
    activeLat.value = lat;
    activeLng.value = lng;
    fetchActiveParticipants(); // Re-fetch after active  changes
  }

  /// Fetch active participants once, then calculate distances in isolate
  Future<void> fetchActiveParticipants() async {
    isParticipantLoading(true);
    try {
      final snapshot = await _firestore
          .collection("checkins")
          .where("isActive", isEqualTo: true)
          .get();

      List<Map<String, dynamic>> participants = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final double? lat = (data["lastLat"] as num?)?.toDouble();
        final double? lng = (data["lastLng"] as num?)?.toDouble();

        DateTime? checkInTime;
        if (data["checkedInAt"] != null && data["checkedInAt"] is Timestamp) {
          checkInTime = (data["checkedInAt"] as Timestamp).toDate();
        }

        final String userId = data["userId"] ?? doc.id;
        final userDoc = await _firestore.collection("users").doc(userId).get();
        final String email =
            (userDoc.exists && userDoc.data()?["email"] != null)
            ? userDoc.data()!["email"]
            : userId;

        if (lat != null && lng != null) {
          participants.add({
            "id": doc.id,
            "lat": lat,
            "lng": lng,
            "checkInTime": checkInTime,
            "email": email,
          });
        }
      }

      // Compute distances in isolate
      final distances = await _computeParticipantDistances(
        participants,
        activeLat.value,
        activeLng.value,
      );

      // Merge distances into participants list
      activeParticipants.value = distances.map((d) {
        final original = participants.firstWhere((p) => p['id'] == d.id);
        return {
          "id": d.id,
          "lat": d.lat,
          "lng": d.lng,
          "distance": d.distance,
          "checkInTime": original['checkInTime'],
          "email": original['email'],
        };
      }).toList();

      activeParticipants.refresh();
      isParticipantLoading(false);
    } catch (e) {
      isParticipantLoading(false);
      print("Error fetching active participants: $e");
    }
  }

  Future<List<ParticipantDistance>> _computeParticipantDistances(
    List<Map<String, dynamic>> participants,
    double activeLat,
    double activeLng,
  ) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(calculateDistances, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;
    final responsePort = ReceivePort();

    sendPort.send({
      'participants': participants,
      'activeLat': activeLat,
      'activeLng': activeLng,
      'replyTo': responsePort.sendPort,
    });

    final result = await responsePort.first as List<ParticipantDistance>;
    return result;
  }

  @override
  void onInit() {
    super.onInit();
    fetchActiveParticipants();
  }
}
