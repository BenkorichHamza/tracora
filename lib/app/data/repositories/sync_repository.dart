import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/utils.dart';
import 'package:get/get.dart' as getx;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/api.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/role.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/sync_operation.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/models/warehouse.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/data/repositories/product_repository.dart';
import 'package:tracora/app/data/repositories/role_repository.dart';
import 'package:tracora/app/data/repositories/stock_transaction_repository.dart';
import 'package:tracora/app/data/repositories/user_repository.dart';
import 'package:tracora/app/data/repositories/warehouse_repository.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Synchronisation/controllers/synchronisation_controller.dart';

class SyncRepository {
  Future<bool> addOperation(
    String table,
    String rowId,
    String operation,
    Map<String, dynamic> data,
  ) async {
    final db = await DbHelper().db;

    try {
      var existing = await db.query(
        "sync_operations",
        where: "rowId = ?  AND synced <> 1",
        whereArgs: [rowId],
        orderBy: 'createdAt ASC',
        limit: 1,
      );

      if (existing.isNotEmpty) {
        await db.delete(
          'sync_operations',
          where: "rowId = ? AND id <> ?",
          whereArgs: [rowId, existing.first["id"]],
        );
        var i = await db.update(
          'sync_operations',
          {
            'tableName': table,
            'data': jsonEncode(data),
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'synced': 0,
            'lastError': null,
          },
          where: "rowId = ?",
          whereArgs: [rowId],
        );
        getx.Get.find<SynchronisationController>().getOperations();
        return i != 0;
      }

      final id = await db.insert('sync_operations', {
        'tableName': table,
        'rowId': rowId,
        'operation': operation,
        'data': jsonEncode(data),
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'synced': 0,
        'lastError': null,
      });
      return id != 0;
    } catch (e) {
      debugPrint('Error adding sync operation: $e');
      return false;
    }
  }

  Future<bool> addOperationUsingTxn(
    Transaction txn,
    String table,
    String rowId,
    String operation,
    Map<String, dynamic> data,
  ) async {
    try {
      var existing = await txn.query(
        "sync_operations",
        where: "rowId = ? AND lastError IS NOT NULL",
        whereArgs: [rowId],
        orderBy: 'createdAt ASC',
        limit: 1,
      );
      if (existing.isNotEmpty) {
        txn.delete(
          'sync_operations',
          where: "rowId = ? AND createdAt > ?",
          whereArgs: [rowId, existing.first["createdAt"]],
        );
        var i = await txn.update(
          'sync_operations',
          {
            'tableName': table,
            'data': jsonEncode(data),
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'synced': 0,
          },
          where: "rowId = ?",
          whereArgs: [rowId],
        );
        getx.Get.find<SynchronisationController>().getOperations();
        return i != 0;
      }

      final id = await txn.insert('sync_operations', {
        'tableName': table,
        'rowId': rowId,
        'operation': operation,
        'data': jsonEncode(data),
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'synced': 0,
        'lastError': null,
      });
      return id != 0;
    } catch (e) {
      debugPrint('Error adding sync operation: $e');
      return false;
    }
  }

  Future<void> push() async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final db = await DbHelper().db;

    ApiService.setToken('$token');

    List<SyncOperation> operations = await getOperations();
    print("operations : ${operations.length}");
    final dio =
        ApiService.dio..options.headers['Authorization'] = 'Bearer $token';

    for (final op in operations) {
      try {
        await _syncOperation(dio: dio, db: db, operation: op);

        await _markAsSynced(db, op.id!);
      } on DioException catch (e) {
        await _handleDioError(operation: op, error: e);
        _markError(db, op.id!, e.toString());
        return;
      } on Exception catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> pullContacts(String lastSyncDateString) async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final db = await DbHelper().db;
    ApiService.setToken('$token');

    final dio =
        ApiService.dio..options.headers['Authorization'] = 'Bearer $token';

    var r = await dio.get(
      '/synccontacts',
      queryParameters: {"last_sync_date": lastSyncDateString},
    );
    if (r.statusCode == 200) {
      if (r.data is Map && r.data.containsKey('data')) {
        var usersMap = r.data['data'] as List;
        var users = usersMap.map((e) => UserModel.fromMap(e)).toList();
        print(users.length);
        users.forEach((user) {
          print(
            'user ${user.firstName} ${user.roles} inserted/updated successfully.',
          );
        });
        db.transaction((Transaction txn) async {
          for (var user in users) {
            await UserRepository().insertUserUsingTxn(user, txn);
            print(
              'user ${user.firstName} ${user.type} inserted/updated successfully.',
            );
          }
        });
      }
      // var productsMap = r.data['data'] as List;
      // var products = productsMap.map((e) => Product.fromMap(e)).toList();
      // print(products.length);
      // products.forEach((e) {
      //   print('${e.id}   ${e.name}   ${e.rest}');
      // });
    }
  }

