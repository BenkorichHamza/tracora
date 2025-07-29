import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';

class SuperAdminMenu extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('drivres'.tr),
        leading: Icon(Icons.local_shipping),
        onTap: () => Get.toNamed(Routes.DRIVER),
      ),
    );
  }
}
