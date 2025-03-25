import 'package:get/get.dart';
import 'package:tracora/app/modules/Login/controllers/login_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put(LoginController());
  }
}
