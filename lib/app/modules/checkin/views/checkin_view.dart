import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:next_check/app/Colors/appcolors.dart';
import 'package:next_check/app/Widgets/customwidgets.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../controllers/checkin_controller.dart';

class CheckinView extends GetView<CheckinController> {
  const CheckinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: AppColors.backGroundGradientBlack(),
        ),
        child: Obx(() {
          if (controller.initialCameraPosition.value == null ||
              controller.isMapLoading.value) {
            return const Center(
              child: SpinKitThreeBounce(color: Colors.white, size: 60),
            );
          }

          return Stack(
            children: [
              Positioned(
                top: 20,
                right: 0,
                bottom: 0,
                left: 0,
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
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,

                child: Column(
                  children: [
                    Obx(() {
                      String distanceText;
                      if (controller.distanceFromActive.value >= 1000) {
                        distanceText =
                            (controller.distanceFromActive.value / 1000)
                                .toStringAsFixed(2) +
                            ' km away';
                      } else {
                        distanceText =
                            controller.distanceFromActive.value.toStringAsFixed(
                              0,
                            ) +
                            ' meters away from active point';
                      }
                      return Container(
                        // height: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.black),
                        child: Center(
                          child: Text(
                            'Active Check-ins: ${controller.liveCount.value} \nYou are $distanceText',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    Obx(
                      () => ZoomTapAnimation(
                        onTap: controller.isCheckedIn.value
                            ? null
                            : () async {
                                await controller.getlocation();
                                await controller.checkIn();
                              },

                        child: Container(
                          height: 50,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: controller.isCheckedIn.value
                                ? Colors.green
                                : Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              controller.isCheckedIn.value
                                  ? 'Checked In'
                                  : 'Check In',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 60,

                left: 0,
                child: CustomWidget.commonBackButton(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
