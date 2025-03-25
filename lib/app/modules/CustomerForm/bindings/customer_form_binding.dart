import 'package:get/get.dart';

import '../controllers/customer_form_controller.dart';

class CustomerFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerFormController>(
      () => CustomerFormController(),
    );
  }
}
