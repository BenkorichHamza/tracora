import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tracora/app/data/models/modals.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

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
      final path = 'E:/';
      final dbPath = join(path, 'db6.db');
      print(dbPath);

      return await databaseFactoryFfi.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(version: 1, onCreate: _onCreate),
      );
    }
    final path = await getDatabasesPath();
    final dbPath = join(
      path,
      '${Get.find<HomeController>().employee.id ?? 'db'}.db',
    );
    print(dbPath);

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
      // onUpgrade: (db, o, n) async {
      //   if (o == 2 && n == 3) {
      //     // Add the 'credit' column to the 'money_transaction' table
      //     await db.execute(
      //       "ALTER TABLE money_transaction ADD COLUMN credit REAL DEFAULT 0",
      //     );
      //   }
      // },
    );
  }

  void _onCreate(Database db, int version) async {
    for (var model in DbModels.models) {
      await db.execute(model.sql);
    }
    await db.execute('''
CREATE TABLE product_category (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id  INTEGER REFERENCES product (id),
    category_id INTEGER REFERENCES category (id)
)
''');
    await db.execute('PRAGMA foreign_keys = ON;');
  }
}
