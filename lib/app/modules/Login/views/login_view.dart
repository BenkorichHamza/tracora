import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('LoginView'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 200),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              controller: controller.email,
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              controller: controller.password,
            ),
            SizedBox(height: 16),
            Obx(
              () =>
                  controller.loading
                      ? CircularProgressIndicator()
                      : OutlinedButton(
                        onPressed: () async {
                          await controller.googleLogin();
                        },
                        child: Text('LOGIN'),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
