import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/customer_repository.dart';

class CustomerController extends GetxController {
  final repository = CustomerRepository();
  final _customers = <UserModel>[].obs;
  List<UserModel> get customers => this._customers.value;
  set customers(List<UserModel> value) => this._customers.value = value;

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _offset = 0.obs;
  int get offset => this._offset.value;
  set offset(int value) => this._offset.value = value;

  loadMore() {
    offset = customers.length;
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
      customers = await repository.getAllCustomers(
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
      customers = await repository.getAllCustomers(
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
