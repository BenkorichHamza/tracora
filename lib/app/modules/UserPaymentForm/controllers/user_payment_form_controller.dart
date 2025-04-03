import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/modules/User/controllers/user_controller.dart';
import 'package:tracora/app/modules/User/views/user_view.dart';
import 'package:tracora/app/modules/CustomerDetails/controllers/user_details_controller.dart';
import 'package:tracora/app/modules/UserPaymentDetails/controllers/user_payment_details_controller.dart';
import 'package:tracora/app/modules/UserPayment/controllers/user_payment_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';

class UserPaymentFormController<T> extends GetxController {
  String get userType => T == Sale || T == Customer ? "customer" : "supplier";
  String get transactionType =>
      T == Sale || T == Customer ? "sale" : "purchase";
  final MoneyTransactionRepository repository = MoneyTransactionRepository();
  final _moneyTransaction = MoneyTransaction().obs;
  MoneyTransaction get transaction => this._moneyTransaction.value;
  set transaction(MoneyTransaction value) =>
      this._moneyTransaction.value = value;

  final _dateTime = DateTime.now().millisecondsSinceEpoch.obs;
  int get dateTime => this._dateTime.value;
  set dateTime(int value) => this._dateTime.value = value;

  final _user = UserModel().obs;
  UserModel get user => this._user.value;
  set user(UserModel value) => this._user.value = value;

  final _employee = UserModel().obs;
  UserModel get employee => this._employee.value;
  set employee(UserModel value) => this._employee.value = value;

  late TextEditingController payment;
  late FocusNode paymentFn;

  @override
  void onInit() {
    if (Get.arguments?['moneyTransaction'] is MoneyTransaction) {
      transaction = Get.arguments?["moneyTransaction"] ?? transaction;
      user = transaction.user ?? user;
      employee = transaction.employee ?? employee;
    }
    payment = TextEditingController(
      text: transaction.amount?.floor().toString(),
    );
    dateTime = transaction.dateTime ?? transaction.createdAt ?? dateTime;
    paymentFn =
        FocusNode()..addListener(() {
          payment.selection = TextSelection(
            baseOffset: 0,
            extentOffset: payment.text.length,
          );
        });
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

  editTime() async {
    var r = await showDatePicker(
      context: Get.context!,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    dateTime = r?.millisecondsSinceEpoch ?? dateTime;
  }

  selectUser() async {
    if (T == Sale || T == Customer) {
      Get.find<UserController<Customer>>().getAll();
    } else {
      Get.find<UserController<Supplier>>().getAll();
    }
    var r = await showDialog(
      routeSettings: RouteSettings(arguments: {"select": true}),
      context: Get.context!,
      builder:
          (c) => Dialog(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 450),
              child: T == Sale ? UserView<Customer>() : UserView<Supplier>(),
            ),
          ),
    );
    if (r is UserModel && r.type == "$userType") user = r;
  }

  save() async {
    try {
      if (user.id == null) {
        ErrorHandler.showError("select_user".tr);
        return;
      }
      if (double.tryParse(payment.text) == null) {
        ErrorHandler.showError("make_payment".tr);
        return;
      }
      if (!validate) return;
      var n = transaction.copyWith(
        user: user,
        amount: double.tryParse(payment.text),
        credit: user.toPay,
        dateTime: dateTime,
        type: "$transactionType",
      );
      var id = await repository.insertMoneyTransaction(n);
      if (Get.isRegistered<UserPaymentController<T>>()) {
        Get.find<UserPaymentController<T>>().getAll();
      }

      if (Get.isRegistered<UserDetailsController<T>>()) {
        await Get.find<UserDetailsController<T>>().getProductTransactions();
        await Get.find<UserDetailsController<T>>().getStockTransactions();
        await Get.find<UserDetailsController<T>>().getUser();
      }
      n = n.copyWith(id: id <= 0 ? null : id, dateTime: dateTime);
      transaction = transaction.copyWith(id: id);
      Get.find<UserPaymentController<T>>().showForm = false;
      Get.find<UserPaymentDetailsController<T>>().getMoneyTransaction();
      init(MoneyTransaction());
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  void init([MoneyTransaction? moneyTransaction]) {
    transaction = moneyTransaction ?? MoneyTransaction();
    user = transaction.user ?? UserModel();
    employee = transaction.employee ?? employee;

    dateTime = transaction.dateTime ?? 0;

    payment = TextEditingController(
      text: transaction.amount?.floor().toString(),
    );
    paymentFn =
        FocusNode()..addListener(() {
          payment.selection = TextSelection(
            baseOffset: 0,
            extentOffset: payment.text.length,
          );
        });
    dateTime = transaction.dateTime ?? transaction.createdAt ?? dateTime;
  }

  bool get validate => user.id != null && int.tryParse(payment.text) != null;
}
