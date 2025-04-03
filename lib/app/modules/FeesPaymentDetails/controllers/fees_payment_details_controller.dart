import 'package:get/get.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/modules/FeesPayment/controllers/fees_payment_controller.dart';
import 'package:tracora/app/modules/FeesPaymentForm/controllers/fees_payment_form_controller.dart';

class FeesPaymentDetailsController extends GetxController {
  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _changed = false.obs;
  bool get changed => this._changed.value;
  set changed(bool value) => this._changed.value = value;

  final MoneyTransactionRepository repository = MoneyTransactionRepository();
  final _moneyTransaction = MoneyTransaction().obs;
  MoneyTransaction get moneyTransaction => this._moneyTransaction.value;
  set moneyTransaction(MoneyTransaction value) =>
      this._moneyTransaction.value = value;

  @override
  void onInit() {
    if (Get.arguments?['moneyTransaction'] is MoneyTransaction) {
      moneyTransaction = Get.arguments?["moneyTransaction"] ?? moneyTransaction;
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

  edit() {
    changed = true;
    Get.find<FeesPaymentFormController>().init(moneyTransaction);
    Get.find<FeesPaymentController>().showForm = true;
  }

  void print() {}
}
