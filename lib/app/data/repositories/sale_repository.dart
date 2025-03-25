import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/customer_repository.dart';
import 'package:tracora/app/data/repositories/product_repository.dart';
import 'package:tracora/app/data/repositories/supplier_repository.dart';

class SaleRepository {
  final DbHelper _dbHelper = DbHelper();

  Future<List<StockTransaction>> getAllSales({required String search}) async {
    final db = await _dbHelper.db;
    // final List<Map<String, dynamic>> maps = await db.query(
    //   'stock_transaction',
    //   where:
    //       'deletedAt IS NULL AND type = "sale" AND () ORDER BY dateTime DESC',
    // );
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT st.*, u.firstName from
      stock_transaction st
      INNER JOIN user u
      ON st.user_id=u.id
      WHERE st.deletedAt IS NULL AND st.type = "sale" AND (u.firstName LIKE "%$search%" OR u.lastName LIKE "%$search%") ORDER BY st.dateTime DESC
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
    var customerIds = maps.map((e) => e['user_id']);
    final List<Map<String, dynamic>> customerMaps = await db.query(
      'user',
      where:
          customerIds.isEmpty
              ? null
              : 'type = "customer" AND id IN (${customerIds.join(', ')})',
    );
    var customers = customerMaps.map(((e) => UserModel.fromMap(e))).toList();

    return maps
        .map(
          (map) => StockTransaction.fromMap(map).copyWith(
            employee: (employees).firstWhereOrNull(
              (e) => e.id == map['employee_id'],
            ),
            user: customers.firstWhereOrNull((e) => e.id == map['user_id']),
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

  Future<StockTransaction> getSale(int id) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'stock_transaction',
      where: 'id = ?',
      whereArgs: [id],
    );
    return StockTransaction.fromMap(maps[0]);
  }

  Future<int> insertSale(StockTransaction sale, {bool sync = true}) async {
    if (sale.ids == null) {
      var doc =
          FirebaseFirestore.instance
              .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
              .doc("2025")
              .collection("stockTransactions")
              .doc();
      sale = sale.copyWith(ids: doc.id);
    }
    final db = await _dbHelper.db;
    var userIds = FirebaseAuth.instance.currentUser?.uid;
    var now = DateTime.now().millisecondsSinceEpoch;
    var products = sale.productTransactions?.map((e) => e.product).toList();
    var user = sale.user;
    await CustomerRepository().insertCustomer(
      user ?? UserModel(),
      replace: false,
      sync: false,
    );
    await Future.forEach(products ?? <Product>[], (c) async {
      await ProductRepository().insertProduct(
        c ?? Product(),
        sync: false,
        replace: false,
      );
    });
    sale = sale.copyWith(
      type: "sale",
      createdBy: sale.id != null ? sale.createdBy : userIds,
      updatedBy: sale.id != null ? userIds : sale.updatedBy,
      dateTime: (sale.dateTime ?? 0) <= 0 ? now : sale.dateTime,
      createdAt: sale.id != null ? sale.createdAt : now,
      updatedAt: sale.id == null ? sale.createdAt : now,
    );
    var map = sale.toSqfliteMap();
    var id = await db.insert(
      'stock_transaction',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.delete(
      'product_transaction',
      where: 'transaction_id = ?',
      whereArgs: [id < 0 ? sale.id : id],
    );

    // add categories to the pivot
    if (sale.productTransactions != null) {
      final List<Map<String, dynamic>> productTransactionMaps =
          sale.productTransactions!
              .map(
                (tr) =>
                    tr
                        .copyWith(
                          transactionId: sale.copyWith(
                            id: id < 0 ? sale.id : id,
                          ),
                        )
                        .toSqfliteMap(),
              )
              .toList();
      await db.rawInsert('''
INSERT INTO product_transaction 
(transaction_id, product_id, direction, price, qte  ) VALUES 
${productTransactionMaps.map((map) => '(${map['transaction_id']}, ${map['product_id']}, -1, ${map['price']}, ${map['qte']})').join(', ')}
          ''');
    }

    if (sync) {
      FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
          .doc("2025")
          .collection("stockTransactions")
          .doc(sale.ids)
          .set(sale.toMap(), SetOptions(merge: sync));
    }

    return id;
  }

  Future<int> updateSale(StockTransaction stock_transaction) async {
    final db = await _dbHelper.db;
    return await db.update(
      'stock_transaction',
      stock_transaction
          .copyWith(
            type: "sale",
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

  Future<int> deleteSale(StockTransaction stockTransaction) async {
    final db = await _dbHelper.db;
    var now = DateTime.now().millisecondsSinceEpoch;
    stockTransaction = stockTransaction.copyWith(deletedAt: now);
    var r = await db.update(
      'stock_transaction',
      {"deletedAt": now},
      where: 'id = ?',
      whereArgs: [stockTransaction.id ?? 0],
    );
    FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
        .doc("2025")
        .collection("stockTransactions")
        .doc(stockTransaction.ids)
        .set(stockTransaction.toMap(), SetOptions(merge: true));
    return r;
  }

  Future<List<StockTransaction>> getAllSalesFor({required int id}) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT st.*, u.firstName from
      stock_transaction st
      INNER JOIN user u
      ON st.user_id=u.id
      WHERE st.deletedAt IS NULL AND st.type = "sale" AND u.id=$id ORDER BY st.dateTime DESC
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
    var supplierIds = maps.map((e) => e['user_id']);
    final List<Map<String, dynamic>> supplierMaps = await db.query(
      'user',
      where:
          supplierIds.isEmpty
              ? null
              : 'type = "customer" AND id IN (${supplierIds.join(', ')})',
    );
    var suppliers = supplierMaps.map(((e) => UserModel.fromMap(e))).toList();

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
      ON st.user_id=u.id
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
    var customerIds = maps.map((e) => e['user_id']);
    final List<Map<String, dynamic>> supplierMaps = await db.query(
      'user',
      where: customerIds.isEmpty ? null : 'id IN (${customerIds.join(', ')})',
    );
    var suppliers = supplierMaps.map(((e) => UserModel.fromMap(e))).toList();
    if (maps.length != 1) return null;
    return StockTransaction.fromMap(maps[0]).copyWith(
      employee: (employees).firstWhereOrNull(
        (e) => e.id == maps[0]['employee_id'],
      ),
      user: suppliers.firstWhereOrNull((e) => e.id == maps[0]['user_id']),
    );
  }

  // sync(StockTransaction model) async {
  //   var products = model.productTransactions?.map((e) => e.product).toList();
  //   var user = model.user;
  //   await CustomerRepository().sync(user);
  //   await Future.forEach(products ?? <Product>[], (c) async {
  //     await ProductRepository().syncProduct(c ?? Product());
  //   });
  //   await insertSale(model);
  // }
}