  Future<void> pullStransactions(String lastSyncDateString) async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final db = await DbHelper().db;

    ApiService.setToken('$token');

    final dio =
        ApiService.dio..options.headers['Authorization'] = 'Bearer $token';

    var r = await dio.get(
      '/syncstransactions',
      queryParameters: {
        "last_sync_date":
            int.tryParse(lastSyncDateString) ??
            DateTime(2026).millisecondsSinceEpoch,
      },
    );
    if (r.statusCode == 200) {
      if (r.data is Map && r.data.containsKey('data')) {
        var maps = r.data['data'] as List;
        var stransactions =
            maps.map((e) => StockTransaction.fromApiMap(e)).toList();
        print(stransactions.length);
        db.transaction((Transaction txn) async {
          for (var v in stransactions) {
            await StockTransactionRepository().insertUsingTxn(v, txn);
            print(
              'stransaction ${v.from_warehouse?.id} ${v.type} ${v.to_warehouse?.id} ${v.total.formatPrice()} inserted/updated successfully.',
            );
          }
        });
      }
      // var productsMap = r.data['data'] as List;
      // var products = productsMap.map((e) => Product.fromMap(e)).toList();
      // print(products.length);
      // products.forEach((e) {
      //   print('${e.id}   ${e.name}   ${e.rest}');
      // });
    }
  }

  Future<void> pullWarehouses(String lastSyncDateString) async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var db = await DbHelper().db;

    ApiService.setToken('$token');

    final dio =
        ApiService.dio..options.headers['Authorization'] = 'Bearer $token';

    var r = await dio.get(
      '/syncwarehouses',
      queryParameters: {"last_sync_date": 0},
    );
    if (r.statusCode == 200) {
      if (r.data is Map && r.data.containsKey('data')) {
        var warehousesMap = r.data['data'] as List;
        var warehouses =
            warehousesMap.map((e) => Warehouse.fromMap(e)).toList();
        print(warehouses.length);
        db.transaction((Transaction txn) async {
          for (var warehouse in warehouses) {
            await WarehouseRepository().insertWarehouseUsingTxn(warehouse, txn);
            print('user ${warehouse.name} inserted/updated successfully.');
          }
        });
      }
      // var productsMap = r.data['data'] as List;
      // var products = productsMap.map((e) => Product.fromMap(e)).toList();
      // print(products.length);
      // products.forEach((e) {
      //   print('${e.id}   ${e.name}   ${e.rest}');
      // });
    }
  }

  Future<void> pullRoles(String lastSyncDateString) async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var db = await DbHelper().db;

    ApiService.setToken('$token');

    final dio =
        ApiService.dio..options.headers['Authorization'] = 'Bearer $token';

    var r = await dio.get('/roles');
    if (r.statusCode == 200) {
      if (r.data is Map && r.data.containsKey('data')) {
        var rolesMap = r.data['data'] as List;
        var roles = rolesMap.map((e) => Role.fromMap(e)).toList();
        print(roles.length);
        db.transaction((Transaction txn) async {
          for (var role in roles) {
            await RoleRepository().insertUsingTxn(role, txn);
            print('role ${role.name} inserted/updated successfully.');
          }
        });
      }
      // var productsMap = r.data['data'] as List;
      // var products = productsMap.map((e) => Product.fromMap(e)).toList();
      // print(products.length);
      // products.forEach((e) {
      //   print('${e.id}   ${e.name}   ${e.rest}');
      // });
    }
  }

  Future<void> pullProducts(String lastSyncDateString) async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    ApiService.setToken('$token');
    var db = await DbHelper().db;

    final dio =
        ApiService.dio..options.headers['Authorization'] = 'Bearer $token';

    var r = await dio.get(
      '/syncproducts',
      queryParameters: {"last_sync_date": lastSyncDateString},
    );
    if (r.statusCode == 200) {
      if (r.data is Map && r.data.containsKey('data')) {
        var productsMap = r.data['data'] as List;
        var products = productsMap.map((e) => Product.fromMap(e)).toList();
        print(products.length);
        db.transaction((Transaction txn) async {
          for (var product in products) {
            await ProductRepository().insertProductUsingTxn(product, txn);
            print('product ${product.name} inserted/updated successfully.');
          }
        });
      }
      // var productsMap = r.data['data'] as List;
      // var products = productsMap.map((e) => Product.fromMap(e)).toList();
      // print(products.length);
      // products.forEach((e) {
      //   print('${e.id}   ${e.name}   ${e.rest}');
      // });
    }
  }

  Future<void> stockBalance(int days) async {
    try {
      var pref = await SharedPreferences.getInstance();
      var token = pref.getString('token');
      ApiService.setToken('$token');
      var db = await DbHelper().db;

      final dio =
          ApiService.dio..options.headers['Authorization'] = 'Bearer $token';

      var r = await dio.get('/stockbalance', queryParameters: {"days": days});
      if (r.statusCode == 200) {
        if (r.data is List) {
          var data = List<Map<String, dynamic>>.from(r.data);
          var warehouses =
              (data as List).map((e) => e["warehouse_id"]).toSet().toList();
          var transactions = warehouses.map(
            (e) => StockTransaction(
              to_warehouse: Warehouse(id: e),
              type: "balance",
              productTransactions:
                  data
                      .where((element) => element["warehouse_id"] == e)
                      .map(
                        (e) => ProductTransaction(
                          product: Product(id: e["product_id"]),
                          qte: e["quantity"],
                          direction: 1,
                        ),
                      )
                      .toList(),
            ),
          );
          transactions.forEach((e) {
            print(
              "warehouse : ${e.to_warehouse?.id}  transactions : ${e.productTransactions?.length}",
            );
          });
          // db.transaction((Transaction txn) async {
          //   for (var transaction in transactions) {
          //     await StockTransactionRepository().insertUsingTxn(transaction, txn);
          //     print('transaction inserted/updated successfully.');
          //   }
          // });
        }
        // var productsMap = r.data['data'] as List;
        // var products = productsMap.map((e) => Product.fromMap(e)).toList();
        // print(products.length);
        // products.forEach((e) {
        //   print('${e.id}   ${e.name}   ${e.rest}');
        // });
      } else {
        print("error");
      }
    } catch (e) {
      print("Error occurred while fetching stock balance: ${e}");
    }
  }

  Future<void> pullMoneyTransactions(String lastSyncDateString) async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final db = await DbHelper().db;
    // 1. Query by the primary key directly
    ApiService.setToken('$token');

    final dio =
        ApiService.dio..options.headers['Authorization'] = 'Bearer $token';

    var r = await dio.get(
      '/syncmoneytransactions',
      queryParameters: {"last_sync_date": lastSyncDateString},
    );
    if (r.statusCode == 200) {
      if (r.data is Map && r.data.containsKey('data')) {
        var moneyTransactionMaps = r.data['data'] as List;
        var moneyTransactions =
            moneyTransactionMaps
                .map((e) => MoneyTransaction.fromMap(e))
                .toList();
        print(moneyTransactions.length);
        db.transaction((Transaction txn) async {
          for (var moneyTransaction in moneyTransactions) {
            await MoneyTransactionRepository().insertMoneyTransactionUsingTxn(
              moneyTransaction,
              txn,
            );
            print(
              'moneyTransaction ${moneyTransaction.user?.firstName} inserted/updated successfully.',
            );
          }
        });
      }
      // var productsMap = r.data['data'] as List;
      // var products = productsMap.map((e) => Product.fromMap(e)).toList();
      // print(products.length);
      // products.forEach((e) {
      //   print('${e.id}   ${e.name}   ${e.rest}');
      // });
    }
  }

  Future<List<SyncOperation>> getOperations() async {
    final db = await DbHelper().db;
    final maps = await db.query(
      'sync_operations',
      where: 'synced = ?',
      whereArgs: [0],
      orderBy: 'createdAt ASC',
    );

    final operations = maps.map((e) => SyncOperation.fromMap(e)).toList();
    return operations;
  }

  /*
  |--------------------------------------------------------------------------
  | Sync Single Operation
  |--------------------------------------------------------------------------
  */

  Future<void> _syncOperation({
    required Dio dio,
    required dynamic db,
    required SyncOperation operation,
  }) async {
    final endpoint = _endpoint(operation.tableName ?? '');
    Response r;
    switch ((operation.operation ?? '').toUpperCase()) {
      case 'INSERT':
        r = await dio.post(endpoint, data: operation.data);
        break;

      case 'UPDATE':
        r = await dio.put('$endpoint/${operation.rowId}', data: operation.data);
        break;

      case 'DELETE':
        r = await dio.put('$endpoint/${operation.rowId}', data: operation.data);
        break;

      default:
        throw Exception('Unsupported operation: ${operation.operation}');
    }

    print(r.statusCode);
    print(r.data);
  }

  /*
  |--------------------------------------------------------------------------
  | Endpoint Resolver
  |--------------------------------------------------------------------------
  */

  String _endpoint(String tableName) {
    switch (tableName) {
      case 'contacts':
        return '/contacts';

      case 'brands':
        return '/brands';

      case 'product':
        return '/products';

      case 'warehouse':
        return '/warehouses';

      case 'stock_transaction':
        return '/stransactions';

      case 'money_transaction':
        return '/mtransactions';

      default:
        throw Exception('No endpoint configured for table: $tableName');
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Mark Synced
  |--------------------------------------------------------------------------
  */

  Future<void> _markAsSynced(dynamic db, int operationId) async {
    await db.update(
      'sync_operations',
      {'synced': 1, 'syncedAt': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [operationId],
    );
  }

  Future<void> _markError(dynamic db, int operationId, String error) async {
    await db.update(
      'sync_operations',
      {
        'synced': 0,
        'syncedAt': DateTime.now().millisecondsSinceEpoch,
        'lastError': error,
      },
      where: 'id = ?',
      whereArgs: [operationId],
    );
  }

  Future<void> _handleDioError({
    required SyncOperation operation,
    required DioException error,
  }) async {
    final response = error.response;

    /*
  |--------------------------------------------------------------------------
  | No response from server
  |--------------------------------------------------------------------------
  */

    if (response == null) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          print('[${operation.id}] Connection timeout');
          ErrorHandler.showError("network_error".tr);
          break;

        case DioExceptionType.receiveTimeout:
          print('[${operation.id}] Receive timeout');
          ErrorHandler.showError("network_error".tr);
          break;

        case DioExceptionType.sendTimeout:
          ErrorHandler.showError("network_error".tr);
          print('[${operation.id}] Send timeout');
          break;

        case DioExceptionType.connectionError:
          ErrorHandler.showError("network_error".tr);
          print('[${operation.id}] No internet connection');
          break;

        default:
          print('[${operation.id}] Network error: ${error.message}');
      }

      return;
    }

    /*
  |--------------------------------------------------------------------------
  | HTTP Errors
  |--------------------------------------------------------------------------
  */

    final status = response.statusCode;

    switch (status) {
      case 401:
        print('[${operation.id}] Unauthorized - token expired');
        ErrorHandler.showError("session_expired".tr);
        break;

      case 403:
        print('[${operation.id}] Forbidden');

        ErrorHandler.showError("forbidden".tr);
        break;

      case 404:
        print('[${operation.id}] Endpoint not found');
        ErrorHandler.showError("not_found".tr);
        break;

      case 422:
        print('[${operation.id}] Validation failed');
        ErrorHandler.showError("validation_failed".tr);

        print(response.data);

        /*
      Example:
      {
        "message":"The name field is required",
        "errors":{...}
      }
      */
        break;

      case 500:
        print('[${operation.id}] Internal server error');

        print(response.data);

        break;

      default:
        print('[${operation.id}] HTTP $status');

        print(response.data);
    }
  }

  log() async {
    var db = await DbHelper().db;
    var maps = await db.query('sync_operations');
    maps.forEach((element) {
      print(
        "${element['tableName']}: ${element['rowId']} - ${element['operation']}",
      );
    });
  }

  Future<void> testPush() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://127.0.0.1:8000/api/v1',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer 2|TmX6syvEMdatAwLZYolb49ieH4pdUCzmhdyMuTlOfa22db68',
        },
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
      ),
    );

    /*
  |--------------------------------------------------------------------------
  | Request Body
  |--------------------------------------------------------------------------
  */

    final body = {
      "operations": [
        {
          "id": 1,
          "tableName": "brands",
          "operation": "INSERT",
          "rowId": "019e5a12-7c3b-70a1-9c2d-1a9f2c8d4e12",
          "data": {
            "id": "019e5a12-7c3b-70a1-9c2d-1a9f2c8d4e12",
            "name": "Test Brand",
            "name_ar": "علامة تجارية",
          },
        },

        /*
      |--------------------------------------------------------------------------
      | Product Insert
      |--------------------------------------------------------------------------
      */
        {
          "id": 2,
          "tableName": "products",
          "operation": "INSERT",
          "rowId": "p1f0c2a0-2000-4000-9000-bbbb2222bbbc",
          "data": {
            "id": "p1f0c2a0-2000-4000-9000-bbbb2222bbbc",
            "name": "Product A",
            "name_ar": "منتج أ",
            "barcode": "123456",
            "buy_price": 100,
            "sell_price": 150,
            "stock": 20,
            "brand_id": "019e5a12-7c3b-70a1-9c2d-1a9f2c8d4e12",
          },
        },

        /*
      |--------------------------------------------------------------------------
      | Transaction Insert
      |--------------------------------------------------------------------------
      */
        {
          "id": 3,
          "tableName": "stransactions",
          "operation": "INSERT",
          "rowId": "t1f0c2a0-3000-4000-9000-cccc3333cccc",
          "data": {
            "id": "t1f0c2a0-3000-4000-9000-cccc3333cccc",
            "type": "SALE",
            "total": 900,
            "payment": 900,
            "topay": 900,
            "credit": 0,
            "products": [
              {
                "product_id": "019e5a12-7c3b-70a1-9c2d-1a9f2c8d4e11",
                "qte": 2,
                "price": 150,
                "tax": 19,
                "direction": -1,
              },
              {
                "product_id": "p1f0c2a0-2000-4000-9000-bbbb2222bbbb",
                "qte": 1,
                "price": 200,
                "tax": 19,
                "direction": -1,
              },
              {
                "product_id": "019e5a12-7c3b-70a1-9c2d-1a9f2c8d4e12",
                "qte": 3,
                "price": 100,
                "tax": 19,
                "direction": -1,
              },
            ],
          },
        },
      ],
    };

    try {
      /*
    |--------------------------------------------------------------------------
    | Request
    |--------------------------------------------------------------------------
    */

      final response = await dio.post('/push', data: body);

      /*
    |--------------------------------------------------------------------------
    | Success
    |--------------------------------------------------------------------------
    */

      print('STATUS CODE: ${response.statusCode}');
      print(jsonEncode(response.data));

      /*
    |--------------------------------------------------------------------------
    | Synced Operations
    |--------------------------------------------------------------------------
    */

      final synced = response.data['synced'] ?? [];

      for (final id in synced) {
        print('SYNCED OPERATION: $id');
      }

      /*
    |--------------------------------------------------------------------------
    | Failed Operations
    |--------------------------------------------------------------------------
    */

      final failed = response.data['failed'] ?? [];
      final messages = response.data['messages'] ?? [];

      for (final item in failed) {
        print(
          'FAILED OPERATION: ${item} ERROR : ${messages[failed.indexOf(item)]}',
        );
      }
    }
    /*
  |--------------------------------------------------------------------------
  | Dio Errors
  |--------------------------------------------------------------------------
  */
    on DioException catch (e) {
      print('DIO ERROR');

      /*
    |--------------------------------------------------------------------------
    | Server Responded
    |--------------------------------------------------------------------------
    */

      if (e.response != null) {
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${jsonEncode(e.response?.data)}');
      }
      /*
    |--------------------------------------------------------------------------
    | Timeout
    |--------------------------------------------------------------------------
    */
      else if (e.type == DioExceptionType.connectionTimeout) {
        print('Connection timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        print('Receive timeout');
      } else if (e.type == DioExceptionType.sendTimeout) {
        print('Send timeout');
      }
      /*
    |--------------------------------------------------------------------------
    | No Internet
    |--------------------------------------------------------------------------
    */
      else if (e.type == DioExceptionType.connectionError) {
        print('No internet connection');
      }
      /*
    |--------------------------------------------------------------------------
    | Unknown
    |--------------------------------------------------------------------------
    */
      else {
        print('UNKNOWN ERROR');
        print(e.message);
      }
    }
    /*
  |--------------------------------------------------------------------------
  | Other Errors
  |--------------------------------------------------------------------------
  */
    catch (e, stackTrace) {
      print('GENERAL ERROR');
      print(e);
      print(stackTrace);
    }
  }
}
