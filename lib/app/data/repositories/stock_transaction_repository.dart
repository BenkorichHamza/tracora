import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/models/warehouse.dart';
import 'package:tracora/app/data/repositories/sync_repository.dart';
import 'package:tracora/app/data/repositories/user_repository.dart';
import 'package:tracora/app/data/repositories/product_repository.dart';
import 'package:tracora/app/data/repositories/warehouse_repository.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:uuid/uuid.dart';

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
          : T == Transfert
          ? "transfert"
          : "all";

  Future<List<StockTransaction>> getAllTransactions({
    required String search,
    required UserModel employee,
    Warehouse? warehouse,
  }) async {
    final db = await _dbHelper.db;
    String employeeCondition =
        employee.id != null ? ' AND st.employeeId LIKE "%${employee.id}%"' : '';
    final List<Map<String, dynamic>> maps;
    if (transactionType == "transfert") {
      maps = await db.rawQuery('''
      SELECT st.*, fromWarehouse.name , toWarehouse.name from
      stock_transaction st
      LEFT JOIN warehouse fromWarehouse
      ON st.from_warehouse=fromWarehouse.id
      LEFT JOIN warehouse toWarehouse
      ON st.to_warehouse=toWarehouse.id
      WHERE st.deletedAt IS NULL $employeeCondition AND st.type = "$transactionType" AND (fromWarehouse.name LIKE "%$search%" OR toWarehouse.name LIKE "%$search%" OR st.id LIKE "%$search%") ORDER BY st.dateTime DESC
      LIMIT 50
    ''');
    } else if (transactionType == "all") {
      maps = await db.rawQuery('''
      SELECT st.* from
      stock_transaction st
      
      WHERE
      (st.from_warehouse = '${warehouse?.id}' OR st.to_warehouse = '${warehouse?.id}') AND
       st.deletedAt IS NULL  ORDER BY st.dateTime DESC
      LIMIT 50
    ''');
    } else {
      if (warehouse?.id == null) {
        maps = await db.rawQuery('''
      SELECT st.*, u.firstName from
      stock_transaction st
      LEFT JOIN user u
      ON st.userId=u.id
            WHERE st.deletedAt IS NULL $employeeCondition AND st.type = "$transactionType" AND (u.firstName LIKE "%$search%" OR u.lastName LIKE "%$search%") ORDER BY st.dateTime DESC
LIMIT 50
    ''');
      } else {
        maps = await db.rawQuery('''
      SELECT st.*, u.firstName from
      stock_transaction st
      LEFT JOIN user u
      ON st.userId=u.id
      WHERE st.deletedAt IS NULL $employeeCondition AND st.type = "$transactionType" AND (u.firstName LIKE "%$search%" OR u.lastName LIKE "%$search%") ORDER BY st.dateTime DESC
      LIMIT 50
    ''');
      }
    }

    if (maps.isEmpty) return [];
    // ignore: prefer_interpolation_to_compose_strings
    var allEmployeeId = maps.map((e) => "'" + (e['employeeId'] ?? '') + "'");
    final List<Map<String, dynamic>> employeeMaps = await db.query(
      'user',
      where:
          allEmployeeId.isEmpty
              ? null
              : 'type = "employee" AND id IN (${allEmployeeId.join(', ')})',
    );
    var employees = employeeMaps.map(((e) => UserModel.fromMap(e))).toList();

    //get all users for all transations
    var allId =
        maps
            .map<String>((e) => e['userId'] ?? "")
            .where((e) => e != '')
            .toSet()
            .toList();
    final users = await UserRepository().getAllUsersFromArray(allId: allId);

    //get all from_warefouses for all transations
    allId =
        maps
            .map<String>((e) => '"' + (e['from_warehouse'] ?? "") + '"')
            .where((e) => e != '""')
            .toSet()
            .toList();
    final fromWarehouses = await WarehouseRepository().getAllFromArray(
      allId: allId,
    );
    allId =
        maps
            .map<String>((e) => '"' + (e['to_warehouse'] ?? "") + '"')
            .where((e) => e != '""')
            .toSet()
            .toList();
    final toWarehouses = await WarehouseRepository().getAllFromArray(
      allId: allId,
    );
    var transactions =
        maps
            .map(
              (map) => StockTransaction.fromMap(map).copyWith(
                employee: (employees).firstWhereOrNull(
                  (e) => e.id == map['employeeId'],
                ),
                user: users.firstWhereOrNull(
                  (e) => e.id == map['userId'] || e.id == map['userId'],
                ),
                from_warehouse: fromWarehouses.firstWhereOrNull(
                  (e) => e.id == map['from_warehouse'],
                ),
                to_warehouse: toWarehouses.firstWhereOrNull(
                  (e) => e.id == map['to_warehouse'],
                ),
              ),
            )
            .toList();
    return transactions;
  }

  Future<List<ProductTransaction>> getProductTransactions(
    String transactionId,
  ) async {
    final db = await _dbHelper.db;
    var maps = await db.query(
      "product_transaction",
      where: 'transactionId="$transactionId"',
    );

    var allProductId = maps.map((e) => ("'${e['productId']}'")).toList();
    final List<Map<String, dynamic>> productMaps = await db.query(
      'product',
      where: allProductId.isEmpty ? null : 'id IN (${allProductId.join(', ')})',
    );
    var products = productMaps.map(((e) => Product.fromMap(e))).toList();

    return maps
        .map(
          (e) => ProductTransaction.fromMap(e).copyWith(
            product: products.firstWhereOrNull((p) => p.id == e['productId']),
          ),
        )
        .toList();
  }

  Future<StockTransaction> getTransaction(String id) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'stock_transaction',
      where: 'id = ?',
      whereArgs: [id],
    );
    return StockTransaction.fromMap(maps[0]);
  }

  Future<int> insert(StockTransaction v) async {
    var transaction = v.copyWith();
    var userId = Get.find<HomeController>().employee.id;
    var now = DateTime.now().millisecondsSinceEpoch;
    String operation;
    if (transaction.id == null) {
      operation = "INSERT";
      var uuid = Uuid().v4();
      transaction = transaction.copyWith(
        id: uuid,
        createdBy: userId,
        employeeId: userId,
      );
    } else {
      operation = "UPDATE";
      transaction = transaction.copyWith(
        employee: transaction.employee ?? Get.find<HomeController>().employee,
        updatedAt: now,
        updatedBy: userId,
        employeeId: userId,
      );
    }
    final db = await _dbHelper.db;
    transaction = transaction.copyWith(
      type: transactionType,
      dateTime: (transaction.dateTime ?? 0) <= 0 ? now : transaction.dateTime,
    );
    var map = transaction.toSqfliteMap();
    return await db.transaction((txn) async {
      var id = await txn.insert(
        'stock_transaction',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await txn.delete(
        'product_transaction',
        where: 'transactionId = ?',
        whereArgs: [transaction.id],
      );

      // add categories to the pivot
      if (transaction.productTransactions != null) {
        await txn.rawInsert('''
INSERT INTO product_transaction 
(transactionId, productId, direction, price, qte  ) VALUES 
${transaction.productTransactions!.map((map) => '("${transaction.id}", "${map.product?.id}", ${transactionType == "purchase"
            ? 1
            : transactionType == "sale"
            ? -1
            : 0}, ${map.price}, ${map.qte})').join(', ')}
          ''');
      }
      await txn.insert('sync_operations', {
        'tableName': 'stock_transaction',
        'rowId': transaction.id ?? "",
        'operation': operation,
        'data': transaction.toSyncJson(),
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'synced': 0,
      });
      print({
        'tableName': 'stock_transaction',
        'rowId': transaction.id ?? "",
        'operation': operation,
        'data': transaction.toSyncJson(),
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'synced': 0,
      });

      return id;
    });
  }

  Future<int> insertUsingTxn(StockTransaction v, Transaction txn) async {
    var map = v.toSqfliteMap();

    var id = await txn.insert(
      'stock_transaction',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await txn.delete(
      'product_transaction',
      where: 'transactionId = ?',
      whereArgs: [v.id],
    );
    print('''INSERT INTO product_transaction 
(transactionId, productId, direction, price, qte) VALUES 
${v.productTransactions!.map((e) {
      return '("${e.transaction?.id}", "${e.product?.id}", ${e.direction}, ${e.price}, ${e.qte})';
    }).join(', ')}
          ''');

    // add categories to the pivot
    if (v.productTransactions != null && v.productTransactions!.isNotEmpty) {
      await txn.rawInsert('''
INSERT INTO product_transaction 
(transactionId, productId, direction, price, qte) VALUES 
${v.productTransactions!.map((e) {
        return '("${e.transaction?.id}", "${e.product?.id}", ${e.direction}, ${e.price}, ${e.qte})';
      }).join(', ')}
          ''');
    }

    return id;
  }

  Future<int> deleteTransaction(StockTransaction stockTransaction) async {
    final db = await _dbHelper.db;
    var now = DateTime.now().millisecondsSinceEpoch;
    stockTransaction = stockTransaction.copyWith(deletedAt: now);
    var r = await db.update(
      'stock_transaction',
      {"deletedAt": now},
      where: 'id = ?',
      whereArgs: [stockTransaction.id],
    );

    await SyncRepository().addOperation(
      'stock_transaction',
      stockTransaction.id ?? "",
      "DELETE",
      stockTransaction.toSyncMap(),
    );

    return r;
  }

  Future<List<StockTransaction>> getAllTransactionsFor({
    required String id,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT st.*, u.firstName from
      stock_transaction st
      INNER JOIN user u
      ON st.userId=u.id
      WHERE st.deletedAt IS NULL AND st.type = "$transactionType" AND u.id="$id" ORDER BY st.dateTime DESC
      LIMIT 50
''');
    if (maps.isEmpty) return [];
    // ignore: prefer_interpolation_to_compose_strings
    var allEmployeeId = maps.map((e) => '"' + (e['employeeId'] ?? '') + '"');
    final List<Map<String, dynamic>> employeeMaps = await db.query(
      'user',
      where:
          allEmployeeId.isEmpty
              ? null
              : 'type = "employee" AND id IN (${allEmployeeId.join(', ')})',
    );
    var employees = employeeMaps.map(((e) => UserModel.fromMap(e))).toList();
    var userId =
        maps
            .map<String>((e) => (e['userId'] ?? ""))
            .toSet()
            .where((e) => e != '')
            .toList();
    final suppliers = await UserRepository().getAllUsersFromArray(
      allId: userId,
    );
    return maps
        .map(
          (map) => StockTransaction.fromMap(map).copyWith(
            employee: (employees).firstWhereOrNull(
              (e) => e.id == map['employeeId'],
            ),
            user: suppliers.firstWhereOrNull((e) => e.id == map["userId"]),
          ),
        )
        .toList();
  }

  Future<List<StockTransaction>> getAllTransactionsForEmployee({
    required String id,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT st.*, u.firstName from
      stock_transaction st
      INNER JOIN user u
      ON st.userId=u.id
      WHERE st.deletedAt IS NULL AND st.employeeId="$id" ORDER BY st.dateTime DESC
      LIMIT 50
''');
    // ignore: prefer_interpolation_to_compose_strings
    var allEmployeeId = maps.map((e) => '"' + (e['employeeId'] ?? '') + '"');
    final List<Map<String, dynamic>> employeeMaps = await db.query(
      'user',
      where:
          allEmployeeId.isEmpty
              ? null
              : 'type = "employee" AND id IN (${allEmployeeId.join(', ')})',
    );
    var employees = employeeMaps.map(((e) => UserModel.fromMap(e))).toList();
    var userId =
        maps
            .map<String>((e) => (e['userId'] ?? ""))
            .toSet()
            .where((e) => e != '')
            .toList();
    final suppliers = await UserRepository().getAllUsersFromArray(
      allId: userId,
    );
    return maps
        .map(
          (map) => StockTransaction.fromMap(map).copyWith(
            employee: (employees).firstWhereOrNull(
              (e) => e.id == map['employeeId'],
            ),
            user: suppliers.firstWhereOrNull((e) => e.id == map['userId']),
          ),
        )
        .toList();
  }

  Future<List<ProductTransaction>> getProductTransactionsFor(
    String userId,
  ) async {
    final db = await _dbHelper.db;

    // Single SQL query with JOINs, filtered by user_id only
    final List<Map<String, dynamic>> results = await db.rawQuery(
      '''
    SELECT pt.*, p.*, st.*,sum(pt.qte) as qte
    FROM product_transaction pt
    INNER JOIN product p ON pt.productId = p.id
    INNER JOIN stock_transaction st ON pt.transactionId = st.id
    WHERE st.userId = ? AND st.deletedAt IS NULL
    group by p.id
  ''',
      [userId],
    );

    return results.map((e) {
      return ProductTransaction.fromMap(e).copyWith(
        product: Product.fromMap(e),
        transaction: StockTransaction.fromMap(
          e,
        ), // Assuming you have a StockTransaction model
      );
    }).toList();
  }

  Future<StockTransaction?> getStockTransactionById({
    required String id,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT st.*, u.firstName from
      stock_transaction st
      INNER JOIN user u
      ON st.userId=u.id OR st.userId=u.id
      WHERE st.deletedAt IS NULL AND st.id = '$id'
      LIMIT 50
''');
    var allEmployeeId = maps.map((e) => '"' + (e['employeeId'] ?? '') + '"');
    final List<Map<String, dynamic>> employeeMaps = await db.query(
      'user',
      where:
          allEmployeeId.isEmpty
              ? null
              : 'type = "employee" AND id IN (${allEmployeeId.join(', ')})',
    );
    var employees = employeeMaps.map(((e) => UserModel.fromMap(e))).toList();
    var userId =
        maps
            .map<String>((e) => '"' + (e['userId'] ?? "") + '"')
            .toSet()
            .where((e) => e != '""')
            .toList();
    final suppliers = await UserRepository().getAllUsersFromArray(
      allId: userId,
    );
    if (maps.length != 1) return null;
    return StockTransaction.fromMap(maps[0]).copyWith(
      employee: (employees).firstWhereOrNull(
        (e) => e.id == maps[0]['employeeId'],
      ),
      user: suppliers.firstWhereOrNull((e) => e.id == maps[0]['userId']),
    );
  }
}
