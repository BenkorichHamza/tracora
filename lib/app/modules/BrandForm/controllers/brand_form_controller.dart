import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/core/image_picker.dart';
import 'package:tracora/app/data/models/brand_model.dart';
import 'package:tracora/app/data/repositories/brand_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/modules/Brand/controllers/brand_controller.dart';

class BrandFormController extends GetxController {
  final repository = BrandRepository();
  final _brand = Brand().obs;
  Brand get brand => this._brand.value;
  set brand(Brand value) => this._brand.value = value;

  final _img = ''.obs;
  String get img => this._img.value;
  set img(String value) => this._img.value = value;

  late TextEditingController name;
  late TextEditingController nameAr;

  @override
  void onInit() {
    if (Get.arguments?['brand'] is Brand) {
      brand = Get.arguments?["brand"] ?? brand;
      img = brand.img ?? img;
    }
    name = TextEditingController(text: brand.name ?? '');
    nameAr = TextEditingController(text: brand.nameAr ?? '');
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
      //     brand = brand.copyWith(img: path);
      //   }
      // } on Exception catch (_) {}
      brand = brand.copyWith(
        name: name.text,
        nameAr: nameAr.text,
        data: img.isEmpty ? null : File(img).readAsBytesSync(),
      );
      var r = await repository.insertBrand(brand);
      Get.find<BrandController>().getAll();
      Get.back();
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
      rethrow;
    }
  }

  bool get validate => name.text.length >= 3 && nameAr.text.length >= 3;

  void delete() async {
    var b = await deleteConfirmation();
    if (b != true) return;
    await repository.deleteBrand(brand);
    Get.find<BrandController>().getAll();
    Get.back();
  }
}
