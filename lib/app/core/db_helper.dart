import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tracora/app/data/models/modals.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();

  factory DbHelper() => _instance;

  static Database? _database;

  set db(v) => _database = v;

  Future<Database> get db async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDb();
    return _database!;
  }

  DbHelper.internal();

  initDb() async {
    if (GetPlatform.isWindows) {
      // final path = 'E:/';
      // final dbPath = join(path, 'db6.db');
      var pref = await SharedPreferences.getInstance();
      var collection = await pref.getString("collection");
      // collection ??=
      //     FirebaseFirestore.instance.collection("collections").doc().id;

      // final exePath = Platform.resolvedExecutable; // Path to .exe
      // final exeDir = dirname(exePath); // Directory of the .exe

      // final dbPath = join(exeDir, 'db1.db');
      final docsDir = await getApplicationSupportDirectory();
      final dbPath = join(docsDir.path, 'app_data35.db');
      print(dbPath);
      await pref.setString("collection", collection ?? 'default');

      return await databaseFactoryFfi.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _onCreate,
          // onUpgrade: (db, oldVersion, newVersion) async {
          //   if (oldVersion < 3 && newVersion >= 3)
          //     await db.execute(
          //       "ALTER TABLE user ADD COLUMN warehouse_id STRING REFERENCES warehouse (id)",
          //     );
          // },
        ),
      );
    }
    final path = await getDatabasesPath();
    final dbPath = join(
      path,
      '${Get.find<HomeController>().employee.id ?? 'db'}+"3.db"',
    );
    print(dbPath);

    return await openDatabase(
      dbPath,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: (db, o, n) async {
        if (o < 2 && n >= 2) {
          await db.execute(
            "ALTER TABLE user ADD COLUMN warehouse_id STRING REFERENCES warehouse (id)",
          );
        }
      },
    );
  }

  void _onCreate(Database db, int version) async {
    for (var model in DbModels.models) {
      await db.execute(model.sql);
    }
    await db.execute('''
CREATE TABLE product_category (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    productId  INTEGER REFERENCES product (id),
    categoryId INTEGER REFERENCES category (id)
)
''');
    await db.execute('PRAGMA foreign_keys = ON;');
  }
}
