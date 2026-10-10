import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/TransactionForm/views/transaction_form_view.dart';

class TransactionFormsPage<T> extends GetView<StockTransactionController<T>> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TransactionFormView<T>(
        form:
            controller.forms.firstWhereOrNull(
              (e) => e.index == controller.selectedFormIndex,
            )!,
      ),
    );
  }
}
