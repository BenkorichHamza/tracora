import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/repositories/product_repository.dart';
import 'package:tracora/app/data/repositories/sale_repository.dart';

class SaleController extends GetxController with GetTickerProviderStateMixin {
  final repository = SaleRepository();
  final _stockTransactions = <StockTransaction>[].obs;
  List<StockTransaction> get sales => this._stockTransactions.value;
  set sales(List<StockTransaction> value) =>
      this._stockTransactions.value = value;

  final _showForm = false.obs;
  bool get showForm => this._showForm.value;
  set showForm(bool value) => this._showForm.value = value;

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _showSearch = false.obs;
  bool get showSearch => this._showSearch.value;

  TextEditingController search = TextEditingController();
  set showSearch(bool value) => this._showSearch.value = value;
  late StreamSubscription listener;
  late TabController tabCtrl;

  @override
  void onInit() {
    super.onInit();
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
      sales = await repository.getAllSales(search: search.text);
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
        .where("type", isEqualTo: "sale")
        // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          if (data.metadata.isFromCache) return;
          await Future.forEach(data.docs, (element) async {
            element.data()?["remoteId"] = element.data()?["id"];
            var model = StockTransaction.fromMap(element.data()!);
            await repository.insertSale(model, sync: false);
          });
          getAll();
        });
  }
}
