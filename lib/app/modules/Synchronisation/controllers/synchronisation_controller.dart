import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';

class SynchronisationController extends GetxController {
  final _missions = <StockTransaction>[].obs;
  List<StockTransaction> get missions => this._missions.value;
  set missions(List<StockTransaction> value) => this._missions.value = value;

  final _sales = <StockTransaction>[].obs;
  List<StockTransaction> get sales => this._sales.value;
  set sales(List<StockTransaction> value) => this._sales.value = value;

  final _payments = <MoneyTransaction>[].obs;
  List<MoneyTransaction> get payments => this._payments.value;
  set payments(List<MoneyTransaction> value) => this._payments.value = value;

  final _paymentLoading = false.obs;
  bool get paymentLoading => this._paymentLoading.value;
  set paymentLoading(bool value) => this._paymentLoading.value = value;

  final _missionLoading = false.obs;
  bool get missionLoading => this._missionLoading.value;
  set missionLoading(bool value) => this._missionLoading.value = value;

  final _saleLoading = false.obs;
  bool get saleLoading => this._saleLoading.value;
  set saleLoading(bool value) => this._saleLoading.value = value;

  @override
  void onInit() {
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

  getMissions() async {
    if (missionLoading) {
      return;
    }
    try {
      missionLoading = true;
      var d = await FirebaseFirestore.instance
          .collectionGroup('missions')
          .get(GetOptions(source: Source.server));
      missions = d.docs.map((e) => StockTransaction.fromMap(e.data())).toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      missionLoading = false;
    }
  }

  getSales() async {
    if (saleLoading) {
      return;
    }
    try {
      saleLoading = true;
      var d = await FirebaseFirestore.instance
          .collectionGroup('stockTransactions')
          .where(
            "updatedBy",
            isNotEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "admin",
          )
          .orderBy("dateTime", descending: true)
          .get(GetOptions(source: Source.server));
      sales = d.docs.map((e) => StockTransaction.fromMap(e.data())).toList();
    } catch (e) {
      print(e);
      ErrorHandler.handleError(e);
    } finally {
      saleLoading = false;
    }
  }

  getPayments() async {
    if (paymentLoading) {
      return;
    }
    try {
      paymentLoading = true;
      var d = await FirebaseFirestore.instance
          .collectionGroup('moneyTransactions')
          .where(
            "updatedBy",
            isNotEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "admin",
          )
          .get(GetOptions(source: Source.server));
      payments = d.docs.map((e) => MoneyTransaction.fromMap(e.data())).toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      paymentLoading = false;
    }
  }
}
