import 'package:flutter/material.dart';

class AppColors {
  static Color mainBgPink = Color.fromARGB(255, 186, 149, 253);
  static Color mainBgBlue = Color.fromARGB(255, 149, 249, 252);

  static List<Color> mainBackgroud = [
    mainBgPink.withAlpha(200),
    mainBgBlue.withAlpha(200),
  ];
  static List<Color> mainTitle = [mainBgPink, Colors.blue];

  static backGroundGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: AppColors.mainBackgroud,
    );
  }

  static backGroundGradientBlack() {
    return LinearGradient(
      end: Alignment.topRight,
      begin: Alignment.bottomLeft,
      colors: [
        Color.fromARGB(255, 2, 33, 48),
        const Color.fromARGB(255, 1, 19, 57),
        // Colors.blueGrey.shade900,
        Color.fromARGB(255, 2, 33, 48),
      ],
    );
  }

  static titleTextGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: AppColors.mainTitle,
    );
  }
}
