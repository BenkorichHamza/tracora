import 'package:get/get.dart';

import '../controllers/stock_transaction_details_controller.dart';

class SaleDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockTransactionDetailsController>(
      () => StockTransactionDetailsController(),
    );
  }
}
