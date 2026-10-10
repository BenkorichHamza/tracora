import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/sync_repository.dart';
import 'package:tracora/app/data/repositories/user_repository.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:uuid/uuid.dart';

class MoneyTransactionRepository {
  final DbHelper _dbHelper = DbHelper();

  Future<List<MoneyTransaction>> getMoneyTransactions({
    required String search,
    required String type,
    required UserModel employee,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT mt.*, u.firstName from
      money_transaction mt
      LEFT JOIN user u
      ON mt.userId=u.id
      WHERE mt.deletedAt IS NULL AND mt.type = "$type" AND (u.firstName LIKE "%$search%" OR u.lastName LIKE "%$search%" or mt.description LIKE "%$search%") ORDER BY mt.dateTime DESC
      LIMIT 50
''');
    if (maps.isEmpty) return [];
    var employeeId = maps.map((e) => '"' + (e['employeeId'] ?? '') + '"');
    final List<Map<String, dynamic>> employeeMaps = await db.query(
      'user',
      where:
          employeeId.isEmpty
              ? null
              : 'type = "employee" AND id IN (${employeeId.join(', ')})',
    );
    var employees = employeeMaps.map(((e) => UserModel.fromMap(e))).toList();
    var userId =
        maps
            .map<String>((e) => (e['userId'] ?? ""))
            .toSet()
            .where((e) => e != '""')
            .toList();
    final users = await UserRepository().getAllUsersFromArray(allId: userId);

    return maps
        .map(
          (map) => MoneyTransaction.fromMap(map).copyWith(
            employee: (employees).firstWhereOrNull(
              (e) => e.id == map['employeeId'],
            ),
            user: users.firstWhereOrNull(
              (e) => e.id == map['userId'] || e.id == map['userId'],
            ),
          ),
        )
        .toList();
  }

  Future<MoneyTransaction?> getMoneyTransactionsById({
    required String id,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT mt.*, u.firstName from
      money_transaction mt
      LEFT JOIN user u
      ON mt.userId=u.id
      WHERE mt.deletedAt IS NULL AND mt.id = '$id'
      LIMIT 50
''');
    var employeeId = maps.map((e) => '"' + (e['employeeId'] ?? '') + '"');
    final List<Map<String, dynamic>> employeeMaps = await db.query(
      'user',
      where:
          employeeId.isEmpty
              ? null
              : 'type = "employee" AND id IN (${employeeId.join(', ')})',
    );
    var employees = employeeMaps.map(((e) => UserModel.fromMap(e))).toList();
    var userId =
        maps
            .map<String>((e) => '"' + (e['userId'] ?? "") + '"')
            .toSet()
            .where((e) => e != '""')
            .toList();
    final users = await UserRepository().getAllUsersFromArray(allId: userId);
    if (maps.length != 1) return null;
    var map = maps.first;
    return MoneyTransaction.fromMap(maps[0]).copyWith(
      employee: (employees).firstWhereOrNull(
        (e) => e.id == maps[0]['employeeId'],
      ),
      user: users.firstWhereOrNull((e) => e.id == maps[0]['userId']),
    );
  }

  Future<List<MoneyTransaction>> getMoneyTransactionsFor({
    required String id,
    required String type,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT mt.*, u.firstName from
      money_transaction mt
      LEFT JOIN user u
      ON mt.userId=u.id
      WHERE mt.deletedAt IS NULL AND mt.type = "$type" AND (mt.userId = "$id" AND u.id = "$id") ORDER BY mt.dateTime DESC
      LIMIT 50
''');
    var employeeId = maps.map((e) => '"' + (e['employeeId'] ?? '') + '"');
    final List<Map<String, dynamic>> employeeMaps = await db.query(
      'user',
      where:
          employeeId.isEmpty
              ? null
              : 'type = "employee" AND id IN (${employeeId.join(', ')})',
    );
    var employees = employeeMaps.map(((e) => UserModel.fromMap(e))).toList();
    var userId =
        maps
            .map<String>((e) => (e['userId'] ?? ""))
            .toSet()
            .where((e) => e != '')
            .toList();
    final users = await UserRepository().getAllUsersFromArray(allId: userId);
    return maps
        .map(
          (map) => MoneyTransaction.fromMap(map).copyWith(
            employee: (employees).firstWhereOrNull(
              (e) => e.id == map['employeeId'],
            ),
            user: users.firstWhereOrNull(
              (e) => e.id == map['userId'] || e.id == map["userId"],
            ),
          ),
        )
        .toList();
  }

  Future<List<MoneyTransaction>> getMoneyTransactionsForEmployee({
    required String id,
    required String type,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT mt.*, u.firstName from
      money_transaction mt
      LEFT JOIN user u
      ON mt.userId=u.id
      WHERE mt.deletedAt IS NULL AND  mt.employeeId='$id' ORDER BY mt.dateTime DESC
      LIMIT 50
''');
    var employeeId = maps.map((e) => '"' + e['employeeId'] + '"');
    final List<Map<String, dynamic>> employeeMaps = await db.query(
      'user',
      where:
          employeeId.isEmpty
              ? null
              : 'type = "employee" AND id IN (${employeeId.join(', ')})',
    );
    var employees = employeeMaps.map(((e) => UserModel.fromMap(e))).toList();
    var userId = maps.map((e) => '"' + (e['userId'] ?? "") + '"');
    final List<Map<String, dynamic>> userMaps = await db.query(
      'user',
      where: userId.isEmpty ? null : 'id IN (${userId.join(', ')})',
    );
    var users = userMaps.map(((e) => UserModel.fromMap(e))).toList();

    return maps
        .map(
          (map) => MoneyTransaction.fromMap(map).copyWith(
            employee: (employees).firstWhereOrNull(
              (e) => e.id == map['employeeId'],
            ),
            user: users.firstWhereOrNull(
              (e) => e.id == map['userId'] || e.id == map["userId"],
            ),
          ),
        )
        .toList();
  }

