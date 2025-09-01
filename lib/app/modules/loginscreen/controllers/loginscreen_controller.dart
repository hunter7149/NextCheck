import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_check/app/Widgets/customwidgets.dart';
import 'package:next_check/app/routes/app_pages.dart';

class LoginscreenController extends GetxController {
  RxBool isSigning = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isObsecure = true.obs;
  obsecureUpdater({required bool value}) {
    isObsecure.value = value;
    update();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);

  loginProccess() {
    login(emailController.text, passwordController.text);
  }

  // Login
  Future<void> login(String email, String password) async {
    isSigning.value = true;
    try {
      // Sign in with FirebaseAuth
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      String uid = userCred.user!.uid;

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        CustomWidget.errorAlert(
          title: "Error",
          message: "User data not found in Firestore.",
        );
        return;
      }

      String role = userDoc['role'] ?? 'participant'; // default fallback
      String? emailAddr = userCred.user?.email;

      // Navigate based on role
      if (role == 'host') {
        Get.offAllNamed(
          Routes.HOME,
          arguments: {"uid": uid, "email": emailAddr ?? '', "role": role},
        );
      } else if (role == 'participant') {
        Get.offAllNamed(
          Routes.HOME,
          arguments: {"uid": uid, "email": emailAddr ?? '', "role": role},
        );
      } else {
        CustomWidget.errorAlert(title: "Error", message: "Unknown role: $role");
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage = 'Login failed. Please try again.';
      }

      CustomWidget.errorAlert(title: "Login Error", message: errorMessage);
    } catch (e) {
      CustomWidget.errorAlert(
        title: "Error",
        message: "An unexpected error occurred.",
      );
    } finally {
      isSigning.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
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
