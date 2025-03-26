import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/supplier_repository.dart';

class SupplierController extends GetxController {
  final repository = SupplierRepository();
  final _suppliers = <UserModel>[].obs;
  List<UserModel> get suppliers => this._suppliers.value;
  set suppliers(List<UserModel> value) => this._suppliers.value = value;

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _offset = 0.obs;
  int get offset => this._offset.value;
  set offset(int value) => this._offset.value = value;

  loadMore() {
    offset = suppliers.length;
    getAll();
  }

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
    // } on Exception catch (e) {
    //   // TODO
    // }
  }

  getAll() async {
    try {
      loading = true && offset == 0;
      suppliers = await repository.getAllSuppliers(
        search: search.text,
        offset: offset,
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }

  filter() async {
    try {
      offset = 0;
      suppliers = await repository.getAllSuppliers(
        search: search.text,
        offset: 0,
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }
}
