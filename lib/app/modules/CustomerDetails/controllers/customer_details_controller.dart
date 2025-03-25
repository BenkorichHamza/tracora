import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/customer_repository.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/data/repositories/purchase_repository.dart';
import 'package:tracora/app/data/repositories/sale_repository.dart';

class CustomerDetailsController extends GetxController
    with GetTickerProviderStateMixin {
  MoneyTransactionRepository moneyRepository = MoneyTransactionRepository();
  SaleRepository saleRepository = SaleRepository();
  final _user = UserModel().obs;
  UserModel get user => this._user.value;
  set user(UserModel value) => this._user.value = value;

  final _stockTransactions = <StockTransaction>[].obs;
  List<StockTransaction> get stockTransactions => this._stockTransactions.value;
  set stockTransactions(List<StockTransaction> value) =>
      this._stockTransactions.value = value;

  final _moneyTransactions = <MoneyTransaction>[].obs;
  List<MoneyTransaction> get moneyTransactions => this._moneyTransactions.value;
  set moneyTransactions(List<MoneyTransaction> value) =>
      this._moneyTransactions.value = value;

  final _productsTransactions = <ProductTransaction>[].obs;
  List<ProductTransaction> get productTransactions =>
      this._productsTransactions.value;
  set productTransactions(List<ProductTransaction> value) =>
      this._productsTransactions.value = value;

  late TabController tabCtrl;

  @override
  void onInit() {
    tabCtrl = TabController(length: 4, vsync: this);
    user = Get.arguments?["user"] ?? user;
    getProductTransactions();
    getMoneyTransactions();
    getStockTransactions();
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

  Future getMoneyTransactions() async {
    try {
      moneyTransactions = await moneyRepository.getMoneyTransactionsFor(
        id: user.id ?? 0,
        type: "sale",
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  Future getStockTransactions() async {
    try {
      stockTransactions = await saleRepository.getAllSalesFor(id: user.id ?? 0);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  Future getProductTransactions() async {
    try {
      productTransactions = await saleRepository.getProductTransactionsFor(
        user.id ?? 0,
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  Future getUser() async {
    try {
      var r = await CustomerRepository().getCustomer(user.id ?? 0);
      user = r ?? user;
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    }
  }
}
