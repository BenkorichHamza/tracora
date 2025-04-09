import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
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

  final _missionPayments = <MoneyTransaction>[].obs;
  List<MoneyTransaction> get missionPayments => this._missionPayments.value;
  set missionPayments(List<MoneyTransaction> value) =>
      this._missionPayments.value = value;

  final _sync = false.obs;
  get sync => this._sync.value;
  set sync(value) => this._sync.value = value;

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

  late StreamSubscription listener;
  late StreamSubscription paymentListener;

  @override
  void onInit() {
    tabCtrl = TabController(length: 4, vsync: this);
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
      // getMissionStockTransactions();
      // listenToSales();
      // listenToPayments();
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
      // loading = true;
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
      var r = await StockTransactionRepository().getMissionStockTransactions(
        ids: stockTransaction.ids ?? "",
      );
      missionSales = r;
      getProductTransactions();
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  getMissionMoneyTransactions() async {
    try {
      var r = await MoneyTransactionRepository().getMissionMoneyTransactions(
        ids: stockTransaction.ids ?? "",
      );
      missionPayments = r;
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  listenToSSales() async {
    try {
      await listener.cancel();
    } catch (e) {}
    listener = FirebaseFirestore.instance
        .collection("missions")
        .doc(stockTransaction.ids)
        .collection("stockTransactions")
        .snapshots()
        .listen((data) async {
          if (data.docChanges.isEmpty) return;
          var sales =
              data.docs.map((d) => StockTransaction.fromMap(d.data())).toList();
          await Future.forEach(sales, (s) async {
            if (s.type == "sale") {
              await StockTransactionRepository<Sale>().insert(
                s,
                sync: s.id == null,
                mission: false,
              );
            } else {
              await StockTransactionRepository<Purchase>().insert(
                s,
                sync: s.id == null,
                mission: false,
              );
            }
          });
          getMissionStockTransactions();
        });
  }

  listenToPayments() async {
    try {
      await paymentListener.cancel();
    } catch (e) {}
    paymentListener = FirebaseFirestore.instance
        .collection("missions")
        .doc(stockTransaction.ids)
        .collection("moneyTransactions")
        .snapshots()
        .listen((data) async {
          var sales =
              data.docs.map((d) => MoneyTransaction.fromMap(d.data())).toList();
          await Future.forEach(sales, (s) async {
            await MoneyTransactionRepository().insertMoneyTransaction(
              s,
              sync: s.id == null,
            );
          });
          getMissionMoneyTransactions();
        });
  }

  edit() {
    Get.lazyPut(() => ProductController());
    changed = true;
    Get.find<TransactionFormController<T>>().init(stockTransaction);
    Get.find<StockTransactionController<T>>().showForm = true;
  }

  late StreamSubscription syncListener;
  listenToSync() {
    sync = false;
    try {
      syncListener.cancel();
    } catch (e) {}
    syncListener = FirebaseFirestore.instance
        .collection("missions")
        .doc(stockTransaction.ids)
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
          sync = !event.metadata.hasPendingWrites;
        });
  }

  void printTicket() {}
}
