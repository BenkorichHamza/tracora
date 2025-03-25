import 'package:get/get.dart';

import '../controllers/mission_form_controller.dart';

class MissionFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MissionFormController>(
      () => MissionFormController(),
    );
  }
}
