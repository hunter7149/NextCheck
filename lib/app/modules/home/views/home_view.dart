import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:next_check/app/Colors/appcolors.dart';
import 'package:next_check/app/routes/app_pages.dart';
import 'package:zo_animated_border/zo_animated_border.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.backGroundGradientBlack(),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Responsive main content
              Center(
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    if (orientation == Orientation.portrait) {
                      // 📱 Portrait layout
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const _AnimatedLogo(),
                          const SizedBox(height: 24),
                          const _TitleAndSlogan(),
                          const SizedBox(height: 32),
                          _ActionsSection(),
                        ],
                      );
                    } else {
                      // 💻 Landscape layout
                      return Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(child: const _AnimatedLogo()),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const _TitleAndSlogan(),
                                const SizedBox(height: 32),
                                _ActionsSection(),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),

              // 🔹 User info always top-right
              Positioned(top: 16, right: 16, child: const _UserSection()),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserSection extends GetView<HomeController> {
  const _UserSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              controller.email.value ?? '',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              controller.role.value ?? '',
              style: GoogleFonts.poppins(
                color: Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.end,
            ),
          ],
        ),
        const SizedBox(width: 12),
        ZoomTapAnimation(
          onTap: () {
            controller.auth.signOut();
            Get.offAllNamed(Routes.LOGINSCREEN);
          },
          child: const Icon(
            CupertinoIcons.power,
            color: Colors.deepOrange,
            size: 28,
          ),
        ),
      ],
    );
  }
}

class _AnimatedLogo extends StatelessWidget {
  const _AnimatedLogo();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoSize = size.shortestSide * 0.5; // adapts to portrait/landscape

    return ZoAnimatedGradientBorder(
      borderRadius: logoSize / 2,
      borderThickness: 1.5,
      gradientColor: AppColors.mainBackgroud,
      animationDuration: const Duration(seconds: 4),
      child: Container(
        height: logoSize,
        width: logoSize,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(logoSize / 2),
          color: Colors.black38,
        ),
        child: Lottie.asset("assets/images/worldwide.json", repeat: true),
      ),
    );
  }
}

class _TitleAndSlogan extends StatelessWidget {
  const _TitleAndSlogan();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "NEXT CHECK",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Proving Presence in Real Time",
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ActionsSection extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.role == 'host'
          ? Column(
              children: [
                _ActionButton(
                  label: "Create Check in point",
                  onTap: () => Get.toNamed(Routes.CREATEPOINT),
                ),
                _ActionButton(
                  label: "Active Users",
                  onTap: () => Get.toNamed(Routes.ACTIVEUSERS),
                ),
                _ActionButton(
                  label: "Check in",
                  onTap: () => Get.toNamed(Routes.CHECKIN),
                ),
              ],
            )
          : _ActionButton(
              label: "Check in",
              onTap: () => Get.toNamed(Routes.CHECKIN),
            ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
      child: ZoomTapAnimation(
        onTap: onTap,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black.withOpacity(0.85),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
