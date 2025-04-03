import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/stock_transaction_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/TransactionForm/controllers/transaction_form_controller.dart';

class StockTransactionDetailsController<T> extends GetxController
    with GetTickerProviderStateMixin {
  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _changed = false.obs;
  bool get changed => this._changed.value;
  set changed(bool value) => this._changed.value = value;

  final _stockTransactions = <StockTransaction>[].obs;
  List<StockTransaction> get stockTransactions => this._stockTransactions.value;
  set stockTransactions(List<StockTransaction> value) =>
      this._stockTransactions.value = value;

  final _moneyTransactions = <MoneyTransaction>[].obs;
  List<MoneyTransaction> get moneyTransactions => this._moneyTransactions.value;
  set moneyTransactions(List<MoneyTransaction> value) =>
      this._moneyTransactions.value = value;

  final StockTransactionRepository repository = StockTransactionRepository();
  final _stockTansaction = StockTransaction().obs;
  StockTransaction get stockTransaction => this._stockTansaction.value;
  set stockTransaction(StockTransaction value) =>
      this._stockTansaction.value = value;

  final _productTransactions = <ProductTransaction>[].obs;
  List<ProductTransaction> get productTransactions =>
      this._productTransactions.value;
  set productTransactions(List<ProductTransaction> value) =>
      this._productTransactions.value = value;

  final _missionSales = <StockTransaction>[].obs;
  List<StockTransaction> get missionSales => this._missionSales.value;
  set missionSales(List<StockTransaction> value) =>
      this._missionSales.value = value;

  late TabController tabCtrl;

  String get userType =>
      T == Sale || T == Customer
          ? "customer"
          : T == Purchase || T == Supplier
          ? "supplier"
          : "employee";
  String get transactionType =>
      T == Sale || T == Customer
          ? "sale"
          : T == Purchase || T == Supplier
          ? "purchase"
          : "mission";

  double get total => productTransactions.fold(
    0.0,
    (previousValue, element) =>
        previousValue + (element.qte ?? 0) * (element.price ?? 0),
  );

  @override
  void onInit() {
    tabCtrl = TabController(length: 3, vsync: this);
    if (Get.arguments?['sale'] is StockTransaction) {
      stockTransaction = Get.arguments?["sale"] ?? stockTransaction;
      productTransactions =
          stockTransaction.productTransactions ?? productTransactions;
    }
    if (stockTransaction.id != null) {
      getStockTransaction();
    }
    getProductTransactions();
    if (T == Mission) {
      getMissionStockTransactions();
    }
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
    await repository.deleteTransaction(stockTransaction);
    Get.find<StockTransactionController<T>>().getAll();
    stockTransaction = StockTransaction();
    productTransactions = <ProductTransaction>[];
  }

  getStockTransaction() async {
    try {
      var r = await StockTransactionRepository().getStockTransactionById(
        id: stockTransaction.id ?? 0,
      );
      stockTransaction = r ?? stockTransaction;
      getProductTransactions();
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  getMissionStockTransactions() async {
    try {
      var r = await StockTransactionRepository().getAllTransactionsForEmployee(
        id: stockTransaction.employee?.id ?? 0,
      );
      missionSales = r;
      getProductTransactions();
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  edit() {
    Get.lazyPut(() => ProductController());
    changed = true;
    Get.find<TransactionFormController<T>>().init(stockTransaction);
    Get.find<StockTransactionController<T>>().showForm = true;
  }

  void print() {}
}
