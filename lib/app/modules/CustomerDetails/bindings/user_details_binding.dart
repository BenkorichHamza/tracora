import 'package:get/get.dart';

import '../controllers/user_details_controller.dart';

class CustomerDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserDetailsController>(() => UserDetailsController());
  }
}
