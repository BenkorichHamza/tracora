import 'package:get/get.dart';

import '../controllers/supplier_details_controller.dart';

class SupplierDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupplierDetailsController>(
      () => SupplierDetailsController(),
    );
  }
}
