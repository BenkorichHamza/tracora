import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';

class SupplierPaymentDetailsController extends GetxController {
  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _changed = false.obs;
  bool get changed => this._changed.value;
  set changed(bool value) => this._changed.value = value;

  final MoneyTransactionRepository repository = MoneyTransactionRepository();
  final _moneyTransaction = MoneyTransaction().obs;
  MoneyTransaction get moneyTransaction => this._moneyTransaction.value;

  UserModel get user => moneyTransaction.user ?? UserModel();
  set moneyTransaction(MoneyTransaction value) =>
      this._moneyTransaction.value = value;

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
    Get.back(result: true);
  }

  getMoneyTransaction() async {
    try {
      var r = await MoneyTransactionRepository().getMoneyTransactionsById(
        id: moneyTransaction.id ?? 0,
      );
      moneyTransaction = r ?? moneyTransaction;
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    }
  }
}
