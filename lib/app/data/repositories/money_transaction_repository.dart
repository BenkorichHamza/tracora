import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/customer_repository.dart';
import 'package:tracora/app/data/repositories/supplier_repository.dart';

class MoneyTransactionRepository {
  final DbHelper _dbHelper = DbHelper();

  Future<List<MoneyTransaction>> getMoneyTransactions({
    required String search,
    required String type,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT mt.*, u.firstName from
      money_transaction mt
      LEFT JOIN user u
      ON mt.user_id=u.id
      WHERE mt.deletedAt IS NULL AND mt.type = "$type" AND (u.firstName LIKE "%$search%" OR u.lastName LIKE "%$search%" or mt.description LIKE "%$search%") ORDER BY mt.dateTime DESC
      LIMIT 50
''');
    var employeeIds = maps.map((e) => e['employee_id']);
    final List<Map<String, dynamic>> employeeMaps = await db.query(
      'user',
      where:
          employeeIds.isEmpty
              ? null
              : 'type = "employee" AND id IN (${employeeIds.join(', ')})',
    );
    var employees = employeeMaps.map(((e) => UserModel.fromMap(e))).toList();
    var userIds = maps.map((e) => e['user_id']);
    final List<Map<String, dynamic>> userMaps = await db.query(
      'user',
      where: userIds.isEmpty ? null : 'id IN (${userIds.join(', ')})',
    );
    var users = userMaps.map(((e) => UserModel.fromMap(e))).toList();

    return maps
        .map(
          (map) => MoneyTransaction.fromMap(map).copyWith(
            employee: (employees).firstWhereOrNull(
              (e) => e.id == map['employee_id'],
            ),
            user: users.firstWhereOrNull((e) => e.id == map['user_id']),
          ),
        )
        .toList();
  }

  Future<MoneyTransaction?> getMoneyTransactionsById({required int id}) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT mt.*, u.firstName from
      money_transaction mt
      LEFT JOIN user u
      ON mt.user_id=u.id
      WHERE mt.deletedAt IS NULL AND mt.id = $id
      LIMIT 50
''');
    var employeeIds = maps.map((e) => e['employee_id']);
    final List<Map<String, dynamic>> employeeMaps = await db.query(
      'user',
      where:
          employeeIds.isEmpty
              ? null
              : 'type = "employee" AND id IN (${employeeIds.join(', ')})',
    );
    var employees = employeeMaps.map(((e) => UserModel.fromMap(e))).toList();
    var userIds = maps.map((e) => e['user_id']);
    final List<Map<String, dynamic>> userMaps = await db.query(
      'user',
      where: userIds.isEmpty ? null : 'id IN (${userIds.join(', ')})',
    );
    var users = userMaps.map(((e) => UserModel.fromMap(e))).toList();
    if (maps.length != 1) return null;
    var map = maps.first;
    return MoneyTransaction.fromMap(maps[0]).copyWith(
      employee: (employees).firstWhereOrNull(
        (e) => e.id == maps[0]['employee_id'],
      ),
      user: users.firstWhereOrNull((e) => e.id == maps[0]['user_id']),
    );
  }

  Future<List<MoneyTransaction>> getMoneyTransactionsFor({
    required int id,
    required String type,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT mt.*, u.firstName from
      money_transaction mt
      LEFT JOIN user u
      ON mt.user_id=u.id
      WHERE mt.deletedAt IS NULL AND mt.type = "$type" AND user_id=$id ORDER BY mt.dateTime DESC
      LIMIT 50
''');
    var employeeIds = maps.map((e) => e['employee_id']);
    final List<Map<String, dynamic>> employeeMaps = await db.query(
      'user',
      where:
          employeeIds.isEmpty
              ? null
              : 'type = "employee" AND id IN (${employeeIds.join(', ')})',
    );
    var employees = employeeMaps.map(((e) => UserModel.fromMap(e))).toList();
    var userIds = maps.map((e) => e['user_id']);
    final List<Map<String, dynamic>> userMaps = await db.query(
      'user',
      where: userIds.isEmpty ? null : 'id IN (${userIds.join(', ')})',
    );
    var users = userMaps.map(((e) => UserModel.fromMap(e))).toList();

    return maps
        .map(
          (map) => MoneyTransaction.fromMap(map).copyWith(
            employee: (employees).firstWhereOrNull(
              (e) => e.id == map['employee_id'],
            ),
            user: users.firstWhereOrNull((e) => e.id == map['user_id']),
          ),
        )
        .toList();
  }

  Future<int> insertMoneyTransaction(
    MoneyTransaction moneyTransaction, {
    bool sync = true,
  }) async {
    final db = await _dbHelper.db;
    var userIds = FirebaseAuth.instance.currentUser?.uid;
    var now = DateTime.now().millisecondsSinceEpoch;
    if (moneyTransaction.ids == null) {
      var doc =
          FirebaseFirestore.instance
              .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
              .doc("2025")
              .collection("moneyTransactions")
              .doc();
      moneyTransaction = moneyTransaction.copyWith(ids: doc.id);
    }
    var user = moneyTransaction.user;
    if (moneyTransaction.type == "purchase") {
      await SupplierRepository().insertSupplier(
        user ?? UserModel(),
        sync: false,
        replace: false,
      );
    } else if (moneyTransaction.type == "sale") {
      await CustomerRepository().insertCustomer(
        user ?? UserModel(),
        sync: false,
        replace: false,
      );
    }
    moneyTransaction = moneyTransaction.copyWith(
      createdBy:
          moneyTransaction.id != null ? moneyTransaction.createdBy : userIds,
      updatedBy:
          moneyTransaction.id != null ? userIds : moneyTransaction.updatedBy,
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
    var map = moneyTransaction.toSqfliteMap();
    var id = await db.insert(
      'money_transaction',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (sync) {
      FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
          .doc("2025")
          .collection("moneyTransactions")
          .doc(moneyTransaction.ids)
          .set(
            moneyTransaction
                .copyWith(id: id < 0 ? moneyTransaction.id : id)
                .toMap(),
            SetOptions(merge: sync),
          );
    }

    return id;
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
          .toSqfliteMap(),
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
    FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
        .doc("2025")
        .collection("moneyTransactions")
        .doc(moneyTransaction.ids)
        .set(moneyTransaction.toMap(), SetOptions(merge: true));
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
