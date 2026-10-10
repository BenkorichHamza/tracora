import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/role.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/models/warehouse.dart';
import 'package:tracora/app/data/repositories/sync_repository.dart';
import 'package:tracora/app/data/repositories/warehouse_repository.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:uuid/uuid.dart';

class UserRepository<T> {
  final DbHelper _dbHelper = DbHelper();
  String get userType =>
      T == Sale || T == Customer
          ? "customer"
          : T == Purchase || T == Supplier
          ? "supplier"
          : "employee";
  String get transactionType =>
      T == Sale || T == Customer
          ? "sale"
          : T == Purchase || T == Supplier
          ? "purchase"
          : "transfert";
  Future<List<UserModel>> getAllUsers({required String search}) async {
    final db = await _dbHelper.db;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
SELECT 
    u.*, 
    COALESCE(mt.payment, 0) + COALESCE(st.payment, 0) AS payment,
    COALESCE(st.due, 0) AS due
FROM user u
LEFT JOIN (
    SELECT userId, SUM(amount) AS payment 
    FROM money_transaction 
    WHERE type = '$transactionType' 
    and status = 1 AND deletedAt IS NULL
    GROUP BY userId
) mt ON mt.userId=u.id
LEFT JOIN (
    SELECT userId, SUM(payment) AS payment, SUM(toPay) AS due 
    FROM stock_transaction 
    WHERE type = '$transactionType' 
    and status = 1 AND deletedAt IS NULL
    GROUP BY userId
) st ON st.userId=u.id
WHERE u.deletedAt IS NULL 
  AND u.type = "$userType"
  AND (u.firstName LIKE "%$search%" OR u.lastName LIKE "%$search%" OR u.email LIKE "%$search%" OR u.phone LIKE "%$search%")
  ORDER BY u.firstName COLLATE NOCASE ASC

''');

    if (maps.isEmpty) return [];
    print(maps);

    final List<String> allId =
        maps.map((e) => e['warehouse_id'].toString()).toSet().toList();
    final List<Warehouse> warehouses = await WarehouseRepository()
        .getAllWarehousesFromArray(allId: allId);
    List<Role> roles = [];
    final List<String> usersId =
        maps.map((e) => '"${e['id'] ?? ''}"').toSet().toList();
    var rolesPivotMap = await db.query(
      "role_user",
      where: "user_id IN (${usersId.join(',')})",
    );
    if (rolesPivotMap.isNotEmpty) {
      var rolesId = rolesPivotMap.map((e) => e['role_id']);
      var rolesm = await db.query(
        "roles",
        where: "id IN (${rolesId.join(",")})",
      );
      roles = rolesm.map((r) => Role.fromMap(r)).toList();
    }

    var rr =
        maps
            .map(
              (map) => UserModel.fromMap(map).copyWith(
                warehouse: warehouses.firstWhereOrNull(
                  (element) => element.id == map['warehouse_id'],
                ),
                roles:
                    roles
                        .where(
                          (r) => rolesPivotMap
                              .where((e) => e['user_id'] == map["id"])
                              .map((e) => e['role_id'])
                              .contains(r.id),
                        )
                        .toList(),
              ),
            )
            .toList();
    return rr;
  }

  Future<List<UserModel>> getAllUsersFromArray({
    required List<String> allId,
  }) async {
    if (allId.isEmpty) return [];
    final db = await _dbHelper.db;
    allId = allId.map((e) => "'$e'").toList();

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
SELECT 
    u.*, 
    COALESCE(mt.payment, 0) + COALESCE(st.payment, 0) AS payment,
    COALESCE(st.due, 0) AS due
FROM user u
LEFT JOIN (
    SELECT userId, SUM(amount) AS payment 
    FROM money_transaction 
    WHERE status = 1 AND deletedAt IS NULL
    GROUP BY userId
) mt ON mt.userId=u.id
LEFT JOIN (
    SELECT userId, SUM(payment) AS payment, SUM(toPay) AS due 
    FROM stock_transaction 
    WHERE status = 1 AND deletedAt IS NULL
    GROUP BY userId
) st ON st.userId=u.id
WHERE (u.id in (${allId.join(', ')}))
''');

