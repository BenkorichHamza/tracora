import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tracora/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var pref = await SharedPreferences.getInstance();
  var isDark = pref.getBool("isDark");
  var lang = pref.getString("lang");
  if (Platform.isWindows) {
    sqfliteFfiInit();
  }

  runApp(
    OverlaySupport.global(
      child: GetMaterialApp(
        title: "tracora",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,

        locale:
            lang == null
                ? ["fr", "ar", "en"].contains(Get.locale?.countryCode)
                    ? Get.locale
                    : Locale('fr')
                : Locale(lang), // translations will be displayed in that locale
        fallbackLocale:
            lang == null
                ? ["fr", "ar", "en"].contains(Get.locale?.countryCode)
                    ? Get.locale
                    : Locale('fr')
                : Locale(lang),
        themeMode:
            isDark == null
                ? ThemeMode.system
                : isDark
                ? ThemeMode.dark
                : ThemeMode.light,
        theme: FlexThemeData.light(
          scheme: FlexScheme.green,
          useMaterial3: true,
        ).copyWith(
          scaffoldBackgroundColor: const Color.fromARGB(255, 242, 248, 235),
          cardColor: const Color.fromARGB(255, 234, 245, 232),
        ),
        darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.green,
          useMaterial3: true,
        ).copyWith(scaffoldBackgroundColor: Color.fromARGB(255, 13, 13, 13)),
      ),
    ),
  );
}
