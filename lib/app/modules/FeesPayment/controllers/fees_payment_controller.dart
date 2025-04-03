import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/modules/FeesPaymentDetails/controllers/fees_payment_details_controller.dart';

class FeesPaymentController extends GetxController {
  final repository = MoneyTransactionRepository();
  final _moneyTransactions = <MoneyTransaction>[].obs;
  List<MoneyTransaction> get transactions => this._moneyTransactions.value;
  set transactions(List<MoneyTransaction> value) =>
      this._moneyTransactions.value = value;

  final _showForm = false.obs;
  bool get showForm => this._showForm.value;
  set showForm(bool value) => this._showForm.value = value;

  final _selected = MoneyTransaction().obs;
  MoneyTransaction get selected => this._selected.value;
  set selected(MoneyTransaction value) => this._selected.value = value;

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _showSearch = false.obs;
  bool get showSearch => this._showSearch.value;

  get detailsController => Get.find<FeesPaymentDetailsController>();

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
    // try {
    //   listener.cancel();
    // } on Exception catch (e) {
    //   // TODO
    // }
  }

  getAll() async {
    try {
      loading = true;
      transactions = await repository.getMoneyTransactions(
        search: search.text,
        type: "fees",
      );
    } catch (e) {
      ErrorHandler.handleError(e);
      rethrow;
    } finally {
      loading = false;
    }
  }

  listen() async {
    try {
      listener.cancel();
    } catch (e) {}
    listener = FirebaseFirestore.instance
        .collection('moneyTransactions')
        .where("type", isEqualTo: "fees")
        // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          if (data.metadata.isFromCache) return;
          await Future.forEach(data.docs, (element) async {
            element.data()?["remoteId"] = element.data()?["id"];
            var model = MoneyTransaction.fromMap(element.data()!);
            await repository.insertMoneyTransaction(model, sync: false);
          });
          getAll();
        });
  }

  void toDetails(MoneyTransaction transaction) async {
    var id = selected.id;
    selected = transaction;
    update(['item_${transaction.id}', 'item_$id']);
    Get.find<FeesPaymentDetailsController>().moneyTransaction = transaction;
  }
}
