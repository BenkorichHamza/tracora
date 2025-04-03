import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/user_repository.dart';
import 'package:tracora/app/modules/CustomerDetails/controllers/user_details_controller.dart';

class UserController<T> extends GetxController {
  final repository = UserRepository<T>();
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
  final _users = <UserModel>[].obs;
  List<UserModel> get users => this._users.value;
  set users(List<UserModel> value) => this._users.value = value;

  final _showForm = false.obs;
  bool get showForm => this._showForm.value;
  set showForm(bool value) => this._showForm.value = value;

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _showSearch = false.obs;
  bool get showSearch => this._showSearch.value;

  TextEditingController search = TextEditingController();
  set showSearch(bool value) => this._showSearch.value = value;

  get detailsController =>
      transactionType == "purchase"
          ? Get.find<UserDetailsController<Supplier>>()
          : Get.find<UserDetailsController<Customer>>();

  next() {
    var i = users.indexWhere((e) => e.id == selected.id);
    if (i >= users.length - 1) return;

    toDetails(users[i + 1]);
  }

  previous() {
    var i = users.indexWhere((e) => e.id == selected.id);
    if (i == 0) return;
    toDetails(users[i - 1]);
  }

  delete() {
    if (selected.id == null) return;
    Get.find<UserController<T>>().delete();
  }

  final _selected = UserModel().obs;
  UserModel get selected => this._selected.value;
  set selected(UserModel value) => this._selected.value = value;

  void toDetails(UserModel user) async {
    if (Get.arguments?["select"] == true) {
      Get.back(result: user);
      return;
    }
    var id = selected.id;
    selected = user;
    update(['item_${user.id}', 'item_$id']);
    Get.find<UserDetailsController<T>>().user = user;
    Get.find<UserDetailsController<T>>().getMoneyTransactions();
    Get.find<UserDetailsController<T>>().getProductTransactions();
    Get.find<UserDetailsController<T>>().getStockTransactions();
  }

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
      loading = true;
      users = await repository.getAllUsers(search: search.text);
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
        .collection('users')
        .where("type", isEqualTo: "$userType")
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          if (data.metadata.isFromCache) return;
          await Future.forEach(data.docs, (element) async {
            element.data()?["remoteId"] = element.data()?["id"];
            var model = UserModel.fromMap(element.data()!);
            await repository.insertUser(model, sync: false);
          });
          getAll();
        });
  }
}
