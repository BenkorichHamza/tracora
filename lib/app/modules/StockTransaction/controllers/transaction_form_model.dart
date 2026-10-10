import 'package:flutter/material.dart';

import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/models/warehouse.dart';
import 'package:tracora/app/helper/extensions.dart';

class TransactionForm<T> {
  List<ProductTransaction>? productTransactions;
  UserModel? user;
  Warehouse? fromWarehouse;
  Warehouse? toWarehouse;
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
    this.fromWarehouse,
    this.toWarehouse,
    this.productTransactions,
  }) {
    productTransactions =
        productTransactions ?? stockTransaction.productTransactions;
    user = user ?? stockTransaction.user;
    fromWarehouse = fromWarehouse ?? stockTransaction.from_warehouse;
    toWarehouse = toWarehouse ?? stockTransaction.to_warehouse;
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
    Warehouse? fromWarehouse,
    Warehouse? toWarehouse,
    int? dateTime,
    int? index,
    StockTransaction? stockTransaction,
  }) {
    return TransactionForm<T>(
      productTransactions: productTransactions ?? this.productTransactions,
      user: user ?? this.user,
      fromWarehouse: fromWarehouse ?? this.fromWarehouse,
      toWarehouse: toWarehouse ?? this.toWarehouse,
      dateTime: dateTime ?? this.dateTime,
      index: index ?? this.index,
      stockTransaction: stockTransaction ?? this.stockTransaction,
    );
  }
}
