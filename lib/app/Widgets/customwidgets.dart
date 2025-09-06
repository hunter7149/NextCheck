import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CustomWidget {
  static customTextBox({
    required bool obsecure,
    required String hintText,
    double? fontsize,
    double? horizontalPadding,
    double? height,
    FocusNode? focusNode,
    Color? textColor,
    required TextEditingController textEditingController,
    required TextInputType keyboardType,
    double? borderRadius,
    bool? haveShadow,
    double? hMargin,
    double? verticalPadding,
    bool? enabled,
    int? maxline,
    VoidCallback? onchanged,
    Color? color,
  }) {
    return Container(
      height: height ?? 50,
      margin: EdgeInsets.symmetric(horizontal: hMargin ?? 30, vertical: 10),
      // padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        // ],
        color: color ?? Colors.white, // Set the background color to white
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius ?? 30.0),
        ), // Apply curved corners
      ),
      child: TextField(
        maxLines: maxline ?? 1,
        textAlignVertical: TextAlignVertical.center,
        onChanged: (string) {
          onchanged ?? () {};
        },
        style: TextStyle(
          fontSize: fontsize ?? 16,
          color: textColor ?? Colors.black,
        ),
        enabled: enabled ?? true,
        keyboardType: keyboardType,
        controller: textEditingController,
        obscureText: obsecure,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.grey.shade400),
          hintText: hintText, // Add placeholder text
          border: InputBorder.none, // Hide the default TextField border
          contentPadding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 15.0,
            vertical: verticalPadding ?? 10,
          ), // Padding
        ),
      ),
    );
  }

  //Successalert
  static successAlert({required String message}) async {
    Get.closeAllSnackbars();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.generalDialog(
        // transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        //       filter: ImageFilter.blur(
        //         sigmaX: 4 * anim1.value,
        //         sigmaY: 4 * anim1.value,
        //       ),
        //       child: FadeTransition(
        //         child: child,
        //         opacity: anim1,
        //       ),
        //     ),
        pageBuilder: (ctx, anim1, anim2) {
          return MediaQuery(
            data: MediaQuery.of(
              ctx,
            ).copyWith(textScaler: TextScaler.linear(1.0)),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Image.asset("assets/images/success.png"),
                        ),
                        Text(
                          "${message}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actionsPadding: EdgeInsets.all(10),
              actions: [],
            ),
          );
        },
      );
    });
  }

  static errorMessage({required String title, required String message}) {
    return Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      animationDuration: Duration(seconds: 0),
      borderRadius: 0,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade500,
      duration: Duration(seconds: 2),
    );
  }

  static successMessage({required String title, required String message}) {
    return Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      animationDuration: Duration(seconds: 0),
      borderRadius: 0,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade500,
      duration: Duration(seconds: 2),
    );
  }

  static successAlert2({required String message}) async {
    Get.closeAllSnackbars();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Timer.periodic(Duration(seconds: 2), (timer) {
      //   Get.back();
      // });
      Get.generalDialog(
        // transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        //       filter: ImageFilter.blur(
        //         sigmaX: 4 * anim1.value,
        //         sigmaY: 4 * anim1.value,
        //       ),
        //       child: FadeTransition(
        //         child: child,
        //         opacity: anim1,
        //       ),
        //     ),
        pageBuilder: (ctx, anim1, anim2) {
          return MediaQuery(
            data: MediaQuery.of(
              ctx,
            ).copyWith(textScaler: TextScaler.linear(1.0)),
            child: AlertDialog(
              backgroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: Container(
                height: 240,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ZoomTapAnimation(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Image.asset("assets/images/success.png"),
                          ),
                        ),
                        Text(
                          "${message}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        ZoomTapAnimation(
                          onTap: () {
                            // controller.productSelector();
                            // print("${controller.validateCart()}");
                            Get.back();
                          },
                          child: Container(
                            height: 40,
                            width: 120,
                            // width: 120,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "OKAY",
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // actionsPadding: EdgeInsets.all(10),
              actions: [],
            ),
          );
        },
      );
    });
  }

  static Future<void> errorAlert({
    required String title,
    required String message,
  }) async {
    // Ensure we have a valid context using Get.context
    if (Get.context != null) {
      // Show a dialog popup
      showDialog(
        context: Get.context!,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.red.shade800.withAlpha(200),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      ),
                      child: Center(
                        child: Icon(Icons.error, size: 40, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              message,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ZoomTapAnimation(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(150),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "Okay",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              backgroundColor: Colors.black54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          );
        },
      );

      // Wait for 2 seconds, then automatically close the dialog
      // await Future.delayed(Duration(seconds: 2));
      // if (Get.isDialogOpen!) {
      //   Get.back(); // Closes the dialog
      // }
    }
  }

  static commonBackButton() {
    return ZoomTapAnimation(
      onTap: () {
        Get.back();
      },
      child: Container(
        // alignment: Alignment.center,
        margin: EdgeInsets.only(left: 10, top: 2),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Icon(Icons.arrow_back, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}
