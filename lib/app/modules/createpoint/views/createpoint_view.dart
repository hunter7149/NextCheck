import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:next_check/app/Colors/appcolors.dart';
import 'package:next_check/app/Widgets/customwidgets.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/createpoint_controller.dart';

class CreatepointView extends GetView<CreatepointController> {
  const CreatepointView({super.key});

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: BoxDecoration(
          gradient: AppColors.backGroundGradientBlack(),
        ),
        child: Obx(
          () => controller.initialCameraPosition.value == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitDoubleBounce(color: Colors.deepOrange, size: 60.sp),
                    SizedBox(height: 10.h),
                    Text(
                      "Hold on while we loading maps..",
                      style: GoogleFonts.poppins(
                        color: Colors.deepOrange,
                        fontSize: isPortrait ? 16.sp : 8.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Positioned(
                      top: 20.h,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: GoogleMap(
                        myLocationEnabled: true,
                        initialCameraPosition:
                            controller.initialCameraPosition.value!,
                        markers: controller.markers.value,
                        onTap: controller.setMarker,
                        onMapCreated: (controller.gcontroller.isCompleted
                            ? (_) {}
                            : (mapController) => controller.gcontroller
                                  .complete(mapController)),
                      ),
                    ),

                    /// Create Check-in Point Button
                    Positioned(
                      bottom: 20.h,
                      left: 20.w,
                      right: 20.w,
                      child: Obx(
                        () => controller.isLocationSetting.value
                            ? Container(
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(
                                  child: Text(
                                    "Creating..",
                                    style: GoogleFonts.poppins(
                                      color: Colors.deepOrange,
                                      fontSize: isPortrait ? 16.sp : 8.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            : ZoomTapAnimation(
                                onTap: () async {
                                  if (controller.selectedLocation == null) {
                                    CustomWidget.errorAlert(
                                      title: "Oops!",
                                      message:
                                          "Please select a location on the map first.To select location,tap on the place you want to make check in point",
                                    );
                                    return;
                                  }

                                  /// Show dialog to enter radius
                                  double? radius = await showDialog<double>(
                                    context: context,
                                    builder: (context) {
                                      final TextEditingController
                                      radiusController =
                                          TextEditingController();
                                      return AlertDialog(
                                        backgroundColor: Colors.black87,
                                        title: const Text(
                                          'Enter Radius (meters)',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: TextField(
                                          style: TextStyle(color: Colors.white),
                                          controller: radiusController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintStyle: TextStyle(
                                              color: Colors.white70,
                                            ),
                                            hintText:
                                                'Radius in meters (1 KM=1000 Meters)',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                    Colors.green,
                                                  ),
                                            ),
                                            onPressed: () {
                                              final value = double.tryParse(
                                                radiusController.text,
                                              );
                                              Navigator.of(context).pop(value);
                                            },
                                            child: const Text(
                                              'OK',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (radius != null && radius > 0) {
                                    await controller.createActiveCheckinPoint(
                                      controller.selectedLocation!,
                                      radius,
                                    );
                                  }
                                },
                                child: Container(
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Create Check-in Point",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: isPortrait ? 16.sp : 8.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),

                    /// Back button
                    Positioned(
                      top: 60.h,
                      left: 0,
                      child: CustomWidget.commonBackButton(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
