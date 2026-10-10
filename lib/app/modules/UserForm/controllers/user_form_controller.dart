import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/core/image_picker.dart';
import 'package:tracora/app/data/models/role.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/models/warehouse.dart';
import 'package:tracora/app/data/repositories/user_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/modules/User/controllers/user_controller.dart';
import 'package:tracora/app/modules/CustomerDetails/controllers/user_details_controller.dart';
import 'package:tracora/app/modules/warehouse/controllers/warehouse_controller.dart';
import 'package:tracora/app/modules/warehouse/views/warehouse_view.dart';
import 'package:tracora/app/routes/app_pages.dart';

class UserFormController<T> extends GetxController {
  final repository = UserRepository<T>();
  String get userType =>
      T == Sale || T == Customer
          ? "customer"
          : T == Purchase || T == Supplier
          ? "supplier"
          : "employee";
  String get transactionType =>
      T == Sale || T == Customer ? "sale" : "purchase";

  final _warehouse = Warehouse().obs;
  Warehouse get warehouse => this._warehouse.value;
  set warehouse(Warehouse value) => this._warehouse.value = value;

  final _roles = <Role>[].obs;
  List<Role> get roles => this._roles.value;
  set roles(List<Role> value) => this._roles.value = value;

  final _user = UserModel().obs;
  UserModel get user => this._user.value;
  set user(UserModel value) {
    print(value.id);
    this._user.value = value;
  }

  final _img = ''.obs;
  String get img => this._img.value;
  set img(String value) => this._img.value = value;

  late TextEditingController name;
  late TextEditingController companyName;
  late TextEditingController nin;
  late TextEditingController nif;
  late TextEditingController nis;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController phone;
  late TextEditingController address;

  @override
  void onInit() {
    // if (Get.arguments?['${userType}'] is UserModel) {
    //   user = Get.arguments?["${userType}"] ?? user;
    //   img = user.img ?? img;
    // }
    init(user);
    warehouse = user.warehouse ?? Warehouse();
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

  pickImage() async {
    var path = await ImagePickerService.pickImage();
    if (path == null) return;
    img = path;
  }

  void save(Function onSuccess) async {
    try {
      if (!validate) return;
      var u = user.copyWith(
        firstName: name.text,
        companyName: companyName.text,
        warehouse: warehouse,
        nif: nif.text,
        nis: nis.text,
        nin: nin.text,
        email: email.text,
        phone: phone.text,
        address: address.text,
        password: password.text,
        roles: roles,
      );
      print(u.warehouse?.id);
      var r = await repository.insertUser(u);
      if (Get.isRegistered<UserController<T>>()) {
        Get.find<UserController<T>>().getAll();
      }
      if (Get.isRegistered<UserDetailsController<T>>()) {
        await Get.find<UserDetailsController<T>>().getUser();
        await Get.find<UserDetailsController<T>>().getMoneyTransactions();
        await Get.find<UserDetailsController<T>>().getStockTransactions();
      }
      // Get.find<UserController<T>>().showForm = false;
      Get.find<UserDetailsController<T>>().user = user;
      init(UserModel());
      onSuccess();
    } on Exception catch (e) {
      print(e.toString());
      ErrorHandler.handleError(e);
      rethrow;
    }
  }

  void init(UserModel? t) {
    user = t ?? UserModel();
    name = TextEditingController(text: user.firstName ?? '');
    companyName = TextEditingController(text: user.companyName ?? '');
    email = TextEditingController(text: user.email ?? '');
    warehouse = user.warehouse ?? Warehouse();
    password = TextEditingController(text: user.password ?? '');
    phone = TextEditingController(text: user.phone ?? '');
    address = TextEditingController(text: user.address ?? '');
    nin = TextEditingController(text: user.nin ?? '');
    nif = TextEditingController(text: user.nif ?? '');
    nis = TextEditingController(text: user.nis ?? '');
    roles = user.roles ?? roles;
  }

  bool get validate => name.text.length >= 3;

  selectWarehouse() async {
    Get.find<WarehouseController>().getAll();

    var r = await showDialog(
      routeSettings: RouteSettings(arguments: {"select": true}),
      context: Get.context!,
      builder:
          (c) => Dialog(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 450),
              child: WarehouseView(),
            ),
          ),
    );
    if (r is Warehouse) {
      warehouse = r;
    }
  }

  void delete() async {
    var b = await deleteConfirmation();
    if (b != true) return;
    await repository.deleteUser(user);
    Get.find<UserController<T>>().getAll();
    Get.back();
  }
}
