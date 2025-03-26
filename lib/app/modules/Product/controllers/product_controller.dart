import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/repositories/product_repository.dart';

class ProductController extends GetxController {
  final repository = ProductRepository();
  final _products = <Product>[].obs;
  List<Product> get products => this._products.value;
  set products(List<Product> value) => this._products.value = value;

  final _gridView = false.obs;
  get gridView => this._gridView.value;
  set gridView(value) => this._gridView.value = value;

  final _offset = 0.obs;
  int get offset => this._offset.value;
  set offset(int value) => this._offset.value = value;

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _showSearch = false.obs;
  bool get showSearch => this._showSearch.value;

  TextEditingController search = TextEditingController();
  set showSearch(bool value) => this._showSearch.value = value;
  late StreamSubscription listener;

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

  loadMore() {
    offset = products.length;
    getAll();
  }

  getAll() async {
    try {
      loading = true && offset == 0;
      var data = await repository.getAllProducts(
        search: search.text,
        offset: offset,
      );
      if (data.isNotEmpty) {
        products = products + data;
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }

  filter() async {
    try {
      offset = 0;
      products = await repository.getAllProducts(
        search: search.text,
        offset: offset,
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }
}
