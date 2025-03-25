import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorHandler {
  static void showError(String message) {
    removeCurrent();
    ScaffoldMessenger.of(
      Get.context!,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static void removeCurrent() {
    ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
  }

  static void handleError(Object error) {
    print(error.toString);
    showError(error.toString());
  }
}
