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
      backgroundColor: Colors.black,
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: AppColors.backGroundGradientBlack(),
        ),
        child: Obx(() {
          if (controller.initialCameraPosition.value == null ||
              controller.isMapLoading.value) {
            return Center(
              child: SpinKitThreeBounce(
                color: Colors.white,
                size: isPortrait ? 60.sp : 40.sp,
              ),
            );
          }

          return Stack(
            children: [
              /// Google Map
              Positioned.fill(
                top: 20.h,
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

              /// Bottom info + button
              Positioned(
                bottom: 20.h,
                left: 20.w,
                right: 20.w,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        gradient: AppColors.backGroundGradientBlack(),

                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(10.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /// Active Check-ins
                          Column(
                            children: [
                              Container(
                                width: isPortrait ? 50.w : 30.w,
                                height: isPortrait ? 50.w : 30.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: Colors.blue.shade900,
                                ),
                                child: Center(
                                  child: Text(
                                    "${controller.liveCount.value}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isPortrait ? 20.sp : 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 6.h),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4.h),
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
                          ),

                          /// Distance
                          Column(
                            children: [
                              Container(
                                width: isPortrait ? 50.w : 30.w,
                                height: isPortrait ? 50.w : 30.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: Colors.blue.shade900,
                                ),
                                child: Center(
                                  child: Text(
                                    controller.distanceFromActive.value >= 1000
                                        ? "${(controller.distanceFromActive.value / 1000).toStringAsFixed(2)}"
                                        : "${controller.distanceFromActive.value.toStringAsFixed(0)}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isPortrait ? 20.sp : 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.my_location,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 2.h),
                                  Text(
                                    controller.distanceFromActive.value >= 1000
                                        ? "Km away"
                                        : "Meters away" + "from location",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: isPortrait ? 14.sp : 8.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // SizedBox(height: 16.h),

                    /// Check-in button
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
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.r),
                              bottomRight: Radius.circular(10.r),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              controller.isCheckedIn.value
                                  ? 'Checked In'
                                  : 'Check In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isPortrait ? 16.sp : 8.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Back Button
              Positioned(
                top: 50.h,
                left: 16.w,
                child: CustomWidget.commonBackButton(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
