import 'package:get/get.dart';

import '../controllers/customer_payment_details_controller.dart';

class CustomerPaymentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerPaymentDetailsController>(
      () => CustomerPaymentDetailsController(),
    );
  }
}
