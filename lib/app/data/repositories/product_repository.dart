import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/brand_model.dart';
import 'package:tracora/app/data/models/category_model.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/warehouse.dart';
import 'package:tracora/app/data/repositories/brand_repository.dart';
import 'package:tracora/app/data/repositories/category_repository.dart';
import 'package:tracora/app/data/repositories/stock_transaction_repository.dart';
import 'package:tracora/app/data/repositories/sync_repository.dart';
import 'package:uuid/uuid.dart';

class ProductRepository {
  final DbHelper _dbHelper = DbHelper();

  Future<List<Product>> getAllProducts({
    required String search,
    Warehouse? warehouse,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps;
    if (warehouse?.id == null) {
      maps = await db.rawQuery('''
        SELECT
    p.*,
   COALESCE(
  
   SUM(
            CASE
                WHEN st.from_warehouse IS NOT NULL AND st.to_warehouse IS NULL AND st.deletedAt IS NULL THEN -pt.qte
                WHEN st.from_warehouse IS NULL AND st.to_warehouse IS NOT NULL AND st.deletedAt IS NULL THEN pt.qte
                ELSE 0
            END
        )
        ,0) AS rest
FROM product p
LEFT JOIN product_transaction pt 
    ON p.id = pt.productId 
LEFT JOIN stock_transaction st 
    ON st.id = pt.transactionId
WHERE p.deletedAt IS NULL
AND (p.name LIKE "%$search%" OR p.nameAr LIKE "%$search%")
GROUP BY p.id

ORDER BY p.name COLLATE NOCASE ASC
LIMIT 50 OFFSET 0;
      ''');
    } else {
      maps = await db.rawQuery('''
        SELECT
    p.*,
    COALESCE(
        
        COALESCE(SUM(
            CASE
                WHEN st.from_warehouse = '${warehouse?.id ?? "0"}' AND st.deletedAt IS NULL THEN -pt.qte
                WHEN st.to_warehouse = '${warehouse?.id ?? "0"}' AND st.deletedAt IS NULL THEN pt.qte
                ELSE 0
            END
        ),0),0
    ) AS rest
FROM product p
LEFT JOIN product_transaction pt 
    ON p.id = pt.productId
LEFT JOIN stock_transaction st 
    ON st.Id = pt.transactionId
WHERE p.deletedAt IS NULL
AND (p.name LIKE "%$search%" OR p.nameAr LIKE "%$search%")
GROUP BY p.Id
ORDER BY p.name COLLATE NOCASE ASC
LIMIT 50 OFFSET 0;
      ''');
    }
    print(maps.length);

    final List<int> brandId =
        maps.map((map) => map['brandId']).whereType<int>().toList();
    final List<Map<String, dynamic>> brandMaps = await db.query(
      'brand',
      where: brandId.isEmpty ? null : 'id IN (${brandId.join(', ')})',
    );

    final List<int> productId =
        maps.map((m) => m['id'] ?? 0).whereType<int>().toList();
    final List<Map<String, dynamic>> pivotMaps = await db.query(
      'product_category',
      where:
          productId.isEmpty ? null : 'productId IN (${productId.join(', ')})',
    );
    final List<String> categoryId =
        pivotMaps.map((map) => map['categoryId']).whereType<String>().toList();
    final List<Map<String, dynamic>> categoryMaps = await db.query(
      'category',
      where: categoryId.isEmpty ? null : 'id IN (${categoryId.join(', ')})',
    );
    var categories = categoryMaps.map((e) => CategoryModel.fromMap(e)).toList();
    final List<Product> products =
        maps.map((map) {
          final brandMap = brandMaps.firstWhereOrNull(
            (element) => element['id'] == map['brandId'],
          );
          return Product.fromMap(map).copyWith(
            brand: brandMap == null ? null : Brand.fromMap(brandMap),
            categories:
                categories.where((cat) {
                  return pivotMaps
                      .where((pm) => pm['productId'] == map["id"])
                      .map((fpm) => fpm["categoryId"])
                      .contains(cat.id);
                }).toList(),
          );
        }).toList();

    return products;
  }

  Future<List<ProductTransaction>> getProductTransactions({
    required String productId,
  }) async {
    final db = await _dbHelper.db;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT pt.*, st.type 
    FROM product_transaction pt
    INNER JOIN stock_transaction  st on st.Id=pt.transactionId
    WHERE pt.productId = '$productId' AND st.deletedAt is  NULL AND st.status=1
    ORDER BY st.dateTime DESC 
    LIMIT 100
  ''');
    maps.forEach((map) => print(map["direction"]));
    return maps
        .map(
          (map) => ProductTransaction.fromMap(map).copyWith(
            direction:
                map["type"] == "sale"
                    ? -1
                    : map["type"] == "purchase"
                    ? 1
                    : 0,
          ),
        )
        .toList();
  }

  Future<Product> getProduct(String id) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'product',
      where: 'id = ?',
      whereArgs: [id],
    );
    return Product.fromMap(maps[0]);
  }

  Future<int> insertProduct(Product product) async {
    final db = await _dbHelper.db;
    var userId = FirebaseAuth.instance.currentUser?.uid;
    String operation;
    var now = DateTime.now().millisecondsSinceEpoch;
    if (product.id == null) {
      operation = "INSERT";

      product = product.copyWith(
        id: Uuid().v4(),
        createdBy: userId,
        createdAt: now,
      );
    } else {
      operation = "UPDATE";
      product = product.copyWith(
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
    }

    var id = await db.insert(
      'product',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // delete all product categories
    await db.delete(
      'product_category',
      where: 'productId = ?',
      whereArgs: [product.id],
    );

    // add categories to the pivot
    if ((product.categories ?? []).isNotEmpty) {
      final List<Map<String, dynamic>> categoryMaps =
          product.categories!
              .map(
                (category) => {
                  'productId': product.id,
                  'categoryId': category.id,
                },
              )
              .toList();
      await db.rawInsert(
        'INSERT INTO product_category (productId, categoryId) VALUES ${categoryMaps.map((map) => '(${map['productId']}, ${map['categoryId']})').join(', ')}',
      );
    }

    await SyncRepository().addOperation(
      'product',
      product.id ?? "",
      operation,
      product.toMap(),
    );

    return id;
  }

  Future<int> insertProductUsingTxn(Product product, Transaction txn) async {
    var id = await txn.insert(
      'product',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // delete all product categories
    await txn.delete(
      'product_category',
      where: 'productId = ?',
      whereArgs: [product.id],
    );

    // add categories to the pivot
    if ((product.categories ?? []).isNotEmpty) {
      final List<Map<String, dynamic>> categoryMaps =
          product.categories!
              .map(
                (category) => {
                  'productId': product.id,
                  'categoryId': category.id,
                },
              )
              .toList();
      await txn.rawInsert(
        'INSERT INTO product_category (productId, categoryId) VALUES ${categoryMaps.map((map) => '(${map['productId']}, ${map['categoryId']})').join(', ')}',
      );
    }

    return id;
  }

  Future<int> updateProduct(Product product) async {
    final db = await _dbHelper.db;
    return await db.update(
      'product',
      product
          .copyWith(updatedAt: DateTime.now().millisecondsSinceEpoch)
          .toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(Product product) async {
    final db = await _dbHelper.db;
    var now = DateTime.now().millisecondsSinceEpoch;
    product = product.copyWith(deletedAt: now);
    var r = await db.update(
      'product',
      {"deletedAt": now},
      where: 'id = ?',
      whereArgs: [product.id],
    );
    await SyncRepository().addOperation(
      'product',
      product.id ?? "",
      "DELETE",
      product.toMap(),
    );
    return r;
  }
}
