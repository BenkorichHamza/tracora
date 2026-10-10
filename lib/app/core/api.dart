import 'package:dio/dio.dart';

class ApiService {
  ApiService._();

  static const String insertOperation = 'INSERT';
  static const String updateOperation = 'UPDATE';
  static const String deleteOperation = 'DELETE';

  static const String productsTable = 'products';
  static const String brandsTable = 'brands';
  static const String contactsTable = 'contacts';
  static const String warehousesTable = 'warehouses';
  static const String transactionsTable = 'stransactions';

  /*
  |--------------------------------------------------------------------------
  | API Configuration
  |--------------------------------------------------------------------------
  */

  static const String baseUrl =
      'https://pink-jay-446772.hostingersite.com/api/v1';

  static const Duration connectTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 60);

  /*
  |--------------------------------------------------------------------------
  | Device Info
  |--------------------------------------------------------------------------
  */

  static String? deviceId;

  /*
  |--------------------------------------------------------------------------
  | Authentication
  |--------------------------------------------------------------------------
  */

  static String? accessToken;

  static bool get isAuthenticated =>
      accessToken != null && accessToken!.isNotEmpty;

  /*
  |--------------------------------------------------------------------------
  | Dio Instance
  |--------------------------------------------------------------------------
  */

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': accessToken != null ? 'Bearer $accessToken' : null,
        'Device-Id': deviceId,
      },
    ),
  );

  /*
  |--------------------------------------------------------------------------
  | Headers
  |--------------------------------------------------------------------------
  */

  static Map<String, dynamic> headers() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      if (deviceId != null) 'Device-Id': deviceId,
    };
  }

  /*
  |--------------------------------------------------------------------------
  | Configure Auth
  |--------------------------------------------------------------------------
  */

  static void setToken(String token) {
    accessToken = token;
  }

  static void clearToken() {
    accessToken = null;
  }

  static void setDeviceId(String id) {
    deviceId = id;
  }
}
