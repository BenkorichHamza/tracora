import 'package:get/get.dart';

import '../controllers/sale_details_controller.dart';

class SaleDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaleDetailsController>(
      () => SaleDetailsController(),
    );
  }
}
