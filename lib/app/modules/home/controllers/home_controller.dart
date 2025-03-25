import 'dart:async';
import 'dart:ui';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracora/app/data/models/employee_model.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final _isDark = Get.isDarkMode.obs;
  bool get isDark => this._isDark.value;
  set isDark(bool value) => this._isDark.value = value;

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

  late AdvancedDrawerController drawerCtrl;

  @override
  void onInit() {
    super.onInit();
    drawerCtrl = AdvancedDrawerController();
    readSettings();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  readSettings() async {
    // listenToStatus();
    var pref = await SharedPreferences.getInstance();
    lang = pref.getString("lang") ?? lang;
    employee =
        pref.getString("employee") == null
            ? employee
            : EmployeeModel.fromJson(pref.getString("employee")!);
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

  ThemeData get dark => FlexThemeData.dark(
    scheme: FlexScheme.green,
    useMaterial3: true,
  ).copyWith(scaffoldBackgroundColor: Color.fromARGB(255, 19, 19, 19));

  get light => FlexThemeData.light(
    scheme: FlexScheme.green,
    useMaterial3: true,
  ).copyWith(
    scaffoldBackgroundColor: const Color.fromARGB(255, 242, 248, 235),
    cardColor: const Color.fromARGB(255, 234, 245, 232),
  );

  ThemeData get theme => isDark ? dark : light;

  get profileController => null;
}
