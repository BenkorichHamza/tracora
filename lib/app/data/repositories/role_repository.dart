import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/role.dart';
import 'package:tracora/app/data/models/warehouse.dart';

class RoleRepository {
  insertRole(Role role) async {
    var db = await DbHelper().db;
    await db.transaction((txn) async {
      var i = await txn.insert(
        "roles",
        role.toMap()..remove("permissions"),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await txn.delete("permission_role", where: "role_id= '${role.id}'");
      await Future.forEach(role.permissions ?? [], (permission) async {
        await txn.insert("permission_role", {
          "role_id": role.id,
          "permission_id": permission.id,
        });
      });
    });
  }

  insertPermission(Permission permission) async {
    var db = await DbHelper().db;
    await db.transaction((txn) async {
      var i = await txn.insert(
        "permissions",
        permission.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<void> insertUsingTxn(Role role, Transaction txn) async {
    var i = await txn.insert(
      "roles",
      role.toMap()..remove("permissions"),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // await txn.delete("permission_role", where: "role_id= '${role.id}'");
    // await Future.forEach(role.permissions ?? [], (permission) async {
    //   await txn.insert("permission_role", {
    //     "role_id": role.id,
    //     "permission_id": permission.id,
    //   });
    // });
  }

  Future<List<Role>> getAll() async {
    var db = await DbHelper().db;
    var maps = await db.query("roles");
    if (maps.isEmpty) return [];
    return maps.map((e) => Role.fromMap(e)).toList();
  }
}
