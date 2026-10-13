import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/modules/User/controllers/user_controller.dart';
import 'package:tracora/app/modules/User/views/user_view.dart';
import 'package:tracora/app/modules/UserPaymentDetails/controllers/user_payment_details_controller.dart';
import 'package:tracora/app/modules/UserPaymentForm/controllers/user_payment_form_controller.dart';

class UserPaymentController<T> extends GetxController {
  final repository = MoneyTransactionRepository();

  String get userType => T == Sale || T == Customer ? "customer" : "supplier";
  String get transactionType =>
      T == Sale || T == Customer ? "sale" : "purchase";
  final _moneyTransactions = <MoneyTransaction>[].obs;
  List<MoneyTransaction> get transactions => this._moneyTransactions.value;
  set transactions(List<MoneyTransaction> value) =>
      this._moneyTransactions.value = value;

  final _selected = MoneyTransaction().obs;
  MoneyTransaction get selected => this._selected.value;
  set selected(MoneyTransaction value) => this._selected.value = value;

  final _showForm = false.obs;
  bool get showForm => this._showForm.value;
  set showForm(bool value) => this._showForm.value = value;

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _employee = UserModel().obs;
  UserModel get employee => this._employee.value;
  set employee(UserModel value) => this._employee.value = value;

  final _showSearch = false.obs;
  bool get showSearch => this._showSearch.value;

  TextEditingController search = TextEditingController();
  set showSearch(bool value) => this._showSearch.value = value;

  get detailsController =>
      transactionType == "purchase"
          ? Get.find<UserPaymentDetailsController<Purchase>>()
          : Get.find<UserPaymentDetailsController<Sale>>();

  String get title =>
      transactionType == "sale"
          ? "customer_payments".tr
          : transactionType == "purchase"
          ? "supplier_payments".tr
          : "fees_payments".tr;
  String get newTitle =>
      transactionType == "sale"
          ? "new_payment".tr
          : transactionType == "purchase"
          ? "new_payment".tr
          : "new_pqy;ent".tr;

  // next() {
  //   var i = transactions.indexWhere((e) => e.id == selected.id);
  //   if (i >= transactions.length - 1) return;

  //   toDetails(transactions[i + 1]);
  // }

  // previous() {
  //   var i = transactions.indexWhere((e) => e.id == selected.id);
  //   if (i == 0) return;
  //   toDetails(transactions[i - 1]);
  // }
  next() {
    var i = transactions.indexWhere((e) => e.id == selected.id);
    if (i >= transactions.length - 1) return;

    toDetails(transactions[i + 1]);

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
    var i = transactions.indexWhere((e) => e.id == selected.id);
    if (i == 0) return;
    toDetails(transactions[i - 1]);
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

  delete() {
    if (selected.id == null) return;
    Get.find<UserPaymentDetailsController<T>>().delete();
  }

  late StreamSubscription listener;
  late FocusNode searchFn;
  late GlobalKey selectedKey;
  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    searchFn = FocusNode();
    selectedKey = GlobalKey();

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
  }

  selectEmployee() async {
    Get.find<UserController<Employee>>().getAll();

    var r = await showDialog(
      routeSettings: RouteSettings(arguments: {"select": true}),
      context: Get.context!,
      builder:
          (c) => Dialog(
            clipBehavior: Clip.antiAlias,

            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 450),
              child: UserView<Employee>(),
            ),
          ),
    );
    if (r is UserModel && r.type == "employee") {
      employee = r;
      getAll();
    }
  }

  getAll() async {
    try {
      loading = true;
      transactions = await repository.getMoneyTransactions(
        search: search.text,
        type: "$transactionType",
        employee: employee,
      );
      if (transactions.isNotEmpty) {
        selected = transactions.first;
        toDetails(selected);
      }
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
    //     .collection('moneyTransactions')
    //     .where("type", isEqualTo: "$transactionType")
    //     // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
    //     .snapshots(includeMetadataChanges: true)
    //     .listen((data) async {
    //       if (data.metadata.isFromCache) return;
    //       await Future.forEach(data.docs, (element) async {
    //         element.data()?["remoteId"] = element.data()?["id"];
    //         var model = MoneyTransaction.fromMap(element.data()!);
    //         await repository.insertMoneyTransaction(model);
    //       });
    //       getAll();
    //     });
  }

  void toDetails(MoneyTransaction transaction) async {
    var id = selected.id;
    selected = transaction;
    update(['item_${transaction.id}', 'item_$id']);
    Get.find<UserPaymentDetailsController<T>>().moneyTransaction = transaction;
  }

  searchIntent() {
    showSearch = !showSearch;
    searchFn.requestFocus();
  }

  newIntent() {
    showForm = true;
  }

  editIntent() {
    edit();
  }

  escapeIntent() {
    showForm = false;
    Get.find<UserPaymentFormController<T>>().init(MoneyTransaction());
  }

  saveIntent() {
    Get.find<UserPaymentFormController<T>>().save();
  }

  saveAndNewIntent() {
    Get.find<UserPaymentFormController<T>>().save();
  }

  deleteIntent() {
    if (selected.id == null) return;
    if (showForm) return;
    Get.find<UserPaymentDetailsController<T>>().delete();
  }

  edit() {
    if (selected.id == null) return;
    Get.find<UserPaymentDetailsController<T>>().edit();
    showForm = true;
  }
}
