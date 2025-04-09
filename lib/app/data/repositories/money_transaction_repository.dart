import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/user_repository.dart';

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
      ON mt.user_id=u.id OR mt.userIds=u.ids
      WHERE ${employee.id == null ? '' : '(mt.employee_id = ${employee.id} OR mt.employeeIds = "${employee.ids}") AND'}  mt.deletedAt IS NULL AND mt.type = "$type" AND (u.firstName LIKE "%$search%" OR u.lastName LIKE "%$search%" or mt.description LIKE "%$search%") ORDER BY mt.dateTime DESC
      LIMIT 50
''');
    if (maps.isEmpty) return [];
    var employeeIds = maps.map((e) => e['employee_id']);
    final List<Map<String, dynamic>> employeeMaps = await db.query(
      'user',
      where:
          employeeIds.isEmpty
              ? null
              : 'type = "employee" AND id IN (${employeeIds.join(', ')})',
    );
    var employees = employeeMaps.map(((e) => UserModel.fromMap(e))).toList();
    var allId = maps.map<int>((e) => e['user_id'] ?? 0).toSet().toList();
    var userIds =
        maps
            .map<String>((e) => '"' + (e['userIds'] ?? "") + '"')
            .toSet()
            .where((e) => e != '""')
            .toList();
    final users = await UserRepository().getAllUsersFromArray(
      allIds: userIds,
      allId: allId,
    );

    return maps
        .map(
          (map) => MoneyTransaction.fromMap(map).copyWith(
            employee: (employees).firstWhereOrNull(
              (e) => e.id == map['employee_id'],
            ),
            user: users.firstWhereOrNull(
              (e) => e.id == map['user_id'] || e.ids == map['userIds'],
            ),
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
      ON mt.user_id=u.id  OR mt.userIds=u.ids
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
    var allId = maps.map<int>((e) => e['user_id'] ?? 0).toSet().toList();
    var userIds =
        maps
            .map<String>((e) => '"' + (e['userIds'] ?? "") + '"')
            .toSet()
            .where((e) => e != '""')
            .toList();
    final users = await UserRepository().getAllUsersFromArray(
      allIds: userIds,
      allId: allId,
    );
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
    required String ids,
    required String type,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT mt.*, u.firstName from
      money_transaction mt
      LEFT JOIN user u
      ON mt.user_id=u.id  OR mt.userIds=u.ids
      WHERE mt.deletedAt IS NULL AND mt.type = "$type" AND (mt.userIds="$ids" or u.ids="$ids") ORDER BY mt.dateTime DESC
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
    var allId = maps.map<int>((e) => e['user_id'] ?? 0).toSet().toList();
    var userIds =
        maps
            .map<String>((e) => '"' + (e['userIds'] ?? "") + '"')
            .toSet()
            .where((e) => e != '""')
            .toList();
    final users = await UserRepository().getAllUsersFromArray(
      allIds: userIds,
      allId: allId,
    );
    return maps
        .map(
          (map) => MoneyTransaction.fromMap(map).copyWith(
            employee: (employees).firstWhereOrNull(
              (e) => e.id == map['employee_id'],
            ),
            user: users.firstWhereOrNull(
              (e) => e.id == map['user_id'] || e.ids == map["userIds"],
            ),
          ),
        )
        .toList();
  }

  Future<List<MoneyTransaction>> getMoneyTransactionsForEmployee({
    required int id,
    required String type,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT mt.*, u.firstName from
      money_transaction mt
      LEFT JOIN user u
      ON mt.user_id=u.id  OR mt.userIds=u.ids
      WHERE mt.deletedAt IS NULL AND  mt.employee_id=$id ORDER BY mt.dateTime DESC
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
    var userIds = maps.map((e) => '"' + (e['userIds'] ?? "") + '"');
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
            user: users.firstWhereOrNull(
              (e) => e.id == map['user_id'] || e.ids == map["userIds"],
            ),
          ),
        )
        .toList();
  }

  Future<List<MoneyTransaction>> getMissionMoneyTransactions({
    required String ids,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT mt.*, u.firstName from
      money_transaction mt
      LEFT JOIN user u
      ON mt.user_id=u.id OR mt.userIds=u.ids
      WHERE mt.deletedAt IS NULL AND  mt.missionIds="$ids" ORDER BY mt.dateTime DESC
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
    var allId = maps.map<int>((e) => e['user_id'] ?? 0).toSet().toList();
    var userIds =
        maps
            .map<String>((e) => '"' + (e['userIds'] ?? "") + '"')
            .toSet()
            .where((e) => e != '""')
            .toList();
    final users = await UserRepository().getAllUsersFromArray(
      allIds: userIds,
      allId: allId,
    );

    return maps
        .map(
          (map) => MoneyTransaction.fromMap(map).copyWith(
            employee: (employees).firstWhereOrNull(
              (e) => e.id == map['employee_id'],
            ),
            user: users.firstWhereOrNull(
              (e) => e.id == map['user_id'] || e.ids == map["userIds"],
            ),
          ),
        )
        .toList();
  }

  Future<int> insertMoneyTransaction(
    MoneyTransaction v, {
    bool sync = true,
  }) async {
    var moneyTransaction = v.copyWith();
    final db = await _dbHelper.db;
    var userIds = FirebaseAuth.instance.currentUser?.uid;
    var now = DateTime.now().millisecondsSinceEpoch;
    if (moneyTransaction.ids == null) {
      var doc =
          FirebaseFirestore.instance.collection("moneyTransactions").doc();
      moneyTransaction = moneyTransaction.copyWith(ids: doc.id);
    }
    var user = moneyTransaction.user;

    if (moneyTransaction.type == "purchase") {
      int id = await UserRepository<Supplier>().insertUser(
        user ?? UserModel(),
        sync: false,
        replace: false,
      );
      user = user?.copyWith(id: id <= 0 ? user.id ?? id : id);
    } else if (moneyTransaction.type == "sale") {
      int id = await UserRepository<Customer>().insertUser(
        user ?? UserModel(),
        sync: false,
        replace: false,
      );
      user = user?.copyWith(id: id <= 0 ? user.id ?? id : id);
    }

    moneyTransaction = moneyTransaction.copyWith(
      user: user,
      createdBy:
          moneyTransaction.id != null ? moneyTransaction.createdBy : userIds,
      updatedBy: userIds ?? "admin",
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
    var id = await db.transaction((txn) async {
      return await txn.insert(
        'money_transaction',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    moneyTransaction = moneyTransaction.copyWith(
      id: id <= 0 ? moneyTransaction.id ?? id : id,
    );
    if ((sync && (moneyTransaction.missionIds ?? '').isNotEmpty) ||
        v.user?.id != id) {
      FirebaseFirestore.instance
          .collection("missions")
          .doc(moneyTransaction.missionIds ?? '')
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
    if ((moneyTransaction.ids ?? "").isNotEmpty) {
      FirebaseFirestore.instance
          .collection("missions")
          .doc(moneyTransaction.missionIds)
          .collection("moneyTransactions")
          .doc(moneyTransaction.ids)
          .set({"deletedAt": now, "deleted": true}, SetOptions(merge: true));
    }

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
