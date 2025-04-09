import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/stock_transaction_repository.dart';
import 'package:tracora/app/modules/StockTransactionDetails/controllers/stock_transaction_details_controller.dart';
import 'package:tracora/app/modules/StockTransactionDetails/views/stock_transaction_details_view.dart';

class StockTransactionController<T> extends GetxController
    with GetTickerProviderStateMixin {
  final repository = StockTransactionRepository<T>();
  final _stockTransactions = <StockTransaction>[].obs;
  List<StockTransaction> get transactions => this._stockTransactions.value;
  set transactions(List<StockTransaction> value) =>
      this._stockTransactions.value = value;

  final _employee = UserModel().obs;
  UserModel get employee => this._employee.value;
  set employee(UserModel value) => this._employee.value = value;

  final _showForm = false.obs;
  bool get showForm => this._showForm.value;
  set showForm(bool value) => this._showForm.value = value;

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _showSearch = false.obs;
  bool get showSearch => this._showSearch.value;

  get detailsController =>
      transactionType == "purchase"
          ? Get.find<StockTransactionDetailsController<Purchase>>()
          : Get.find<StockTransactionDetailsController<Sale>>();

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
  delete() {
    if (selected.id == null) return;
    Get.find<StockTransactionDetailsController<T>>().delete();
  }

  next() {
    var i = transactions.indexWhere((e) => e.id == selected.id);
    if (i >= transactions.length - 1) return;

    toDetails(transactions[i + 1]);
  }

  previous() {
    var i = transactions.indexWhere((e) => e.id == selected.id);
    if (i == 0) return;
    toDetails(transactions[i - 1]);
  }

  TextEditingController search = TextEditingController();
  set showSearch(bool value) => this._showSearch.value = value;
  late StreamSubscription listener;
  late TabController tabCtrl;
  late FocusNode focusNode;
  late FocusNode searchFn;

  @override
  void onInit() {
    super.onInit();
    focusNode = FocusNode();
    searchFn = FocusNode();
    tabCtrl = TabController(length: 2, vsync: this);
    getAll();
    // listen();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    // try {
    //   listener.cancel();
    // } on Exception catch (e) {
    //   // TODO
    // }
  }

  getAll() async {
    try {
      loading = true;
      transactions = await repository.getAllTransactions(
        search: search.text,
        employee: employee,
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }

  listen() async {
    try {
      listener.cancel();
    } catch (e) {}
    listener = FirebaseFirestore.instance
        .collection('stockTransactions')
        .where("transactionType", isEqualTo: transactionType)
        // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          if (data.metadata.isFromCache) return;
          await Future.forEach(data.docs, (element) async {
            element.data()?["remoteId"] = element.data()?["id"];
            var model = StockTransaction.fromMap(element.data()!);
            await repository.insert(model, sync: false);
          });
          getAll();
        });
  }

  final _selected = StockTransaction().obs;
  StockTransaction get selected => this._selected.value;
  set selected(StockTransaction value) => this._selected.value = value;

  void toDetails(StockTransaction transaction) async {
    var id = selected.id;
    selected = transaction;
    update(['item_${transaction.id}', 'item_$id']);
    Get.find<StockTransactionDetailsController<T>>().stockTransaction =
        transaction;
    Get.find<StockTransactionDetailsController<T>>().getProductTransactions();
    Get.find<StockTransactionDetailsController<T>>()
        .getMissionStockTransactions();

    Get.find<StockTransactionDetailsController<T>>()
        .getMissionMoneyTransactions();
    if (T == Mission) {
      // Get.find<StockTransactionDetailsController<T>>().listenToSales();
      // Get.find<StockTransactionDetailsController<T>>().listenToPayments();
      Get.find<StockTransactionDetailsController<T>>().listenToSync();
    }
  }
}
