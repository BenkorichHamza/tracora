import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_form_model.dart';
import 'package:tracora/app/modules/TransactionForm/views/product_shopping_view.dart';
import 'package:tracora/app/modules/TransactionForm/views/transaction_cart_bar.dart';
import 'package:tracora/app/modules/TransactionForm/views/transaction_checkout.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

import '../controllers/transaction_form_controller.dart';

class TransactionFormView<T> extends StatelessWidget {
  final TransactionForm form;
  const TransactionFormView({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: ProductShoppingView<T>()),
          SizedBox(width: 8),
          Container(
            width: 500,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: TransactionCheckoutPage<T>(),
          ),
        ],
      ),
    );
  }
}
