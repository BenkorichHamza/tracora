import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/brand_model.dart';
import 'package:uuid/uuid.dart';

class BrandRepository {
  final DbHelper _dbHelper = DbHelper();

  Future<List<Brand>> getAllBrands({required String search}) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'brand',
      where:
          'deletedAt IS NULL AND (name LIKE "%$search%" OR nameAr LIKE "%$search%")',
    );

    return maps.map((map) => Brand.fromMap(map)).toList();
  }

  Future<Brand> getBrand(int id) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'brand',
      where: 'id = ?',
      whereArgs: [id],
    );
    return Brand.fromMap(maps[0]);
  }

  Future<int> insertBrand(
    Brand brand, {
    bool sync = true,
    bool replace = true,
  }) async {
    var userIds = FirebaseAuth.instance.currentUser?.uid;
    if (brand.id == null) {
      var uuid = Uuid().v4();

      brand = brand.copyWith(id: uuid);
    }
    final db = await _dbHelper.db;
    brand = brand.copyWith(
      createdBy: brand.id != null ? brand.createdBy : userIds,
      updatedBy: brand.id != null ? userIds : brand.updatedBy,
      createdAt:
          brand.id != null
              ? brand.createdAt
              : DateTime.now().millisecondsSinceEpoch,
      updatedAt:
          brand.id == null
              ? brand.createdAt
              : DateTime.now().millisecondsSinceEpoch,
    );

    var id = await db.insert(
      'brand',
      brand.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<int> updateBrand(Brand brand) async {
    final db = await _dbHelper.db;
    return await db.update(
      'brand',
      brand
          .copyWith(
            createdAt:
                brand.id != null
                    ? brand.createdAt
                    : DateTime.now().millisecondsSinceEpoch,
            updatedAt:
                brand.id == null
                    ? brand.createdAt
                    : DateTime.now().millisecondsSinceEpoch,
          )
          .toMap(),
      where: 'id = ?',
      whereArgs: [brand.id],
    );
  }

  Future<int> deleteBrand(Brand brand) async {
    final db = await _dbHelper.db;
    var now = DateTime.now().millisecondsSinceEpoch;
    brand = brand.copyWith(deletedAt: now);
    var r = await db.update(
      'brand',
      {"deletedAt": now},
      where: 'id = ?',
      whereArgs: [brand.id ?? 0],
    );

    return r;
  }

  // sync(Brand model) async {
  //   await insertBrand(model, sync: false, replace: false);
  // }
}
