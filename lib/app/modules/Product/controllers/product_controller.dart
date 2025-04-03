import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/category_model.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/repositories/brand_repository.dart';
import 'package:tracora/app/data/repositories/category_repository.dart';
import 'package:tracora/app/data/repositories/product_repository.dart';
import 'package:tracora/app/modules/ProductDetails/controllers/product_details_controller.dart';

class ProductController extends GetxController {
  final repository = ProductRepository();
  final _products = <Product>[].obs;
  List<Product> get products => this._products.value;
  set products(List<Product> value) => this._products.value = value;

  final _gridView = false.obs;
  get gridView => this._gridView.value;
  set gridView(value) => this._gridView.value = value;

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _showSearch = false.obs;
  bool get showSearch => this._showSearch.value;

  TextEditingController search = TextEditingController();
  set showSearch(bool value) => this._showSearch.value = value;
  late StreamSubscription listener;

  final _showForm = false.obs;
  bool get showForm => this._showForm.value;
  set showForm(bool value) => this._showForm.value = value;

  final _selected = Product().obs;
  Product get selected => this._selected.value;
  set selected(Product value) => this._selected.value = value;

  get detailsController => Get.find<ProductDetailsController>();
  next() {
    var i = products.indexWhere((e) => e.id == selected.id);
    if (i >= products.length - 1) return;

    toDetails(products[i + 1]);
  }

  previous() {
    var i = products.indexWhere((e) => e.id == selected.id);
    if (i == 0) return;
    toDetails(products[i - 1]);
  }

  delete() {
    if (selected.id == null) return;
    Get.find<ProductController>().delete();
  }

  @override
  void onInit() {
    super.onInit();
    getAll();
    // listen();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    // try {
    //   listener.cancel();
    // } catch (e) {}
  }

  getAll() async {
    try {
      loading = true;
      products = await repository.getAllProducts(search: search.text);
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }

  listen() async {
    try {
      listener.cancel();
    } catch (e) {}
    listener = FirebaseFirestore.instance
        .collection('products')
        // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          if (data.metadata.isFromCache) return;
          await Future.forEach(data.docs, (element) async {
            element.data()["remoteId"] = element.data()["id"];
            var model = Product.fromMap(element.data()!);
            await repository.insertProduct(model, sync: false);
          });
          getAll();
        });
  }

  void toDetails(Product product) {
    if (Get.arguments?["select"] == true) {
      Get.back(result: product);
      return;
    }
    var id = selected.id;
    selected = product;
    update(['item_${product.id}', 'item_$id']);
    Get.find<ProductDetailsController>().product = product;
    Get.find<ProductDetailsController>().getSuppliers();
    Get.find<ProductDetailsController>().getCustomers();
    Get.find<ProductDetailsController>().getTransactions();
  }
}
