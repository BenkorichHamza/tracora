import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/data/repositories/stock_transaction_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/Statistic/controllers/statistic_controller.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/TransactionForm/controllers/transaction_form_controller.dart';
import 'package:tracora/app/modules/UserPayment/controllers/user_payment_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class StockTransactionDetailsController<T> extends GetxController
    with GetTickerProviderStateMixin {
  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _synchronisationLoading = false.obs;
  bool get synchronisationLoading => this._synchronisationLoading.value;
  set synchronisationLoading(bool value) =>
      this._synchronisationLoading.value = value;

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

  final _missionProductTransactions = <ProductTransaction>[].obs;
  List<ProductTransaction> get missionProductTransactions =>
      this._missionProductTransactions.value;
  set missionProductTransactions(List<ProductTransaction> value) =>
      this._missionProductTransactions.value = value;

  final _missionSales = <StockTransaction>[].obs;
  List<StockTransaction> get missionSales => this._missionSales.value;
  set missionSales(List<StockTransaction> value) =>
      this._missionSales.value = value;

  final _missionOnlineSales = <StockTransaction>[].obs;
  List<StockTransaction> get missionOnlineSales =>
      this._missionOnlineSales.value;
  set missionOnlineSales(List<StockTransaction> value) =>
      this._missionOnlineSales.value = value;

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

  double saledQteOf(ProductTransaction? pt) =>
      pt?.product == null
          ? 0
          : missionProductTransactions
              .where((e) => e.product?.id == pt?.product?.id)
              .fold(0.0, (a, b) => a + (b.qte ?? 0) * (b.direction ?? 0))
              .abs();
  double restQteOf(ProductTransaction? pt) =>
      pt?.product == null ? 0 : (pt!.qte ?? 0) - saledQteOf(pt);

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

  getMissionProductTransactions() async {
    try {
      // if (T == Mission) return;
      // loading = true;
      missionProductTransactions = await repository
          .getMissionProductTransactions(
            missionIds: stockTransaction.ids ?? "default",
          );
      print(missionProductTransactions.length);
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

  Future getStockTransaction() async {
    try {
      var r = await StockTransactionRepository().getStockTransactionById(
        id: stockTransaction.id ?? 0,
      );
      stockTransaction = r ?? stockTransaction;
      Get.find<StockTransactionController<Mission>>().getAll();
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
        .collection("collections")
        .doc(Get.find<HomeController>().collection)
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
        .collection("collections")
        .doc(Get.find<HomeController>().collection)
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

  double get totalSalePayments =>
      missionSales.fold(0.0, (a, b) => a + (b.payment ?? 0));

  double get totalPayments =>
      missionPayments.fold(0.0, (a, b) => a + (b.amount ?? 0));

  double get totalSaled => missionSales.fold(0.0, (a, b) => a + (b.total ?? 0));

  double get totalCaisse => totalPayments + totalSalePayments;
  listenToSync() {
    sync = false;
    try {
      syncListener.cancel();
    } catch (e) {}
    syncListener = FirebaseFirestore.instance
        .collection("collections")
        .doc(Get.find<HomeController>().collection)
        .collection("missions")
        .doc(stockTransaction.ids)
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
          sync = !event.metadata.hasPendingWrites;
        });
  }

  void printTicket() {}

  void approve() async {
    await StockTransactionRepository<T>().insert(
      stockTransaction.copyWith(
        status: 1,
        productTransactions: productTransactions,
      ),

      sync: false,
    );
    FirebaseFirestore.instance
        .collection("collections")
        .doc(Get.find<HomeController>().collection)
        .collection("missions")
        .doc(stockTransaction.missionIds ?? "default")
        .collection("stockTransactions")
        .doc(stockTransaction.ids ?? "default")
        .update({
          "status": 1,
          "updatedBy": FirebaseAuth.instance.currentUser?.uid ?? "admin",
        })
        .catchError((e) {
          ErrorHandler.handleError(e);
        });
    var missionsCtrl = Get.find<StockTransactionController<Mission>>();
    var ctrl = Get.find<StockTransactionController<T>>();
    await getStockTransaction();
    var index = ctrl.transactions.indexWhere(
      (e) => e.id == stockTransaction.id,
    );

    if (index != -1) {
      ctrl.transactions[index] = stockTransaction;
      ctrl.transactions = ctrl.transactions.sublist(0);
    }

    if (missionsCtrl.selected.id == null) return;
    missionsCtrl.toDetails(missionsCtrl.selected);
  }

  void synchronize() async {
    try {
      synchronisationLoading = true;
      var collection = Get.find<HomeController>().collection;
      var data = await FirebaseFirestore.instance
          .collection("collections")
          .doc(collection)
          .collection("missions")
          .doc(stockTransaction.ids ?? "default")
          .collection("stockTransactions")
          .where(
            "updatedBy",
            whereNotIn: [
              FirebaseAuth.instance.currentUser?.uid ?? "admin",
              "admin",
            ],
          )
          .get(GetOptions(source: Source.server));

      var sales =
          data.docChanges
              .where((e) => e.type != DocumentChangeType.removed)
              .map((d) => StockTransaction.fromMap(d.doc.data() ?? {}))
              .toList();
      sales = sales.where((e) => (e.topay ?? 0) > 0).toList();
      print(sales.length);
      await Future.forEach(sales, (s) async {
        if (s.type == "sale") {
          await StockTransactionRepository<Sale>().insert(
            s.copyWith(status: 0),
            sync:
                s.id == null ||
                s.updatedBy !=
                    (FirebaseAuth.instance.currentUser?.uid ?? "admin"),
            mission: false,
          );
        } else {
          await StockTransactionRepository<Purchase>().insert(
            s.copyWith(status: 0),
            sync:
                s.id == null ||
                s.updatedBy !=
                    (FirebaseAuth.instance.currentUser?.uid ?? "admin"),
            mission: false,
          );
        }
      });
      var data2 = await FirebaseFirestore.instance
          .collection("collections")
          .doc(collection)
          .collection("missions")
          .doc(stockTransaction.ids ?? "default")
          .collection("moneyTransactions")
          .where(
            "updatedBy",
            whereNotIn: [
              FirebaseAuth.instance.currentUser?.uid ?? "admin",
              "admin",
            ],
          )
          .get(GetOptions(source: Source.server));

      var payments =
          data2.docChanges
              .where((e) => e.type != DocumentChangeType.removed)
              .map((d) => MoneyTransaction.fromMap(d.doc.data() ?? {}))
              .toList();
      payments = payments.where((e) => (e.amount ?? 0) > 0).toList();
      await Future.forEach(payments, (s) async {
        await MoneyTransactionRepository().insertMoneyTransaction(
          s.copyWith(status: 0),
          sync:
              s.id == null ||
              s.updatedBy !=
                  (FirebaseAuth.instance.currentUser?.uid ?? "admin"),
        );
      });
      Get.find<StockTransactionController<Sale>>().getAll();
      Get.find<UserPaymentController<Sale>>().getAll();
      Get.find<StockTransactionDetailsController<Mission>>()
          .getMissionStockTransactions();
      Get.find<StockTransactionDetailsController<Mission>>()
          .getMissionMoneyTransactions();
      Get.find<StatisticController>().loadStatistics();
      Get.find<StockTransactionDetailsController<Mission>>()
          .getMissionProductTransactions();
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      synchronisationLoading = false;
    }
  }
}
