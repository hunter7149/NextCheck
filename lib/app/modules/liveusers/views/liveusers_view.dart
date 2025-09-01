import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/liveusers_controller.dart';

class LiveusersView extends GetView<LiveusersController> {
  const LiveusersView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiveusersView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LiveusersView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
