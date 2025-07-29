import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/core/image_picker.dart';
import 'package:tracora/app/data/models/brand_model.dart';
import 'package:tracora/app/data/models/category_model.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/repositories/product_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Brand/controllers/brand_controller.dart';
import 'package:tracora/app/modules/Brand/views/brand_view.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/ProductDetails/controllers/product_details_controller.dart';
import 'package:tracora/app/modules/ProductForm/views/scanner.dart';
import 'package:tracora/app/routes/app_pages.dart';

class ProductFormController extends GetxController {
  final repository = ProductRepository();
  final _product = Product().obs;
  Product get product => this._product.value;
  set product(Product value) => this._product.value = value;

  final _img = ''.obs;
  String get img => this._img.value;
  set img(String value) => this._img.value = value;

  final _brand = Brand().obs;
  Brand get brand => this._brand.value;
  set brand(Brand value) => this._brand.value = value;

  final _categories = <CategoryModel>[].obs;
  List<CategoryModel> get categories => this._categories.value;
  set categories(value) => this._categories.value = value;

  late GlobalKey<FormState> formKey;

  late TextEditingController name;
  late TextEditingController nameAr;
  late TextEditingController alert;
  late TextEditingController stock;
  late TextEditingController packaging;
  late TextEditingController barcode;
  late TextEditingController unity;
  late TextEditingController buyPrice;
  late TextEditingController sellPrice;
  late TextEditingController sellPrice1;
  late TextEditingController sellPrice2;

  @override
  void onInit() {
    formKey = GlobalKey<FormState>();

    init(product);

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

  getBrand() async {
    var r = await Get.toNamed(Routes.BRAND, arguments: {"select": true});
    if (r is! Brand) return;
    brand = r;
  }

  getCategories() async {
    var r = await Get.toNamed(
      Routes.CATEGORY,
      arguments: {
        "select": true,
        "selected": categories.map((e) => e.id ?? (-1)).toList(),
      },
    );
    if (r is! List<CategoryModel>) return;
    categories = r;
  }

  void save() async {
    try {
      if (!(formKey.currentState?.validate() ?? false)) return;
      // try {
      //   if (img.isNotEmpty && product.img != img) {
      //     var path = await ImagePickerService.saveImageToPermanentStorage(img);
      //     product = product.copyWith(img: path);
      //   }
      // } on Exception catch (_) {}
      product = product.copyWith(
        name: name.text,
        nameAr: nameAr.text,
        alert: double.tryParse(alert.text),
        packaging: double.tryParse(packaging.text),
        buyPrice: double.tryParse(buyPrice.text),
        sellPrice: double.tryParse(sellPrice.text),
        sellPrice1: double.tryParse(sellPrice1.text),
        sellPrice2: double.tryParse(sellPrice2.text),
        stock: double.tryParse(stock.text),
        barcode: barcode.text,
        unity: unity.text.isEmpty ? 'u'.tr : unity.text,
        brand: brand,
        categories: categories,
        data: img.isNotEmpty ? await File(img).readAsBytes() : null,
      );
      var r = await repository.insertProduct(product);
      if (Get.isRegistered<ProductDetailsController>()) {
        Get.find<ProductDetailsController>().product = product.copyWith(
          id: r <= 0 ? null : r,
        );
      }
      if (Get.isRegistered<ProductController>()) {
        Get.find<ProductController>().getAll();
      }
      product = product.copyWith(id: r <= 0 ? null : r);
      Get.find<ProductController>().showForm = false;
      init(Product());
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
      rethrow;
    }
  }

  bool get validate =>
      name.text.length >= 3 &&
      nameAr.text.length >= 3 &&
      double.tryParse(buyPrice.text) != null &&
      double.tryParse(sellPrice.text) != null;

  void delete() async {
    var b = await deleteConfirmation();
    if (b != true) return;
    await repository.deleteProduct(product);
    Get.find<ProductController>().getAll();
    Get.back();
  }

  void toggle(CategoryModel category) {
    var ids = categories.map((e) => e.id).toList();
    if (ids.contains(category.id)) {
      categories.remove(category);
    } else {
      categories.add(category);
    }
    categories = categories.sublist(0);
  }

  void scanBarcode() async {
    try {
      var r = await Get.to(() => ScannerPage());

      if (r != null && r is String) {
        barcode.text = r;
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  void init(Product? t) {
    product = t ?? Product();
    name = TextEditingController(text: product.name ?? '');
    nameAr = TextEditingController(text: product.nameAr ?? '');
    alert = TextEditingController(text: product.alert?.formatNumber() ?? '');
    packaging = TextEditingController(
      text: product.packaging?.formatNumber() ?? '',
    );
    barcode = TextEditingController(text: product.barcode ?? '');
    unity = TextEditingController(text: product.unity ?? '');
    stock = TextEditingController(text: product.stock.formatNumber() ?? '');
    buyPrice = TextEditingController(
      text: product.buyPrice?.formatNumber() ?? '',
    );
    sellPrice = TextEditingController(
      text: product.sellPrice?.formatNumber() ?? '',
    );
    sellPrice1 = TextEditingController(
      text: product.sellPrice1?.formatNumber() ?? '',
    );
    sellPrice2 = TextEditingController(
      text: product.sellPrice2?.formatNumber() ?? '',
    );
    brand = product.brand ?? brand;
    categories = product.categories ?? categories;
    img = "";
  }
}
