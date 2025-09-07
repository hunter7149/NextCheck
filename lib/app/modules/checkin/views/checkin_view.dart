import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:next_check/app/Colors/appcolors.dart';
import 'package:next_check/app/Widgets/customwidgets.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/checkin_controller.dart';

class CheckinView extends GetView<CheckinController> {
  const CheckinView({super.key});

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 1.sh,
          width: 1.sw,
          decoration: BoxDecoration(
            gradient: AppColors.backGroundGradientBlack(),
          ),
          child: Obx(() {
            if (controller.initialCameraPosition.value == null ||
                controller.isMapLoading.value) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitDoubleBounce(color: Colors.white, size: 60.sp),
                  SizedBox(height: 10.h),
                  Text(
                    "Hold on while we load map..",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: isPortrait ? 16.sp : 8.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }

            return Stack(
              children: [
                Positioned.fill(
                  top: 0.h,
                  child: GoogleMap(
                    initialCameraPosition:
                        controller.initialCameraPosition.value!,
                    markers: controller.markers.value,
                    circles: controller.circles.value,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    onMapCreated: (mapController) {
                      if (!controller.gcontroller.isCompleted) {
                        controller.gcontroller.complete(mapController);
                      }
                    },
                  ),
                ),

                isPortrait
                    ? Positioned(
                        left: 20.w,
                        right: 20.w,
                        bottom: 20.h,
                        child: checkInSection(isPortrait: true),
                      )
                    : Positioned(
                        right: 20.w,
                        top: 20.h,
                        bottom: 20.h,
                        child: SizedBox(
                          width: 140.w,
                          child: checkInSection(isPortrait: false),
                        ),
                      ),

                Positioned(
                  top: 10.h,
                  left: 0.w,
                  child: CustomWidget.commonBackButton(
                    onTap: () async {
                      bool? confirm = await Get.dialog<bool>(
                        AlertDialog(
                          backgroundColor: Colors.black87,
                          title: const Text(
                            "Confirm",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            "Do you want to check out and leave?",
                            style: TextStyle(color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(result: false),
                              child: const Text(
                                "No",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Get.back(result: true),
                              child: const Text(
                                "Yes",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await controller.autoCheckOut();
                        Get.back();
                      }
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget checkInSection({required bool isPortrait}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: AppColors.backGroundGradientBlack(),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          isPortrait
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _activeCheckins(isPortrait),
                    _distanceStat(isPortrait),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _activeCheckins(isPortrait),
                    SizedBox(height: 20.h),
                    _distanceStat(isPortrait),
                  ],
                ),

          SizedBox(height: 10.h),

          Obx(
            () => ZoomTapAnimation(
              onTap: controller.isCheckedIn.value
                  ? null
                  : () async {
                      await controller.getlocation();
                      await controller.checkIn();
                    },
              child: Container(
                height: 50.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: controller.isCheckedIn.value
                      ? Colors.green
                      : Colors.black,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    controller.isCheckedIn.value ? 'Checked In' : 'Check In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isPortrait ? 14.sp : 8.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeCheckins(bool isPortrait) => Column(
    children: [
      Container(
        width: isPortrait ? 60.w : 40.w,
        height: isPortrait ? 50.w : 20.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.blue.shade900,
        ),
        child: Center(
          child: Text(
            "${controller.liveCount.value}",
            style: TextStyle(
              color: Colors.white,
              fontSize: isPortrait ? 16.sp : 8.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      SizedBox(height: 6.h),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline, color: Colors.white, size: 14),
          SizedBox(width: 4.w),
          Text(
            "Check-ins",
            style: TextStyle(
              color: Colors.white70,
              fontSize: isPortrait ? 14.sp : 8.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ],
  );

  Widget _distanceStat(bool isPortrait) => Column(
    children: [
      Container(
        width: isPortrait ? 60.w : 40.w,
        height: isPortrait ? 50.w : 20.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.blue.shade900,
        ),
        child: Center(
          child: Text(
            controller.distanceFromActive.value >= 1000
                ? "${(controller.distanceFromActive.value / 1000).toStringAsFixed(0)}"
                : "${controller.distanceFromActive.value.toStringAsFixed(0)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: isPortrait ? 14.sp : 8.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      SizedBox(height: 6.h),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.my_location, color: Colors.white, size: 14),
          SizedBox(width: 2.w),
          Text(
            controller.distanceFromActive.value >= 1000
                ? "Km away"
                : "Meters away",
            style: TextStyle(
              color: Colors.white70,
              fontSize: isPortrait ? 14.sp : 8.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ],
  );
}
