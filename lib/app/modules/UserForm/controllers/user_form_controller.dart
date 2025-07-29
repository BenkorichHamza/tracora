import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/core/image_picker.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/user_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/modules/User/controllers/user_controller.dart';
import 'package:tracora/app/modules/CustomerDetails/controllers/user_details_controller.dart';
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
  late TextEditingController phone;
  late TextEditingController address;

  @override
  void onInit() {
    // if (Get.arguments?['${userType}'] is UserModel) {
    //   user = Get.arguments?["${userType}"] ?? user;
    //   img = user.img ?? img;
    // }
    init(user);
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

  void save() async {
    try {
      if (!validate) return;
      user = user.copyWith(
        firstName: name.text,
        companyName: companyName.text,
        nif: nif.text,
        nis: nis.text,
        nin: nin.text,
        data: img.isEmpty ? null : File(img).readAsBytesSync(),
        email: email.text,
        phone: phone.text,
        address: address.text,
      );
      var r = await repository.insertUser(user);
      if (Get.isRegistered<UserController<T>>()) {
        Get.find<UserController<T>>().getAll();
      }
      if (Get.isRegistered<UserDetailsController<T>>()) {
        await Get.find<UserDetailsController<T>>().getUser();
        await Get.find<UserDetailsController<T>>().getMoneyTransactions();
        await Get.find<UserDetailsController<T>>().getStockTransactions();
      }
      user = user.copyWith(id: r <= 0 ? null : r);
      Get.find<UserController<T>>().showForm = false;
      Get.find<UserDetailsController<T>>().user = user;
      init(UserModel());
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
      rethrow;
    }
  }

  void init(UserModel? t) {
    user = t ?? UserModel();
    name = TextEditingController(text: user.firstName ?? '');
    companyName = TextEditingController(text: user.companyName ?? '');
    email = TextEditingController(text: user.email ?? '');
    phone = TextEditingController(text: user.phone ?? '');
    address = TextEditingController(text: user.address ?? '');
    nin = TextEditingController(text: user.nin ?? '');
    nif = TextEditingController(text: user.nif ?? '');
    nis = TextEditingController(text: user.nis ?? '');
  }

  bool get validate => name.text.length >= 3;

  void delete() async {
    var b = await deleteConfirmation();
    if (b != true) return;
    await repository.deleteUser(user);
    Get.find<UserController<T>>().getAll();
    Get.back();
  }
}
