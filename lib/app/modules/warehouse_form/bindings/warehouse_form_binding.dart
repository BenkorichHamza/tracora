import 'package:get/get.dart';

import '../controllers/warehouse_form_controller.dart';

class WarehouseFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WarehouseFormController>(
      () => WarehouseFormController(),
    );
  }
}
