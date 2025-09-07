import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final isPortrait = size.height > size.width;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: AppColors.backGroundGradientBlack(),
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600.w),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isPortrait ? 24.w : 60.w,
                  vertical: 20.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _topTitle(isPortrait: isPortrait),
                    SizedBox(height: isPortrait ? 40.h : 20.h),

                    // Email
                    _inputField(
                      controller: controller.emailController,
                      hint: "Email",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      isPortrait: isPortrait
                    ),
                    SizedBox(height: 20.h),

                    // Password
                    Obx(
                      () => _inputField(
                        controller: controller.passwordController,
                        isPortrait: isPortrait,
                        hint: "Password",
                        icon: Icons.password,
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
                            size: isPortrait ? 20.sp : 10.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Role selector
                    _roleSelector(isPortrait: isPortrait),
                    SizedBox(height:20.h),

                    // Signup button or loader
                    Obx(
                      () => controller.isSigningUp.value
                          ? const SpinKitPulse(color: Colors.white, size: 40)
                          : _signupButton(isPortrait: isPortrait),
                    ),
                    SizedBox(height:20.h ),

                    // Text: Already have account
                    _signupText(isPortrait: isPortrait),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _topTitle({required bool isPortrait}) {
    return DefaultTextStyle(
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: isPortrait ? 26.sp : 20.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          ColorizeAnimatedText(
            'Sign up to Next Check',
            textStyle: GoogleFonts.poppins(
              fontSize: isPortrait ? 26.sp : 20.sp,
            ),
            speed: const Duration(milliseconds: 1000),
            colors: [Colors.blue, Colors.purple, Colors.pink],
          ),
        ],
        repeatForever: true,
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
  required bool isPortrait,
}) {
  // Calculate font size and vertical padding
  final fontSize = isPortrait ? 14.sp : 8.sp;
  final verticalPadding = isPortrait ? 12.h : 6.h;

  // Calculate container height to fit text + padding
  final containerHeight = fontSize * 1.8 + verticalPadding * 2;

  return Container(
    height: containerHeight,
    decoration: BoxDecoration(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white, fontSize: fontSize),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70, size: fontSize ),
        suffixIcon: suffix,
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: Colors.white54,
          fontWeight: FontWeight.w300,
          fontSize: fontSize-2,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: 12.w,
        ),
      ),
    ),
  );
}

  Widget _roleSelector({required bool isPortrait}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.role.value,
            dropdownColor: Colors.black,
            style: GoogleFonts.poppins(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
            icon: Icon(Icons.arrow_drop_down, color: Colors.white70, size: isPortrait ? 20.sp : 10.sp,),
            items: ["host", "participant"]
                .map(
                  (role) => DropdownMenuItem(
                    value: role,
                    child: Text(
                      role[0].toUpperCase() + role.substring(1),
                      style: TextStyle(fontSize: isPortrait ? 14.sp : 8.sp,),
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

  Widget _signupButton({required bool isPortrait}) {
    return ZoomTapAnimation(
      onTap: () => controller.signupProccess(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.blue.shade800,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade900.withOpacity(0.4),
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Sign up",
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

  Widget _signupText({required bool isPortrait}) {
    return RichText(
      text: TextSpan(
        text: "Already have an account? ",
        style: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: isPortrait ? 14.sp : 8.sp,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.offAllNamed(Routes.LOGINSCREEN),
            text: "Login",
            style: GoogleFonts.poppins(
              color: Colors.blueAccent,
              fontSize: isPortrait ? 14.sp : 8.sp,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
