import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/user_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/modules/CustomerDetails/controllers/user_details_controller.dart';
import 'package:tracora/app/modules/UserForm/controllers/user_form_controller.dart';

class UserController<T> extends GetxController {
  final repository = UserRepository<T>();
  String get userType =>
      T == Sale || T == Customer
          ? "customer"
          : T == Purchase || T == Supplier
          ? "supplier"
          : "employee";
  String get transactionType =>
      T == Sale || T == Customer
          ? "sale"
          : T == Purchase || T == Supplier
          ? "purchase"
          : "mission";
  final _users = <UserModel>[].obs;
  List<UserModel> get users => this._users.value;
  set users(List<UserModel> value) => this._users.value = value;

  final _showForm = false.obs;
  bool get showForm => this._showForm.value;
  set showForm(bool value) => this._showForm.value = value;

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _showSearch = false.obs;
  bool get showSearch => this._showSearch.value;

  TextEditingController search = TextEditingController();
  set showSearch(bool value) => this._showSearch.value = value;

  get detailsController =>
      transactionType == "purchase"
          ? Get.find<UserDetailsController<Supplier>>()
          : Get.find<UserDetailsController<Customer>>();
  delete() async {
    if (selected.id == null) return;
    var b = await deleteConfirmation();
    if (b != true) return;
    await UserRepository().deleteUser(selected);
    Get.find<UserController<T>>().getAll();
    Get.find<UserDetailsController<T>>().user = UserModel();

    Get.back(result: true);
  }

  edit() {
    Get.find<UserFormController<T>>().init(selected);
    Get.find<UserController<T>>().showForm = true;
  }

  newIntent() {
    showForm = true;
  }

  editIntent() {
    edit();
  }

  escapeIntent() {
    showForm = false;
    Get.find<UserFormController<T>>().init(UserModel());
  }

  saveIntent() {
    Get.find<UserFormController<T>>().save(() {
      showForm = false;
      Get.find<UserFormController<T>>().init(UserModel());
    });
  }

  saveAndNewIntent() {
    Get.find<UserFormController<T>>().save(() {});
  }

  deleteIntent() {
    if (selected.id == null) return;
    if (showForm) return;
    delete();
  }

  searchIntent() {
    showSearch = !showSearch;
    searchFn.requestFocus();
  }

  nextIntent() {
    next();
  }

  previousIntent() {
    previous();
  }

  printIntent() {
    print("not implemented ....");
  }

  next() {
    var i = users.indexWhere((e) => e.id == selected.id);
    if (i >= users.length - 1) return;

    toDetails(users[i + 1]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = selectedKey.currentContext;
      if (context == null) return;
      if (!scrollController.hasClients) return;

      // 2. Grab just the inner scroll position
      final position = scrollController.position;
      var renderObject = context.findRenderObject()!;
      // 3. Ask *that* position to ensure your item’s RenderObject is visible

      RenderAbstractViewport viewport = RenderAbstractViewport.of(renderObject);
      var offsetToRevealBottom = viewport.getOffsetToReveal(renderObject, 1.0);
      var offsetToRevealTop = viewport.getOffsetToReveal(renderObject, 0.0);

      if (offsetToRevealBottom.offset + 1 > scrollController.position.pixels) {
        print("aaaaaaaaaaaaaaaaaaa");
        scrollController.animateTo(
          offsetToRevealBottom.offset,
          duration: Duration(milliseconds: 10),
          curve: Curves.linear,
        );
      }
    });
  }

  previous() {
    var i = users.indexWhere((e) => e.id == selected.id);
    if (i == 0) return;
    toDetails(users[i - 1]);
    final context = selectedKey.currentContext;
    if (context == null) return;
    if (!scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final position = scrollController.position;
      var renderObject = context.findRenderObject()!;
      // 3. Ask *that* position to ensure your item’s RenderObject is visible

      RenderAbstractViewport viewport = RenderAbstractViewport.of(renderObject);
      var offsetToRevealBottom = viewport.getOffsetToReveal(renderObject, 1.0);
      var offsetToRevealTop = viewport.getOffsetToReveal(renderObject, 0.0);

      if (offsetToRevealTop.offset - 30 < scrollController.position.pixels) {
        print("aaaaaaaaaaaaaaaaaaa");
        scrollController.animateTo(
          offsetToRevealTop.offset,
          duration: Duration(milliseconds: 10),
          curve: Curves.linear,
        );
      }
    });
  }

  final _selected = UserModel().obs;
  UserModel get selected => this._selected.value;
  set selected(UserModel value) => this._selected.value = value;

  String get title =>
      transactionType == "sale"
          ? "customers".tr
          : transactionType == "purchase"
          ? "suppliers".tr
          : "employees".tr;

  String get newTitle =>
      transactionType == "sale"
          ? "new_customer".tr
          : transactionType == "purchase"
          ? "new_supplier".tr
          : "new_employee".tr;

  void toDetails(UserModel user) async {
    if (Get.arguments?["select"] == true) {
      Get.back(result: user);
      return;
    }
    var id = selected.id;
    selected = user;
    update(['item_${user.id}', 'item_$id']);
    Get.find<UserDetailsController<T>>().user = user;
    Get.find<UserDetailsController<T>>().getMoneyTransactions();
    Get.find<UserDetailsController<T>>().getProductTransactions();
    Get.find<UserDetailsController<T>>().getStockTransactions();
    Get.find<UserDetailsController<T>>().getStockTransactionsByEmployee();
    Get.find<UserDetailsController<T>>().getEmployeeMoneyTransactions();
  }

  late StreamSubscription listener;
  late GlobalKey selectedKey;
  late FocusNode searchFn;
  late ScrollController scrollController;

  @override
  void onInit() {
    selectedKey = GlobalKey();
    scrollController = ScrollController();
    searchFn = FocusNode();

    super.onInit();
    getAll();
    // listen();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    // try {
    //   listener.cancel();
    // } on Exception catch (e) {
    //   // TODO
    // }
  }

  getAll() async {
    try {
      loading = true;
      users = await repository.getAllUsers(search: search.text);
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }

  listen() async {
    // try {
    //   listener.cancel();
    // } catch (e) {}
    // listener = FirebaseFirestore.instance
    //     .collection('users')
    //     .where("type", isEqualTo: "$userType")
    //     .snapshots(includeMetadataChanges: true)
    //     .listen((data) async {
    //       if (data.metadata.isFromCache) return;
    //       await Future.forEach(data.docs, (element) async {
    //         element.data()?["remoteId"] = element.data()?["id"];
    //         var model = UserModel.fromMap(element.data()!);
    //         await repository.insertUser(model);
    //       });
    //       getAll();
    //     });
  }
}
