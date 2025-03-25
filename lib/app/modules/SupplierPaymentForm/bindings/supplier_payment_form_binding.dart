import 'package:get/get.dart';

import '../controllers/supplier_payment_form_controller.dart';

class SupplierPaymentFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupplierPaymentFormController>(
      () => SupplierPaymentFormController(),
    );
  }
}
