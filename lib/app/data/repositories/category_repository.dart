import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/category_model.dart';
import 'package:uuid/uuid.dart';

class CategoryRepository {
  final DbHelper _dbHelper = DbHelper();

  Future<List<CategoryModel>> getAllCategoryModels({
    required String search,
  }) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'category',
      where:
          'deletedAt IS NULL AND (name LIKE "%$search%" OR nameAr LIKE "%$search%")',
    );

    return maps.map((map) => CategoryModel.fromMap(map)).toList();
  }

  Future<CategoryModel> getCategoryModel(String id) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'category',
      where: 'id = ?',
      whereArgs: [id],
    );
    return CategoryModel.fromMap(maps[0]);
  }

  Future<int> insertCategory(
    CategoryModel category, {
    bool sync = true,
    bool replace = true,
  }) async {
    final db = await _dbHelper.db;
    if (category.id == null) {
      category = category.copyWith(id: Uuid().v4());
    }

    var id = await db.insert(
      'category',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<int> updateCategory(CategoryModel category) async {
    final db = await _dbHelper.db;
    return await db.update(
      'category',
      category
          .copyWith(
            createdAt:
                category.id != null
                    ? category.createdAt
                    : DateTime.now().millisecondsSinceEpoch,
            updatedAt:
                category.id == null
                    ? category.createdAt
                    : DateTime.now().millisecondsSinceEpoch,
          )
          .toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(CategoryModel category) async {
    final db = await _dbHelper.db;
    var now = DateTime.now().millisecondsSinceEpoch;
    category = category.copyWith(deletedAt: now);
    var r = await db.update(
      'category',
      {"deletedAt": now},
      where: 'id = ?',
      whereArgs: [category.id ?? 0],
    );

    return r;
  }

  // sync(CategoryModel model) async {
  //   await insertCategory(model, sync: false, replace: false);
  // }
}
