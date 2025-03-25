import 'package:get/get.dart';

import '../controllers/supplier_payment_controller.dart';

class SupplierPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupplierPaymentController>(
      () => SupplierPaymentController(),
    );
  }
}
