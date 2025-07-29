import 'package:get/get.dart';

import '../controllers/synchronisation_controller.dart';

class SynchronisationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SynchronisationController>(
      () => SynchronisationController(),
    );
  }
}
