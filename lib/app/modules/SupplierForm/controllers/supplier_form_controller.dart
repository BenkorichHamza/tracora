import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/core/image_picker.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/supplier_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/modules/Supplier/controllers/supplier_controller.dart';
import 'package:tracora/app/modules/SupplierDetails/controllers/supplier_details_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';

class SupplierFormController extends GetxController {
  final repository = SupplierRepository();
  final _supplier = UserModel().obs;
  UserModel get supplier => this._supplier.value;
  set supplier(UserModel value) => this._supplier.value = value;

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
    if (Get.arguments?['supplier'] is UserModel) {
      supplier = Get.arguments?["supplier"] ?? supplier;
      img = supplier.img ?? img;
    }
    name = TextEditingController(text: supplier.firstName ?? '');
    companyName = TextEditingController(text: supplier.companyName ?? '');
    email = TextEditingController(text: supplier.email ?? '');
    phone = TextEditingController(text: supplier.phone ?? '');
    address = TextEditingController(text: supplier.address ?? '');
    nin = TextEditingController(text: supplier.nin ?? '');
    nif = TextEditingController(text: supplier.nif ?? '');
    nis = TextEditingController(text: supplier.nis ?? '');
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
      // try {
      //   if (img.isNotEmpty) {
      //     var path = await ImagePickerService.saveImageToPermanentStorage(img);
      //     supplier = supplier.copyWith(img: path);
      //   }
      // } on Exception catch (_) {}
      supplier = supplier.copyWith(
        firstName: name.text,
        companyName: companyName.text,
        nif: nif.text,
        data: img.isEmpty ? null : File(img).readAsBytesSync(),
        nis: nis.text,
        nin: nin.text,
        email: email.text,
        phone: phone.text,
        address: address.text,
      );
      var r = await repository.insertSupplier(supplier);
      if (Get.isRegistered<SupplierController>()) {
        Get.find<SupplierController>().getAll();
      }
      if (Get.isRegistered<SupplierDetailsController>()) {
        await Get.find<SupplierDetailsController>().getUser();
        await Get.find<SupplierDetailsController>().getStockTransactions();
        await Get.find<SupplierDetailsController>().getMoneyTransactions();
      }
      Get.offNamedUntil(
        Routes.SUPPLIER_DETAILS,
        (r) => [Routes.SUPPLIER, Routes.HOME].contains(r.settings.name),
        arguments: {"user": supplier.copyWith(id: r)},
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
    await repository.deleteSupplier(supplier);
    Get.find<SupplierController>().getAll();
    Get.back();
  }
}
