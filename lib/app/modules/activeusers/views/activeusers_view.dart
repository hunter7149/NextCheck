import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/activeusers_controller.dart';

class ActiveusersView extends GetView<ActiveusersController> {
  const ActiveusersView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ActiveusersView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ActiveusersView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
