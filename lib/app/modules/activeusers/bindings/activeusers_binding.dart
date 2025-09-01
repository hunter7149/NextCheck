import 'package:get/get.dart';

import '../controllers/activeusers_controller.dart';

class ActiveusersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActiveusersController>(
      () => ActiveusersController(),
    );
  }
}
