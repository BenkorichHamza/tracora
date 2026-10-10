import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/warehouse.dart';
import 'package:tracora/app/data/repositories/sync_repository.dart';
import 'package:uuid/uuid.dart';

class WarehouseRepository {
  final DbHelper _dbHelper = DbHelper();

  Future<List<Warehouse>> getAllWarehouses({required String search}) async {
    final db = await _dbHelper.db;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT
        * from warehouse where deletedAt is NULL AND (name LIKE "%$search%" OR description LIKE "%$search%")
      ''');
    final List<Warehouse> warehouses =
        maps.map((map) {
          return Warehouse.fromMap(map);
        }).toList();

    return warehouses;
  }

  Future<Warehouse> getWarehouse(String id) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'warehouse',
      where: 'id = ?',
      whereArgs: [id],
    );
    return Warehouse.fromMap(maps[0]);
  }

  Future<List<Warehouse>> getAllFromArray({required List<String> allId}) async {
    if (allId.isEmpty) return [];
    final db = await _dbHelper.db;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
SELECT 
    *
FROM warehouse u

WHERE  id in (${allId.join(', ')})
''');

    return maps.map((map) => Warehouse.fromMap(map)).toList();
  }

  Future<int> insertWarehouse(Warehouse warehouse) async {
    final db = await _dbHelper.db;
    var userId = FirebaseAuth.instance.currentUser?.uid;
    var now = DateTime.now().millisecondsSinceEpoch;
    String operation;
    if (warehouse.id == null) {
      operation = "INSERT";
      warehouse = warehouse.copyWith(
        id: Uuid().v4(),
        createdBy: userId,
        createdAt: now,
      );
    } else {
      operation = "UPDATE";
      warehouse = warehouse.copyWith(updatedBy: userId, updatedAt: now);
    }

    var id = await db.insert(
      'warehouse',
      warehouse.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await SyncRepository().addOperation(
      'warehouse',
      warehouse.id ?? "",
      operation,
      warehouse.toSyncMap(),
    );
    return id;
  }

  Future<int> insertWarehouseUsingTxn(
    Warehouse warehouse,
    Transaction txn,
  ) async {
    var id = await txn.insert(
      'warehouse',
      warehouse.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<List<Map<Warehouse, double>>> getWarehouseStock(
    Product product, {
    String search = "",
  }) async {
    final db = await _dbHelper.db;
    //     await db.rawQuery('''
    // update stock_transaction  set type = 'transfert' where type='mission'
    // ''');

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
    SELECT
        w.*,
        COALESCE(SUM(
            CASE
                WHEN st.to_warehouse = w.id   THEN pt.qte
                WHEN st.from_warehouse = w.id  THEN -pt.qte
                ELSE 0
            END
        ),0) AS stock
    FROM warehouse w
    LEFT JOIN stock_transaction st
    LEFT JOIN product_transaction pt
        ON pt.transactionId = st.id
        AND pt.productId = ?
    WHERE (w.name LIKE "%$search%" 
       OR w.description LIKE "%$search%") AND pt.productId='${product.id}' AND st.deletedAt IS NULL AND w.deletedAt IS NULL
    GROUP BY w.id
  ''',
      [product.id],
    );

    return maps
        .map(
          (e) => {
            Warehouse.fromMap(e): double.tryParse(e['stock'].toString()) ?? 0,
          },
        )
        .toList();
  }

  Future<int> deleteWarehouse(Warehouse warehouse) async {
    final db = await _dbHelper.db;
    var now = DateTime.now().millisecondsSinceEpoch;
    warehouse = warehouse.copyWith(deletedAt: now);
    var r = await db.update(
      'warehouse',
      {"deletedAt": now},
      where: 'id = ?',
      whereArgs: [warehouse.id],
    );
    await SyncRepository().addOperation(
      'warehouse',
      warehouse.id ?? "",
      "DELETE",
      warehouse.toSyncMap(),
    );
    return r;
  }

  Future<List<Warehouse>> getAllWarehousesFromArray({
    required List<String> allId,
  }) async {
    final db = await _dbHelper.db;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT
        * from warehouse where id in (${allId.map((e) => "'$e'").join(', ')}) AND deletedAt IS NULL
      ''');
    final List<Warehouse> warehouses =
        maps.map((map) {
          return Warehouse.fromMap(map);
        }).toList();

    return warehouses;
  }
}
