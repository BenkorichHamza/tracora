import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/models/warehouse.dart';
import 'package:tracora/app/data/repositories/product_repository.dart';
import 'package:tracora/app/data/repositories/stock_transaction_repository.dart';
import 'package:tracora/app/data/repositories/warehouse_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/modules/warehouse/controllers/warehouse_controller.dart';
import 'package:tracora/app/modules/warehouse_form/controllers/warehouse_form_controller.dart';

class WarehouseDetailsController extends GetxController
    with GetTickerProviderStateMixin {
  final _warehouse = Warehouse().obs;
  Warehouse get warehouse => this._warehouse.value;
  set warehouse(Warehouse value) => this._warehouse.value = value;

  final _employee = UserModel().obs;
  UserModel get employee => this._employee.value;
  set employee(UserModel value) => this._employee.value = value;

  final _products = <Product>[].obs;
  List<Product> get products => this._products.value;
  set products(List<Product> value) => this._products.value = value;

  final _transactions = <StockTransaction>[].obs;
  List<StockTransaction> get transactions => this._transactions.value;
  set transactions(List<StockTransaction> value) =>
      this._transactions.value = value;

  late TabController tabCtrl;

  print() {}

  @override
  void onInit() {
    tabCtrl = TabController(length: 4, vsync: this);
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

  delete() async {
    if (Get.isDialogOpen == true) return;
    var b = await deleteConfirmation();
    if (b != true) return;
    await WarehouseRepository().deleteWarehouse(warehouse);
    Get.find<WarehouseController>().getAll();
    Get.find<WarehouseDetailsController>().warehouse = Warehouse();

    Get.back(result: true);
  }

  edit() {
    Get.find<WarehouseFormController>().init(warehouse);
    Get.find<WarehouseController>().showForm = true;
  }

  getProducts() async {
    try {
      if (warehouse.id == null) return;
      products = await ProductRepository().getAllProducts(
        warehouse: warehouse,
        search: "",
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  getEmployee() async {
    try {
      var db = await DbHelper().db;
      var maps = await db.query(
        "user",
        where: "warehouse_id = ?",
        whereArgs: [warehouse.id],
      );
      if (maps.isEmpty) return;
      employee = UserModel.fromMap(maps[0]);
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  getTransactions() async {
    try {
      transactions = await StockTransactionRepository().getAllTransactions(
        warehouse: warehouse,
        search: "",
        employee: UserModel(),
      );
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    }
  }
}
