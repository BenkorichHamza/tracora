import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/models/mission_model.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/modules/MissionForm/views/bottom_sheet_item_selector.dart';
import 'package:tracora/app/routes/app_pages.dart';

class MissionFormController extends GetxController {
  final _mission = Mission().obs;
  Mission get mission => this._mission.value;
  set mission(Mission value) => this._mission.value = value;

  final _dateTime = 0.obs;
  int get dateTime => this._dateTime.value;
  set dateTime(int value) => this._dateTime.value = value;

  final _user = UserModel().obs;
  UserModel get user => this._user.value;
  set user(UserModel value) => this._user.value = value;

  final _missionProducts = <MissionProduct>[].obs;
  List<MissionProduct> get missionProducts => this._missionProducts.value;
  set missionProducts(List<MissionProduct> value) =>
      this._missionProducts.value = value;

  @override
  void onInit() {
    if (Get.arguments?['mission'] is Mission) {
      mission = Get.arguments?["mission"] ?? mission;
      user = mission.user ?? user;
      missionProducts = mission.missionProducts ?? missionProducts;
    }

    dateTime = mission.dateTime ?? mission.createdAt ?? dateTime;
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

  editTime() async {
    var r = await showDatePicker(
      context: Get.context!,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    dateTime = r?.millisecondsSinceEpoch ?? dateTime;
  }

  void increment(Product p) {
    var pt = missionProducts.firstWhereOrNull((e) => e.product?.id == p.id);
    if (pt == null) {
      pt = MissionProduct(product: p, qte: 0);
      missionProducts.insert(0, pt);
    }
    pt = pt.copyWith(qte: (pt.qte ?? 0) + 1);
    var i = missionProducts.indexWhere((e) => e.product?.id == p.id);
    missionProducts[i] = pt;
    missionProducts = missionProducts
        .where((e) => (e.qte ?? 0) > 0)
        .toList()
        .sublist(0);
    update(['shop_${p.id}']);
  }

  void decrement(Product p) {
    var pt = missionProducts.firstWhereOrNull((e) => e.product?.id == p.id);
    if (pt == null) {
      pt = MissionProduct(product: p, qte: 0);
      missionProducts.insert(0, pt);
    }
    if ((pt.qte ?? 0) <= 0) return;
    pt = pt.copyWith(qte: (pt.qte ?? 0) - 1);
    var i = missionProducts.indexWhere((e) => e.product?.id == p.id);
    missionProducts[i] = pt;
    missionProducts = missionProducts
        .where((e) => (e.qte ?? 0) > 0)
        .toList()
        .sublist(0);
    update(['shop_${p.id}']);
  }

  double qteOf(Product product) {
    return missionProducts
            .firstWhereOrNull((e) => e.product?.id == product.id)
            ?.qte ??
        0;
  }

  MissionProduct transactionOf(Product product) {
    return missionProducts.firstWhereOrNull(
          (e) => e.product?.id == product.id,
        ) ??
        MissionProduct(product: product, qte: 0);
  }

  void setQte(Product product) async {
    var t = transactionOf(product);
    var r = await showModalBottomSheet(
      isScrollControlled: true,
      context: Get.context!,
      builder: (c) {
        return ItemBottomSheet(missionProduct: t);
      },
    );
    if (r is! MissionProduct) return;
    var i = missionProducts.indexWhere((e) => e.product?.id == product.id);
    if (i < 0) {
      missionProducts.add(t.copyWith(qte: r.qte));
    } else {
      t = t.copyWith(qte: r.qte);
      missionProducts[i] = t;
      missionProducts = missionProducts.where((e) => (e.qte ?? 0) > 0).toList();
    }
    missionProducts = missionProducts.sublist(0);
    update(['shop_${product.id}']);
  }

  buy() {}

  sellectSupplier() async {
    var r = await Get.toNamed(
      Routes.DRIVER,
      arguments: {"user": user, 'select': true},
    );
    if (r is UserModel) user = r;
  }

  save() async {
    try {
      if (user.id == null) {
        ErrorHandler.showError("select_user".tr);
        return;
      }

      if (!validate) return;
      if (dateTime <= 0) {
        dateTime = DateTime.now().millisecondsSinceEpoch;
      }
      var n = mission.copyWith(
        user: user,

        missionProducts: missionProducts,

        dateTime: dateTime,
      );
      if ((mission.ids ?? '').isNotEmpty) {
        FirebaseFirestore.instance
            .collection("missions")
            .doc(mission.ids)
            .set(n.toMap(), SetOptions(merge: true));
      } else {
        var ids = FirebaseFirestore.instance.collection("missions").doc().id;
        FirebaseFirestore.instance
            .collection("missions")
            .doc(ids)
            .set(n.copyWith(ids: ids).toMap());
      }
      Get.back();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  bool get validate => missionProducts.isNotEmpty;
}
