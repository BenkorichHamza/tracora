import 'package:get/get.dart';

import '../controllers/fees_payment_details_controller.dart';

class FeesPaymentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeesPaymentDetailsController>(
      () => FeesPaymentDetailsController(),
    );
  }
}
