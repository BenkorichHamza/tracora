import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/user_model.dart';

class EmployeeRepository {
  final DbHelper _dbHelper = DbHelper();

  Future<List<UserModel>> getAllEmployees({required String search}) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where:
          'deletedAt IS NULL AND type = "employee" AND (firstName LIKE "%$search%" OR lastName LIKE "%$search%" OR email LIKE "%$search%" OR phone LIKE "%$search%")',
    );

    return maps.map((map) => UserModel.fromMap(map)).toList();
  }

  Future<UserModel> getEmployee(String id) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'id = ?',
      whereArgs: [id],
    );
    return UserModel.fromMap(maps[0]);
  }

  Future<int> insertEmployee(UserModel user) async {
    final db = await _dbHelper.db;
    return await db.insert(
      'user',
      user
          .copyWith(
            type: "employee",
            createdAt:
                user.id != null
                    ? user.createdAt
                    : DateTime.now().millisecondsSinceEpoch,
            updatedAt:
                user.id == null
                    ? user.createdAt
                    : DateTime.now().millisecondsSinceEpoch,
          )
          .toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateEmployee(UserModel user) async {
    final db = await _dbHelper.db;
    return await db.update(
      'user',
      user
          .copyWith(
            type: "employee",
            createdAt:
                user.id != null
                    ? user.createdAt
                    : DateTime.now().millisecondsSinceEpoch,
            updatedAt:
                user.id == null
                    ? user.createdAt
                    : DateTime.now().millisecondsSinceEpoch,
          )
          .toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteEmployee(String id) async {
    final db = await _dbHelper.db;
    return await db.update(
      'user',
      {"deletedAt": DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
