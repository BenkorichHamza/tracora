import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/stock_transaction_repository.dart';
import 'package:tracora/app/modules/User/controllers/user_controller.dart';
import 'package:tracora/app/modules/User/views/user_view.dart';
import 'package:tracora/app/modules/CustomerDetails/controllers/user_details_controller.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/StockTransactionDetails/controllers/stock_transaction_details_controller.dart';
import 'package:tracora/app/modules/TransactionForm/views/bottom_sheet_item_selector.dart';

class TransactionFormController<T> extends GetxController {
  String get userType =>
      T == Sale || T == Customer
          ? "customer"
          : T == Purchase || T == Supplier
          ? "supplier"
          : "employee";
  String get transactionType =>
      T == Sale || T == Customer
          ? "sale"
          : T == Purchase || T == Supplier
          ? "purchase"
          : "mission";
  final StockTransactionRepository<T> repository =
      StockTransactionRepository<T>();
  final _transaction = StockTransaction().obs;
  StockTransaction get transaction => this._transaction.value;
  set transaction(StockTransaction value) => this._transaction.value = value;

  final _dateTime = 0.obs;
  int get dateTime => this._dateTime.value;
  set dateTime(int value) => this._dateTime.value = value;

  final _user = UserModel().obs;
  UserModel get user => this._user.value;
  set user(UserModel value) => this._user.value = value;

  final _employee = UserModel().obs;
  UserModel get employee => this._employee.value;
  set employee(UserModel value) => this._employee.value = value;

  final _productTransactions = <ProductTransaction>[].obs;
  List<ProductTransaction> get productTransactions =>
      this._productTransactions.value;
  set productTransactions(List<ProductTransaction> value) =>
      this._productTransactions.value = value;

  double get total => productTransactions.fold(
    0.0,
    (previousValue, element) =>
        previousValue + (element.qte ?? 0) * (element.price ?? 0),
  );

  late TextEditingController payment;
  late FocusNode paymentFn;

  @override
  void onInit() {
    if (Get.arguments?['$userType'] is StockTransaction) {
      transaction = Get.arguments?["$userType"] ?? transaction;
    }
    init(transaction);
    super.onInit();
  }

  void init(StockTransaction? stockTransaction) {
    transaction = stockTransaction ?? StockTransaction();
    user = transaction.user ?? UserModel();
    employee = transaction.employee ?? employee;
    productTransactions =
        transaction.productTransactions ?? <ProductTransaction>[];
    dateTime = transaction.dateTime ?? 0;

    payment = TextEditingController(
      text: transaction.payment?.floor().toString(),
    );
    paymentFn =
        FocusNode()..addListener(() {
          payment.selection = TextSelection(
            baseOffset: 0,
            extentOffset: payment.text.length,
          );
        });
    dateTime = transaction.dateTime ?? transaction.createdAt ?? dateTime;
    getProductTransactions();
  }

