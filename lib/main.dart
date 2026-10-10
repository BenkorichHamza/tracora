import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tracora/app/core/intents.dart';
import 'package:tracora/app/locale/translations.dart';
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
        translations: AppTranslation(),
        getPages: AppPages.routes,
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.f1): NewIntent(),
          LogicalKeySet(LogicalKeyboardKey.f2): EditIntent(),
          LogicalKeySet(LogicalKeyboardKey.escape): EscapeIntent(),
          LogicalKeySet(LogicalKeyboardKey.f4): SaveIntent(),
          LogicalKeySet(LogicalKeyboardKey.f5): SaveAndNewIntent(),
          LogicalKeySet(LogicalKeyboardKey.delete): DeleteIntent(),

          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF):
              SearchIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowDown): NextIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowUp): PreviousIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyP):
              PrintIntent(),
        },

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

  doWhenWindowReady(() {
    appWindow.maximize(); // Make it full screenr
    appWindow.show();
  });
}
