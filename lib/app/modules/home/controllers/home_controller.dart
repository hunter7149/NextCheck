import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxString uid = "".obs;
  RxString email = "".obs;
  RxString role = "".obs;
  setUserInfo({required Map<String, dynamic> userInfo}) {
    uid.value = userInfo?['uid'] ?? '';
    email.value = userInfo?['email'] ?? '';
    role.value = userInfo?['role'] ?? '';
    print("User Info: $userInfo");
    print("Role: ${role.value}");
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  // Logout
  Future<void> logout() async {
    await auth.signOut();
  }

  @override
  void onInit() {
    super.onInit();
    // Retrieve arguments passed from the login page
    final args = Get.arguments as Map<String, dynamic>?;

    setUserInfo(userInfo: args ?? {});
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
