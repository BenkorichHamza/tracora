import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/image_model.dart';

class ImageRepository {
  final DbHelper _dbHelper = DbHelper();
  Future<int> insertBrand(
    ImageModel image, {
    bool sync = true,
    bool replace = true,
  }) async {
    final db = await _dbHelper.db;

    var id = await db.insert(
      'image',
      image.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }
}
