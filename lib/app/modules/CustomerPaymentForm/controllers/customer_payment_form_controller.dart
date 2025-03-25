import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/modules/Customer/controllers/customer_controller.dart';
import 'package:tracora/app/modules/Customer/views/customer_view.dart';
import 'package:tracora/app/modules/CustomerDetails/controllers/customer_details_controller.dart';
import 'package:tracora/app/modules/CustomerPayment/controllers/customer_payment_controller.dart';
import 'package:tracora/app/modules/CustomerPaymentDetails/controllers/customer_payment_details_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';

class CustomerPaymentFormController extends GetxController {
  final MoneyTransactionRepository repository = MoneyTransactionRepository();
  final _moneyTransaction = MoneyTransaction().obs;
  MoneyTransaction get moneyTransaction => this._moneyTransaction.value;
  set moneyTransaction(MoneyTransaction value) =>
      this._moneyTransaction.value = value;

  final _dateTime = DateTime.now().millisecondsSinceEpoch.obs;
  int get dateTime => this._dateTime.value;
  set dateTime(int value) => this._dateTime.value = value;

  final _customer = UserModel().obs;
  UserModel get customer => this._customer.value;
  set customer(UserModel value) => this._customer.value = value;

  final _employee = UserModel().obs;
  UserModel get employee => this._employee.value;
  set employee(UserModel value) => this._employee.value = value;

  late TextEditingController payment;

  @override
  void onInit() {
    if (Get.arguments?['moneyTransaction'] is MoneyTransaction) {
      moneyTransaction = Get.arguments?["moneyTransaction"] ?? moneyTransaction;
      customer = moneyTransaction.user ?? customer;
      employee = moneyTransaction.employee ?? employee;
    }
    payment = TextEditingController(
      text: moneyTransaction.amount?.floor().toString(),
    );
    dateTime =
        moneyTransaction.dateTime ?? moneyTransaction.createdAt ?? dateTime;
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

  sellectCustomer() async {
    var r = await Get.toNamed(
      Routes.CUSTOMER,
      arguments: {"customer": customer, 'select': true},
    );
    // Get.lazyPut(() => CustomerController());
    // var r = await showModalBottomSheet(
    //   context: Get.context!,
    //   routeSettings: RouteSettings(
    //     name: Routes.CUSTOMER,
    //     arguments: {"customer": customer, 'select': true},
    //   ),
    //   builder: (c) {
    //     return CustomerView();
    //   },
    // );
    if (r is UserModel && r.type == "customer") customer = r;
  }

  save() async {
    try {
      if (customer.id == null) {
        ErrorHandler.showError("select_customer".tr);
        return;
      }
      if (double.tryParse(payment.text) == null) {
        ErrorHandler.showError("make_payment".tr);
        return;
      }
      if (!validate) return;
      var n = moneyTransaction.copyWith(
        user: customer,
        amount: double.tryParse(payment.text),
        credit: customer.toPay,
        dateTime: dateTime,
        type: "sale",
      );
      var id = await repository.insertMoneyTransaction(n);
      if (Get.isRegistered<CustomerPaymentController>()) {
        Get.find<CustomerPaymentController>().getAll();
      }

      if (Get.isRegistered<CustomerDetailsController>()) {
        await Get.find<CustomerDetailsController>().getMoneyTransactions();
        await Get.find<CustomerDetailsController>().getUser();
      }
      Get.offNamedUntil(
        Routes.CUSTOMER_PAYMENT_DETAILS,
        (r) => [
          Routes.CUSTOMER_PAYMENT,
          Routes.CUSTOMER_DETAILS,
        ].contains(r.settings.name),
        arguments: {"moneyTransaction": n.copyWith(id: id <= 0 ? null : id)},
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  bool get validate =>
      customer.id != null && int.tryParse(payment.text) != null;
}
