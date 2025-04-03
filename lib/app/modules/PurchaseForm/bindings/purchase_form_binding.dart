import 'package:get/get.dart';

import '../controllers/purchase_form_controller.dart';

class UserFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchaseFormController>(() => PurchaseFormController());
  }
}
