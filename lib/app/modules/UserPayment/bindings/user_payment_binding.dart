import 'package:get/get.dart';

import '../controllers/user_payment_controller.dart';

class CustomerPaymentBinding<T> extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserPaymentController<T>>(() => UserPaymentController<T>());
  }
}
