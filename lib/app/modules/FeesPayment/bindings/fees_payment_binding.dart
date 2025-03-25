import 'package:get/get.dart';

import '../controllers/fees_payment_controller.dart';

class FeesPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeesPaymentController>(
      () => FeesPaymentController(),
    );
  }
}
