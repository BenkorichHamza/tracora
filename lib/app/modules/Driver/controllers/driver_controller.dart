import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/employee_model.dart';

class DriverController extends GetxController {
  //TODO: Implement DriverController

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _firstLoad = false.obs;
  bool get firstLoad => this._firstLoad.value;
  set firstLoad(bool value) => this._firstLoad.value = value;

  final _drivers = <EmployeeModel>[].obs;
  List<EmployeeModel> get drivers => this._drivers.value;
  set drivers(List<EmployeeModel> value) => this._drivers.value = value;

  late StreamSubscription listener;

  List<EmployeeModel> get filteredDrivers =>
      drivers
          .where((e) => e.id != FirebaseAuth.instance.currentUser?.uid)
          .toList();

  @override
  void onInit() {
    super.onInit();
    listen();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  listen() async {
    try {
      await listener.cancel();
    } catch (e) {}
    listener = FirebaseFirestore.instance
      .collection("employees")
      .snapshots()
      .listen((data) {
        drivers =
            data.docs.map((e) => EmployeeModel.fromMap(e.data())).toList();
        firstLoad = false;
      })..onError((e) => ErrorHandler.handleError(e));
  }
}
