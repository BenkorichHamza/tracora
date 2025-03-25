import 'package:get/get.dart';

import '../controllers/supplier_payment_details_controller.dart';

class SupplierPaymentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupplierPaymentDetailsController>(
      () => SupplierPaymentDetailsController(),
    );
  }
}
