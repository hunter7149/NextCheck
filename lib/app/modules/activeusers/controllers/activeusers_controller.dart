import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ActiveusersController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> activeParticipants =
      <Map<String, dynamic>>[].obs;

  void fetchActiveParticipants() {
    _firestore
        .collection("meta")
        .doc("active_checkin_point")
        .collection("participants")
        .where("isActive", isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
          activeParticipants.value = snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              "id": doc.id,
              "lat": data["lat"],
              "lng": data["lng"],
              "checkInTime": data["checkInTime"],
            };
          }).toList();
        });
  }

  @override
  void onInit() {
    super.onInit();
    fetchActiveParticipants();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
