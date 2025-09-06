import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_check/app/Widgets/customwidgets.dart';
import 'package:next_check/app/data/strings/appstring.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CreatepointController extends GetxController {
  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Circle> circles = <Circle>{}.obs;
  LatLng? selectedLocation;

  void setMarker(LatLng latLng) async {
    selectedLocation = latLng;

    markers.value = {
      Marker(
        markerId: MarkerId('active_point'),
        position: latLng,
        infoWindow: InfoWindow(title: 'Selected Check-in Point'),
      ),
    };

    circles.clear();

    if (gcontroller.isCompleted) {
      final GoogleMapController mapController = await gcontroller.future;
      mapController.animateCamera(CameraUpdate.newLatLng(latLng));
    }
  }

  TextEditingController radiusController = TextEditingController();
  late Completer<GoogleMapController> gcontroller =
      Completer<GoogleMapController>();
  Rx<CameraPosition?> initialCameraPosition = Rx<CameraPosition?>(null);
  RxBool isMapLoading = true.obs;
  RxDouble lattitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString address = "".obs;
  RxBool isLocationLoading = false.obs;

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
      print(e);
      lattitude.value = 0.0;
      longitude.value = 0.0;
    }
    isLocationLoading(false);

    address.value = "${lattitude.value},${longitude.value}";

    initialCameraPosition.value = CameraPosition(
      target: LatLng(lattitude.value, longitude.value),
      zoom: 12.0,
    );
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
                  onTap: () {
                    Get.back();
                  },
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
                      onTap: () async {
                        Get.back();
                      },
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

  void updateMapWithInitialPosition() async {
    if (initialCameraPosition.value != null && gcontroller.isCompleted) {
      final GoogleMapController mapController = await gcontroller.future;
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(initialCameraPosition.value!),
      );
    }
  }

  RxBool isLocationSetting = false.obs;

  Future<void> createActiveCheckinPoint(LatLng location, double radius) async {
    isLocationSetting(true);
    try {
      String hostId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.doc('meta/active_checkin_point').set({
        'hostId': hostId,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'radius': radius,
        'createdAt': FieldValue.serverTimestamp(),
        'active': true,
      });

      markers.value = {
        Marker(
          markerId: MarkerId('active_point'),
          position: location,
          infoWindow: InfoWindow(title: 'Active Check-in Point'),
        ),
      };

      circles.value = {
        Circle(
          circleId: CircleId('checkin_radius'),
          center: location,
          radius: radius,
          strokeWidth: 2,
          strokeColor: Colors.deepOrange,
          fillColor: Colors.deepOrange.withOpacity(0.2),
        ),
      };

      if (gcontroller.isCompleted) {
        final GoogleMapController mapController = await gcontroller.future;

        final bounds = LatLngBounds(
          southwest: LatLng(
            location.latitude - radius / 111000,
            location.longitude -
                radius / (111000 * (cos(location.latitude * pi / 180))),
          ),
          northeast: LatLng(
            location.latitude + radius / 111000,
            location.longitude +
                radius / (111000 * (cos(location.latitude * pi / 180))),
          ),
        );

        mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }

      CustomWidget.successAlert2(
        message: "Check-in point created successfully",
      );
    } catch (e) {
      CustomWidget.errorAlert(
        title: "Oops",
        message: "Failed to create check-in point",
      );
    }
    isLocationSetting(false);
  }

  requestMap() async {
    await permissionchecker();
    await getlocation();
    isMapLoading(false);
  }

  @override
  void onInit() async {
    super.onInit();
    await requestMap();
  }
}