  getProductTransactions() async {
    productTransactions = await repository.getProductTransactions(
      transaction.id ?? 0,
    );
    update([
      productTransactions.map((pt) => 'shop_${pt.product?.id}').toList(),
    ]);
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

  void increment(Product p) {
    var pt = productTransactions.firstWhereOrNull((e) => e.product?.id == p.id);
    if (pt == null) {
      pt = ProductTransaction(product: p, qte: 0, price: p.getPrice<T>());
      productTransactions.insert(0, pt);
    }
    pt = pt.copyWith(qte: (pt.qte ?? 0) + 1);
    var i = productTransactions.indexWhere((e) => e.product?.id == p.id);
    productTransactions[i] = pt;
    productTransactions = productTransactions
        .where((e) => (e.qte ?? 0) > 0)
        .toList()
        .sublist(0);
    update(['shop_${p.id}']);
  }

  void decrement(Product p) {
    var pt = productTransactions.firstWhereOrNull((e) => e.product?.id == p.id);
    if (pt == null) {
      pt = ProductTransaction(product: p, qte: 0, price: p.getPrice<T>());
      productTransactions.insert(0, pt);
    }
    if ((pt.qte ?? 0) <= 0) return;
    pt = pt.copyWith(qte: (pt.qte ?? 0) - 1);
    var i = productTransactions.indexWhere((e) => e.product?.id == p.id);
    productTransactions[i] = pt;
    productTransactions = productTransactions
        .where((e) => (e.qte ?? 0) > 0)
        .toList()
        .sublist(0);
    update(['shop_${p.id}']);
  }

  double qteOf(Product product) {
    return productTransactions
            .firstWhereOrNull((e) => e.product?.id == product.id)
            ?.qte ??
        0;
  }

  ProductTransaction transactionOf(Product product) {
    return productTransactions.firstWhereOrNull(
          (e) => e.product?.id == product.id,
        ) ??
        ProductTransaction(
          product: product,
          qte: 0,
          price: product.getPrice<T>() ?? 0,
        );
  }

  void setQte(Product product) async {
    var t = transactionOf(product);
    var r = await showModalBottomSheet(
      isScrollControlled: true,
      context: Get.context!,
      builder: (c) {
        return ItemBottomSheet<T>(productTransaction: t);
      },
    );
    if (r is! ProductTransaction) return;
    var i = productTransactions.indexWhere((e) => e.product?.id == product.id);
    if (i < 0) {
      productTransactions.add(t.copyWith(qte: r.qte, price: r.price));
    } else {
      t = t.copyWith(qte: r.qte, price: r.price);
      productTransactions[i] = t;
      productTransactions =
          productTransactions.where((e) => (e.qte ?? 0) > 0).toList();
    }
    productTransactions = productTransactions.sublist(0);
    update(['shop_${product.id}']);
  }

  selectUser() async {
    if (T == Sale || T == Customer) {
      Get.find<UserController<Customer>>().getAll();
    } else if (T == Purchase || T == Supplier) {
      Get.find<UserController<Supplier>>().getAll();
    } else {
      Get.find<UserController<Employee>>().getAll();
    }
    var r = await showDialog(
      routeSettings: RouteSettings(arguments: {"select": true}),
      context: Get.context!,
      builder:
          (c) => Dialog(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 450),
              child:
                  userType == "customer"
                      ? UserView<Customer>()
                      : userType == "supplier"
                      ? UserView<Supplier>()
                      : UserView<Employee>(),
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
      if (double.tryParse(payment.text) == null &&
          transactionType != "mission") {
        ErrorHandler.showError("make_payment".tr);
        return;
      }
      if (!validate) return;
      if (dateTime <= 0) {
        dateTime = DateTime.now().millisecondsSinceEpoch;
      }
      var n = transaction.copyWith(
        user: user,
        topay: total,
        status: 1,
        total: total,
        productTransactions: productTransactions,
        payment: double.tryParse(payment.text),
        credit: user.toPay,
        tax: 0,
        dateTime: dateTime,
        type: transactionType,
      );
      var id = await repository.insert(n, mission: T == Mission);
      if (Get.isRegistered<StockTransactionController<T>>()) {
        Get.find<StockTransactionController<T>>().getAll();
      }

      if (Get.isRegistered<UserDetailsController<T>>()) {
        await Get.find<UserDetailsController<T>>().getProductTransactions();
        await Get.find<UserDetailsController<T>>().getStockTransactions();
        await Get.find<UserDetailsController<T>>().getUser();
      }
      n = n.copyWith(id: id <= 0 ? null : id, dateTime: dateTime);
      transaction = transaction.copyWith(id: id);
      Get.find<StockTransactionController<T>>().showForm = false;
      Get.find<StockTransactionDetailsController<T>>().stockTransaction = n;
      Get.find<StockTransactionDetailsController<T>>().getStockTransaction();
      init(StockTransaction());
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  bool get validate =>
      user.id != null &&
      (int.tryParse(payment.text) != null || transactionType == "mission") &&
      productTransactions.isNotEmpty;
}
