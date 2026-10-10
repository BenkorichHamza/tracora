import 'package:get/get.dart';

import '../controllers/role_permission_controller.dart';

class RolePermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RolePermissionController>(
      () => RolePermissionController(),
    );
  }
}
