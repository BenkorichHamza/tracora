import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/stock_transaction_repository.dart';
import 'package:tracora/app/modules/CustomerDetails/controllers/user_details_controller.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_form_model.dart';
import 'package:tracora/app/modules/StockTransactionDetails/controllers/stock_transaction_details_controller.dart';
import 'package:tracora/app/modules/StockTransactionDetails/views/stock_transaction_details_view.dart';
import 'package:tracora/app/modules/TransactionForm/views/bottom_sheet_item_selector.dart';
import 'package:tracora/app/modules/User/controllers/user_controller.dart';
import 'package:tracora/app/modules/User/views/user_view.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class StockTransactionController<T> extends GetxController
    with GetTickerProviderStateMixin {
  final repository = StockTransactionRepository<T>();
  final _stockTransactions = <StockTransaction>[].obs;
  List<StockTransaction> get transactions => this._stockTransactions.value;
  set transactions(List<StockTransaction> value) =>
      this._stockTransactions.value = value;

  final _employee = UserModel().obs;
  UserModel get employee => this._employee.value;
  set employee(UserModel value) => this._employee.value = value;

  final _showForm = false.obs;
  bool get showForm => this._showForm.value;
  set showForm(bool value) => this._showForm.value = value;

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _showSearch = false.obs;
  bool get showSearch => this._showSearch.value;

  final _forms = <TransactionForm<T>>[].obs;
  List<TransactionForm<T>> get forms => this._forms.value;
  set forms(List<TransactionForm<T>> value) => this._forms.value = value;

  final _selectedFormIndex = (-1).obs;
  int get selectedFormIndex => this._selectedFormIndex.value;
  set selectedFormIndex(int value) => this._selectedFormIndex.value = value;

  TransactionForm<T> get selectedForm =>
      forms.firstWhereOrNull((e) => e.index == selectedFormIndex)!;

  addNewForm([StockTransaction? stockTransaction]) {
    forms.add(
      TransactionForm(
        index: forms.isNotEmpty ? forms.last.index + 1 : 0,
        stockTransaction: stockTransaction ?? StockTransaction(),
      ),
    );

    selectedFormIndex = forms.last.index;
    forms = forms.sublist(0);
  }

  deleteForm(int deleteIndex) {
    if (selectedFormIndex == deleteIndex) {
      var nb = forms.lastIndexWhere((e) => e.index < deleteIndex);
      if (nb == -1) {
        var na = forms.firstWhereOrNull((e) => e.index > deleteIndex);
        selectedFormIndex = na?.index ?? -1;
      } else {
        selectedFormIndex = forms[nb].index;
      }
    }
    forms.removeWhere((e) => e.index == deleteIndex);
    forms = List.from(forms);
  }

  get detailsController =>
      transactionType == "purchase"
          ? Get.find<StockTransactionDetailsController<Purchase>>()
          : Get.find<StockTransactionDetailsController<Sale>>();

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
  String get title =>
      transactionType == "sale"
          ? "sales".tr
          : transactionType == "purchase"
          ? "purchases".tr
          : "missions".tr;
  String get newTitle =>
      transactionType == "sale"
          ? "new_sale".tr
          : transactionType == "purchase"
          ? "new_purchase".tr
          : "new_mission".tr;
  delete() {
    if (selected.id == null) return;
    Get.find<StockTransactionDetailsController<T>>().delete();
  }

  late GlobalKey selectedKey;
  late ScrollController scrollController;

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

  TextEditingController search = TextEditingController();
  set showSearch(bool value) => this._showSearch.value = value;
  late StreamSubscription listener;
  late TabController tabCtrl;
  late FocusNode focusNode;
  late FocusNode searchFn;

  @override
  void onInit() {
    super.onInit();
    focusNode = FocusNode();
    searchFn = FocusNode();
    selectedKey = GlobalKey();
    scrollController = ScrollController();
    tabCtrl = TabController(length: 2, vsync: this);
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
      transactions = await repository.getAllTransactions(
        search: search.text,
        employee: employee,
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }

  listen() async {
    try {
      listener.cancel();
    } catch (e) {}
    listener = FirebaseFirestore.instance
        .collection('stockTransactions')
        .where("transactionType", isEqualTo: transactionType)
        // .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((data) async {
          if (data.metadata.isFromCache) return;
          await Future.forEach(data.docs, (element) async {
            element.data()?["remoteId"] = element.data()?["id"];
            var model = StockTransaction.fromMap(element.data()!);
            await repository.insert(model, sync: false);
          });
          getAll();
        });
  }

  final _selected = StockTransaction().obs;
  StockTransaction get selected => this._selected.value;
  set selected(StockTransaction value) => this._selected.value = value;

  double get total => (selectedForm.productTransactions ?? []).fold(
    0.0,
    (previousValue, element) =>
        previousValue + (element.qte ?? 0) * (element.price ?? 0),
  );

  void toDetails(StockTransaction transaction) async {
    var id = selected.id;
    selected = transaction;
    update(['item_${transaction.id}', 'item_$id']);
    Get.find<StockTransactionDetailsController<T>>().stockTransaction =
        transaction;
    Get.find<StockTransactionDetailsController<T>>().getProductTransactions();
    Get.find<StockTransactionDetailsController<T>>()
        .getMissionStockTransactions();

    Get.find<StockTransactionDetailsController<T>>()
        .getMissionMoneyTransactions();
    if (T == Mission) {
      // Get.find<StockTransactionDetailsController<T>>().listenToSales();
      // Get.find<StockTransactionDetailsController<T>>().listenToPayments();
      Get.find<StockTransactionDetailsController<T>>()
          .getMissionProductTransactions();
      Get.find<StockTransactionDetailsController<T>>().listenToSync();
    }
  }

  editTime() async {
    var r = await showDatePicker(
      context: Get.context!,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    var dt = r?.millisecondsSinceEpoch;
    var f = selectedForm.copyWith(dateTime: dt);
    replaceForm(f);
  }

  replaceForm(TransactionForm<T> f) {
    var index = forms.indexWhere((e) => e.index == f.index);
    forms[index] = f;
    forms = forms.sublist(0);
  }

  save() async {
    try {
      if (selectedForm.user?.id == null) {
        ErrorHandler.showError("select_user".tr);
        return;
      }
      if (double.tryParse(selectedForm.payment.text) == null &&
          transactionType != "mission") {
        ErrorHandler.showError("make_payment".tr);
        return;
      }
      if (!validate) return;
      if ((selectedForm.dateTime ?? 0) <= 0) {
        selectedForm.dateTime = DateTime.now().millisecondsSinceEpoch;
      }
      var n = selectedForm.stockTransaction.copyWith(
        user: selectedForm.user,
        topay: selectedForm.total,
        status: 1,
        total: total,
        productTransactions: selectedForm.productTransactions ?? [],
        payment: double.tryParse(selectedForm.payment.text),
        credit: selectedForm.user?.toPay ?? 0,
        tax: 0,
        dateTime: selectedForm.dateTime,
        type: transactionType,
      );
      var id = await repository.insert(n, mission: T == Mission);
      if (Get.isRegistered<StockTransactionController<T>>()) {
        Get.find<StockTransactionController<T>>().getAll();
      }

      if (Get.isRegistered<UserDetailsController<T>>()) {
        await Get.find<UserDetailsController<T>>().getProductTransactions();
        await Get.find<UserDetailsController<T>>().getStockTransactions();
        await Get.find<UserDetailsController<T>>().getUser();
      }
      n = n.copyWith(id: id <= 0 ? null : id, dateTime: selectedForm.dateTime);
      var f = selectedForm.copyWith(
        stockTransaction: selectedForm.stockTransaction.copyWith(id: id),
      );
      replaceForm(f);
      Get.find<StockTransactionController<T>>().showForm = false;
      Get.find<StockTransactionDetailsController<T>>().stockTransaction = n;
      Get.find<StockTransactionDetailsController<T>>().getStockTransaction();
      deleteForm(f.index);
      // init(StockTransaction());
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  bool get validate =>
      selectedForm.user?.id != null &&
      (int.tryParse(selectedForm.payment.text) != null ||
          transactionType == "mission") &&
      (selectedForm.productTransactions ?? []).isNotEmpty;

  selectUser() async {
    if (T == Sale || T == Customer) {
      Get.find<UserController<Customer>>().getAll();
    } else if (T == Purchase || T == Supplier) {
      Get.find<UserController<Supplier>>().getAll();
    } else {
      Get.find<UserController<Employee>>().getAll();
    }
    var r = await showDialog(
      routeSettings: RouteSettings(arguments: {"select": true}),
      context: Get.context!,
      builder:
          (c) => Dialog(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 450),
              child:
                  userType == "customer"
                      ? UserView<Customer>()
                      : userType == "supplier"
                      ? UserView<Supplier>()
                      : UserView<Employee>(),
            ),
          ),
    );
    if (r is UserModel && r.type == "$userType") {
      var f = selectedForm.copyWith(user: r);
      replaceForm(f);
    }
  }

  void increment(Product p) {
    var f = selectedForm.copyWith();
    List<ProductTransaction> productTransactions = (f.productTransactions ?? [])
        .sublist(0);
    var pt = productTransactions.firstWhereOrNull((e) => e.product?.id == p.id);
    if (pt == null) {
      pt = ProductTransaction(
        product: p,
        qte: 0,
        price: p.getPrice<T>(Get.find<HomeController>().sellMode),
      );
      productTransactions.insert(0, pt);
    }
    pt = pt.copyWith(qte: (pt.qte ?? 0) + 1);
    var i = productTransactions.indexWhere((e) => e.product?.id == p.id);
    productTransactions[i] = pt;
    productTransactions =
        productTransactions.where((e) => (e.qte ?? 0) > 0).toList();
    f.productTransactions = productTransactions;
    replaceForm(f);
    update(['shop_${p.id}']);
  }

  void decrement(Product p) {
    var f = selectedForm.copyWith();
    var pt = f.productTransactions?.firstWhereOrNull(
      (e) => e.product?.id == p.id,
    );
    if (pt == null) {
      pt = ProductTransaction(
        product: p,
        qte: 0,
        price: p.getPrice<T>(Get.find<HomeController>().sellMode),
      );
      (f.productTransactions ?? <ProductTransaction>[]).insert(0, pt);
    }
    if ((pt.qte ?? 0) <= 0) return;
    pt = pt.copyWith(qte: (pt.qte ?? 0) - 1);
    var i = (f.productTransactions ?? <ProductTransaction>[]).indexWhere(
      (e) => e.product?.id == p.id,
    );
    (f.productTransactions ?? [])[i] = pt;
    f.productTransactions = (f.productTransactions ?? [])
        .where((e) => (e.qte ?? 0) > 0)
        .toList()
        .sublist(0);
    replaceForm(f);
    update(['shop_${p.id}']);
  }

  double qteOf(Product product) {
    return (selectedForm.productTransactions ?? [])
            .firstWhereOrNull((e) => e.product?.id == product.id)
            ?.qte ??
        0;
  }

  ProductTransaction transactionOf(Product product) {
    return (selectedForm.productTransactions ?? []).firstWhereOrNull(
          (e) => e.product?.id == product.id,
        ) ??
        ProductTransaction(
          product: product,
          qte: 0,
          price: product.getPrice<T>(Get.find<HomeController>().sellMode) ?? 0,
        );
  }

  void setQte(Product product) async {
    var t = transactionOf(product);
    var f = selectedForm.copyWith();
    var r = await showModalBottomSheet(
      isScrollControlled: true,
      context: Get.context!,
      builder: (c) {
        return ItemBottomSheet<T>(productTransaction: t);
      },
    );
    if (selectedForm.productTransactions == null) {
      selectedForm.productTransactions = [];
    }
    if (r is! ProductTransaction) return;
    var i = selectedForm.productTransactions!.indexWhere(
      (e) => e.product?.id == product.id,
    );
    if (i < 0) {
      selectedForm.productTransactions!.add(
        t.copyWith(qte: r.qte, price: r.price),
      );
    } else {
      t = t.copyWith(qte: r.qte, price: r.price);
      selectedForm.productTransactions![i] = t;
      selectedForm.productTransactions =
          selectedForm.productTransactions!
              .where((e) => (e.qte ?? 0) > 0)
              .toList();
    }
    f.productTransactions = (selectedForm.productTransactions ?? []).sublist(0);
    replaceForm(f);
    update(['shop_${product.id}']);
    Get.find<ProductController>().searchFn.requestFocus();
  }

  // void init(StockTransaction stockTransaction) {
  //   selectedForm.stockTransaction = stockTransaction ?? StockTransaction();
  //   selectedForm.user = selectedForm.user ?? UserModel();
  //   // employee = transaction.employee ?? employee;
  //   selectedForm.productTransactions =
  //       selectedForm.stockTransaction.productTransactions ??
  //       <ProductTransaction>[];
  //   selectedForm.dateTime = selectedForm.stockTransaction.dateTime ?? 0;

  //   selectedForm.payment = TextEditingController(
  //     text: selectedForm.stockTransaction.payment?.floor().toString(),
  //   );
  //   selectedForm.paymentFn =
  //       FocusNode()..addListener(() {
  //         selectedForm.payment.selection = TextSelection(
  //           baseOffset: 0,
  //           extentOffset: selectedForm.payment.text.length,
  //         );
  //       });
  //   selectedForm.dateTime =
  //       selectedForm.stockTransaction.dateTime ??
  //       selectedForm.stockTransaction.createdAt ??
  //       selectedForm.dateTime;

  //   // getProductTransactions();
  // }

  newIntent() {
    addNewForm(StockTransaction());
  }

  editIntent() {
    if (selected.id == null) return;
    if (selectedFormIndex >= 0) return;
    if (forms.firstWhereOrNull((e) => e.stockTransaction.id == selected.id) !=
        null) {
      return;
    }
    addNewForm(selected);
  }

  escapeIntent() {
    deleteForm(selectedFormIndex);
  }

  saveIntent() {
    save();
  }

  saveAndNewIntent() {
    save();
  }

  deleteIntent() {
    if (selected.id == null) return;
    if (selectedFormIndex >= 0) return;
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
}
