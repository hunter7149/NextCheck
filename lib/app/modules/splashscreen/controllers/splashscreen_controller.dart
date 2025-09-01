import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashscreenController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animationController.forward();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
     animationController?.dispose();
    super.onClose();
    
  }


}
