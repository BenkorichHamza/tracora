import 'package:get/get.dart';

import '../controllers/pos_home_controller.dart';

class PosHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosHomeController>(
      () => PosHomeController(),
    );
  }
}
