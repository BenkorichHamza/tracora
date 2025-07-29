import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/employee_model.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/modules/FeesPayment/controllers/fees_payment_controller.dart';
import 'package:tracora/app/modules/FeesPaymentDetails/controllers/fees_payment_details_controller.dart';
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
  late FocusNode paymentFn;

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
      var id = await repository.insertMoneyTransaction(n, sync: false);
      if (Get.isRegistered<FeesPaymentController>()) {
        Get.find<FeesPaymentController>().getAll();
      }

      if (Get.isRegistered<FeesPaymentDetailsController>()) {
        // await Get.find<FeesPaymentDetailsController>();
      }
      n = n.copyWith(id: id <= 0 ? null : id, dateTime: dateTime);
      moneyTransaction = moneyTransaction.copyWith(id: id);
      Get.find<FeesPaymentController>().showForm = false;
      Get.find<FeesPaymentController>().getAll();
      Get.find<FeesPaymentDetailsController>().moneyTransaction = n;
      Get.find<FeesPaymentFormController>().moneyTransaction =
          MoneyTransaction();

      init(MoneyTransaction());
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  bool get validate =>
      int.tryParse(payment.text) != null && description.text.length >= 3;

  void init(MoneyTransaction? transaction) {
    transaction = transaction ?? MoneyTransaction();

    dateTime = transaction.dateTime ?? 0;
    description = TextEditingController(text: transaction.description);
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
}
