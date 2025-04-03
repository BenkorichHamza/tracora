// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:get/get.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:tracora/app/core/db_helper.dart';
// import 'package:tracora/app/data/models/mission_model.dart';
// import 'package:tracora/app/data/models/product_model.dart';
// import 'package:tracora/app/data/models/product_transaction_model.dart';
// import 'package:tracora/app/data/models/stock_transaction_model.dart';
// import 'package:tracora/app/data/models/user_model.dart';
// import 'package:tracora/app/data/repositories/user_repository.dart';
// import 'package:tracora/app/data/repositories/product_repository.dart';
// import 'package:tracora/app/data/repositories/supplier_repository.dart';
// import 'package:tracora/app/modules/MissionForm/views/product_mission_view.dart';

// class MissionRepository {
//   final DbHelper _dbHelper = DbHelper();

//   Future<List<StockTransaction>> getAll({required String search}) async {
//     final db = await _dbHelper.db;

//     final List<Map<String, dynamic>> maps = await db.rawQuery('''
//       SELECT m.*, u.firstName from
//       mission m
//       INNER JOIN user u
//       ON m.user_id=u.id
//       WHERE m.deletedAt IS NULL AND (u.firstName LIKE "%$search%" OR u.lastName LIKE "%$search%") ORDER BY m.dateTime DESC
//       LIMIT 50
// ''');
//     var userIds = maps.map<int>((e) => e['user_id']).toList();
//     final users = await UserRepository().getAllUsersFromArray(ids: userIds);

//     return maps
//         .map(
//           (map) => StockTransaction.fromMap(map).copyWith(
//             user: users.firstWhereOrNull((e) => e.id == map['user_id']),
//           ),
//         )
//         .toList();
//   }

//   Future<List<MissionProduct>> getMissionProducts(int missionId) async {
//     final db = await _dbHelper.db;
//     var maps = await db.query(
//       "mission_product",
//       where: 'mission_id=$missionId',
//     );

//     var productIds = maps.map((e) => e['product_id']).toList();
//     final List<Map<String, dynamic>> productMaps = await db.query(
//       'product',
//       where: productIds.isEmpty ? null : 'id IN (${productIds.join(', ')})',
//     );
//     var products = productMaps.map(((e) => Product.fromMap(e))).toList();

//     return maps
//         .map(
//           (e) => MissionProduct.fromMap(e).copyWith(
//             product: products.firstWhereOrNull((p) => p.id == e['product_id']),
//           ),
//         )
//         .toList();
//   }

//   Future<Mission> getMission(int id) async {
//     final db = await _dbHelper.db;
//     final List<Map<String, dynamic>> maps = await db.query(
//       'mission',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     return Mission.fromMap(maps[0]);
//   }

//   Future<int> insert(Mission mission, {bool sync = true}) async {
//     if (mission.ids == null) {
//       var doc =
//           FirebaseFirestore.instance
//               .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
//               .doc("2025")
//               .collection("missions")
//               .doc();
//       mission = mission.copyWith(ids: doc.id);
//     }
//     final db = await _dbHelper.db;
//     var userIds = FirebaseAuth.instance.currentUser?.uid;
//     var now = DateTime.now().millisecondsSinceEpoch;
//     var products = mission.missionProducts?.map((e) => e.product).toList();
//     var user = mission.user;
//     await UserRepository().insertUser(
//       user ?? UserModel(),
//       replace: false,
//       sync: false,
//     );
//     await Future.forEach(products ?? <Product>[], (c) async {
//       await ProductRepository().insertProduct(
//         c ?? Product(),
//         sync: false,
//         replace: false,
//       );
//     });
//     mission = mission.copyWith(
//       createdBy: mission.id != null ? mission.createdBy : userIds,
//       updatedBy: mission.id != null ? userIds : mission.updatedBy,
//       dateTime: (mission.dateTime ?? 0) <= 0 ? now : mission.dateTime,
//       createdAt: mission.id != null ? mission.createdAt : now,
//       updatedAt: mission.id == null ? mission.createdAt : now,
//     );
//     var map = mission.toSqfliteMap();
//     var id = await db.insert(
//       'mission',
//       map,
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );

//     await db.delete(
//       'mission_product',
//       where: 'mission_id = ?',
//       whereArgs: [id < 0 ? mission.id : id],
//     );

