import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracora/app/core/api.dart';

import 'package:dio/dio.dart';
import 'package:tracora/app/data/models/role.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;

  Future<void> login() async {
    try {
      isLoading.value = true;

      final response = await ApiService.dio.post(
        '/login',
        data: {
          'email': emailController.text.trim(),
          'password': passwordController.text,
        },
      );
      print(response?.data);

      final token = response.data['token'];
      final user = UserModel.fromMap(response.data['user']['contact'] ?? {});
      var roles =
          ((response.data['roles'] ?? []) as List)
              .map((e) => Role.fromMap(e))
              .toList();

      // final warehouse = Warehouse.fromMap(response.data['warehouse'] ?? {});
      // user = user.copyWith(warehouse: warehouse);
      ApiService.setToken(token);
      var pref = await SharedPreferences.getInstance();
      await pref.setStringList("roles", roles.map((e) => e.toJson()).toList());
      await pref.setString("token", token);
      await pref.setString("user", user.toSharedPrefJson());
      Get.find<HomeController>().token = token;
      Get.find<HomeController>().employee = user;
      pref.setString("token", token);
      pref.setString("user", user.toJson());
      Get.find<HomeController>().token = token;
      Get.find<HomeController>().employee = user;

      Get.back();

      // Navigate to home
      // Get.offAllNamed(Routes.HOME);
    } on DioException catch (e) {
      String message = 'Login failed';

      if (e.response != null) {
        message = e.response?.data['message'] ?? message;
      }
      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      print("error");
      print(e.toString());
      isLoading.value = false;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
