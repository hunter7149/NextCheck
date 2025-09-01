import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:next_check/app/Widgets/customwidgets.dart';
import 'package:next_check/app/data/strings/appstring.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CheckinController extends GetxController with WidgetsBindingObserver {
  // Map controller
  late Completer<GoogleMapController> gcontroller =
      Completer<GoogleMapController>();
  Rx<CameraPosition?> initialCameraPosition = Rx<CameraPosition?>(null);
  RxBool isMapLoading = true.obs;

  // User location
  RxDouble lattitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString address = "".obs;
  RxBool isLocationLoading = false.obs;

  // Participant logic
  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Circle> circles = <Circle>{}.obs;
  RxInt liveCount = 0.obs;
  RxBool isCheckedIn = false.obs;
  LatLng? activePointLocation;
  double activeRadius = 0.0;
  RxDouble distanceFromActive = 0.0.obs; // Distance in meters

  StreamSubscription<DocumentSnapshot>? activePointSubscription;
  StreamSubscription<QuerySnapshot>? checkinCountSubscription;
  StreamSubscription<Position>? positionStream;

  // ---------------- Lifecycle ----------------
  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    await requestMap();
    _listenActiveCheckinPoint();
    _listenLiveCheckinCount();
    _startForegroundLocationStream();
    _checkActivePointOnStartup();
  }

  @override
  void onClose() {
    activePointSubscription?.cancel();
    checkinCountSubscription?.cancel();
    positionStream?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  // ---------------- Location Methods ----------------
  Future<void> permissionchecker() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      await getlocation();
    } else {
      await userconsent();
    }
  }

  RxBool cameraMovedToActivePoint = false.obs;
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
      print(e);
      lattitude.value = 0.0;
      longitude.value = 0.0;
    }
    isLocationLoading(false);

    address.value = "${lattitude.value},${longitude.value}";

    // Move camera **only once** to active point
    if (activePointLocation != null && !cameraMovedToActivePoint.value) {
      final GoogleMapController mapController = await gcontroller.future;
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: activePointLocation!, zoom: 15.0),
        ),
      );
      cameraMovedToActivePoint.value = true;
    }

    _updateDistanceFromActive();
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
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                ZoomTapAnimation(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Icon(
                        Icons.close,
                        color: Colors.red.shade800,
                        size: 20,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ],
            ),
            content: Container(
              height: MediaQuery.of(Get.context!).size.height / 1.5,
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Center(
                  child: Text(
                    Appstring.prominentDisclosure,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
            actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                        child: Text(
                          "Decline",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
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
                        child: Text(
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

  // ---------------- Participant logic ----------------
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

          // Marker for active check-in point
          markers.value = {
            Marker(
              markerId: const MarkerId('active_point'),
              position: activePointLocation!,
              infoWindow: const InfoWindow(title: 'Active Check-in Point'),
            ),
          };

          // Circle showing radius
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

          _updateDistanceFromActive();
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

  double _distanceToActivePoint() {
    if (activePointLocation == null) return double.infinity;
    return Geolocator.distanceBetween(
      lattitude.value,
      longitude.value,
      activePointLocation!.latitude,
      activePointLocation!.longitude,
    );
  }

  void _updateDistanceFromActive() {
    distanceFromActive.value = _distanceToActivePoint();
  }

  Future<void> checkIn() async {
    _updateDistanceFromActive();
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
    });
    isCheckedIn.value = true;
    CustomWidget.successAlert2(message: "Checked in successfully");
  }

  Future<void> autoCheckOut() async {
    _updateDistanceFromActive();
    if (!isCheckedIn.value) return;
    if (distanceFromActive.value > activeRadius) {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('checkins').doc(uid).update({
        'isActive': false,
      });
      isCheckedIn.value = false;
      // Get.snackbar('Info', 'You have been automatically checked out.');
      CustomWidget.successAlert2(
        message: 'You have been automatically checked out.',
      );
    }
  }

  void _startForegroundLocationStream() {
    positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        ).listen((position) {
          lattitude.value = position.latitude;
          longitude.value = position.longitude;
          _updateDistanceFromActive();
          autoCheckOut();
        });
  }

  void _checkActivePointOnStartup() async {
    await getlocation();
    _updateDistanceFromActive();
    autoCheckOut();
  }

  requestMap() async {
    await permissionchecker();
    await getlocation();
    isMapLoading(false);
  }
}
