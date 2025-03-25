import 'package:get/get.dart';

import '../controllers/customer_payment_form_controller.dart';

class CustomerPaymentFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerPaymentFormController>(
      () => CustomerPaymentFormController(),
    );
  }
}
