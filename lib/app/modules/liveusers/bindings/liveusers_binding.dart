import 'package:get/get.dart';

import '../controllers/liveusers_controller.dart';

class LiveusersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LiveusersController>(
      () => LiveusersController(),
    );
  }
}
