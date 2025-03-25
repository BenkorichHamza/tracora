import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/mission_model.dart';

class MissionController extends GetxController {
  final _missions = <Mission>[].obs;
  List<Mission> get missions => this._missions.value;
  set missions(List<Mission> value) => this._missions.value = value;

  @override
  void onInit() {
    listen();
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

  listen() {
    FirebaseFirestore.instance.collection("missions").snapshots().listen((
      data,
    ) {
      missions = data.docs.map((e) => Mission.fromMap(e.data())).toList();
    });
  }
}
