import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/createpoint_controller.dart';

class CreatepointView extends GetView<CreatepointController> {
  const CreatepointView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreatepointView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CreatepointView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
