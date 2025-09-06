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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          final horizontalPadding = isLandscape
              ? constraints.maxWidth * 0.2
              : 24.0;
          final verticalSpacing = isLandscape ? 20.0 : 40.0;

          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            decoration: BoxDecoration(
              gradient: AppColors.backGroundGradientBlack(),
            ),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _topTitle(isLandscape: isLandscape),
                      SizedBox(height: verticalSpacing),
                      _inputField(
                        controller: controller.emailController,
                        hint: "Email",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: verticalSpacing / 2),
                      Obx(
                        () => _inputField(
                          controller: controller.passwordController,
                          hint: "Password",
                          icon: Icons.lock_outline,
                          obscureText: controller.isObsecure.value,
                          suffix: ZoomTapAnimation(
                            onTap: () => controller.obsecureUpdater(
                              value: !controller.isObsecure.value,
                            ),
                            child: Icon(
                              controller.isObsecure.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: verticalSpacing / 2),
                      _roleSelector(),
                      SizedBox(height: verticalSpacing),
                      Obx(
                        () => controller.isSigningUp.value
                            ? const SpinKitPulse(color: Colors.white, size: 40)
                            : _signupButton(),
                      ),
                      SizedBox(height: verticalSpacing),
                      _signupText(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _topTitle({bool isLandscape = false}) {
    return SizedBox(
      child: DefaultTextStyle(
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: isLandscape ? 28 : 36,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        child: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'Sign up to NextCheck',
              textStyle: GoogleFonts.poppins(fontSize: isLandscape ? 28 : 36),
              speed: const Duration(milliseconds: 1000),
              colors: [Colors.blue, Colors.purple, Colors.pink],
            ),
          ],
          repeatForever: true,
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          suffixIcon: suffix,
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            color: Colors.white54,
            fontWeight: FontWeight.w300,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 12,
          ),
        ),
      ),
    );
  }

  Widget _roleSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.role.value,
            dropdownColor: Colors.black,
            style: GoogleFonts.poppins(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
            items: ["host", "participant"]
                .map(
                  (role) => DropdownMenuItem(
                    value: role,
                    child: Text(role[0].toUpperCase() + role.substring(1)),
                  ),
                )
                .toList(),
            onChanged: (val) => controller.role.value = val!,
          ),
        ),
      ),
    );
  }

  Widget _signupButton() {
    return ZoomTapAnimation(
      onTap: () => controller.signupProccess(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.blue.shade800,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade900.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Sign up",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _signupText() {
    return RichText(
      text: TextSpan(
        text: "Already have an account? ",
        style: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.offAllNamed(Routes.LOGINSCREEN),
            text: "Login",
            style: GoogleFonts.poppins(
              color: Colors.blueAccent,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
