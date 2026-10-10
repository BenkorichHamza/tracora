import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/category_model.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/repositories/brand_repository.dart';
import 'package:tracora/app/data/repositories/category_repository.dart';
import 'package:tracora/app/data/repositories/product_repository.dart';
import 'package:tracora/app/modules/ProductDetails/controllers/product_details_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:tracora/app/modules/ProductForm/controllers/product_form_controller.dart';

class ProductController extends GetxController {
  final repository = ProductRepository();
  final _products = <Product>[].obs;
  List<Product> get products => this._products.value;
  set products(List<Product> value) => this._products.value = value;

  final _gridView = false.obs;
  get gridView => this._gridView.value;
  set gridView(value) => this._gridView.value = value;

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _showSearch = false.obs;
  bool get showSearch => this._showSearch.value;

  TextEditingController search = TextEditingController();
  set showSearch(bool value) => this._showSearch.value = value;
  late StreamSubscription listener;
  late FocusNode searchFn;

  final _showForm = false.obs;
  bool get showForm => this._showForm.value;
  set showForm(bool value) => this._showForm.value = value;

  final _selected = Product().obs;
  Product get selected => this._selected.value;
  set selected(Product value) => this._selected.value = value;

  late GlobalKey selectedKey;
  late ScrollController scrollController;

  get detailsController => Get.find<ProductDetailsController>();
  next() {
    var i = products.indexWhere((e) => e.id == selected.id);
    if (i >= products.length - 1) return;

    toDetails(products[i + 1]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = selectedKey.currentContext;
      if (context == null) return;
      if (!scrollController.hasClients) return;

      // 2. Grab just the inner scroll position
      final position = scrollController.position;
      var renderObject = context.findRenderObject()!;
      // 3. Ask *that* position to ensure your item’s RenderObject is visible

      RenderAbstractViewport viewport = RenderAbstractViewport.of(renderObject);
      var offsetToRevealBottom = viewport.getOffsetToReveal(renderObject, 1.0);
      var offsetToRevealTop = viewport.getOffsetToReveal(renderObject, 0.0);

      if (offsetToRevealBottom.offset + 1 > scrollController.position.pixels) {
        print("aaaaaaaaaaaaaaaaaaa");
        scrollController.animateTo(
          offsetToRevealBottom.offset,
          duration: Duration(milliseconds: 10),
          curve: Curves.linear,
        );
      }
    });
  }

  previous() {
    var i = products.indexWhere((e) => e.id == selected.id);
    if (i == 0) return;
    toDetails(products[i - 1]);
    final context = selectedKey.currentContext;
    if (context == null) return;
    if (!scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final position = scrollController.position;
      var renderObject = context.findRenderObject()!;
      // 3. Ask *that* position to ensure your item’s RenderObject is visible

      RenderAbstractViewport viewport = RenderAbstractViewport.of(renderObject);
      var offsetToRevealBottom = viewport.getOffsetToReveal(renderObject, 1.0);
      var offsetToRevealTop = viewport.getOffsetToReveal(renderObject, 0.0);

      if (offsetToRevealTop.offset - 30 < scrollController.position.pixels) {
        print("aaaaaaaaaaaaaaaaaaa");
        scrollController.animateTo(
          offsetToRevealTop.offset,
          duration: Duration(milliseconds: 10),
          curve: Curves.linear,
        );
      }
    });
  }

  delete() {
    if (selected.id == null) return;
    Get.find<ProductDetailsController>().delete();
  }

  @override
  void onInit() {
    super.onInit();
    searchFn = FocusNode();
    selectedKey = GlobalKey();
    scrollController = ScrollController();
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
    // } catch (e) {}
  }

  getAll() async {
    try {
      loading = true;
      products = await repository.getAllProducts(search: search.text);
      selected = products.isEmpty ? Product() : products.first;
      if (selected.id != null) {
        Get.find<ProductDetailsController>().product = selected;
        Get.find<ProductDetailsController>().getSuppliers();
        Get.find<ProductDetailsController>().getCustomers();
        Get.find<ProductDetailsController>().getTransactions();
      }
      if (scrollController.hasClients) scrollController.jumpTo(0);
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
        .collection('products')
        // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          if (data.metadata.isFromCache) return;
          await Future.forEach(data.docs, (element) async {
            element.data()["remoteId"] = element.data()["id"];
            var model = Product.fromMap(element.data()!);
            await repository.insertProduct(model, sync: false);
          });
          getAll();
        });
  }

  void toDetails(Product product) {
    if (Get.arguments?["select"] == true) {
      Get.back(result: product);
      return;
    }
    var id = selected.id;
    selected = product;
    update(['item_${product.id}', 'item_$id']);
    Get.find<ProductDetailsController>().product = product;
    Get.find<ProductDetailsController>().getSuppliers();
    Get.find<ProductDetailsController>().getCustomers();
    Get.find<ProductDetailsController>().getTransactions();
  }

  Future<void> importExcelFile() async {
    var db = await DbHelper().db;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      await db.transaction((txn) async {
        var rows = excel.sheets.values.first.rows;
        for (int i = 1; i < rows.length; i++) {
          print('insert row $i / ${rows.length}');
          var row = rows[i];
          var product = Product(
            barcode: row[0]?.value?.toString(),
            name: row[1]?.value?.toString(),
            stock: row[2]?.value?.toDouble(),
            buyPrice: row[3]?.value?.toDouble()?.round()?.toDouble() ?? 0,
            sellPrice: row[4]?.value?.toDouble()?.round()?.toDouble() ?? 0,
          );
          await txn.insert("product", product.toSqliteMap());
          // Or store it in your database or state
        }
      });
    } else {
      print('No file selected');
    }
  }

  ProductFormController get formController => Get.find<ProductFormController>();

  newIntent() {
    showForm = true;
    formController.init(Product());
  }

  editIntent() {
    if (selected.id == null) return;
    formController.init(selected);
    showForm = true;
  }

  escapeIntent() {
    showForm = false;
    formController.init(Product());
  }

  saveIntent() {
    formController.save(() => showForm = false);
  }

  saveAndNewIntent() {
    formController.save(() {
      formController.init(Product());
    });
  }

  deleteIntent() {
    if (showForm) return;
    if (selected.id == null) return;
    delete();
  }

  searchIntent() {
    showSearch = !showSearch;
    searchFn.requestFocus();
  }

  nextIntent() {
    next();
  }

  previousIntent() {
    previous();
  }

  printIntent() {
    print("not implemented ....");
  }
}