  Future<int> insertMoneyTransaction(MoneyTransaction v) async {
    var moneyTransaction = v.copyWith();
    final db = await _dbHelper.db;
    var userId = Get.find<HomeController>().employee?.id ?? "admin";
    var now = DateTime.now().millisecondsSinceEpoch;
    String operation = "UPDATE";
    if (moneyTransaction.id == null) {
      operation = "INSERT";

      moneyTransaction = moneyTransaction.copyWith(
        id: Uuid().v4(),
        employee: Get.find<HomeController>().employee,
      );
    }
    moneyTransaction = moneyTransaction.copyWith(
      employee:
          moneyTransaction.employee ?? Get.find<HomeController>().employee,

      createdBy:
          moneyTransaction.id != null ? moneyTransaction.createdBy : userId,
      updatedBy: userId,
      dateTime:
          (moneyTransaction.dateTime ?? 0) <= 0
              ? now
              : moneyTransaction.dateTime,
      createdAt:
          (moneyTransaction.createdAt ?? 0) <= 0
              ? now
              : moneyTransaction.createdAt,
      updatedAt: now,
    );
    var map = moneyTransaction.toMap();
    var id = await db.transaction((txn) async {
      return await txn.insert(
        'money_transaction',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    await SyncRepository().addOperation(
      'money_transaction',
      moneyTransaction.id ?? "",
      operation,
      moneyTransaction.toSyncMap(),
    );

    return id;
  }

  Future<int> insertMoneyTransactionUsingTxn(
    MoneyTransaction v,
    Transaction txn,
  ) async {
    var moneyTransaction = v.copyWith();
    var map = moneyTransaction.toMap();
    return await txn.insert(
      'money_transaction',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateMoneyTransaction(MoneyTransaction moneyTransaction) async {
    final db = await _dbHelper.db;
    return await db.update(
      'money_transaction',
      moneyTransaction
          .copyWith(
            createdAt:
                moneyTransaction.id != null
                    ? moneyTransaction.createdAt
                    : DateTime.now().millisecondsSinceEpoch,
            updatedAt:
                moneyTransaction.id == null
                    ? moneyTransaction.createdAt
                    : DateTime.now().millisecondsSinceEpoch,
          )
          .toMap(),
      where: 'id = ?',
      whereArgs: [moneyTransaction.id],
    );
  }

  Future<int> deleteMoneyTransaction(MoneyTransaction moneyTransaction) async {
    final db = await _dbHelper.db;
    var now = DateTime.now().millisecondsSinceEpoch;
    moneyTransaction = moneyTransaction.copyWith(deletedAt: now);
    var r = await db.update(
      'money_transaction',
      {"deletedAt": now},
      where: 'id = ?',
      whereArgs: [moneyTransaction.id ?? 0],
    );

    await SyncRepository().addOperation(
      'money_transaction',
      moneyTransaction.id ?? "",
      "DELETE",
      moneyTransaction.toSyncMap(),
    );

    return r;
  }

  // sync(MoneyTransaction model) async {
  //   var user = model.user;
  //   if (model.type == "purchase") {
  //     await SupplierRepository().sync(user);
  //   } else {
  //     await CustomerRepository().sync(user);
  //   }
  //   await insertMoneyTransaction(model);
  // }
}
