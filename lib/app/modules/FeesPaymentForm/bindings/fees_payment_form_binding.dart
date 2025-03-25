import 'package:get/get.dart';

import '../controllers/fees_payment_form_controller.dart';

class FeesPaymentFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeesPaymentFormController>(
      () => FeesPaymentFormController(),
    );
  }
}
