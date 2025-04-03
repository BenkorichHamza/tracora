import 'package:get/get.dart';

import '../controllers/transaction_controller.dart';

class SaleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockTransactionController>(() => StockTransactionController());
  }
}
