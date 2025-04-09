import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:tracora/app/data/repositories/user_repository.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/data/repositories/product_repository.dart';
import 'package:tracora/app/data/repositories/stock_transaction_repository.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/FeesPayment/controllers/fees_payment_controller.dart';
import 'package:tracora/app/modules/FeesPaymentForm/controllers/fees_payment_form_controller.dart';
import 'package:tracora/app/modules/Login/controllers/login_controller.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/ProductForm/controllers/product_form_controller.dart';
import 'package:tracora/app/modules/ProductForm/views/scanner.dart';
import 'package:tracora/app/modules/Profile/controllers/profile_controller.dart';
import 'package:tracora/app/modules/Statistic/controllers/statistic_controller.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/StockTransactionDetails/controllers/stock_transaction_details_controller.dart';
import 'package:tracora/app/modules/TransactionForm/controllers/transaction_form_controller.dart';
import 'package:tracora/app/modules/User/controllers/user_controller.dart';
import 'package:tracora/app/modules/UserForm/controllers/user_form_controller.dart';
import 'package:tracora/app/modules/UserPayment/controllers/user_payment_controller.dart';
import 'package:tracora/app/modules/UserPaymentForm/controllers/user_payment_form_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:tracora/app/widgets/toast_managet.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  //TODO: Implement HomeController

  final _isDark = Get.isDarkMode.obs;
  bool get isDark => this._isDark.value;
  set isDark(bool value) => this._isDark.value = value;

  final _scanning = false.obs;
  bool get scanning => this._scanning.value;
  set scanning(bool value) => this._scanning.value = value;

  final _mission = StockTransaction().obs;
  StockTransaction get mission => this._mission.value;
  set mission(StockTransaction value) => this._mission.value = value;

  final _pendingWrites = <String, bool>{}.obs;
  Map<String, bool> get pendingWrites => this._pendingWrites.value;
  set pendingWrites(Map<String, bool> value) =>
      this._pendingWrites.value = value;

  final _fromCache = <String, bool>{}.obs;
  Map<String, bool> get fromCache => this._fromCache.value;
  set fromCache(Map<String, bool> value) => this._fromCache.value = value;

  bool get pending => pendingWrites.values.fold(false, (i, v) => i || v);
  bool get cache => fromCache.values.fold(false, (i, v) => i || v);

  final _employee = EmployeeModel().obs;
  EmployeeModel get employee => this._employee.value;
  set employee(EmployeeModel value) => this._employee.value = value;

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

  late TabController tabCtrl;

  List<Map> get controllers => [
    {
      Get.find<StockTransactionController<Sale>>():
          Get.find<TransactionFormController<Sale>>(),
    },
    {
      Get.find<StockTransactionController<Purchase>>():
          Get.find<TransactionFormController<Purchase>>(),
    },
    {
      Get.find<StockTransactionController<Mission>>():
          Get.find<TransactionFormController<Mission>>(),
    },
    {
      Get.find<UserPaymentController<Sale>>():
          Get.find<UserPaymentFormController<Sale>>(),
    },
    {
      Get.find<UserPaymentController<Purchase>>():
          Get.find<UserPaymentFormController<Purchase>>(),
    },
    {
      Get.find<UserController<Customer>>():
          Get.find<UserFormController<Customer>>(),
    },
    {
      Get.find<UserController<Supplier>>():
          Get.find<UserFormController<Supplier>>(),
    },

    {Get.find<FeesPaymentController>(): Get.find<FeesPaymentFormController>()},
    {Get.find<ProductController>(): Get.find<ProductFormController>()},
  ];

  @override
  void onInit() {
    super.onInit();
    tabCtrl = TabController(length: 11, vsync: this);
    drawerCtrl = AdvancedDrawerController();
    readSettings();
    // listen();
    listenToAuth();
    listenToMissions();
    listenToMissionPayments();
    listenToUsers();
    setupNetworkListener();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // void openPlayStore() async {
  //   const url =
  //       'https://play.google.com/store/apps/details?id=com.benkosoft.kodian';
  //   launchUrl(Uri.parse(url));
  // }

  listen() {
    listenToAccount();
    listenToProducts();
    listenToBrands();
    listenToCategories();
    listenToCustomers();
    listenToSales();
    listenToMoneyTransaction();
    listenToSuppliers();
    listenToPurchases();
  }

  listenToAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // cancelListener();
        // employee = EmployeeModel();
      } else {
        // listen();
      }
    });
  }

  cancelListener() async {
    try {
      await accountListener.cancel();
    } catch (e) {}
    try {
      await productsListener.cancel();
    } catch (e) {}
    try {
      await brandsListener.cancel();
    } catch (e) {}
    try {
      await categoriesListener.cancel();
    } catch (e) {}
    try {
      await customersListener.cancel();
    } catch (e) {}
    try {
      await salesListener.cancel();
    } catch (e) {}
    try {
      await moneyTransactionListener.cancel();
    } catch (e) {}
    try {
      await suppliersListener.cancel();
    } catch (e) {}
    try {
      await purchasesListener.cancel();
    } catch (e) {}
  }

  listenToAccount() {
    accountListener = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
        .doc("2025")
        .collection("employees")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((event) {
          employee = EmployeeModel.fromMap(event.data() ?? {});
        });
  }

  readSettings() async {
    // listenToStatus();
    var pref = await SharedPreferences.getInstance();
    lang = pref.getString("lang") ?? lang;
    employee =
        pref.getString("employee") == null
            ? employee
            : EmployeeModel.fromJson(pref.getString("employee")!);
    mission =
        pref.getString("mission") == null
            ? mission
            : StockTransaction.fromJson(pref.getString("mission")!);

    await Get.updateLocale(Locale(lang));
    isDark = pref.getBool('isDark') ?? isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
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

  ThemeData get dark =>
      FlexThemeData.dark(scheme: FlexScheme.green, useMaterial3: true).copyWith(
        // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        //   selectedItemColor: Colors.white,
        // ),
        scaffoldBackgroundColor: Color.fromARGB(255, 19, 19, 19),
      );

  get light => FlexThemeData.light(
    scheme: FlexScheme.green,
    useMaterial3: true,
  ).copyWith(
    scaffoldBackgroundColor: const Color.fromARGB(255, 242, 248, 235),
    cardColor: const Color.fromARGB(255, 234, 245, 232),
  );

  ThemeData get theme => isDark ? dark : light;

  get profileController => null;

  Map? get aciveController => index == 0 ? null : controllers[index - 1];

  logout() async {
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
    productsListener = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
        .doc("2025")
        .collection('products')
        // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          pendingWrites =
              pendingWrites..['product'] = data.metadata.hasPendingWrites;
          fromCache = fromCache..['product'] = data.metadata.isFromCache;
          update(["sync"]);
          if (data.metadata.isFromCache) return;
          await Future.forEach(data.docs, (element) async {
            element.data()["remoteId"] = element.data()["id"];
            var model = Product.fromMap(element.data()!);
            await ProductRepository().insertProduct(model, sync: false);
          });
        });
  }

  listenToBrands() async {
    brandsListener = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
        .doc("2025")
        .collection('brands')
        // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          pendingWrites =
              pendingWrites..['brand'] = data.metadata.hasPendingWrites;
          fromCache = fromCache..['brand'] = data.metadata.isFromCache;
          update(["sync"]);
          if (data.metadata.isFromCache) return;
          await Future.forEach(data.docs, (element) async {
            element.data()["remoteId"] = element.data()["id"];
            var model = Brand.fromMap(element.data()!);
            await BrandRepository().insertBrand(model, sync: false);
          });
        });
  }

  listenToCategories() async {
    categoriesListener = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
        .doc("2025")
        .collection('categories')
        // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          pendingWrites['category'] = data.metadata.hasPendingWrites;
          fromCache['category'] = data.metadata.isFromCache;
          update(["sync"]);
          if (data.metadata.isFromCache) return;
          await Future.forEach(data.docs, (element) async {
            element.data()["remoteId"] = element.data()["id"];
            var model = CategoryModel.fromMap(element.data()!);
            await CategoryRepository().insertCategory(model, sync: false);
          });
        });
  }

  listenToCustomers() async {
    customersListener = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
        .doc("2025")
        .collection('users')
        .where("type", isEqualTo: "customer")
        // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          pendingWrites =
              pendingWrites..['customer'] = data.metadata.hasPendingWrites;
          fromCache = fromCache..['customer'] = data.metadata.isFromCache;
          update(["sync"]);
          if (data.metadata.isFromCache) return;
          await Future.forEach(data.docs, (element) async {
            element.data()["remoteId"] = element.data()["id"];
            var model = UserModel.fromMap(element.data()!);
            await UserRepository().insertUser(model, sync: false);
          });
        });
  }

  listenToSuppliers() async {
    suppliersListener = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
        .doc("2025")
        .collection('users')
        .where("type", isEqualTo: "supplier")
        // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          pendingWrites =
              pendingWrites..['supplier'] = data.metadata.hasPendingWrites;
          fromCache = fromCache..['supplier'] = data.metadata.isFromCache;
          update(["sync"]);
          if (data.metadata.isFromCache) return;
          await Future.forEach(data.docs, (element) async {
            element.data()["remoteId"] = element.data()["id"];
            var model = UserModel.fromMap(element.data()!);
            await UserRepository().insertUser(model, sync: false);
          });
        });
  }

  listenToSales() async {
    salesListener = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
        .doc("2025")
        .collection('stockTransactions')
        .where("type", isEqualTo: "sale")
        // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          pendingWrites =
              pendingWrites..['sale'] = data.metadata.hasPendingWrites;
          fromCache = fromCache..['sale'] = data.metadata.isFromCache;
          update(["sync"]);
          if (data.metadata.isFromCache) return;
          await Future.forEach(data.docs, (element) async {
            element.data()["remoteId"] = element.data()["id"];
            var model = StockTransaction.fromMap(element.data()!);
            await StockTransactionRepository().insert(model, sync: false);
          });
        });
  }

  listenToPurchases() async {
    purchasesListener = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
        .doc("2025")
        .collection('stockTransactions')
        .where("type", isEqualTo: "purchase")
        // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          pendingWrites =
              pendingWrites..['purchase'] = data.metadata.hasPendingWrites;
          fromCache = fromCache..['purchase'] = data.metadata.isFromCache;
          update(["sync"]);
          if (data.metadata.isFromCache) return;
          await Future.forEach(data.docs, (element) async {
            element.data()["remoteId"] = element.data()["id"];
            var model = StockTransaction.fromMap(element.data()!);
            await StockTransactionRepository().insert(model, sync: false);
          });
        });
  }

  listenToMoneyTransaction() async {
    moneyTransactionListener = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
        .doc("2025")
        .collection('moneyTransactions')
        // .where("type", isEqualTo: "sale")
        // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          pendingWrites =
              pendingWrites
                ..['moneyTransaction'] = data.metadata.hasPendingWrites;
          fromCache =
              fromCache..['moneyTransaction'] = data.metadata.isFromCache;
          update(["sync"]);
          if (data.metadata.isFromCache) return;
          await Future.forEach(data.docs, (element) async {
            element.data()["remoteId"] = element.data()["id"];
            var model = MoneyTransaction.fromMap(element.data()!);
            await MoneyTransactionRepository().insertMoneyTransaction(
              model,
              sync: false,
            );
          });
        });
  }

  void scanMission() async {
    try {
      scanning = true;
      var r = await Get.to(ScannerPage());
      if (r is! String) return;
      var d = await FirebaseFirestore.instance
          .collection("missions")
          .doc(r)
          .get(GetOptions(source: Source.server));
      if (d.data() == null) return;
      if (d.data()!.isEmpty) return;
      mission = StockTransaction.fromMap(d.data()!);

      var pref = await SharedPreferences.getInstance();
      await pref.setString("mission", mission.toJson());
      StockTransactionRepository().insert(mission, mission: true, sync: false);
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      scanning = false;
    }
  }

  late StreamSubscription missionListener;

  listenToMissions() async {
    try {
      await missionListener.cancel();
    } catch (e) {}
    missionListener = FirebaseFirestore.instance
        .collectionGroup("stockTransactions")
        .where(
          "updatedBy",
          isNotEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "admin",
        )
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          if (data.docChanges.isEmpty) return;
          if (data.metadata.isFromCache) return;
          var sales =
              data.docChanges
                  .where((e) => e.type != DocumentChangeType.removed)
                  .map((d) => StockTransaction.fromMap(d.doc.data() ?? {}))
                  .toList();
          sales = sales.where((e) => (e.topay ?? 0) > 0).toList();
          print(sales.length);
          await Future.forEach(sales, (s) async {
            if (s.type == "sale") {
              await StockTransactionRepository<Sale>().insert(
                s,
                sync:
                    s.id == null ||
                    s.updatedBy !=
                        (FirebaseAuth.instance.currentUser?.uid ?? "admin"),
                mission: false,
              );
            } else {
              await StockTransactionRepository<Purchase>().insert(
                s,
                sync:
                    s.id == null ||
                    s.updatedBy !=
                        (FirebaseAuth.instance.currentUser?.uid ?? "admin"),
                mission: false,
              );
            }
            if (s.id == null) {
              showBottomRightNotification(
                "new sale created ${s.topay.formatPrice()}",
              );
            }
          });
          Get.find<StockTransactionController<Sale>>().getAll();

          Get.find<StockTransactionDetailsController<Mission>>()
              .getMissionStockTransactions();
          Get.find<StatisticController>().loadStatistics();
        });
  }

  late StreamSubscription missionPaymentListener;

  listenToMissionPayments() async {
    try {
      await missionPaymentListener.cancel();
    } catch (e) {}
    missionPaymentListener = FirebaseFirestore.instance
        .collectionGroup("moneyTransactions")
        .where(
          "updatedBy",
          isNotEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "admin",
        )
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          if (data.docChanges.isEmpty) return;
          if (data.metadata.isFromCache) return;
          var sales =
              data.docChanges
                  .where((e) => e.type != DocumentChangeType.removed)
                  .map((d) => MoneyTransaction.fromMap(d.doc.data() ?? {}))
                  .toList();
          sales = sales.where((e) => (e.amount ?? 0) > 0).toList();
          print(sales.length);
          await Future.forEach(sales, (s) async {
            if (s.type == "sale") {
              await MoneyTransactionRepository().insertMoneyTransaction(
                s,
                sync:
                    s.updatedBy !=
                    (FirebaseAuth.instance.currentUser?.uid ?? "admin"),
              );
              Get.find<UserPaymentController<Sale>>().getAll();
            } else if (s.type == "purchase") {
              await MoneyTransactionRepository().insertMoneyTransaction(
                s,
                sync:
                    s.updatedBy !=
                    (FirebaseAuth.instance.currentUser?.uid ?? "admin"),
              );
            } else {
              await MoneyTransactionRepository().insertMoneyTransaction(
                s,
                sync:
                    s.updatedBy !=
                    (FirebaseAuth.instance.currentUser?.uid ?? "admin"),
              );
            }
            if (s.id == null) {
              showBottomRightNotification(
                "payment created ${s.amount.formatPrice()}",
              );
            }
          });
          Get.find<FeesPaymentController>().getAll();
          Get.find<StockTransactionDetailsController<Mission>>()
              .getMissionMoneyTransactions();
          Get.find<StatisticController>().loadStatistics();
        });
  }

  late StreamSubscription userListener;

  listenToUsers() async {
    try {
      await userListener.cancel();
    } catch (e) {}
    userListener = FirebaseFirestore.instance
        .collectionGroup("users")
        .where(
          "updatedBy",
          isNotEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "admin",
        )
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          if (data.docChanges.isEmpty) return;
          if (data.metadata.isFromCache) return;
          var sales =
              data.docChanges
                  .where((e) => e.type != DocumentChangeType.removed)
                  .map((d) => UserModel.fromMap(d.doc.data() ?? {}))
                  .toList();
          await Future.forEach(sales, (s) async {
            if (s.type == "customer") {
              await UserRepository<Customer>().insertUser(
                s,
                sync:
                    s.updatedBy !=
                    (FirebaseAuth.instance.currentUser?.uid ?? "admin"),
              );
            } else if (s.type == "supplier") {
              await UserRepository<Supplier>().insertUser(
                s,
                sync:
                    s.updatedBy !=
                    (FirebaseAuth.instance.currentUser?.uid ?? "admin"),
              );
            }
            if (s.id == null) {
              showBottomRightNotification("new user created ${s.firstName}");
            } else {
              showBottomRightNotification("user updated ${s.firstName}");
            }
          });
          Get.find<UserController<Customer>>().getAll();
          Get.find<UserController<Supplier>>().getAll();

          Get.find<StockTransactionDetailsController<Mission>>()
              .getMissionMoneyTransactions();
          Get.find<StatisticController>().loadStatistics();
        });
  }

  void showBottomRightNotification(String content) {
    showOverlayNotification(
      (context) {
        return Align(
          alignment: Alignment.bottomRight,
          child: Material(
            color: Colors.transparent,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications, color: Colors.white),
                    SizedBox(width: 12),
                    Text(content, style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      duration: Duration(seconds: 4),

      position:
          NotificationPosition
              .bottom, // required but ignored when using Positioned
    );
  }

  void setupNetworkListener() {
    InternetConnectionChecker.createInstance().onStatusChange.listen((
      status,
    ) async {
      if (status == InternetConnectionStatus.connected) {
        showBottomRightNotification("internet restored");
        listenToMissionPayments();
        listenToMissions();
        listenToUsers();
      } else if (status == InternetConnectionStatus.slow) {
        showBottomRightNotification("Slow connection");
      } else {
        showBottomRightNotification("working offline");
      }
    });
  }
}
