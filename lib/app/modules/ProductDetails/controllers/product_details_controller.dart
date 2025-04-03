import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/product_repository.dart';
import 'package:tracora/app/data/repositories/user_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/ProductForm/controllers/product_form_controller.dart';

class ProductDetailsController extends GetxController
    with GetTickerProviderStateMixin {
  var customerRepository = UserRepository<Customer>();
  var supplierRepository = UserRepository<Supplier>();

  final _product = Product().obs;
  Product get product => this._product.value;
  set product(Product value) => this._product.value = value;

  final _customers = <UserModel>[].obs;
  List<UserModel> get customers => this._customers.value;
  set customers(List<UserModel> value) => this._customers.value = value;

  final _suppliers = <UserModel>[].obs;
  List<UserModel> get suppliers => this._suppliers.value;
  set suppliers(List<UserModel> value) => this._suppliers.value = value;

  final _transactions = <ProductTransaction>[].obs;
  List<ProductTransaction> get transactions => this._transactions.value;
  set transactions(List<ProductTransaction> value) =>
      this._transactions.value = value;

  late TabController tabCtrl;

  print() {}

  @override
  void onInit() {
    tabCtrl = TabController(length: 4, vsync: this);
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

  void getSuppliers() async {
    suppliers = await supplierRepository.getAllUsersByProductId(
      product.id ?? 0,
    );
  }

  void getCustomers() async {
    customers = await customerRepository.getAllUsersByProductId(
      product.id ?? 0,
    );
  }

  void getTransactions() async {
    transactions = await ProductRepository().getProductTransactions(
      productId: product.id ?? 0,
    );
  }

  delete() async {
    var b = await deleteConfirmation();
    if (b != true) return;
    await ProductRepository().deleteProduct(product);
    Get.find<ProductController>().getAll();
    Get.find<ProductDetailsController>().product = Product();

    Get.back(result: true);
  }

  edit() {
    Get.find<ProductFormController>().init(product);
    Get.find<ProductController>().showForm = true;
  }
}
