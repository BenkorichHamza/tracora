import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/brand_model.dart';
import 'package:tracora/app/data/models/category_model.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/repositories/brand_repository.dart';
import 'package:tracora/app/data/repositories/category_repository.dart';

class ProductRepository {
  final DbHelper _dbHelper = DbHelper();

  Future<List<Product>> getAllProducts({required String search}) async {
    final db = await _dbHelper.db;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT 
      p.*, 
      COALESCE(SUM(pt.qte * pt.direction), 0) AS stock
    FROM product p
    LEFT JOIN product_transaction pt ON p.id = pt.product_id
    WHERE p.deletedAt IS NULL AND (p.name LIKE "%$search%" OR p.nameAr LIKE "%$search%")
    GROUP BY p.id
    LIMIT 50
  ''');

    // final List<Map<String, dynamic>> maps = await db.query(
    //   'product',
    //   where:
    //       'deletedAt IS NULL AND (name LIKE "%$search%" OR nameAr LIKE "%$search%")',
    // );
    final List<int> brandIds =
        maps.map((map) => map['brand_id']).whereType<int>().toList();
    final List<Map<String, dynamic>> brandMaps = await db.query(
      'brand',
      where: brandIds.isEmpty ? null : 'id IN (${brandIds.join(', ')})',
    );

    final List<int> productIds =
        maps.map((m) => m['id'] ?? 0).whereType<int>().toList();
    final List<Map<String, dynamic>> pivotMaps = await db.query(
      'product_category',
      where:
          productIds.isEmpty
              ? null
              : 'product_id IN (${productIds.join(', ')})',
    );
    final List<int> categoryIds =
        pivotMaps.map((map) => map['category_id']).whereType<int>().toList();
    final List<Map<String, dynamic>> categoryMaps = await db.query(
      'category',
      where: categoryIds.isEmpty ? null : 'id IN (${categoryIds.join(', ')})',
    );
    var categories = categoryMaps.map((e) => CategoryModel.fromMap(e)).toList();
    final List<Product> products =
        maps.map((map) {
          final brandMap = brandMaps.firstWhereOrNull(
            (element) => element['id'] == map['brand_id'],
          );
          return Product.fromMap(map).copyWith(
            brand: brandMap == null ? null : Brand.fromMap(brandMap),
            categories:
                categories.where((cat) {
                  return pivotMaps
                      .where((pm) => pm['product_id'] == map["id"])
                      .map((fpm) => fpm["category_id"])
                      .contains(cat.id);
                }).toList(),
          );
        }).toList();

    return products;
  }

  Future<List<ProductTransaction>> getProductTransactions({
    required int productId,
  }) async {
    final db = await _dbHelper.db;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT pt.* 
    FROM product_transaction pt
    INNER JOIN stock_transaction  st on st.id=pt.transaction_id
    WHERE pt.product_id = $productId AND st.type<>"mission"
    ORDER BY st.dateTime DESC 
    LIMIT 100
  ''');

    // Convert each Map to a ProductTransaction object
    return maps.map((map) => ProductTransaction.fromMap(map)).toList();
  }

  Future<Product> getProduct(int id) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'product',
      where: 'id = ?',
      whereArgs: [id],
    );
    return Product.fromMap(maps[0]);
  }

  Future<int> insertProduct(
    Product product, {
    bool sync = true,
    replace = true,
  }) async {
    final db = await _dbHelper.db;
    var userIds = FirebaseAuth.instance.currentUser?.uid;
    if (product.ids == null) {
      var doc = FirebaseFirestore.instance.collection("products").doc();
      product = product.copyWith(ids: doc.id);
    }
    await Future.forEach(product.categories ?? <CategoryModel>[], (c) async {
      await CategoryRepository().insertCategory(c, sync: false, replace: false);
    });
    if (product.brand?.id is int) {
      await BrandRepository().insertBrand(
        product.brand!,
        sync: false,
        replace: false,
      );
    }
    List<Map<String, dynamic>> m = await db.query(
      "product",
      columns: ['id'],
      where: "ids = '${product.ids}'",
    );
    if (m.length == 1) {
      product = product.copyWith(id: m.first['id']?.toInt());
      if (!replace) return -1;
    }
    product = product.copyWith(
      createdBy: product.id != null ? product.createdBy : userIds,
      updatedBy: product.id != null ? userIds : product.updatedBy,
      createdAt:
          product.id != null
              ? product.createdAt
              : DateTime.now().millisecondsSinceEpoch,
      updatedAt:
          product.id == null
              ? product.createdAt
              : DateTime.now().millisecondsSinceEpoch,
    );
    var id = await db.insert(
      'product',
      product.toSqliteMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // delete all product categories
    await db.delete(
      'product_category',
      where: 'product_id = ?',
      whereArgs: [id < 0 ? product.id : id],
    );

    // add categories to the pivot
    if ((product.categories ?? []).isNotEmpty) {
      final List<Map<String, dynamic>> categoryMaps =
          product.categories!
              .map((category) => {'product_id': id, 'category_id': category.id})
              .toList();
      await db
        ..rawInsert(
          'INSERT INTO product_category (product_id, category_id) VALUES ${categoryMaps.map((map) => '(${map['product_id']}, ${map['category_id']})').join(', ')}',
        );
    }

    if (sync) {
      FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
          .doc("2025")
          .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
          .doc("2025")
          .collection("products")
          .doc(product.ids)
          .set(
            product.copyWith(id: id < 0 ? product.id : id).toMap(),
            SetOptions(merge: sync),
          );
    }

    return id;
  }

  Future<int> updateProduct(Product product) async {
    final db = await _dbHelper.db;
    return await db.update(
      'product',
      product
          .copyWith(
            createdAt:
                product.id != null
                    ? product.createdAt
                    : DateTime.now().millisecondsSinceEpoch,
            updatedAt:
                product.id == null
                    ? product.createdAt
                    : DateTime.now().millisecondsSinceEpoch,
          )
          .toSqliteMap(),
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
      whereArgs: [product.id ?? 0],
    );
    FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
        .doc("2025")
        .collection("products")
        .doc(product.ids)
        .set(product.toMap(), SetOptions(merge: true));
    return r;
  }

  // Future syncProduct(Product product) async {
  //   await Future.forEach(product.categories ?? <CategoryModel>[], (c) async {
  //     await CategoryRepository().insertCategory(c);
  //   });
  //   if (product.brand?.id is int) {
  //     await BrandRepository().sync(product.brand!);
  //   }
  //   await insertProduct(product, sync: false, replace: false);
  // }
}
