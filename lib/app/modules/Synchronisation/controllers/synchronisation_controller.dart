import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/sync_operation.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/sync_repository.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';

class SynchronisationController extends GetxController {
  final _operations = <SyncOperation>[].obs;
  List<SyncOperation> get operations => this._operations.value;
  set operations(List<SyncOperation> value) => this._operations.value = value;

  final _selected = SyncOperation().obs;
  SyncOperation get selected => this._selected.value;
  set selected(SyncOperation value) => this._selected.value = value;

  final _syncing = false.obs;
  bool get syncing => this._syncing.value;
  set syncing(bool value) => this._syncing.value = value;

  get operationsLength => operations.length;

  get selectedModel {
    if (selected.data == null) return;
    if (selected.tableName == "products") {
      return Product.fromJson(selected.data!);
    }
    if (selected.tableName == "contacts") {
      return UserModel.fromJson(selected.data!);
    }
  }

  Map<String, List<SyncOperation>> get groupedPendingOperations {
    final Map<String, List<SyncOperation>> grouped = {};

    final pending = operations.where((op) => (op.synced ?? 0) == 0);

    for (var op in pending) {
      final tableName = op.tableName ?? 'Unknown Table';
      grouped.putIfAbsent(tableName, () => []).add(op);
    }

    return grouped;
  }

  operationTile(SyncOperation op) {
    if (op.tableName == "products") {
      var m = Product.fromJson(op.data!);
      return ListTile(
        title: Text(m.name ?? 'table'),
        leading: m.leading(),
        subtitle: Text(op.createdAt.formatDateTime() ?? 'date'),
        trailing: Text(op.operation ?? 'operation'),
        onTap: () => selected = op,
      );
    }
    if (op.tableName == "contacts") {
      var m = UserModel.fromJson(op.data!);
      return ListTile(
        title: Text(m.firstName ?? 'name'),
        leading: m.circleAvatar(),
        subtitle: Text(op.createdAt.formatDateTime() ?? 'date'),
        trailing: Text('${op.operation ?? 'operation'} ${m.type ?? 'user'}'),
        onTap: () => selected = op,
      );
    }
    if (op.tableName == "stock_transaction") {
      var m = StockTransaction.fromJson(op.data!);
      return ListTile(
        title: Text(m.user?.firstName ?? 'name'),
        leading: m.user?.circleAvatar(),
        subtitle: Text(op.createdAt.formatDateTime() ?? 'date'),
        trailing: Text(
          '${op.operation ?? 'operation'} ${m.type ?? 'transaction'}',
        ),
        onTap: () => selected = op,
      );
    }
    return ListTile(
      title: Text(op.tableName ?? 'table'),
      subtitle: Text(op.createdAt.formatDate() ?? 'date'),
      trailing: Text(op.operation ?? 'operation'),
      onTap: () => selected = op,
    );
  }

  @override
  void onInit() {
    getOperations();
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

  getOperations() async {
    try {
      operations = await SyncRepository().getOperations();
      getOperations();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  Future<void> pull() async {
    syncing = true;
    final db = await DbHelper().db;
    // 1. Query by the primary key directly
    List<Map<String, dynamic>> maps = await db.query(
      "sync_state",
      where: "key = ?",
      whereArgs: ['last_sync_date'],
    );

    String? lastSyncDateString;

    // 2. Check if the row exists and safely extract the value
    if (maps.isNotEmpty) {
      lastSyncDateString = maps.first['value'] as String?;
    }

    // Result: lastSyncDateString will be your millisecond string (or null if it's the first sync)
    print("Last Sync Date: $lastSyncDateString");
    lastSyncDateString ??= DateTime(2026).millisecondsSinceEpoch.toString();
    await SyncRepository().pullRoles(lastSyncDateString);
    await SyncRepository().pullWarehouses(lastSyncDateString);
    await SyncRepository().pullContacts(lastSyncDateString);
    await SyncRepository().pullProducts(lastSyncDateString);
    await SyncRepository().pullStransactions(lastSyncDateString);
    await SyncRepository().pullMoneyTransactions(lastSyncDateString);
    syncing = false;
    await db.insert("sync_state", {
      "key": "last_sync_date",
      'value': DateTime.now().millisecondsSinceEpoch.toString(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    print('Last sync date updated successfully.');
  }

  void sync() async {
    try {
      syncing = true;
      await push();
      await pull();
      if (Get.isRegistered<ProductController>()) {
        Get.find<ProductController>().getAll();
      }
      syncing = false;
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
      syncing = false;
    }
    syncing = false;
  }

  Future<void> push() async {
    await SyncRepository().push();
  }
}
