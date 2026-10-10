import 'package:flutter/material.dart';

import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/helper/extensions.dart';

class TransactionForm<T> {
  List<ProductTransaction>? productTransactions;
  UserModel? user;
  late TextEditingController payment;
  int? dateTime;
  late FocusNode paymentFn;
  int index;
  StockTransaction stockTransaction;
  TransactionForm({
    required this.index,
    required this.stockTransaction,
    this.dateTime,
    this.user,
    this.productTransactions,
  }) {
    productTransactions =
        productTransactions ?? stockTransaction.productTransactions;
    user = user ?? stockTransaction.user;
    payment = TextEditingController(text: stockTransaction.payment.toString());
    dateTime = dateTime ?? stockTransaction.dateTime;
    paymentFn = FocusNode();
    payment = TextEditingController(
      text: stockTransaction.payment.formatNumber(),
    );
  }

  double get total => (productTransactions ?? []).fold(
    0.0,
    (previousValue, element) =>
        previousValue + (element.qte ?? 0) * (element.price ?? 0),
  );
  TransactionForm<T> copyWith({
    List<ProductTransaction>? productTransactions,
    UserModel? user,
    int? dateTime,
    int? index,
    StockTransaction? stockTransaction,
  }) {
    return TransactionForm<T>(
      productTransactions: productTransactions ?? this.productTransactions,
      user: user ?? this.user,
      dateTime: dateTime ?? this.dateTime,
      index: index ?? this.index,
      stockTransaction: stockTransaction ?? this.stockTransaction,
    );
  }
}
