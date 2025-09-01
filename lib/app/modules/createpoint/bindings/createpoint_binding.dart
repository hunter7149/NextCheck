import 'package:get/get.dart';

import '../controllers/createpoint_controller.dart';

class CreatepointBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatepointController>(
      () => CreatepointController(),
    );
  }
}
