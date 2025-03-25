import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
        centerTitle: true,
        backgroundColor:
            Get.find<HomeController>().theme.scaffoldBackgroundColor,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.arrow_upward),
            title: Text('export'.tr),
            trailing: OutlinedButton(
              onPressed: controller.exportDatabase,
              child: Text('export'.tr),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.arrow_downward),
            title: Text('import'.tr),
            trailing: OutlinedButton(
              onPressed: controller.importDatabase,
              child: Text('import'.tr),
            ),
          ),
        ],
      ),
    );
  }
}
