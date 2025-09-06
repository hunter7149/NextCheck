import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/loginscreen_controller.dart';
import 'package:next_check/app/Colors/appcolors.dart';
import 'package:next_check/app/routes/app_pages.dart';

class LoginscreenView extends GetView<LoginscreenController> {
  const LoginscreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        decoration: BoxDecoration(
          gradient: AppColors.backGroundGradientBlack(),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _topTitle(isPortrait: isPortrait),
                  SizedBox(height: isPortrait ? 40.h : 20.h),
                  _buildTextField(
                    controller: controller.emailController,
                    hint: "Email",
                    isPortrait: isPortrait,
                  ),
                  SizedBox(height: isPortrait ? 20.h : 12.h),
                  Obx(
                    () => _buildTextField(
                      isPortrait: isPortrait,
                      controller: controller.passwordController,
                      hint: "Password",
                      isPassword: true,
                      isObscure: controller.isObsecure.value,
                      toggleObscure: () => controller.obsecureUpdater(
                        value: !controller.isObsecure.value,
                      ),
                    ),
                  ),
                  SizedBox(height: isPortrait ? 20.h : 12.h),
                  Obx(() {
                    return controller.isSigning.value
                        ? SizedBox(
                            height: 50.h,
                            child: Center(
                              child: SpinKitPulse(
                                color: Colors.white,
                                size: 40.sp,
                              ),
                            ),
                          )
                        : _loginButton(isPortrait: isPortrait);
                  }),
                  SizedBox(height: isPortrait ? 25.h : 15.h),
                  _signupText(isPortrait: isPortrait),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Top Welcome Title
  Widget _topTitle({required bool isPortrait}) {
    return DefaultTextStyle(
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: isPortrait ? 40.sp : 28.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          ColorizeAnimatedText(
            'Welcome Back',
            textStyle: GoogleFonts.poppins(
              fontSize: isPortrait ? 40.sp : 28.sp,
            ),
            speed: const Duration(milliseconds: 1200),
            colors: [Colors.blue, Colors.purple, Colors.pink],
          ),
        ],
        repeatForever: true,
      ),
    );
  }

  /// Text Field Builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool isObscure = false,
    required bool isPortrait,
    VoidCallback? toggleObscure,
  }) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextField(
        style: TextStyle(
          color: Colors.white,
          fontSize: isPortrait ? 14.sp : 8.sp,
        ),
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        obscureText: isPassword ? isObscure : false,
        decoration: InputDecoration(
          prefixIcon: isPassword == false
              ? Icon(
                  Icons.email_outlined,
                  color: Colors.white70,
                  size: isPortrait ? 20.sp : 10.sp,
                )
              : null,
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: toggleObscure,
                  child: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white70,
                    size: isPortrait ? 20.sp : 10.sp,
                  ),
                )
              : null,
          hintStyle: GoogleFonts.poppins(
            color: Colors.white54,
            fontWeight: FontWeight.w300,
            fontSize: isPortrait ? 14.sp : 8.sp,
          ),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: isPortrait ? 14.sp : 4.sp,
          ),
        ),
      ),
    );
  }

  /// Login Button
  Widget _loginButton({required bool isPortrait}) {
    return ZoomTapAnimation(
      onTap: controller.loginProccess,
      child: Container(
        height: 50.h,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Login",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: isPortrait ? 14.sp : 8.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// Signup Text
  Widget _signupText({required bool isPortrait}) {
    return RichText(
      text: TextSpan(
        text: "Don’t have an account? ",
        style: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: isPortrait ? 14.sp : 8.sp,
        ),
        children: [
          TextSpan(
            text: "Sign up",
            style: GoogleFonts.poppins(
              color: Colors.blueAccent,
              fontSize: isPortrait ? 14.sp : 8.sp,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.toNamed(Routes.SIGNUP),
          ),
        ],
      ),
    );
  }
}
