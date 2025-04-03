import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/modules/TransactionForm/views/product_shopping_view.dart';
import 'package:tracora/app/modules/TransactionForm/views/transaction_cart_bar.dart';
import 'package:tracora/app/modules/TransactionForm/views/transaction_checkout.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

import '../controllers/transaction_form_controller.dart';

class TransactionFormView<T> extends GetView<TransactionFormController<T>> {
  const TransactionFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: ProductShoppingView<T>()),
          Container(
            width: 400,
            margin: EdgeInsets.all(4),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 0.2),
            ),
            child: TransactionCheckoutPage<T>(),
          ),
        ],
      ),
    );
  }
}
