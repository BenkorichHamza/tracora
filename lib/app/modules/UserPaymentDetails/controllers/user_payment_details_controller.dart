import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/modules/UserPaymentForm/controllers/user_payment_form_controller.dart';
import 'package:tracora/app/modules/UserPayment/controllers/user_payment_controller.dart';

class UserPaymentDetailsController<T> extends GetxController {
  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;
  String get userType => T == Sale || T == Customer ? "customer" : "supplier";
  String get transactionType =>
      T == Sale || T == Customer ? "sale" : "purchase";
  final _changed = false.obs;
  bool get changed => this._changed.value;
  set changed(bool value) => this._changed.value = value;

  final MoneyTransactionRepository repository = MoneyTransactionRepository();

  final _moneyTransaction = MoneyTransaction().obs;
  MoneyTransaction get moneyTransaction => this._moneyTransaction.value;
  set moneyTransaction(MoneyTransaction value) =>
      this._moneyTransaction.value = value;

  UserModel get user => moneyTransaction.user ?? UserModel();
  @override
  void onInit() {
    if (Get.arguments?['moneyTransaction'] is MoneyTransaction) {
      moneyTransaction = Get.arguments?["moneyTransaction"] ?? moneyTransaction;
    }
    if (moneyTransaction.id != null) {
      getMoneyTransaction();
    }
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

  delete() async {
    var b = await deleteConfirmation();
    if (b != true) return;
    await repository.deleteMoneyTransaction(moneyTransaction);
    Get.find<UserPaymentController<T>>().getAll();
    moneyTransaction = MoneyTransaction();
  }

  edit() {
    changed = true;
    Get.find<UserPaymentFormController<T>>().init(moneyTransaction);
    Get.find<UserPaymentController<T>>().showForm = true;
  }

  getMoneyTransaction() async {
    try {
      var r = await MoneyTransactionRepository().getMoneyTransactionsById(
        id: moneyTransaction.id ?? "",
      );
      moneyTransaction = r ?? moneyTransaction;
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  void approve() async {
    // await MoneyTransactionRepository().insertMoneyTransaction(
    //   moneyTransaction.copyWith(status: 1),
    // );
    // FirebaseFirestore.instance
    //     .collection("collections")
    //     .doc(Get.find<HomeController>().collection)
    //     .collection("missions")
    //     .doc(moneyTransaction.missionIds ?? "default")
    //     .collection("moneyTransactions")
    //     .doc(moneyTransaction.id ?? "default")
    //     .update({"status": 1})
    //     .catchError((e) {
    //       ErrorHandler.handleError(e);
    //     });
    // var missionsCtrl = Get.find<StockTransactionController<Transfert>>();
    // if (missionsCtrl.selected.id == null) return;
    // getMoneyTransaction();
    // missionsCtrl.toDetails(missionsCtrl.selected);
  }

  void printTicket() {}
}
