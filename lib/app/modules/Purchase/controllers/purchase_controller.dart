import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/repositories/product_repository.dart';
import 'package:tracora/app/data/repositories/purchase_repository.dart';

class PurchaseController extends GetxController {
  final repository = PurchaseRepository();
  final _stockTransactions = <StockTransaction>[].obs;
  List<StockTransaction> get purchases => this._stockTransactions.value;
  set purchases(List<StockTransaction> value) =>
      this._stockTransactions.value = value;

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

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
    // try {
    //   listener.cancel();
    // } on Exception catch (e) {
    //   // TODO
    // }
  }

  getAll() async {
    try {
      loading = true;
      purchases = await repository.getAllPurchases(search: search.text);
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }

  // listen() async {
  //   try {
  //     listener.cancel();
  //   } catch (e) {}
  //   listener = FirebaseFirestore.instance
  //       .collection('stockTransactions')
  //       .where("type", isEqualTo: "purchase")
  //       // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
  //       .snapshots(includeMetadataChanges: true)
  //       .listen((data) async {
  //         if (data.metadata.isFromCache) return;
  //         await Future.forEach(data.docs, (element) async {
  //           element..data()?["remoteId"] = element.data()?["id"];
  //           var model = StockTransaction.fromMap(element.data()!);
  //           await repository.insertPurchase(model, sync: false);
  //         });
  //         getAll();
  //       });
  // }

  // listen() async {
  //   try {
  //     listener.cancel();
  //   } catch (e) {}
  //   listener = FirebaseFirestore.instance
  //       .collection('stockTransactions')
  //       .snapshots()
  //       .listen((data) async {
  //         await Future.forEach(data.docChanges, (element) async {
  //           element.data()?["remoteId"] = element.data()?["id"];
  //           element.data()?["id"] = null;

  //           await repository.insertPurchase(
  //             element.data() != null
  //                 ? StockTransaction.fromMap(element.data()!..["id"] = null)
  //                 : StockTransaction(),
  //             sync: false,
  //           );
  //         });
  //         getAll();
  //       });
  // }
}
