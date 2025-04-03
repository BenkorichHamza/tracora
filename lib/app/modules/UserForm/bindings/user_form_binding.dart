import 'package:get/get.dart';

import '../controllers/user_form_controller.dart';

class CustomerFormBinding<T> extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserFormController<T>>(() => UserFormController<T>());
  }
}
