import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/modules/RolePermission/controllers/role_permission_controller.dart';

class RoleSelectionView extends GetView<RolePermissionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roles'),
        actions: [
          ElevatedButton(
            child: Text('OK'),
            onPressed: () => Get.back(result: controller.selected),
          ),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.roles.length,
          itemBuilder: (c, i) {
            var r = controller.roles[i];
            return Obx(
              () => SwitchListTile(
                title: Text(r.name ?? 'r'),
                value: controller.selected.contains(r),
                onChanged: (v) {
                  if (v) {
                    controller.selected = controller.selected + [r];
                  } else {
                    controller.selected.removeWhere((e) => e.id == r.id);
                    controller.selected = controller.selected.sublist(0);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
