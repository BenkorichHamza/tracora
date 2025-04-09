import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/user_repository.dart';
import 'package:tracora/app/data/repositories/product_repository.dart';

class StockTransactionRepository<T> {
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
          : "mission";

  Future<List<StockTransaction>> getAllTransactions({
    required String search,
    required UserModel employee,
  }) async {
    final db = await _dbHelper.db;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT st.*, u.firstName from
      stock_transaction st
      INNER JOIN user u
      ON st.user_id=u.id OR st.userIds=u.ids
      LEFT JOIN stock_transaction m
      ON m.ids==st.missionIds
      WHERE ${(employee.id == null && (employee.ids ?? "").isEmpty) ? '' : '(${transactionType == "mission" ? "st.user_id" : "st.employee_id"} = ${employee.id} OR ${transactionType == "mission" ? "st.userIds" : "st.employeeIds"} = "${employee.ids}") AND'} st.deletedAt IS NULL AND m.deletedAt IS NULL AND st.type = "$transactionType" AND (u.firstName LIKE "%$search%" OR u.lastName LIKE "%$search%") ORDER BY st.dateTime DESC
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
    var allIds =
        maps
            .map<String>((e) => '"' + (e['userIds'] ?? "") + '"')
            .where((e) => e != '""')
            .toSet()
            .toList();
    final users = await UserRepository().getAllUsersFromArray(
      allIds: allIds,
      allId: allId,
    );

    return maps
        .map(
          (map) => StockTransaction.fromMap(map).copyWith(
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

  Future<List<ProductTransaction>> getProductTransactions(
    int transactionId,
  ) async {
    final db = await _dbHelper.db;
    var maps = await db.query(
      "product_transaction",
      where: 'transaction_id=$transactionId',
    );

    var productIds = maps.map((e) => e['product_id']).toList();
    final List<Map<String, dynamic>> productMaps = await db.query(
      'product',
      where: productIds.isEmpty ? null : 'id IN (${productIds.join(', ')})',
    );
    var products = productMaps.map(((e) => Product.fromMap(e))).toList();

    return maps
        .map(
          (e) => ProductTransaction.fromMap(e).copyWith(
            product: products.firstWhereOrNull((p) => p.id == e['product_id']),
          ),
        )
        .toList();
  }

  Future<StockTransaction> getTransaction(int id) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'stock_transaction',
      where: 'id = ?',
      whereArgs: [id],
    );
    return StockTransaction.fromMap(maps[0]);
  }

  Future<int> insert(
    StockTransaction v, {
    bool sync = true,
    bool mission = false,
  }) async {
    var transaction = v.copyWith();
    if (transaction.ids == null) {
      var doc =
          FirebaseFirestore.instance.collection("stockTransactions").doc();
      transaction = transaction.copyWith(ids: doc.id);
    }
    final db = await _dbHelper.db;
    var userIds = FirebaseAuth.instance.currentUser?.uid;
    var now = DateTime.now().millisecondsSinceEpoch;
    var products =
        transaction.productTransactions?.map((e) => e.product).toList();
    var user = transaction.user;

    var userId = await UserRepository<T>().insertUser(
      user ?? UserModel(),
      replace: false,
      sync: user?.id == null,
    );
    user = user?.copyWith(id: userId <= 0 ? user.id ?? userId : userId);

    var insertedProducts = <Product>[];
    await Future.forEach(products ?? <Product>[], (c) async {
      if (c == null) return;
      var productId = await ProductRepository().insertProduct(
        c,
        sync: false,
        replace: false,
      );
      insertedProducts.add(
        c.copyWith(id: productId <= 0 ? c.id ?? productId : productId),
      );
    });
    products = insertedProducts;
    transaction = transaction.copyWith(
      user: user,
      type: transactionType,
      createdBy: transaction.id != null ? transaction.createdBy : userIds,
      updatedBy: userIds ?? "admin",
      dateTime: (transaction.dateTime ?? 0) <= 0 ? now : transaction.dateTime,
      createdAt: transaction.id != null ? transaction.createdAt : now,
      updatedAt: transaction.id == null ? transaction.createdAt : now,
    );
    var map = transaction.toSqfliteMap();
    return await db.transaction((txn) async {
      var id = await txn.insert(
        'stock_transaction',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      transaction = transaction.copyWith(
        id: id <= 0 ? transaction.id ?? id : id,
      );

      await txn.delete(
        'product_transaction',
        where: 'transaction_id = ?',
        whereArgs: [id < 0 ? transaction.id : id],
      );

      // add categories to the pivot
      if (transaction.productTransactions != null) {
        final List<Map<String, dynamic>> productTransactionMaps =
            transaction.productTransactions!
                .map(
                  (tr) =>
                      tr
                          .copyWith(
                            product: insertedProducts.firstWhere(
                              (e) =>
                                  (e.ids ?? e.id) ==
                                  (tr.product?.ids ?? tr.product?.id),
                            ),
                            transactionId: transaction.copyWith(
                              id: id < 0 ? transaction.id : id,
                            ),
                          )
                          .toSqfliteMap(),
                )
                .toList();
        await txn.rawInsert('''
INSERT INTO product_transaction 
(transaction_id, product_id, direction, price, qte  ) VALUES 
${productTransactionMaps.map((map) => '(${map['transaction_id']}, ${map['product_id']}, ${transactionType == "purchase"
            ? 1
            : transactionType == "sale"
            ? -1
            : 0}, ${map['price']}, ${map['qte']})').join(', ')}
          ''');
      }

      if (sync) {
        if (mission) {
          FirebaseFirestore.instance
              .collection("missions")
              .doc(transaction.ids)
              .set(transaction.toMap(), SetOptions(merge: sync));
        } else if ((sync && (transaction.missionIds ?? '').isNotEmpty) ||
            v.user?.id != id) {
          FirebaseFirestore.instance
              .collection("missions")
              .doc(transaction.missionIds)
              .collection("stockTransactions")
              .doc(transaction.ids)
              .set(transaction.toMap(), SetOptions(merge: sync));
        }
      }
      return id;
    });
  }

  Future<int> updateTransaction(StockTransaction stock_transaction) async {
    final db = await _dbHelper.db;
    return await db.update(
      'stock_transaction',
      stock_transaction
          .copyWith(
            type: "$transactionType",
            createdAt:
                stock_transaction.id != null
                    ? stock_transaction.createdAt
                    : DateTime.now().millisecondsSinceEpoch,
            updatedAt:
                stock_transaction.id == null
                    ? stock_transaction.createdAt
                    : DateTime.now().millisecondsSinceEpoch,
          )
          .toSqfliteMap(),
      where: 'id = ?',
      whereArgs: [stock_transaction.id],
    );
  }

  Future<int> deleteTransaction(StockTransaction stockTransaction) async {
    final db = await _dbHelper.db;
    var now = DateTime.now().millisecondsSinceEpoch;
    stockTransaction = stockTransaction.copyWith(deletedAt: now);
    var r = await db.update(
      'stock_transaction',
      {"deletedAt": now},
      where: 'id = ?',
      whereArgs: [stockTransaction.id ?? 0],
    );
    if ((stockTransaction.ids ?? "").isNotEmpty) {
      FirebaseFirestore.instance
          .collection("missions")
          .doc(stockTransaction.missionIds)
          .collection("stockTransactions")
          .doc(stockTransaction.ids)
          .set({"deletedAt": now, "deleted": true}, SetOptions(merge: true));
    }
    return r;
  }

  Future<List<StockTransaction>> getAllTransactionsFor({
    required String ids,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT st.*, u.firstName from
      stock_transaction st
      INNER JOIN user u
      ON st.user_id=u.id  OR st.userIds=u.ids
      WHERE st.deletedAt IS NULL AND st.type = "$transactionType" AND u.ids="$ids" ORDER BY st.dateTime DESC
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
    var supplierIds = maps.map((e) => '"' + (e['userIds'] ?? "") + '"');
    var allId = maps.map<int>((e) => e['user_id'] ?? 0).toSet().toList();
    var userIds =
        maps
            .map<String>((e) => '"' + (e['userIds'] ?? "") + '"')
            .toSet()
            .where((e) => e != '""')
            .toList();
    final suppliers = await UserRepository().getAllUsersFromArray(
      allIds: userIds,
      allId: allId,
    );
    return maps
        .map(
          (map) => StockTransaction.fromMap(map).copyWith(
            employee: (employees).firstWhereOrNull(
              (e) => e.id == map['employee_id'],
            ),
            user: suppliers.firstWhereOrNull(
              (e) => e.id == map['user_id'] || e.ids == map["userIds"],
            ),
          ),
        )
        .toList();
  }

  Future<List<StockTransaction>> getAllTransactionsForEmployee({
    required int id,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT st.*, u.firstName from
      stock_transaction st
      INNER JOIN user u
      ON st.user_id=u.id  OR st.userIds=u.ids
      WHERE st.deletedAt IS NULL AND st.employee_id=$id ORDER BY st.dateTime DESC
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
    var supplierIds = maps.map((e) => '"' + (e['userIds'] ?? "") + '"');
    var allId = maps.map<int>((e) => e['user_id'] ?? 0).toSet().toList();
    var userIds =
        maps
            .map<String>((e) => '"' + (e['userIds'] ?? "") + '"')
            .toSet()
            .where((e) => e != '""')
            .toList();
    final suppliers = await UserRepository().getAllUsersFromArray(
      allIds: userIds,
      allId: allId,
    );
    return maps
        .map(
          (map) => StockTransaction.fromMap(map).copyWith(
            employee: (employees).firstWhereOrNull(
              (e) => e.id == map['employee_id'],
            ),
            user: suppliers.firstWhereOrNull((e) => e.id == map['user_id']),
          ),
        )
        .toList();
  }

  Future<List<StockTransaction>> getMissionStockTransactions({
    required String ids,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT st.*, u.firstName from
      stock_transaction st
      INNER JOIN user u
      ON st.user_id=u.id OR st.userIds=u.ids
      WHERE st.deletedAt IS NULL AND st.missionIds="$ids" ORDER BY st.dateTime DESC
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
    final suppliers = await UserRepository().getAllUsersFromArray(
      allIds: userIds,
      allId: allId,
    );
    return maps
        .map(
          (map) => StockTransaction.fromMap(map).copyWith(
            employee: (employees).firstWhereOrNull(
              (e) => e.id == map['employee_id'],
            ),
            user: suppliers.firstWhereOrNull(
              (e) => e.id == map['user_id'] || e.ids == map["userIds"],
            ),
          ),
        )
        .toList();
  }

  Future<List<ProductTransaction>> getProductTransactionsFor(int userId) async {
    final db = await _dbHelper.db;

    // Single SQL query with JOINs, filtered by user_id only
    final List<Map<String, dynamic>> results = await db.rawQuery(
      '''
    SELECT pt.*, p.*, st.*,sum(pt.qte) as qte
    FROM product_transaction pt
    INNER JOIN product p ON pt.product_id = p.id
    INNER JOIN stock_transaction st ON pt.transaction_id = st.id
    WHERE st.user_id = ?
    group by p.id
  ''',
      [userId],
    );

    return results.map((e) {
      return ProductTransaction.fromMap(e).copyWith(
        product: Product.fromMap(e),
        transactionId: StockTransaction.fromMap(
          e,
        ), // Assuming you have a StockTransaction model
      );
    }).toList();
  }

  Future<StockTransaction?> getStockTransactionById({required int id}) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT st.*, u.firstName from
      stock_transaction st
      INNER JOIN user u
      ON st.user_id=u.id OR st.userIds=u.ids
      WHERE st.deletedAt IS NULL AND st.id = $id
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
    final suppliers = await UserRepository().getAllUsersFromArray(
      allIds: userIds,
      allId: allId,
    );
    if (maps.length != 1) return null;
    return StockTransaction.fromMap(maps[0]).copyWith(
      employee: (employees).firstWhereOrNull(
        (e) => e.id == maps[0]['employee_id'],
      ),
      user: suppliers.firstWhereOrNull((e) => e.id == maps[0]['user_id']),
    );
  }
}
