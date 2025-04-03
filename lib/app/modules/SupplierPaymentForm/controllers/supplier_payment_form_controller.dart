import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/data/repositories/purchase_repository.dart';
import 'package:tracora/app/modules/User/bindings/user_binding.dart';
import 'package:tracora/app/modules/CustomerDetails/controllers/user_details_controller.dart';
import 'package:tracora/app/modules/CustomerDetails/views/user_details_view.dart';
import 'package:tracora/app/modules/Purchase/controllers/purchase_controller.dart';
import 'package:tracora/app/modules/PurchaseForm/views/bottom_sheet_item_selector.dart';
import 'package:tracora/app/modules/SupplierDetails/controllers/supplier_details_controller.dart';
import 'package:tracora/app/modules/SupplierPayment/controllers/supplier_payment_controller.dart';
import 'package:tracora/app/modules/SupplierPaymentDetails/controllers/supplier_payment_details_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';

class SupplierPaymentFormController extends GetxController {
  final MoneyTransactionRepository repository = MoneyTransactionRepository();
  final _moneyTransaction = MoneyTransaction().obs;
  MoneyTransaction get moneyTransaction => this._moneyTransaction.value;
  set moneyTransaction(MoneyTransaction value) =>
      this._moneyTransaction.value = value;

  final _dateTime = DateTime.now().millisecondsSinceEpoch.obs;
  int get dateTime => this._dateTime.value;
  set dateTime(int value) => this._dateTime.value = value;

  final _supplier = UserModel().obs;
  UserModel get supplier => this._supplier.value;
  set supplier(UserModel value) => this._supplier.value = value;

  final _employee = UserModel().obs;
  UserModel get employee => this._employee.value;
  set employee(UserModel value) => this._employee.value = value;

  late TextEditingController payment;

  @override
  void onInit() {
    if (Get.arguments?['moneyTransaction'] is MoneyTransaction) {
      moneyTransaction = Get.arguments?["moneyTransaction"] ?? moneyTransaction;
      supplier = moneyTransaction.user ?? supplier;
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

  sellectSupplier() async {
    var r = await Get.toNamed(
      Routes.SUPPLIER,
      arguments: {"supplier": supplier, 'select': true},
    );
    if (r is UserModel && r.type == "supplier") supplier = r;
  }

  save() async {
    try {
      if (supplier.id == null) {
        ErrorHandler.showError("select_supplier".tr);
        return;
      }
      if (double.tryParse(payment.text) == null) {
        ErrorHandler.showError("make_payment".tr);
        return;
      }
      if (!validate) return;
      var n = moneyTransaction.copyWith(
        user: supplier,
        amount: double.tryParse(payment.text),
        credit: supplier.toPay,
        dateTime: dateTime,
        type: "purchase",
      );
      var id = await repository.insertMoneyTransaction(n);
      if (Get.isRegistered<SupplierPaymentController>()) {
        Get.find<SupplierPaymentController>().getAll();
      }
      if (Get.isRegistered<SupplierPaymentDetailsController>()) {
        Get.find<SupplierPaymentDetailsController>().getMoneyTransaction();
      }
      if (Get.isRegistered<SupplierDetailsController>()) {
        await Get.find<SupplierDetailsController>().getMoneyTransactions();
        await Get.find<SupplierDetailsController>().getUser();
      }

      Get.offNamedUntil(
        Routes.SUPPLIER_PAYMENT_DETAILS,
        (r) => [
          Routes.SUPPLIER_PAYMENT,
          Routes.SUPPLIER_DETAILS,
        ].contains(r.settings.name),
        arguments: {"moneyTransaction": n.copyWith(id: id <= 0 ? null : id)},
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  bool get validate =>
      supplier.id != null && int.tryParse(payment.text) != null;
}
