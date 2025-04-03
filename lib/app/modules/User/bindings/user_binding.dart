import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class UserBinding<T> extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController<T>>(() => UserController<T>());
  }
}
