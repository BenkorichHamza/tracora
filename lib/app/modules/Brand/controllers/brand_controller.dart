import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/brand_model.dart';
import 'package:tracora/app/data/repositories/brand_repository.dart';

class BrandController extends GetxController {
  final repository = BrandRepository();
  final _brands = <Brand>[].obs;
  List<Brand> get brands => this._brands.value;
  set brands(List<Brand> value) => this._brands.value = value;

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
    // try {
    //   listener.cancel();
    // } on Exception catch (e) {
    //   // TODO
    // }
  }

  @override
  void onClose() {
    super.onClose();
  }

  getAll() async {
    try {
      loading = true;
      brands = await repository.getAllBrands(search: search.text);
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }
}
