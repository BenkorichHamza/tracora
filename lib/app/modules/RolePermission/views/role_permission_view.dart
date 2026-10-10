import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/role_permission_controller.dart';

class RolePermissionView extends GetView<RolePermissionController> {
  const RolePermissionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Roles'), centerTitle: true),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.roles.length,
          itemBuilder: (c, i) {
            var r = controller.roles[i];
            return ListTile(title: Text(r.name ?? 'r'));
          },
        ),
      ),
    );
  }
}
