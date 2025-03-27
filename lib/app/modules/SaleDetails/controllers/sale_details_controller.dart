import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/repositories/sale_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/modules/Sale/controllers/sale_controller.dart';

class SaleDetailsController extends GetxController {
  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _changed = false.obs;
  bool get changed => this._changed.value;
  set changed(bool value) => this._changed.value = value;

  final SaleRepository repository = SaleRepository();
  final _stockTansaction = StockTransaction().obs;
  StockTransaction get stockTransaction => this._stockTansaction.value;
  set stockTransaction(StockTransaction value) =>
      this._stockTansaction.value = value;

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
    if (Get.arguments?['sale'] is StockTransaction) {
      stockTransaction = Get.arguments?["sale"] ?? stockTransaction;
      productTransactions =
          stockTransaction.productTransactions ?? productTransactions;
    }
    if (stockTransaction.id != null) {
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
        stockTransaction.id ?? 0,
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
    await repository.deleteSale(stockTransaction);
    Get.find<SaleController>().getAll();
    Get.find<SaleDetailsController>().stockTransaction = StockTransaction();
    Get.find<SaleDetailsController>().productTransactions =
        <ProductTransaction>[];

    Get.back(result: true);
  }

  getStockTransaction() async {
    try {
      var r = await SaleRepository().getStockTransactionById(
        id: stockTransaction.id ?? 0,
      );
      stockTransaction = r ?? stockTransaction;
      getProductTransactions();
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    }
  }
}