//     if (mission.missionProducts != null) {
//       final List<Map<String, dynamic>> missionProductMaps =
//           mission.missionProducts!
//               .map(
//                 (tr) =>
//                     tr
//                         .copyWith(
//                           mission: mission.copyWith(
//                             id: id < 0 ? mission.id : id,
//                           ),
//                         )
//                         .toSqfliteMap(),
//               )
//               .toList();
//       await db.rawInsert('''
// INSERT INTO mission_product 
// (mission_id, product_id, qte  ) VALUES 
// ${missionProductMaps.map((map) => '(${map['mission_id']}, ${map['product_id']},   ${map['qte']})').join(', ')}
//           ''');
//     }

//     if (sync) {
//       FirebaseFirestore.instance
//           .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
//           .doc("2025")
//           .collection("missions")
//           .doc(mission.ids)
//           .set(mission.toMap(), SetOptions(merge: sync));
//     }

//     return id;
//   }

//   Future<int> deleteMission(Mission mission) async {
//     final db = await _dbHelper.db;
//     var now = DateTime.now().millisecondsSinceEpoch;
//     mission = mission.copyWith(deletedAt: now);
//     var r = await db.update(
//       'mission',
//       {"deletedAt": now},
//       where: 'id = ?',
//       whereArgs: [mission.id ?? 0],
//     );
//     FirebaseFirestore.instance
//         .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
//         .doc("2025")
//         .collection("missions")
//         .doc(mission.ids)
//         .set(mission.toMap(), SetOptions(merge: true));
//     return r;
//   }

//   Future<List<StockTransaction>> getAllMssionsFor({required int id}) async {
//     final db = await _dbHelper.db;
//     final List<Map<String, dynamic>> maps = await db.rawQuery('''
//       SELECT m.*, u.firstName from
//       mission m
//       INNER JOIN user u
//       ON m.user_id=u.id
//       WHERE m.deletedAt IS NULL AND u.id=$id ORDER BY st.dateTime DESC
//       LIMIT 50
// ''');
//     var userIds = maps.map((e) => e['user_id']);
//     final List<Map<String, dynamic>> userMaps = await db.query(
//       'user',
//       where: userIds.isEmpty ? null : 'id IN (${userIds.join(', ')})',
//     );
//     var users = userMaps.map(((e) => UserModel.fromMap(e))).toList();

//     return maps
//         .map(
//           (map) => StockTransaction.fromMap(map).copyWith(
//             user: users.firstWhereOrNull((e) => e.id == map['user_id']),
//           ),
//         )
//         .toList();
//   }

//   Future<List<ProductTransaction>> getProductTransactionsFor(int userId) async {
//     final db = await _dbHelper.db;

//     // Single SQL query with JOINs, filtered by user_id only
//     final List<Map<String, dynamic>> results = await db.rawQuery(
//       '''
//     SELECT pt.*, p.*, st.*,sum(pt.qte) as qte
//     FROM product_transaction pt
//     INNER JOIN product p ON pt.product_id = p.id
//     INNER JOIN stock_transaction st ON pt.transaction_id = st.id
//     WHERE st.user_id = ?
//     group by p.id
//   ''',
//       [userId],
//     );

//     return results.map((e) {
//       return ProductTransaction.fromMap(e).copyWith(
//         product: Product.fromMap(e),
//         transactionId: StockTransaction.fromMap(
//           e,
//         ), // Assuming you have a StockTransaction model
//       );
//     }).toList();
//   }

//   Future<StockTransaction?> getStockTransactionById({required int id}) async {
//     final db = await _dbHelper.db;
//     final List<Map<String, dynamic>> maps = await db.rawQuery('''
//       SELECT st.*, u.firstName from
//       stock_transaction st
//       INNER JOIN user u
//       ON st.user_id=u.id
//       WHERE st.deletedAt IS NULL AND st.id = $id
//       LIMIT 50
// ''');
//     var employeeIds = maps.map((e) => e['employee_id']);
//     final List<Map<String, dynamic>> employeeMaps = await db.query(
//       'user',
//       where:
//           employeeIds.isEmpty
//               ? null
//               : 'type = "employee" AND id IN (${employeeIds.join(', ')})',
//     );
//     var employees = employeeMaps.map(((e) => UserModel.fromMap(e))).toList();
//     var userIds = maps.map((e) => e['user_id']);
//     final List<Map<String, dynamic>> supplierMaps = await db.query(
//       'user',
//       where: userIds.isEmpty ? null : 'id IN (${userIds.join(', ')})',
//     );
//     var suppliers = supplierMaps.map(((e) => UserModel.fromMap(e))).toList();
//     if (maps.length != 1) return null;
//     return StockTransaction.fromMap(maps[0]).copyWith(
//       employee: (employees).firstWhereOrNull(
//         (e) => e.id == maps[0]['employee_id'],
//       ),
//       user: suppliers.firstWhereOrNull((e) => e.id == maps[0]['user_id']),
//     );
//   }
// }
