import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';

class CustomerPaymentController extends GetxController {
  final repository = MoneyTransactionRepository();
  final _moneyTransactions = <MoneyTransaction>[].obs;
  List<MoneyTransaction> get moneyTransactions => this._moneyTransactions.value;
  set moneyTransactions(List<MoneyTransaction> value) =>
      this._moneyTransactions.value = value;

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;
  final _offset = 0.obs;
  int get offset => this._offset.value;
  set offset(int value) => this._offset.value = value;

  loadMore() {
    offset = moneyTransactions.length;
    getAll();
  }

  final _showSearch = false.obs;
  bool get showSearch => this._showSearch.value;

  TextEditingController search = TextEditingController();
  set showSearch(bool value) => this._showSearch.value = value;

  late StreamSubscription listener;

  @override
  void onInit() {
    super.onInit();
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
  }

  getAll() async {
    try {
      loading = true && offset == 0;
      moneyTransactions = await repository.getMoneyTransactions(
        search: search.text,
        type: "sale",
        offset: offset,
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }

  filter() async {
    try {
      offset = 0;
      moneyTransactions = await repository.getMoneyTransactions(
        search: search.text,
        type: "sale",
        offset: offset,
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }
}
