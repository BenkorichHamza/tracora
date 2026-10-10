import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/warehouse.dart';
import 'package:tracora/app/data/repositories/warehouse_repository.dart';
import 'package:tracora/app/modules/warehouse_details/controllers/warehouse_details_controller.dart';
import 'package:tracora/app/modules/warehouse_form/controllers/warehouse_form_controller.dart';

class WarehouseController extends GetxController {
  final repository = WarehouseRepository();
  final _warehouses = <Warehouse>[].obs;
  List<Warehouse> get warehouses => this._warehouses.value;
  set warehouses(List<Warehouse> value) => this._warehouses.value = value;

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

  final _selected = Warehouse().obs;
  Warehouse get selected => this._selected.value;
  set selected(Warehouse value) => this._selected.value = value;

  late GlobalKey selectedKey;
  late ScrollController scrollController;

  get detailsController => Get.find<WarehouseDetailsController>();
  next() {
    var i = warehouses.indexWhere((e) => e.id == selected.id);
    if (i >= warehouses.length - 1) return;

    toDetails(warehouses[i + 1]);

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
    var i = warehouses.indexWhere((e) => e.id == selected.id);
    if (i == 0) return;
    toDetails(warehouses[i - 1]);
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
    Get.find<WarehouseDetailsController>().delete();
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
      warehouses = await repository.getAllWarehouses(search: search.text);
      selected = warehouses.isEmpty ? Warehouse() : warehouses.first;
      if (selected.id != null) {
        Get.find<WarehouseDetailsController>().warehouse = selected;
        // Get.find<WarehouseDetailsController>().getSuppliers();
        // Get.find<WarehouseDetailsController>().getCustomers();
        // Get.find<WarehouseDetailsController>().getTransactions();
      }
      if (scrollController.hasClients) scrollController.jumpTo(0);
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }

  void toDetails(Warehouse warehouse) {
    if (Get.arguments?["select"] == true) {
      Get.back(result: warehouse);
      return;
    }
    var id = selected.id;
    selected = warehouse;
    update(['item_${warehouse.id}', 'item_$id']);
    Get.find<WarehouseDetailsController>().warehouse = warehouse;
    Get.find<WarehouseDetailsController>().getEmployee();
    Get.find<WarehouseDetailsController>().getProducts();
    Get.find<WarehouseDetailsController>().getTransactions();
  }

  Future<void> importExcelFile() async {
    // var db = await DbHelper().db;
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['xlsx'],
    // );

    // if (result != null && result.files.single.path != null) {
    //   File file = File(result.files.single.path!);
    //   final bytes = await file.readAsBytes();
    //   final excel = Excel.decodeBytes(bytes);

    //   await db.transaction((txn) async {
    //     var rows = excel.sheets.values.first.rows;
    //     for (int i = 1; i < rows.length; i++) {
    //       print('insert row $i / ${rows.length}');
    //       var row = rows[i];
    //       var warehouse = Warehouse(
    //         barcode: row[0]?.value?.toString(),
    //         name: row[1]?.value?.toString(),
    //         stock: row[2]?.value?.toDouble(),
    //         buyPrice: row[3]?.value?.toDouble()?.round()?.toDouble() ?? 0,
    //         sellPrice: row[4]?.value?.toDouble()?.round()?.toDouble() ?? 0,
    //       );
    //       await txn.insert("warehouse", warehouse.toSqliteMap());
    //       // Or store it in your database or state
    //     }
    //   });
    // } else {
    //   print('No file selected');
    // }
  }

  WarehouseFormController get formController =>
      Get.find<WarehouseFormController>();

  newIntent() {
    showForm = true;
    formController.init(Warehouse());
  }

  editIntent() {
    if (selected.id == null) return;
    formController.init(selected);
    showForm = true;
  }

  escapeIntent() {
    showForm = false;
    formController.init(Warehouse());
  }

  saveIntent() {
    formController.save(() => showForm = false);
  }

  saveAndNewIntent() {
    formController.save(() {
      formController.init(Warehouse());
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
