import 'package:get/get.dart';

import '../controllers/supplier_form_controller.dart';

class SupplierFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupplierFormController>(
      () => SupplierFormController(),
    );
  }
}
