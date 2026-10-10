import 'package:get/get.dart';

import '../controllers/warehouse_details_controller.dart';

class WarehouseDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WarehouseDetailsController>(
      () => WarehouseDetailsController(),
    );
  }
}
