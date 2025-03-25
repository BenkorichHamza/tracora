import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/purchase_repository.dart';
import 'package:tracora/app/modules/Purchase/controllers/purchase_controller.dart';
import 'package:tracora/app/modules/PurchaseDetails/controllers/purchase_details_controller.dart';
import 'package:tracora/app/modules/PurchaseForm/views/bottom_sheet_item_selector.dart';
import 'package:tracora/app/modules/Supplier/controllers/supplier_controller.dart';
import 'package:tracora/app/modules/SupplierDetails/controllers/supplier_details_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';

class PurchaseFormController extends GetxController {
  final PurchaseRepository repository = PurchaseRepository();
  final _purchase = StockTransaction().obs;
  StockTransaction get purchase => this._purchase.value;
  set purchase(StockTransaction value) => this._purchase.value = value;

  final _dateTime = 0.obs;
  int get dateTime => this._dateTime.value;
  set dateTime(int value) => this._dateTime.value = value;

  final _supplier = UserModel().obs;
  UserModel get supplier => this._supplier.value;
  set supplier(UserModel value) => this._supplier.value = value;

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
    if (Get.arguments?['purchase'] is StockTransaction) {
      purchase = Get.arguments?["purchase"] ?? purchase;
      supplier = purchase.user ?? supplier;
      employee = purchase.employee ?? employee;
      productTransactions = purchase.productTransactions ?? productTransactions;
    }
    payment = TextEditingController(text: purchase.payment?.floor().toString());
    paymentFn =
        FocusNode()..addListener(() {
          payment.selection = TextSelection(
            baseOffset: 0,
            extentOffset: payment.text.length,
          );
        });
    dateTime = purchase.dateTime ?? purchase.createdAt ?? dateTime;
    getProductTransactions();
    super.onInit();
  }

  getProductTransactions() async {
    productTransactions = await repository.getProductTransactions(
      purchase.id ?? 0,
    );
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
      pt = ProductTransaction(product: p, qte: 0, price: p.buyPrice ?? 0);
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
      pt = ProductTransaction(product: p, qte: 0, price: p.buyPrice ?? 0);
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
          price: product.buyPrice ?? 0,
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

  buy() {}

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
      if (dateTime <= 0) {
        dateTime = DateTime.now().millisecondsSinceEpoch;
      }
      var n = purchase.copyWith(
        user: supplier,
        topay: total,
        total: total,
        productTransactions: productTransactions,
        payment: double.tryParse(payment.text),
        credit: supplier.toPay,
        tax: 0,
        dateTime: dateTime,
        type: "purchase",
      );
      var id = await repository.insertPurchase(n);

      if (Get.isRegistered<PurchaseController>()) {
        Get.find<PurchaseController>().getAll();
      }
      if (Get.isRegistered<SupplierController>()) {
        Get.find<SupplierController>().getAll();
      }
      if (Get.isRegistered<PurchaseDetailsController>()) {
        Get.find<PurchaseDetailsController>().getStockTransaction();
      }
      if (Get.isRegistered<SupplierDetailsController>()) {
        await Get.find<SupplierDetailsController>().getProductTransactions();
        await Get.find<SupplierDetailsController>().getStockTransactions();
        await Get.find<SupplierDetailsController>().getUser();
      }
      Get.offNamedUntil(
        Routes.PURCHASE_DETAILS,
        (r) => [
          Routes.PURCHASE,
          Routes.SUPPLIER_DETAILS,
        ].contains(r.settings.name),
        arguments: {
          "purchase": n.copyWith(id: id <= 0 ? null : id, dateTime: dateTime),
        },
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  bool get validate =>
      supplier.id != null &&
      int.tryParse(payment.text) != null &&
      productTransactions.isNotEmpty;
}
