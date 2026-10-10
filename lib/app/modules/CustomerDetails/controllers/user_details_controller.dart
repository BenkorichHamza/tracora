import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/user_repository.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/data/repositories/purchase_repository.dart';
import 'package:tracora/app/data/repositories/stock_transaction_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/modules/User/controllers/user_controller.dart';
import 'package:tracora/app/modules/UserForm/controllers/user_form_controller.dart';

class UserDetailsController<T> extends GetxController
    with GetTickerProviderStateMixin {
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
  MoneyTransactionRepository moneyRepository = MoneyTransactionRepository();
  StockTransactionRepository transactionRepository =
      StockTransactionRepository<T>();
  final _user = UserModel().obs;
  UserModel get user => this._user.value;
  set user(UserModel value) => this._user.value = value;

  final _stockTransactions = <StockTransaction>[].obs;
  List<StockTransaction> get stockTransactions => this._stockTransactions.value;
  set stockTransactions(List<StockTransaction> value) =>
      this._stockTransactions.value = value;

  final _employeeTransactions = <StockTransaction>[].obs;
  List<StockTransaction> get employeeTransaction =>
      this._employeeTransactions.value;
  set employeeTransaction(List<StockTransaction> value) =>
      this._employeeTransactions.value = value;

  final _moneyTransactions = <MoneyTransaction>[].obs;
  List<MoneyTransaction> get moneyTransactions => this._moneyTransactions.value;
  set moneyTransactions(List<MoneyTransaction> value) =>
      this._moneyTransactions.value = value;

  final _employeeMoneyTransactions = <MoneyTransaction>[].obs;
  List<MoneyTransaction> get employeeMoneyTransactions =>
      this._employeeMoneyTransactions.value;
  set employeeMoneyTransactions(List<MoneyTransaction> value) =>
      this._employeeMoneyTransactions.value = value;

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
    getEmployeeMoneyTransactions();
    getStockTransactions();
    getStockTransactionsByEmployee();
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
        ids: user.ids ?? "",
        type: "$transactionType",
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  Future getEmployeeMoneyTransactions() async {
    try {
      employeeMoneyTransactions = await moneyRepository
          .getMoneyTransactionsForEmployee(id: user.id ?? 0, type: "$userType");
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  Future getStockTransactions() async {
    try {
      stockTransactions = await transactionRepository.getAllTransactionsFor(
        ids: user.ids ?? "",
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  Future getStockTransactionsByEmployee() async {
    try {
      employeeTransaction = await transactionRepository
          .getAllTransactionsForEmployee(id: user.id ?? 0);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  Future getProductTransactions() async {
    try {
      productTransactions = await transactionRepository
          .getProductTransactionsFor(user.id ?? 0);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  Future getUser() async {
    try {
      var r = await UserRepository().getUser(user.id ?? 0);
      user = r ?? user;
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  delete() async {
    var b = await deleteConfirmation();
    if (b != true) return;
    await UserRepository().deleteUser(user);
    Get.find<UserController<T>>().getAll();
    Get.find<UserDetailsController<T>>().user = UserModel();

    Get.back(result: true);
  }

  edit() {
    Get.find<UserFormController<T>>().init(user);
    Get.find<UserController<T>>().showForm = true;
  }

  void print() {}
}
