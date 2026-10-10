import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/warehouse.dart';
import 'package:tracora/app/data/repositories/warehouse_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/modules/warehouse/controllers/warehouse_controller.dart';
import 'package:tracora/app/modules/warehouse_details/controllers/warehouse_details_controller.dart';

class WarehouseFormController extends GetxController {
  final repository = WarehouseRepository();
  final _warehouse = Warehouse().obs;
  Warehouse get warehouse => this._warehouse.value;
  set warehouse(Warehouse value) => this._warehouse.value = value;

  final _img = ''.obs;
  String get img => this._img.value;
  set img(String value) => this._img.value = value;

  late GlobalKey<FormState> formKey;

  late TextEditingController name;
  late TextEditingController nameAr;
  late TextEditingController location;
  late TextEditingController description;

  @override
  void onInit() {
    formKey = GlobalKey<FormState>();

    init(warehouse);

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

  void save(Function onSuccess) async {
    try {
      if (!(formKey.currentState?.validate() ?? false)) return;
      // try {
      //   if (img.isNotEmpty && warehouse.img != img) {
      //     var path = await ImagePickerService.saveImageToPermanentStorage(img);
      //     warehouse = warehouse.copyWith(img: path);
      //   }
      // } on Exception catch (_) {}
      warehouse = warehouse.copyWith(
        name: name.text,
        description: description.text,
      );
      var r = await repository.insertWarehouse(warehouse);
      if (Get.isRegistered<WarehouseDetailsController>()) {
        Get.find<WarehouseDetailsController>().warehouse = warehouse.copyWith();
      }
      if (Get.isRegistered<WarehouseController>()) {
        Get.find<WarehouseController>().getAll();
      }
      warehouse = warehouse.copyWith();
      onSuccess();
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
      // rethrow;
    }
  }

  bool get validate => name.text.length >= 3 && nameAr.text.length >= 3;
  void delete() async {
    var b = await deleteConfirmation();
    if (b != true) return;
    await repository.deleteWarehouse(warehouse);
    Get.find<WarehouseController>().getAll();
    Get.back();
  }

  void init(Warehouse? t) {
    warehouse = t ?? Warehouse();
    name = TextEditingController(text: warehouse.name ?? '');
    nameAr = TextEditingController(text: warehouse.nameAr ?? '');
    description = TextEditingController(text: warehouse.description ?? '');
  }
}
