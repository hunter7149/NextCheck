import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:next_check/app/Colors/appcolors.dart';
import 'package:next_check/app/Widgets/customwidgets.dart';

import '../controllers/activeusers_controller.dart';

class ActiveusersView extends GetView<ActiveusersController> {
  const ActiveusersView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Active Users',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        leading: CustomWidget.commonBackButton(),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: AppColors.backGroundGradientBlack(),
        ),
        child: Obx(() {
          if (controller.activeParticipants.isEmpty) {
            return Center(
              child: Text(
                "No active participants",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            itemCount: controller.activeParticipants.length,
            itemBuilder: (context, index) {
              final participant = controller.activeParticipants[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.person, color: Colors.green, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Participant ${participant['id']}",
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Lat: ${participant['lat']}, Lng: ${participant['lng']}",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Checked in: ${DateTime.fromMillisecondsSinceEpoch(DateTime.friday)}",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
