import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/repositories/purchase_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';

class PurchaseDetailsController extends GetxController {
  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _changed = false.obs;
  bool get changed => this._changed.value;
  set changed(bool value) => this._changed.value = value;

  final PurchaseRepository repository = PurchaseRepository();
  final _purchase = StockTransaction().obs;
  StockTransaction get purchase => this._purchase.value;
  set purchase(StockTransaction value) => this._purchase.value = value;

  final _productTransactions = <ProductTransaction>[].obs;
  List<ProductTransaction> get productTransactions =>
      this._productTransactions.value;
  set productTransactions(List<ProductTransaction> value) =>
      this._productTransactions.value = value;

  double get total => productTransactions.fold(
    0.0,
    (previousValue, element) =>
        previousValue + (element.qte ?? 0) * (element.price ?? 0),
  );

  @override
  void onInit() {
    if (Get.arguments?['purchase'] is StockTransaction) {
      purchase = Get.arguments?["purchase"] ?? purchase;
      productTransactions = purchase.productTransactions ?? productTransactions;
    }
    if (purchase.id != null) {
      getStockTransaction();
    }
    getProductTransactions();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getProductTransactions() async {
    try {
      loading = true;
      productTransactions = await repository.getProductTransactions(
        purchase.id ?? 0,
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }

  delete() async {
    var b = await deleteConfirmation();
    if (b != true) return;
    await repository.deletePurchase(purchase);
    Get.back(result: true);
  }

  getStockTransaction() async {
    try {
      var r = await PurchaseRepository().getStockTransactionById(
        id: purchase.id ?? 0,
      );
      purchase = r ?? purchase;
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    }
  }
}
