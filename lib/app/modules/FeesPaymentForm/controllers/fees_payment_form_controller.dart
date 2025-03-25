import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/modules/FeesPayment/controllers/fees_payment_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';

class FeesPaymentFormController extends GetxController {
  final MoneyTransactionRepository repository = MoneyTransactionRepository();
  final _moneyTransaction = MoneyTransaction().obs;
  MoneyTransaction get moneyTransaction => this._moneyTransaction.value;
  set moneyTransaction(MoneyTransaction value) =>
      this._moneyTransaction.value = value;

  final _dateTime = DateTime.now().millisecondsSinceEpoch.obs;
  int get dateTime => this._dateTime.value;
  set dateTime(int value) => this._dateTime.value = value;

  final _employee = UserModel().obs;
  UserModel get employee => this._employee.value;
  set employee(UserModel value) => this._employee.value = value;

  late TextEditingController description;
  late TextEditingController payment;

  @override
  void onInit() {
    if (Get.arguments?['moneyTransaction'] is MoneyTransaction) {
      moneyTransaction = Get.arguments?["moneyTransaction"] ?? moneyTransaction;
      employee = moneyTransaction.employee ?? employee;
    }
    payment = TextEditingController(
      text: moneyTransaction.amount?.floor().toString(),
    );
    description = TextEditingController(
      text: moneyTransaction.description?.toString(),
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

  save() async {
    try {
      if (description.text.length < 3) {
        ErrorHandler.showError("make_title".tr);
        return;
      }
      if (double.tryParse(payment.text) == null) {
        ErrorHandler.showError("make_payment".tr);
        return;
      }
      if (!validate) return;
      var n = moneyTransaction.copyWith(
        amount: double.tryParse(payment.text),
        description: description.text,
        dateTime: dateTime,
        type: "fees",
      );
      var id = await repository.insertMoneyTransaction(n);
      if (Get.isRegistered<FeesPaymentController>()) {
        Get.find<FeesPaymentController>().getAll();
      }
      Get.offNamedUntil(
        Routes.FEES_PAYMENT_DETAILS,
        (r) => r.settings.name == Routes.FEES_PAYMENT,
        arguments: {"moneyTransaction": n.copyWith(id: id <= 0 ? null : id)},
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  bool get validate =>
      int.tryParse(payment.text) != null && description.text.length >= 3;
}
