import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../controllers/loginscreen_controller.dart';
import 'package:next_check/app/Colors/appcolors.dart';
import 'package:next_check/app/routes/app_pages.dart';

class LoginscreenView extends GetView<LoginscreenController> {
  const LoginscreenView({super.key});

  static const double _horizontalPadding = 28.0;
  static const double _fieldHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        decoration: BoxDecoration(
          gradient: AppColors.backGroundGradientBlack(),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _topTitle(),
                const SizedBox(height: 40),
                _buildTextField(
                  controller: controller.emailController,
                  hint: "Email",
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),
                Obx(
                  () => _buildTextField(
                    controller: controller.passwordController,
                    hint: "Password",
                    isPassword: true,
                    isObscure: controller.isObsecure.value,
                    toggleObscure: () => controller.obsecureUpdater(
                      value: !controller.isObsecure.value,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  return controller.isSigning.value
                      ? const SizedBox(
                          height: _fieldHeight,
                          child: Center(
                            child: SpinKitPulse(color: Colors.white, size: 40),
                          ),
                        )
                      : _loginButton();
                }),
                const SizedBox(height: 25),
                // _forgotPasswordText(),
                const SizedBox(height: 25),
                _signupText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Top Welcome Title
  Widget _topTitle() {
    return DefaultTextStyle(
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          ColorizeAnimatedText(
            'Welcome Back',
            textStyle: GoogleFonts.poppins(fontSize: 40),
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
    IconData? icon,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? toggleObscure,
  }) {
    return Container(
      height: _fieldHeight,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        obscureText: isPassword ? isObscure : false,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: toggleObscure,
                  child: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white70,
                  ),
                )
              : null,
          hintStyle: GoogleFonts.poppins(
            color: Colors.white54,
            fontWeight: FontWeight.w300,
          ),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  /// Login Button
  Widget _loginButton() {
    return ZoomTapAnimation(
      onTap: controller.loginProccess,
      child: Container(
        height: _fieldHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Login",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// Signup Text
  Widget _signupText() {
    return RichText(
      text: TextSpan(
        text: "Don’t have an account? ",
        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
        children: [
          TextSpan(
            text: "Sign up",
            style: GoogleFonts.poppins(
              color: Colors.blueAccent,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.toNamed(Routes.SIGNUP),
          ),
        ],
      ),
    );
  }

  /// Forgot Password
  Widget _forgotPasswordText() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Forgot password logic
        },
        child: Text(
          "Forgot Password?",
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
        ),
      ),
    );
  }
}
