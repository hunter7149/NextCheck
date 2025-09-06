import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:next_check/app/Widgets/customwidgets.dart';
import 'package:next_check/app/data/strings/appstring.dart';
import 'package:next_check/app/modules/checkin/isolate/checkin_isolate.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CheckinController extends GetxController with WidgetsBindingObserver {
  late Completer<GoogleMapController> gcontroller =
      Completer<GoogleMapController>();
  Rx<CameraPosition?> initialCameraPosition = Rx<CameraPosition?>(null);
  RxBool isMapLoading = true.obs;

  RxDouble lattitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString address = "".obs;
  RxBool isLocationLoading = false.obs;

  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Circle> circles = <Circle>{}.obs;
  RxInt liveCount = 0.obs;
  RxBool isCheckedIn = false.obs;
  LatLng? activePointLocation;
  double activeRadius = 0.0;
  RxDouble distanceFromActive = 0.0.obs;

  StreamSubscription<DocumentSnapshot>? activePointSubscription;
  StreamSubscription<QuerySnapshot>? checkinCountSubscription;
  StreamSubscription<Position>? positionStream;

  RxBool cameraMovedToActivePoint = false.obs;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    await requestMap();
    await validateUserCheckinStatus();

    _listenActiveCheckinPoint();
    _fetchUserCheckinStatus();
    _listenLiveCheckinCount();
    _startForegroundLocationStream();
  }

  @override
  void onClose() {
    activePointSubscription?.cancel();
    checkinCountSubscription?.cancel();
    positionStream?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  bool _screenIsActive = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _screenIsActive = state == AppLifecycleState.resumed;
  }

  Future<void> permissionchecker() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      await getlocation();
    } else {
      await userconsent();
    }
  }

  Future<void> getlocation() async {
    isLocationLoading(true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isLocationLoading(false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        isLocationLoading(false);
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      lattitude.value = position.latitude;
      longitude.value = position.longitude;
    } catch (e) {
      print("Location error: $e");
      lattitude.value = 0.0;
      longitude.value = 0.0;
    }
    isLocationLoading(false);

    address.value = "${lattitude.value},${longitude.value}";

    if (activePointLocation != null && !cameraMovedToActivePoint.value) {
      final GoogleMapController mapController = await gcontroller.future;
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: activePointLocation!, zoom: 15.0),
        ),
      );
      cameraMovedToActivePoint.value = true;
    }

    updateDistanceFromActive();
  }

  userconsent() {
    return Get.generalDialog(
      barrierDismissible: false,
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 4 * anim1.value,
          sigmaY: 4 * anim1.value,
        ),
        child: FadeTransition(child: child, opacity: anim1),
      ),
      pageBuilder: (ctx, anim1, anim2) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(textScaler: TextScaler.linear(1.0)),
        child: PopScope(
          canPop: false,
          child: AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 150, horizontal: 24),
            backgroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Prominent Disclosure for Next Check",
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ),
                ZoomTapAnimation(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: const Icon(Icons.close, color: Colors.red, size: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              height: MediaQuery.of(Get.context!).size.height / 1.5,
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Center(
                  child: Text(
                    Appstring.prominentDisclosure,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async => Get.back(),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Decline",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        Get.back();
                        await getlocation();
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Allow",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _listenActiveCheckinPoint() {
    activePointSubscription = FirebaseFirestore.instance
        .doc('meta/active_checkin_point')
        .snapshots()
        .listen((snapshot) {
          if (!snapshot.exists) return;
          final data = snapshot.data()!;
          activePointLocation = LatLng(
            (data['latitude'] as num).toDouble(),
            (data['longitude'] as num).toDouble(),
          );
          activeRadius = (data['radius'] as num).toDouble();

          markers.value = {
            Marker(
              markerId: const MarkerId('active_point'),
              position: activePointLocation!,
              infoWindow: const InfoWindow(title: 'Active Check-in Point'),
            ),
          };

          circles.value = {
            Circle(
              circleId: const CircleId('active_radius'),
              center: activePointLocation!,
              radius: activeRadius,
              fillColor: Colors.blueAccent.withOpacity(0.2),
              strokeColor: Colors.blueAccent,
              strokeWidth: 2,
            ),
          };

          initialCameraPosition.value = CameraPosition(
            target: activePointLocation!,
            zoom: 15.0,
          );

          updateDistanceFromActive();
        });
  }

  void _listenLiveCheckinCount() {
    checkinCountSubscription = FirebaseFirestore.instance
        .collection('checkins')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
          liveCount.value = snapshot.docs.length;
        });
  }

  double distanceToActivePoint() {
    if (activePointLocation == null) return double.infinity;
    return Geolocator.distanceBetween(
      lattitude.value,
      longitude.value,
      activePointLocation!.latitude,
      activePointLocation!.longitude,
    );
  }

  double distanceToActivePointFrom(double lat, double lng) {
    if (activePointLocation == null) return double.infinity;
    return Geolocator.distanceBetween(
      lat,
      lng,
      activePointLocation!.latitude,
      activePointLocation!.longitude,
    );
  }

  void updateDistanceFromActive() {
    distanceFromActive.value = distanceToActivePoint();
  }

  Future<void> checkIn() async {
    await getlocation();
    updateDistanceFromActive();

    if (distanceFromActive.value > activeRadius) {
      CustomWidget.errorAlert(
        title: "Sorry",
        message: 'You are outside the allowed radius!',
      );
      return;
    }

    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('checkins').doc(uid).set({
      'userId': uid,
      'checkedInAt': FieldValue.serverTimestamp(),
      'isActive': true,
      'lastLat': lattitude.value,
      'lastLng': longitude.value,
    }, SetOptions(merge: true));

    isCheckedIn.value = true;
    CustomWidget.successAlert2(message: "Checked in successfully");
  }

  autoCheckOut() async {
    print("Caling autocheckout");
    if (!isCheckedIn.value || !_screenIsActive) return;

    updateDistanceFromActive();
    if (distanceFromActive.value > activeRadius) {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('checkins').doc(uid).update({
        'isActive': false,
      });
      isCheckedIn.value = false;
      CustomWidget.successAlert2(
        message: 'You have been automatically checked out.',
      );
    }
  }

  Future<void> validateUserCheckinStatus() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userCheckinDoc = await FirebaseFirestore.instance
        .collection('checkins')
        .doc(uid)
        .get();

    if (!userCheckinDoc.exists) {
      isCheckedIn.value = false;
      return;
    }

    final data = userCheckinDoc.data() as Map<String, dynamic>;

    bool active = (data['isActive'] as bool?) ?? false;

    if (!active) {
      isCheckedIn.value = false;
      return;
    }

    double lastLat = (data['lastLat'] as num?)?.toDouble() ?? 0;
    double lastLng = (data['lastLng'] as num?)?.toDouble() ?? 0;

    double distance = distanceToActivePointFrom(lastLat, lastLng);

    Timestamp? checkedInAt = data['checkedInAt'] as Timestamp?;
    bool expired = false;
    if (checkedInAt != null) {
      expired = DateTime.now().difference(checkedInAt.toDate()).inHours > 12;
    } else {
      expired = false;
    }

    if (distance > activeRadius || expired) {
      await FirebaseFirestore.instance.collection('checkins').doc(uid).update({
        'isActive': false,
      });

      isCheckedIn.value = false;
    } else {
      isCheckedIn.value = true;

      lattitude.value = lastLat;
      longitude.value = lastLng;
      updateDistanceFromActive();
    }
  }

  void _startForegroundLocationStream() async {
    final receivePort = ReceivePort();
    await Isolate.spawn(calculateDistanceIsolate, receivePort.sendPort);
    final SendPort sendPort = await receivePort.first as SendPort;

    positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        ).listen((position) async {
          lattitude.value = position.latitude;
          longitude.value = position.longitude;

          final responsePort = ReceivePort();
          sendPort.send({
            'userLat': lattitude.value,
            'userLng': longitude.value,
            'activeLat': activePointLocation?.latitude ?? 0,
            'activeLng': activePointLocation?.longitude ?? 0,
            'replyTo': responsePort.sendPort,
          });

          distanceFromActive.value = await responsePort.first as double;

          autoCheckOut();
        });
  }

  void _checkActivePointOnStartup() async {
    await getlocation();
    updateDistanceFromActive();
    autoCheckOut();
  }

  Future<void> _fetchUserCheckinStatus() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('checkins')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        isCheckedIn.value = data['isActive'] ?? false;

        updateDistanceFromActive();
        if (distanceFromActive.value > activeRadius && isCheckedIn.value) {
          await autoCheckOut();
        }
      } else {
        isCheckedIn.value = false;
      }
    } catch (e) {
      print("Error fetching user check-in status: $e");
      isCheckedIn.value = false;
    }
  }

  Future<void> requestMap() async {
    await permissionchecker();
    await getlocation();
    isMapLoading(false);
  }
}
