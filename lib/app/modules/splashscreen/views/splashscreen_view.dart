import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_check/app/routes/app_pages.dart';

import '../controllers/splashscreen_controller.dart';

class SplashscreenView extends GetView<SplashscreenController> {
  const SplashscreenView({super.key});
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () {
      // controller.checkLoginStatus();
    Get.offNamed(Routes.HOME);
   

    });
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                end: Alignment.topRight,
                begin: Alignment.bottomLeft,
                colors: [
              Color.fromARGB(255, 2, 33, 48),
              Colors.black,
              // Colors.blueGrey.shade900,
              Color.fromARGB(255, 2, 33, 48)
            ])),
        // color: AppColors.modernBlue,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 1), // Start position (bottom)
                      end: Offset.zero, // End position (center)
                    ).animate(
                      CurvedAnimation(
                        curve: Curves.fastLinearToSlowEaseIn,
                        parent: controller.animationController,
                      ),
                    ),
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Image.asset(
                        'assets/logo/nextcheck.png',
                        height: 250,
                        // colorBlendMode: BlendMode.colorBurn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Text(
                  "V 1.0.1",
                  style: GoogleFonts.poppins(color: Colors.grey.shade500),
                  textAlign: TextAlign.center,
                ))
          ],
        ),
      ),
    );
  }
}