    return maps.map((map) => UserModel.fromMap(map)).toList();
  }

  Future<UserModel?> getUser(String id) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
SELECT 
    u.*, 
    COALESCE(mt.payment, 0) + COALESCE(st.payment, 0) AS payment,
    COALESCE(st.due, 0) AS due
FROM user u
LEFT JOIN (
    SELECT userId, SUM(amount) AS payment 
    FROM money_transaction 
    WHERE type = '$transactionType' 
    and status = 1
    GROUP BY userId
) mt ON mt.userId=u.id
LEFT JOIN (
    SELECT userId, SUM(payment) AS payment, SUM(toPay) AS due 
    FROM stock_transaction 
    WHERE type = '$transactionType' 
    and status == 1
    GROUP BY userId
) st ON st.userId=u.id
WHERE u.deletedAt IS NULL 
  AND u.type = "$userType"
  AND u.id='$id'
''');
    if (maps.length != 1) return null;
    return UserModel.fromMap(maps[0]);
  }

  Future<int> insertUser(UserModel u) async {
    final db = await _dbHelper.db;
    // await db.delete('user');
    // await db.delete('sync_operations');
    var user = u.copyWith(type: userType);
    var userId = Get.find<HomeController>().employee.id;
    var now = DateTime.now().millisecondsSinceEpoch;
    String operation;
    if (user.id == null) {
      operation = "INSERT";

      user = user.copyWith(id: Uuid().v4(), createdBy: userId, createdAt: now);
    } else {
      operation = "UPDATE";
      user = user.copyWith(updatedBy: userId, updatedAt: now);
    }

    user = user.copyWith(type: userType);
    await db.transaction((txn) async {
      int id = await txn.insert(
        'user',
        user.toMap()..remove("roles"),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await txn.delete("role_user", where: "user_id='${user.id}'");
      await Future.forEach(user.roles ?? [], (role) async {
        await txn.insert("role_user", {"user_id": user.id, "role_id": role.id});
      });
    });

    await SyncRepository().addOperation(
      'contacts',
      user.id ?? "",
      operation,
      user.toSyncMap(),
    );
    return 0;
  }

  Future<int> insertUserUsingTxn(UserModel user, Transaction txn) async {
    print(user.roles);
    var id = await txn.insert(
      'user',
      user.toMap()..remove("roles"),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await txn.delete("role_user", where: "user_id='${user.id}'");
    await Future.forEach(user.roles ?? <Role>[], (role) async {
      var id = await txn.insert("role_user", {
        "user_id": user.id,
        "role_id": role.id,
      });
    });

    return id;
  }

  Future<int> deleteUser(UserModel user) async {
    final db = await _dbHelper.db;
    var now = DateTime.now().millisecondsSinceEpoch;
    user = user.copyWith(deletedAt: now);
    var r = await db.update(
      'user',
      {"deletedAt": now},
      where: 'id = ?',
      whereArgs: [user.id],
    );

    await SyncRepository().addOperation(
      'contacts',
      user.id ?? "",
      "DELETE",
      user.toSyncMap(),
    );

    return r;
  }

  Future<List<UserModel>> getAllUsersByProductId(String productId) async {
    final db = await _dbHelper.db;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
    SELECT DISTINCT u.*
    FROM user u
    INNER JOIN stock_transaction st ON u.id = st.userId  OR st.userId=u.id
    INNER JOIN product_transaction pt ON st.id = pt.transactionId
    WHERE pt.productId = ?
      AND u.deletedAt IS NULL AND u.type="$userType"
  ''',
      [productId],
    );
    return maps.map((map) => UserModel.fromMap(map)).toList();
  }
}
