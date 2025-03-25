import 'package:get/get.dart';

import '../controllers/purchase_details_controller.dart';

class PurchaseDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchaseDetailsController>(
      () => PurchaseDetailsController(),
    );
  }
}
