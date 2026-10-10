import 'dart:async';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/brand_model.dart';
import 'package:tracora/app/data/models/category_model.dart';
import 'package:tracora/app/data/models/employee_model.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/brand_repository.dart';
import 'package:tracora/app/data/repositories/category_repository.dart';
import 'package:tracora/app/data/repositories/sync_repository.dart';
import 'package:tracora/app/data/repositories/user_repository.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/data/repositories/product_repository.dart';
import 'package:tracora/app/data/repositories/stock_transaction_repository.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/FeesPayment/controllers/fees_payment_controller.dart';
import 'package:tracora/app/modules/FeesPaymentForm/controllers/fees_payment_form_controller.dart';
import 'package:tracora/app/modules/Login/controllers/login_controller.dart';
import 'package:tracora/app/modules/Login/views/login_view.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/ProductForm/controllers/product_form_controller.dart';
import 'package:tracora/app/modules/ProductForm/views/scanner.dart';
import 'package:tracora/app/modules/Profile/controllers/profile_controller.dart';
import 'package:tracora/app/modules/RolePermission/controllers/role_permission_controller.dart';
import 'package:tracora/app/modules/Statistic/controllers/statistic_controller.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/StockTransactionDetails/controllers/stock_transaction_details_controller.dart';
import 'package:tracora/app/modules/Synchronisation/controllers/synchronisation_controller.dart';
import 'package:tracora/app/modules/TransactionForm/controllers/transaction_form_controller.dart';
import 'package:tracora/app/modules/User/controllers/user_controller.dart';
import 'package:tracora/app/modules/UserForm/controllers/user_form_controller.dart';
import 'package:tracora/app/modules/UserPayment/controllers/user_payment_controller.dart';
import 'package:tracora/app/modules/UserPaymentForm/controllers/user_payment_form_controller.dart';
import 'package:tracora/app/modules/warehouse/controllers/warehouse_controller.dart';
import 'package:tracora/app/modules/warehouse_form/controllers/warehouse_form_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:tracora/app/widgets/toast_managet.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  //TODO: Implement HomeController

  final _isDark = Get.isDarkMode.obs;
  bool get isDark => this._isDark.value;
  set isDark(bool value) => this._isDark.value = value;

  final _sellMode = 0.obs;
  int get sellMode => this._sellMode.value;
  set sellMode(int value) => this._sellMode.value = value;

  final _scanning = false.obs;
  bool get scanning => this._scanning.value;
  set scanning(bool value) => this._scanning.value = value;

  final _transfert = StockTransaction().obs;
  StockTransaction get transfert => this._transfert.value;
  set transfert(StockTransaction value) => this._transfert.value = value;

  final _pendingWrites = <String, bool>{}.obs;
  Map<String, bool> get pendingWrites => this._pendingWrites.value;
  set pendingWrites(Map<String, bool> value) =>
      this._pendingWrites.value = value;

  final _fromCache = <String, bool>{}.obs;
  Map<String, bool> get fromCache => this._fromCache.value;
  set fromCache(Map<String, bool> value) => this._fromCache.value = value;

  bool get pending => pendingWrites.values.fold(false, (i, v) => i || v);
  bool get cache => fromCache.values.fold(false, (i, v) => i || v);

  final _employee = UserModel().obs;
  UserModel get employee => this._employee.value;
  set employee(UserModel value) => this._employee.value = value;

  final _token = "".obs;
  String get token => this._token.value;
  set token(String value) => this._token.value = value;

  final _lang =
      (["ar", 'fr', "en"].contains(Get.locale?.languageCode)
              ? (Get.locale?.languageCode ?? 'fr')
              : 'fr')
          .obs;
  String get lang => this._lang.value;
  set lang(String value) => this._lang.value = value;

  final _settingsLoaded = false.obs;
  bool get settingsLoaded => this._settingsLoaded.value;
  set settingsLoaded(bool value) => this._settingsLoaded.value = value;

  final _index = 0.obs;
  int get index => this._index.value;
  set index(int value) => this._index.value = value;

  final _extended = false.obs;
  bool get extended => this._extended.value;
  set extended(bool value) => this._extended.value = value;

  get selectedNode => nodes[index];

  late AdvancedDrawerController drawerCtrl;

  late StreamSubscription accountListener;
  late StreamSubscription productsListener;
  late StreamSubscription brandsListener;
  late StreamSubscription categoriesListener;
  late StreamSubscription customersListener;
  late StreamSubscription salesListener;
  late StreamSubscription moneyTransactionListener;
  late StreamSubscription suppliersListener;
  late StreamSubscription purchasesListener;

  late FocusScopeNode statisticsNode;
  late FocusScopeNode saleNode;
  late FocusScopeNode purchaseNode;
  late FocusScopeNode transfertNode;
  late FocusScopeNode salePaymentNode;
  late FocusScopeNode purchasePaymentNode;
  late FocusScopeNode customerNode;
  late FocusScopeNode supplierNode;
  late FocusScopeNode employeeNode;
  late FocusScopeNode feesPaymentNode;
  late FocusScopeNode productNode;
  late FocusScopeNode settingNode;
  late FocusScopeNode synchronizationNode;
  late FocusScopeNode wareHouseNode;
  late FocusScopeNode rolePermissionNode;

  late TabController tabCtrl;

  List<Map> get controllers => [
    {Get.find<StatisticController>(): Get.find<StatisticController>()},
    {
      Get.find<StockTransactionController<Sale>>():
          Get.find<TransactionFormController<Sale>>(),
    },
    {
      Get.find<StockTransactionController<Purchase>>():
          Get.find<TransactionFormController<Purchase>>(),
    },
    {
      Get.find<StockTransactionController<Transfert>>():
          Get.find<TransactionFormController<Transfert>>(),
    },
    {
      Get.find<UserPaymentController<Sale>>():
          Get.find<UserPaymentFormController<Sale>>(),
    },
    {
      Get.find<UserPaymentController<Purchase>>():
          Get.find<UserPaymentFormController<Purchase>>(),
    },
    {Get.find<FeesPaymentController>(): Get.find<FeesPaymentFormController>()},

    {
      Get.find<UserController<Customer>>():
          Get.find<UserFormController<Customer>>(),
    },
    {
      Get.find<UserController<Supplier>>():
          Get.find<UserFormController<Supplier>>(),
    },
    {
      Get.find<UserController<Employee>>():
          Get.find<UserFormController<Employee>>(),
    },

    {Get.find<ProductController>(): Get.find<ProductFormController>()},
    {Get.find<WarehouseController>(): Get.find<WarehouseFormController>()},
    {
      Get.find<SynchronisationController>():
          Get.find<SynchronisationController>(),
    },
    {
      Get.find<RolePermissionController>():
          Get.find<RolePermissionController>(),
    },
  ];

  @override
  void onInit() {
    super.onInit();
    tabCtrl = TabController(length: 15, vsync: this);
    initNodes();
    drawerCtrl = AdvancedDrawerController();
    readSettings().then((v) {});
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  initNodes() {
    statisticsNode = FocusScopeNode();
    saleNode = FocusScopeNode();
    purchaseNode = FocusScopeNode();
    transfertNode = FocusScopeNode();
    salePaymentNode = FocusScopeNode();
    purchasePaymentNode = FocusScopeNode();
    customerNode = FocusScopeNode();
    supplierNode = FocusScopeNode();
    employeeNode = FocusScopeNode();
    feesPaymentNode = FocusScopeNode();
    productNode = FocusScopeNode();
    settingNode = FocusScopeNode();
    synchronizationNode = FocusScopeNode();
    wareHouseNode = FocusScopeNode();
    rolePermissionNode = FocusScopeNode();
  }

  get nodes => [
    statisticsNode,
    saleNode,
    purchaseNode,
    transfertNode,
    salePaymentNode,
    purchasePaymentNode,
    feesPaymentNode,
    customerNode,
    supplierNode,
    employeeNode,
    productNode,
    settingNode,
    synchronizationNode,
    wareHouseNode,
    rolePermissionNode,
  ];

  final _collection = ''.obs;
  get collection => this._collection.value;
  set collection(value) => this._collection.value = value;

  readSettings() async {
    // listenToStatus();
    var pref = await SharedPreferences.getInstance();
    var c = pref.getString("collection");
    await pref.setString("collection", c ?? "default");
    collection = c;
    lang = pref.getString("lang") ?? lang;
    employee =
        pref.getString("user") == null
            ? employee
            : UserModel.fromJson(pref.getString("user")!);
    token = pref.getString("token") ?? token;
    transfert =
        pref.getString("transfert") == null
            ? transfert
            : StockTransaction.fromJson(pref.getString("transfert")!);

    await Get.updateLocale(Locale(lang));
    isDark = pref.getBool('isDark') ?? isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    sellMode = pref.getInt("sellMode") ?? 0;
    settingsLoaded = true;

    // Get.find<ProfileController>().initilize();
  }

  void changeThemeMode(bool v) async {
    if (v) {
      // Get.changeThemeMode(ThemeMode.dark);
      // Get.changeTheme(dark);
      isDark = true;
    } else {
      // Get.changeThemeMode(ThemeMode.light);
      // Get.changeTheme(light);
      isDark = false;
    }
    saveSettings();

    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,

        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        // systemNavigationBarContrastEnforced: true,
        statusBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  saveSettings() async {
    var pref = await SharedPreferences.getInstance();
    await pref.setBool('isDark', isDark);
    await pref.setString('lang', lang);
  }

  void updateLocale(String s) {
    lang = s;
    Get.updateLocale(Locale(s));
    saveSettings();
  }

  logout() async {
    token = '';
    var pref = await SharedPreferences.getInstance();
    pref.remove('token');
  }

  login() async {
    showDialog(
      context: Get.context!,
      builder: (c) {
        return Center(
          child: Container(height: 500, width: 500, child: LoginView()),
        );
      },
    );
  }

  ThemeData get dark =>
      FlexThemeData.dark(scheme: FlexScheme.green, useMaterial3: true).copyWith(
        // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        //   selectedItemColor: Colors.white,
        // ),
        scaffoldBackgroundColor: Color(0xFF030712),
      );

  get light => FlexThemeData.light(
    scheme: FlexScheme.green,
    useMaterial3: true,
  ).copyWith(
    scaffoldBackgroundColor: const Color.fromARGB(255, 226, 232, 223),

    cardColor: const Color.fromARGB(255, 234, 245, 232),
  );

  ThemeData get theme => isDark ? dark : light;

  get profileController => null;

  Map? get aciveController => controllers[index];

  logout1() async {
    // var pref = await SharedPreferences.getInstance();
    // pref.remove("employee");
    // employee = EmployeeModel();

    // await cancelListener();
    // await FirebaseAuth.instance.signOut();
    // // await GoogleSignIn().signOut();
    // DbHelper().db = null;
  }

  // Future<void> setupToken() async {
  //   FirebaseMessaging.instance.onTokenRefresh.listen(
  //     AuthenticationProvider.saveTokenToDatabase,
  //   );
  // }

  listenToProducts() async {
    // productsListener = FirebaseFirestore.instance
    //     .collection("collections")
    //     .doc(collection)
    //     .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
    //     .doc("2025")
    //     .collection('products')
    //     // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
    //     .snapshots(includeMetadataChanges: true)
    //     .listen((data) async {
    //       pendingWrites =
    //           pendingWrites..['product'] = data.metadata.hasPendingWrites;
    //       fromCache = fromCache..['product'] = data.metadata.isFromCache;
    //       update(["sync"]);
    //       if (data.metadata.isFromCache) return;
    //       await Future.forEach(data.docs, (element) async {
    //         element.data()["remoteId"] = element.data()["id"];
    //         var model = Product.fromMap(element.data()!);
    //         await ProductRepository().insertProduct(model);
    //       });
    //     });
  }

  listenToBrands() async {
    // brandsListener = FirebaseFirestore.instance
    //     .collection("collections")
    //     .doc(collection)
    //     .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
    //     .doc("2025")
    //     .collection('brands')
    //     // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
    //     .snapshots(includeMetadataChanges: true)
    //     .listen((data) async {
    //       pendingWrites =
    //           pendingWrites..['brand'] = data.metadata.hasPendingWrites;
    //       fromCache = fromCache..['brand'] = data.metadata.isFromCache;
    //       update(["sync"]);
    //       if (data.metadata.isFromCache) return;
    //       await Future.forEach(data.docs, (element) async {
    //         element.data()["remoteId"] = element.data()["id"];
    //         var model = Brand.fromMap(element.data()!);
    //         await BrandRepository().insertBrand(model);
    //       });
    //     });
  }

  listenToCategories() async {
    // categoriesListener = FirebaseFirestore.instance
    //     .collection("collections")
    //     .doc(collection)
    //     .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
    //     .doc("2025")
    //     .collection('categories')
    //     // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
    //     .snapshots(includeMetadataChanges: true)
    //     .listen((data) async {
    //       pendingWrites['category'] = data.metadata.hasPendingWrites;
    //       fromCache['category'] = data.metadata.isFromCache;
    //       update(["sync"]);
    //       if (data.metadata.isFromCache) return;
    //       await Future.forEach(data.docs, (element) async {
    //         element.data()["remoteId"] = element.data()["id"];
    //         var model = CategoryModel.fromMap(element.data()!);
    //         await CategoryRepository().insertCategory(model);
    //       });
    //     });
  }

  listenToCustomers() async {
    // customersListener = FirebaseFirestore.instance
    //     .collection("collections")
    //     .doc(collection)
    //     .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
    //     .doc("2025")
    //     .collection('users')
    //     .where("type", isEqualTo: "customer")
    //     // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
    //     .snapshots(includeMetadataChanges: true)
    //     .listen((data) async {
    //       pendingWrites =
    //           pendingWrites..['customer'] = data.metadata.hasPendingWrites;
    //       fromCache = fromCache..['customer'] = data.metadata.isFromCache;
    //       update(["sync"]);
    //       if (data.metadata.isFromCache) return;
    //       await Future.forEach(data.docs, (element) async {
    //         element.data()["remoteId"] = element.data()["id"];
    //         var model = UserModel.fromMap(element.data()!);
    //         await UserRepository().insertUser(model);
    //       });
    //     });
  }

  listenToSuppliers() async {
    // suppliersListener = FirebaseFirestore.instance
    //     .collection("collections")
    //     .doc(collection)
    //     .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
    //     .doc("2025")
    //     .collection('users')
    //     .where("type", isEqualTo: "supplier")
    //     // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
    //     .snapshots(includeMetadataChanges: true)
    //     .listen((data) async {
    //       pendingWrites =
    //           pendingWrites..['supplier'] = data.metadata.hasPendingWrites;
    //       fromCache = fromCache..['supplier'] = data.metadata.isFromCache;
    //       update(["sync"]);
    //       if (data.metadata.isFromCache) return;
    //       await Future.forEach(data.docs, (element) async {
    //         element.data()["remoteId"] = element.data()["id"];
    //         var model = UserModel.fromMap(element.data()!);
    //         await UserRepository().insertUser(model);
    //       });
    //     });
  }

  listenToSales() async {
    // salesListener = FirebaseFirestore.instance
    //     .collection("collections")
    //     .doc(collection)
    //     .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
    //     .doc("2025")
    //     .collection('stockTransactions')
    //     .where("type", isEqualTo: "sale")
    //     // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
    //     .snapshots(includeMetadataChanges: true)
    //     .listen((data) async {
    //       pendingWrites =
    //           pendingWrites..['sale'] = data.metadata.hasPendingWrites;
    //       fromCache = fromCache..['sale'] = data.metadata.isFromCache;
    //       update(["sync"]);
    //       if (data.metadata.isFromCache) return;
    //       await Future.forEach(data.docs, (element) async {
    //         element.data()["remoteId"] = element.data()["id"];
    //         var model = StockTransaction.fromMap(element.data()!);
    //         await StockTransactionRepository().insert(model);
    //       });
    //     });
  }

  listenToPurchases() async {
    // purchasesListener = FirebaseFirestore.instance
    //     .collection("collections")
    //     .doc(collection)
    //     .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
    //     .doc("2025")
    //     .collection('stockTransactions')
    //     .where("type", isEqualTo: "purchase")
    //     // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
    //     .snapshots(includeMetadataChanges: true)
    //     .listen((data) async {
    //       pendingWrites =
    //           pendingWrites..['purchase'] = data.metadata.hasPendingWrites;
    //       fromCache = fromCache..['purchase'] = data.metadata.isFromCache;
    //       update(["sync"]);
    //       if (data.metadata.isFromCache) return;
    //       await Future.forEach(data.docs, (element) async {
    //         element.data()["remoteId"] = element.data()["id"];
    //         var model = StockTransaction.fromMap(element.data()!);
    //         await StockTransactionRepository().insert(model);
    //       });
    //     });
  }

  void scanMission() async {
    // try {
    //   scanning = true;
    //   var r = await Get.to(ScannerPage());
    //   if (r is! String) return;
    //   var d = await FirebaseFirestore.instance
    //       .collection("collections")
    //       .doc(collection)
    //       .collection("transferts")
    //       .doc(r)
    //       .get(GetOptions(source: Source.server));
    //   if (d.data() == null) return;
    //   if (d.data()!.isEmpty) return;
    //   transfert = StockTransaction.fromMap(d.data()!);

    //   var pref = await SharedPreferences.getInstance();
    //   await pref.setString("transfert", transfert.toJson());
    //   StockTransactionRepository().insert(transfert);
    // } on Exception catch (e) {
    //   ErrorHandler.handleError(e);
    // } finally {
    //   scanning = false;
    // }
  }
}
