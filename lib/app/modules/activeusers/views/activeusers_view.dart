import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_check/app/Colors/appcolors.dart';
import 'package:next_check/app/Widgets/customwidgets.dart';
import '../controllers/activeusers_controller.dart';

class ActiveusersView extends GetView<ActiveusersController> {
  const ActiveusersView({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: media.size.height,
          width: media.size.width,
          decoration: BoxDecoration(
            gradient: AppColors.backGroundGradientBlack(),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 60.h,
                bottom: 0.h,
                left: 20.w,
                right: 20.w,
                child: Obx(() {
                  if (controller.isParticipantLoading.value) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitDoubleBounce(color: Colors.white, size: 60.sp),
                        SizedBox(height: 10.h),
                        Text(
                          "Hold on while we get active users..",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: isPortrait ? 16.sp : 8.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  } else if (controller.activeParticipants.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people, color: Colors.white, size: 100),
                        Text(
                          "No active participants",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    );
                  } else if (isPortrait) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      itemCount: controller.activeParticipants.length,
                      itemBuilder: (context, index) {
                        final participant =
                            controller.activeParticipants[index];
                        return _participantCard(participant);
                      },
                    );
                  } else {
                    return Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            itemCount: controller.activeParticipants.length,
                            itemBuilder: (context, index) {
                              final participant =
                                  controller.activeParticipants[index];
                              return _participantCard(participant);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                }),
              ),
              Positioned(
                top: 10.h,
                left: 0.w,
                child: CustomWidget.commonBackButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _participantCard(Map<String, dynamic> participant) {
    final checkedInTimestamp = participant['checkedIn'] as int? ?? 0;
    final checkedInDate = DateTime.fromMillisecondsSinceEpoch(
      checkedInTimestamp,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const Icon(Icons.person, color: Colors.white, size: 32)],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${participant['email'] ?? '-'}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Lat: ${participant['lat'] ?? '-'}, Lng: ${participant['lng'] ?? '-'}",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  "Checked in: ${checkedInDate.toLocal()}",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
