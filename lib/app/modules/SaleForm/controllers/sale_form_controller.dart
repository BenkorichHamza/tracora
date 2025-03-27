import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/sale_repository.dart';
import 'package:tracora/app/modules/Customer/controllers/customer_controller.dart';
import 'package:tracora/app/modules/Customer/views/customer_view.dart';
import 'package:tracora/app/modules/CustomerDetails/controllers/customer_details_controller.dart';
import 'package:tracora/app/modules/Sale/controllers/sale_controller.dart';
import 'package:tracora/app/modules/SaleDetails/controllers/sale_details_controller.dart';
import 'package:tracora/app/modules/SaleForm/views/bottom_sheet_item_selector.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';

class SaleFormController extends GetxController {
  final SaleRepository repository = SaleRepository();
  final _sale = StockTransaction().obs;
  StockTransaction get sale => this._sale.value;
  set sale(StockTransaction value) => this._sale.value = value;

  final _dateTime = 0.obs;
  int get dateTime => this._dateTime.value;
  set dateTime(int value) => this._dateTime.value = value;

  final _customer = UserModel().obs;
  UserModel get customer => this._customer.value;
  set customer(UserModel value) => this._customer.value = value;

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
    if (Get.arguments?['sale'] is StockTransaction) {
      sale = Get.arguments?["sale"] ?? sale;
    }
    init(sale);
    super.onInit();
  }

  void init(StockTransaction stockTransaction) {
    sale = stockTransaction;
    customer = sale.user ?? UserModel();
    employee = sale.employee ?? employee;
    productTransactions = sale.productTransactions ?? <ProductTransaction>[];
    dateTime = sale.dateTime ?? 0;

    payment = TextEditingController(text: sale.payment?.floor().toString());
    paymentFn =
        FocusNode()..addListener(() {
          payment.selection = TextSelection(
            baseOffset: 0,
            extentOffset: payment.text.length,
          );
        });
    dateTime = sale.dateTime ?? sale.createdAt ?? dateTime;
    getProductTransactions();
  }

  getProductTransactions() async {
    productTransactions = await repository.getProductTransactions(sale.id ?? 0);
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
      pt = ProductTransaction(product: p, qte: 0, price: p.sellPrice ?? 0);
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
      pt = ProductTransaction(product: p, qte: 0, price: p.sellPrice ?? 0);
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
          price: product.sellPrice ?? 0,
        );
  }

  void setQte(Product product) async {
    var t = transactionOf(product);
    var r = await showModalBottomSheet(
      isScrollControlled: true,
      context: Get.context!,
      builder: (c) {
        return ItemBottomSheet(productTransaction: t);
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

  sell() {}

  selectCustomer() async {
    var r = await showDialog(
      routeSettings: RouteSettings(arguments: {"select": true}),
      context: Get.context!,
      builder:
          (c) => Dialog(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 450),

              child: CustomerView(),
            ),
          ),
    );
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
      if (dateTime <= 0) {
        dateTime = DateTime.now().millisecondsSinceEpoch;
      }
      var n = sale.copyWith(
        user: customer,
        topay: total,
        total: total,
        productTransactions: productTransactions,
        payment: double.tryParse(payment.text),
        credit: customer.toPay,
        tax: 0,
        dateTime: dateTime,
        type: "sale",
      );
      var id = await repository.insertSale(n);
      if (Get.isRegistered<SaleController>()) {
        Get.find<SaleController>().getAll();
      }

      if (Get.isRegistered<CustomerDetailsController>()) {
        await Get.find<CustomerDetailsController>().getProductTransactions();
        await Get.find<CustomerDetailsController>().getStockTransactions();
        await Get.find<CustomerDetailsController>().getUser();
      }
      n = n.copyWith(id: id <= 0 ? null : id, dateTime: dateTime);
      sale = sale.copyWith(id: id);
      Get.find<SaleController>().showForm = false;
      Get.find<SaleDetailsController>().stockTransaction = n;
      Get.find<SaleDetailsController>().getStockTransaction();
      init(StockTransaction());
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  bool get validate =>
      customer.id != null &&
      int.tryParse(payment.text) != null &&
      productTransactions.isNotEmpty;
}
