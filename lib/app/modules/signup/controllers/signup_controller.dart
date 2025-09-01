import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_check/app/Widgets/customwidgets.dart';
import 'package:next_check/app/routes/app_pages.dart';

class SignupController extends GetxController {
  RxBool isSigningUp = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxString role = "participant".obs;
  RxBool isObsecure = true.obs;
  obsecureUpdater({required bool value}) {
    isObsecure.value = value;
    update();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);

  signupProccess() {
    register(emailController.text, passwordController.text, role.value);
  }

  // Signup with role
  Future<void> register(String email, String password, String role) async {
    isSigningUp.value = true;
    update();
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _db.collection("users").doc(userCred.user!.uid).set({
        "email": email,
        "role": role, // "host" or "participant"
        "createdAt": DateTime.now(),
      });
      CustomWidget.successAlert2(message: "Sign up successful!");
      Get.offNamed(Routes.LOGINSCREEN);
    } catch (e) {
      CustomWidget.errorAlert(title: "Opps", message: "Sign up failed!");
    } finally {
      isSigningUp.value = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
