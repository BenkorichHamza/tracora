import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/core/image_picker.dart';
import 'package:tracora/app/data/models/category_model.dart';
import 'package:tracora/app/data/repositories/category_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/modules/Category/controllers/category_controller.dart';

class CategoryFormController extends GetxController {
  final repository = CategoryRepository();
  final _category = CategoryModel().obs;
  CategoryModel get category => this._category.value;
  set category(CategoryModel value) => this._category.value = value;

  final _img = ''.obs;
  String get img => this._img.value;
  set img(String value) => this._img.value = value;

  late TextEditingController name;
  late TextEditingController nameAr;
  late TextEditingController order;

  @override
  void onInit() {
    if (Get.arguments?['category'] is CategoryModel) {
      category = Get.arguments?["category"] ?? category;
      img = category.img ?? img;
    }
    name = TextEditingController(text: category.name ?? '');
    nameAr = TextEditingController(text: category.nameAr ?? '');
    order = TextEditingController(text: category.order?.toString() ?? '');
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
      //     category = category.copyWith(img: path);
      //   }
      // } on Exception catch (_) {}
      category = category.copyWith(
        name: name.text,
        data: img.isEmpty ? null : File(img).readAsBytesSync(),
        nameAr: nameAr.text,
        order: int.tryParse(order.text),
      );
      var r = await repository.insertCategory(category);
      Get.find<CategoryController>().getAll();
      Get.back();
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
      rethrow;
    }
  }

  bool get validate =>
      name.text.length >= 3 &&
      nameAr.text.length >= 3 &&
      int.tryParse(order.text) != null;

  void delete() async {
    var b = await deleteConfirmation();
    if (b != true) return;
    await repository.deleteCategory(category);
    Get.find<CategoryController>().getAll();
    Get.back();
  }
}
