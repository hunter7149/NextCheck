import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:next_check/app/Colors/appcolors.dart';

import 'package:next_check/app/routes/app_pages.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: AppColors.backGroundGradientBlack(),
        ),
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  topAnimatedLogo(),
                  titleandSlogan(),
                  SizedBox(height: 50),
                  Obx(
                    () => controller.role == 'host'
                        ? Column(
                            children: [
                              createCheckInButton(),
                              activeUsersButton(),
                              checkInButton(),
                            ],
                          )
                        : checkInButton(),
                  ),
                ],
              ),

              Positioned(
                top: 60,
                right: 10,
                // left: 0,
                child: userSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  userSection() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${controller.email}",
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${controller.role}",
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.end,
            ),
          ],
        ),
        SizedBox(width: 10),
        ZoomTapAnimation(
          onTap: () {
            controller.auth.signOut();
            Get.offAllNamed(Routes.LOGINSCREEN);
          },
          child: Icon(CupertinoIcons.power, color: Colors.deepOrange, size: 30),
        ),
      ],
    );
  }

  topAnimatedLogo() {
    return Container(
      height: 350,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(250),
        color: Colors.black45,
      ),
      child: Lottie.asset(
        // height: 300,
        key: UniqueKey(),
        "assets/images/worldwide.json",
        repeat: true,
      ),
    );
  }

  titleandSlogan() {
    return Column(
      children: [
        Text(
          "NEXT CHECK",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Proving Presence in Real Time",
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  checkInButton() {
    return ZoomTapAnimation(
      onTap: () {
        Get.toNamed(Routes.CHECKIN);
      },
      child: Container(
        height: 50,
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black87,
        ),
        child: Center(
          child: Text(
            "Check in",
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  createCheckInButton() {
    return ZoomTapAnimation(
      onTap: () {
        Get.toNamed(Routes.CREATEPOINT);
      },
      child: Container(
        height: 50,
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black87,
        ),
        child: Center(
          child: Text(
            "Create Check in point",
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  activeUsersButton() {
    return ZoomTapAnimation(
      onTap: () {
        Get.toNamed(Routes.ACTIVEUSERS);
      },
      child: Container(
        height: 50,
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black87,
        ),
        child: Center(
          child: Text(
            "Active Users",
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
