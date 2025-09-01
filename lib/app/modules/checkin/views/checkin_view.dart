import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/checkin_controller.dart';

class CheckinView extends GetView<CheckinController> {
  const CheckinView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckinView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CheckinView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
