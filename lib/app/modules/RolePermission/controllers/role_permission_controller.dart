import 'package:get/get.dart';
import 'package:tracora/app/data/models/role.dart';
import 'package:tracora/app/data/repositories/role_repository.dart';

class RolePermissionController extends GetxController {
  //TODO: Implement RolePermissionController

  final _roles = <Role>[].obs;
  List<Role> get roles => this._roles.value;
  set roles(List<Role> value) => this._roles.value = value;

  final _selected = <Role>[].obs;
  List<Role> get selected => this._selected.value;
  set selected(List<Role> value) => this._selected.value = value;

  @override
  void onInit() {
    getAll();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getAll() async {
    roles = await RoleRepository().getAll();
  }
}
