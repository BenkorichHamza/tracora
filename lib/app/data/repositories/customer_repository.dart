import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/user_model.dart';

class CustomerRepository {
  final DbHelper _dbHelper = DbHelper();

  Future<List<UserModel>> getAllCustomers({required String search}) async {
    final db = await _dbHelper.db;
    // final List<Map<String, dynamic>> maps = await db.query(
    //   'user',
    //   where:
    //       'deletedAt IS NULL AND type = "customer" AND (firstName LIKE "%$search%" OR lastName LIKE "%$search%" OR email LIKE "%$search%" OR phone LIKE "%$search%")',
    // );
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
SELECT 
    u.*, 
    COALESCE(mt.payment, 0) + COALESCE(st.payment, 0) AS payment,
    COALESCE(st.due, 0) AS due
FROM user u
LEFT JOIN (
    SELECT user_id, SUM(amount) AS payment 
    FROM money_transaction 
    WHERE type = 'sale' 
    GROUP BY user_id
) mt ON u.id = mt.user_id
LEFT JOIN (
    SELECT user_id, SUM(payment) AS payment, SUM(toPay) AS due 
    FROM stock_transaction 
    WHERE type = 'sale' 
    GROUP BY user_id
) st ON u.id = st.user_id
WHERE u.deletedAt IS NULL 
  AND u.type = "customer"
  AND (u.firstName LIKE "%$search%" OR u.lastName LIKE "%$search%" OR u.email LIKE "%$search%" OR u.phone LIKE "%$search%")
''');

    return maps.map((map) => UserModel.fromMap(map)).toList();
  }

  Future<UserModel?> getCustomer(int id) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
SELECT 
    u.*, 
    COALESCE(mt.payment, 0) + COALESCE(st.payment, 0) AS payment,
    COALESCE(st.due, 0) AS due
FROM user u
LEFT JOIN (
    SELECT user_id, SUM(amount) AS payment 
    FROM money_transaction 
    WHERE type = 'sale' 
    GROUP BY user_id
) mt ON u.id = mt.user_id
LEFT JOIN (
    SELECT user_id, SUM(payment) AS payment, SUM(toPay) AS due 
    FROM stock_transaction 
    WHERE type = 'sale' 
    GROUP BY user_id
) st ON u.id = st.user_id
WHERE u.deletedAt IS NULL 
  AND u.type = "customer"
  AND u.id=$id
''');
    if (maps.length != 1) return null;
    return UserModel.fromMap(maps[0]);
  }

  Future<int> insertCustomer(
    UserModel user, {
    bool sync = true,
    bool replace = true,
  }) async {
    final db = await _dbHelper.db;
    user = user.copyWith(type: "customer");
    var userIds = FirebaseAuth.instance.currentUser?.uid;
    if (user.ids == null) {
      var doc =
          FirebaseFirestore.instance
              .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
              .doc("2025")
              .collection("users")
              .doc();
      user = user.copyWith(ids: doc.id);
    }
    List<Map<String, dynamic>> m = await db.query(
      "user",
      columns: ['id'],
      where: "ids = '${user.ids}'",
    );
    if (m.length == 1) {
      user = user.copyWith(id: m.first['id']?.toInt());
      if (!replace) return -1;
    }
    user = user.copyWith(
      type: "customer",
      createdBy: user.id != null ? user.createdBy : userIds,
      updatedBy: user.id != null ? userIds : user.updatedBy,
      createdAt:
          user.id != null
              ? user.createdAt
              : DateTime.now().millisecondsSinceEpoch,
      updatedAt:
          user.id == null
              ? user.createdAt
              : DateTime.now().millisecondsSinceEpoch,
    );
    int id = await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (sync) {
      FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
          .doc("2025")
          .collection("users")
          .doc(user.ids)
          .set(
            user.copyWith(id: id < 0 ? user.id : id).toMap(),
            SetOptions(merge: sync),
          );
    }

    return id;
  }

  Future<int> updateCustomer(UserModel user) async {
    final db = await _dbHelper.db;
    return await db.update(
      'user',
      user
          .copyWith(
            type: "customer",
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

  Future<int> deleteCustomer(UserModel user) async {
    final db = await _dbHelper.db;
    var now = DateTime.now().millisecondsSinceEpoch;
    user = user.copyWith(deletedAt: now);
    var r = await db.update(
      'user',
      {"deletedAt": now},
      where: 'id = ?',
      whereArgs: [user.id ?? 0],
    );
    FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
        .doc("2025")
        .collection("users")
        .doc(user.ids)
        .set(user.toMap(), SetOptions(merge: true));
    return r;
  }

  // Future sync(UserModel? user) async {
  //   await insertCustomer(user ?? UserModel(), sync: false, replace: false);
  // }
}
