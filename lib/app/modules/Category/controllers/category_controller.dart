import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/category_model.dart';
import 'package:tracora/app/data/repositories/category_repository.dart';

class CategoryController extends GetxController {
  final repository = CategoryRepository();
  final _categories = <CategoryModel>[].obs;
  List<CategoryModel> get categories => this._categories.value;
  set categories(List<CategoryModel> value) => this._categories.value = value;

  final _selected = <int>[].obs;
  List<int> get selected => this._selected.value;
  set selected(List<int> value) => this._selected.value = value;

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _showSearch = false.obs;
  bool get showSearch => this._showSearch.value;

  TextEditingController search = TextEditingController();
  set showSearch(bool value) => this._showSearch.value = value;
  late StreamSubscription listener;

  @override
  void onInit() {
    super.onInit();
    selected = Get.arguments?["selected"] ?? selected;
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
      categories = await repository.getAllCategoryModels(search: search.text);
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }

  toggleSelected(int id) {
    if (selected.contains(id)) {
      selected.remove(id);
    } else {
      selected.add(id);
    }
    selected = selected.sublist(0);
  }

  listen() async {
    try {
      listener.cancel();
    } catch (e) {}
    // listener = FirebaseFirestore.instance
    //     .collection('categories')
    //     .snapshots(includeMetadataChanges: true)
    //     .listen((data) async {
    //       if (data.metadata.isFromCache) return;
    //       await Future.forEach(data.docs, (element) async {
    //         element.data()["remoteId"] = element.data()["id"];
    //         var model = CategoryModel.fromMap(element.data());
    //         await repository.insertCategory(model, sync: false);
    //       });
    //       getAll();
    //     });
  }
}
