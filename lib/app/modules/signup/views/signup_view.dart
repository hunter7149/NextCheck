import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_check/app/Colors/appcolors.dart';
import 'package:next_check/app/routes/app_pages.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 32),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: AppColors.backGroundGradientBlack(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            topTitle(),
            vSpace(),
            userIdTextField(controller: controller.emailController),
            vSpace(20),
            Obx(
              () => userPasswordTextField(
                passwordcontroller: controller.passwordController,
              ),
            ),
            vSpace(),
            roleSelector(),
            vSpace(),
            Obx(
              () => controller.isSigningUp.value
                  ? Container(
                      height: 40,
                      width: 80,
                      color: Colors.black,
                      child: SpinKitPulse(color: Colors.white, size: 40),
                    )
                  : signupButton(),
            ),
            vSpace(),
            signupText(),
            vSpace(20),
          ],
        ),
      ),
    );
  }

  topTitle() {
    return SizedBox(
      // width: 250.0,
      child: DefaultTextStyle(
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontSize: 46, color: Colors.white),
        child: AnimatedTextKit(
          // isRepeatingAnimation: true,
          animatedTexts: [
            ColorizeAnimatedText(
              'Sign up to NextCheck',
              textStyle: GoogleFonts.poppins(
                fontSize: 46,
                // color: Colors.white,
              ),
              speed: Duration(milliseconds: 1000),
              textAlign: TextAlign.center,

              //
              colors: [Colors.blue, Colors.purple, Colors.pink],
            ),
          ],
          repeatForever: true,
          // onFinished: () => controller.checkLoginStatus(),
        ),
      ),
    );
  }

  vSpace([double? height]) {
    return SizedBox(height: height != null ? height : 20);
  }

  signupText() {
    return RichText(
      text: TextSpan(
        text: "Already have an account? ",
        style: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.offAllNamed(Routes.LOGINSCREEN);
              },
            text: "Login",
            style: GoogleFonts.poppins(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              // decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  signupButton() {
    return ZoomTapAnimation(
      onTap: () {
        controller.signupProccess();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue.shade900,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text("Sign up", style: GoogleFonts.poppins(color: Colors.white)),
      ),
    );
  }

  userIdTextField({required TextEditingController controller}) {
    return Container(
      height: 40,
      decoration: BoxDecoration(color: Colors.blueGrey.shade900),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,

        controller: controller,
        // obscureText: controller.isObsecure.value,
        decoration: InputDecoration(
          hintStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w200,
          ),
          alignLabelWithHint: true,
          hintText: "Email", // Add placeholder text
          border: InputBorder.none, // Hide the default TextField border
          contentPadding: EdgeInsets.all(10), // Padding
        ),
      ),
    );
  }

  userPasswordTextField({required TextEditingController passwordcontroller}) {
    return Container(
      height: 40,
      decoration: BoxDecoration(color: Colors.blueGrey.shade900),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        enabled: true,
        controller: passwordcontroller,
        obscureText: controller.isObsecure.value,
        decoration: InputDecoration(
          suffixIcon: ZoomTapAnimation(
            onTap: () {
              controller.obsecureUpdater(value: !controller.isObsecure.value);
            },
            child: Icon(
              controller.isObsecure.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.black,
            ),
          ),
          hintStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w200,
          ),
          hintText: "Password", // Add placeholder text
          border: InputBorder.none, // Hide the default TextField border
          contentPadding: EdgeInsets.all(10), // Padding
        ),
      ),
    );
  }

  roleSelector() {
    return Container(
      height: 40,
      width: double.maxFinite,
      decoration: BoxDecoration(color: Colors.blueGrey.shade900),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.role.value,
            dropdownColor: Colors.blueGrey.shade900,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            items: ["host", "participant"]
                .map(
                  (r) => DropdownMenuItem(
                    value: r,
                    child: Text(
                      r[0].toUpperCase() + r.substring(1),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (val) => controller.role.value = val!,
          ),
        ),
      ),
    );
  }
}
