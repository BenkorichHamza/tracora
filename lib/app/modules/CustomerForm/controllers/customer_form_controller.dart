import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/core/image_picker.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/customer_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/modules/Customer/controllers/customer_controller.dart';
import 'package:tracora/app/modules/CustomerDetails/controllers/customer_details_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';

class CustomerFormController extends GetxController {
  final repository = CustomerRepository();
  final _customer = UserModel().obs;
  UserModel get customer => this._customer.value;
  set customer(UserModel value) => this._customer.value = value;

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
    if (Get.arguments?['customer'] is UserModel) {
      customer = Get.arguments?["customer"] ?? customer;
      img = customer.img ?? img;
    }
    name = TextEditingController(text: customer.firstName ?? '');
    companyName = TextEditingController(text: customer.companyName ?? '');
    email = TextEditingController(text: customer.email ?? '');
    phone = TextEditingController(text: customer.phone ?? '');
    address = TextEditingController(text: customer.address ?? '');
    nin = TextEditingController(text: customer.nin ?? '');
    nif = TextEditingController(text: customer.nif ?? '');
    nis = TextEditingController(text: customer.nis ?? '');
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
      String? path = "";
      try {
        if (img.isNotEmpty) {
          path = await ImagePickerService.saveImageToPermanentStorage(img);
          customer = customer.copyWith(img: path);
        }
      } on Exception catch (_) {}
      customer = customer.copyWith(
        firstName: name.text,
        companyName: companyName.text,
        nif: nif.text,
        data:
            File(path ?? '').existsSync()
                ? File(path ?? '').readAsBytesSync()
                : null,
        nis: nis.text,
        nin: nin.text,
        email: email.text,
        phone: phone.text,
        address: address.text,
      );
      var r = await repository.insertCustomer(customer);
      if (Get.isRegistered<CustomerController>()) {
        Get.find<CustomerController>().getAll();
      }
      if (Get.isRegistered<CustomerDetailsController>()) {
        await Get.find<CustomerDetailsController>().getUser();
        await Get.find<CustomerDetailsController>().getMoneyTransactions();
        await Get.find<CustomerDetailsController>().getStockTransactions();
      }
      Get.offNamedUntil(
        Routes.CUSTOMER_DETAILS,
        (r) => [Routes.CUSTOMER, Routes.HOME].contains(r.settings.name),
        arguments: {"user": customer.copyWith(id: r)},
      );
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
      rethrow;
    }
  }

  bool get validate => name.text.length >= 3;

  void delete() async {
    var b = await deleteConfirmation();
    if (b != true) return;
    await repository.deleteCustomer(customer);
    Get.find<CustomerController>().getAll();
    Get.back();
  }
}
