import 'package:get/get.dart';

import '../controllers/user_payment_details_controller.dart';

class UserPaymentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserPaymentDetailsController>(
      () => UserPaymentDetailsController(),
    );
  }
}
