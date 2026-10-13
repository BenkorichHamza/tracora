import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/TransactionForm/views/cart_list_transaction_button.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class TransactionCheckoutPage<T>
    extends GetView<StockTransactionController<T>> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => ListView(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              // padding: EdgeInsets.all(8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  T == Transfert
                      ? SizedBox()
                      : DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color:
                              Get.find<HomeController>()
                                  .theme
                                  .colorScheme
                                  .surfaceContainer,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: controller.selectUser,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: (controller.selectedForm.user ??
                                      UserModel())
                                  .circleAvatar(radius: 28),

                              title:
                                  controller.selectedForm.user?.id == null
                                      ? Text(
                                        'select_user'.tr,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                      : Text(
                                        controller
                                                .selectedForm
                                                .user
                                                ?.firstName ??
                                            '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          // color: Colors.white,
                                        ),
                                      ),

                              trailing:
                                  controller.selectedForm.user?.id == null
                                      ? const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 18,
                                        color: Colors.white70,
                                      )
                                      : controller.transactionType ==
                                              "transfert" ||
                                          controller.selectedForm.user?.id ==
                                              null
                                      ? null
                                      : Text(
                                        '${'credit'.tr} ${controller.selectedForm.user?.toPay.formatPrice()}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              (controller
                                                              .selectedForm
                                                              .user
                                                              ?.toPay ??
                                                          0) <=
                                                      0
                                                  ? null
                                                  : Colors.deepOrange,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ),
                  T == Purchase ? SizedBox() : SizedBox(height: 8),
                  T == Purchase
                      ? SizedBox()
                      : DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color:
                              Get.find<HomeController>()
                                  .theme
                                  .colorScheme
                                  .surfaceContainer,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: controller.selectFromWarehouse,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: Icon(Icons.warehouse_outlined),

                              title:
                                  controller.selectedForm.fromWarehouse?.id ==
                                          null
                                      ? Text(
                                        'select_from_warehouse'.tr,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                      : Text(
                                        controller
                                                .selectedForm
                                                .fromWarehouse
                                                ?.name ??
                                            '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          // color: Colors.white,
                                        ),
                                      ),

                              subtitle:
                                  controller.selectedForm.fromWarehouse?.id ==
                                          null
                                      ? null
                                      : Text(
                                        controller
                                                .selectedForm
                                                .fromWarehouse
                                                ?.description ??
                                            '',
                                      ),

                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 18,
                                // color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ),
                  T == Sale ? SizedBox() : SizedBox(height: 8),
                  T == Sale
                      ? SizedBox()
                      : DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color:
                              Get.find<HomeController>()
                                  .theme
                                  .colorScheme
                                  .surfaceContainer,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: controller.selectToWarehouse,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: Icon(Icons.warehouse_outlined),

                              title:
                                  controller.selectedForm.toWarehouse?.id ==
                                          null
                                      ? Text(
                                        'select_to_warehouse'.tr,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                      : Text(
                                        controller
                                                .selectedForm
                                                .toWarehouse
                                                ?.name ??
                                            '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          // color: Colors.white,
                                        ),
                                      ),

                              subtitle:
                                  controller.selectedForm.toWarehouse?.id ==
                                          null
                                      ? null
                                      : Text(
                                        controller
                                                .selectedForm
                                                .toWarehouse
                                                ?.description ??
                                            '',
                                      ),

                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 18,
                                // color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ),

                  ...List.generate(
                    (controller.selectedForm.productTransactions ?? []).length,
                    (i) {
                      var transaction =
                          (controller.selectedForm.productTransactions ??
                              [])[i];
                      return cartItem(transaction);
                    },
                  ),
                  Divider(),
                  controller.transactionType == "transfert"
                      ? SizedBox()
                      : ListTile(
                        title: Text('total'),
                        trailing: Text(
                          controller.selectedForm.total.formatPrice()!,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                  controller.transactionType == "transfert"
                      ? SizedBox()
                      : ListTile(
                        title: Text('old_credit'),
                        trailing: Text(
                          controller.selectedForm.stockTransaction.id == null
                              ? (controller.selectedForm.user?.toPay ?? 0)
                                  .formatPrice()
                              : controller.selectedForm.stockTransaction?.credit
                                      .formatPrice() ??
                                  0.formatPrice()!,
                          style: TextStyle(fontSize: 16, color: Colors.orange),
                        ),
                      ),
                  controller.transactionType == "transfert"
                      ? SizedBox()
                      : ListTile(
                        title: Text('topay'.tr),
                        trailing: Text(
                          (controller.selectedForm.total +
                                      (controller.selectedForm.user?.toPay ??
                                          0))
                                  .formatPrice() ??
                              0.formatPrice()!,
                          style: TextStyle(fontSize: 18, color: Colors.green),
                        ),
                      ),
                ],
              ),
            ),

            Obx(
              () => ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () => controller.editTime(),
                leading: Icon(Icons.calendar_month),
                title:
                    controller.selectedForm.dateTime == 0
                        ? Text('select_date'.tr)
                        : Text(
                          controller.selectedForm.dateTime.formatDate() ??
                              '-- / -- / ----',
                        ),
                trailing: OutlinedButton.icon(
                  icon: Icon(Icons.edit_calendar),
                  onPressed: controller.editTime,
                  label: Text('edit'),
                ),
              ),
            ),
            controller.transactionType == "transfert"
                ? SizedBox()
                : GetBuilder<StockTransactionController<T>>(
                  id: 'checkout',
                  init: controller,
                  initState: (_) {},
                  builder: (_) {
                    return TextFormField(
                      textDirection: TextDirection.ltr,
                      autovalidateMode: AutovalidateMode.disabled,
                      controller: controller.selectedForm.payment,
                      focusNode: controller.selectedForm.paymentFn,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final text = newValue.text;
                          if (text.contains('.')) {
                            return oldValue;
                          }
                          if (text.startsWith('0') && text.length > 1) {
                            return TextEditingValue(text: text.substring(1));
                          }
                          if (text.startsWith('.')) {
                            return oldValue;
                          }

                          if (text.characters.where((c) => c == ".").length >
                              1) {
                            return oldValue;
                          }

                          return newValue;
                        }),
                      ],
                      onChanged: (v) => controller.update(['checkout']),
                      decoration: InputDecoration(
                        error:
                            int.tryParse(
                                      controller.selectedForm.payment.text,
                                    ) !=
                                    null
                                ? null
                                : SizedBox(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // label: Text('${'payment'.tr}'),
                        prefixIcon: TextButton(
                          onPressed: () {
                            controller.selectedForm.payment.text =
                                ((controller.selectedForm.user?.toPay ?? 0) +
                                        controller.total)
                                    .floor()
                                    .toString();
                            controller.update(['checkout']);
                          },
                          child: Text('pay_all'.tr),
                        ),
                        suffix: Text(
                          '${'dzd'.tr} ',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color:
                  Get.find<HomeController>().dark.colorScheme.primaryContainer,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: controller.save,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      'validate_transaction'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cartItem(ProductTransaction transaction) {
    var product = transaction.product;
    return ListTile(
      onTap: () {
        controller.setQte(product ?? Product());
      },
      subtitle: Text((transaction.price ?? 0).formatPrice() ?? ''),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

      contentPadding: EdgeInsets.only(right: 8, top: 0, bottom: 0, left: 8),
      leading: product?.leading(),
      title: Text(product?.translateName ?? 'product'.tr),
      trailing: CartListButton<T>(product: product ?? Product()),
    );
  }
}
