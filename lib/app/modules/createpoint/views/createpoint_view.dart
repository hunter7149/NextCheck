import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:next_check/app/Colors/appcolors.dart';
import 'package:next_check/app/Widgets/customwidgets.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../controllers/createpoint_controller.dart';

class CreatepointView extends GetView<CreatepointController> {
  const CreatepointView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: AppColors.backGroundGradientBlack(),
        ),
        child: Obx(
          () => controller.initialCameraPosition.value == null
              ? const Center(
                  child: SpinKitThreeBounce(color: Colors.white, size: 60),
                )
              : Stack(
                  children: [
                    Positioned(
                      top: 20,
                      right: 0,
                      bottom: 0,
                      left: 0,
                      child: Obx(
                        () => GoogleMap(
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
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: ZoomTapAnimation(
                        onTap: () async {
                          if (controller.selectedLocation == null) {
                            CustomWidget.errorAlert(
                              title: "Opps!",
                              message:
                                  "Please select a location on the map first.",
                            );
                            return;
                          }

                          // Show dialog to enter radius
                          double? radius = await showDialog<double>(
                            context: context,
                            builder: (context) {
                              final TextEditingController radiusController =
                                  TextEditingController();
                              return AlertDialog(
                                title: const Text('Enter Radius (meters)'),
                                content: TextField(
                                  controller: radiusController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'Radius in meters',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final value = double.tryParse(
                                        radiusController.text,
                                      );
                                      Navigator.of(context).pop(value);
                                    },
                                    child: const Text('OK'),
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
                            CustomWidget.successAlert2(
                              message: "Check-in point created successfully",
                            );
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Create Check-in Point",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,

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
