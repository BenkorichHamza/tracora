import 'package:get/get.dart';

import '../controllers/user_payment_form_controller.dart';

class UserPaymentFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserPaymentFormController>(() => UserPaymentFormController());
  }
}
