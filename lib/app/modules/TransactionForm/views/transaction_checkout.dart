import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/TransactionForm/views/cart_list_transaction_button.dart';
import 'package:tracora/app/modules/TransactionForm/controllers/transaction_form_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class TransactionCheckoutPage<T> extends GetView<TransactionFormController<T>> {
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
                  DecoratedBox(
                    decoration: BoxDecoration(
                      // border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      color:
                          Get.find<HomeController>()
                              .dark
                              .colorScheme
                              .primaryContainer,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: controller.selectUser,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                controller.user.circleAvatar(radius: 40),
                                SizedBox(height: 8),
                                Center(
                                  child:
                                      controller.user.id == null
                                          ? Text('select_user'.tr)
                                          : Text(
                                            '${controller.user.firstName ?? ''} | ${controller.user.companyName ?? ''}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                ),

                                controller.transactionType == "mission"
                                    ? SizedBox()
                                    : controller.user.id == null
                                    ? Text(' ')
                                    : Center(
                                      child: Text(
                                        '${'credit'.tr} | ${controller.user.toPay.formatPrice()}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              controller.user.toPay <= 0
                                                  ? const Color.fromARGB(
                                                    255,
                                                    212,
                                                    255,
                                                    213,
                                                  )
                                                  : Colors.deepOrange,
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  ...List.generate(controller.productTransactions.length, (i) {
                    var transaction = controller.productTransactions[i];
                    return cartItem(transaction);
                  }),
                  Divider(),
                  controller.transactionType == "mission"
                      ? SizedBox()
                      : ListTile(
                        title: Text('total'),
                        trailing: Text(
                          controller.total.formatPrice()!,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                  controller.transactionType == "mission"
                      ? SizedBox()
                      : ListTile(
                        title: Text('old_credit'),
                        trailing: Text(
                          controller.user.toPay.formatPrice() ??
                              0.formatPrice()!,
                          style: TextStyle(fontSize: 16, color: Colors.orange),
                        ),
                      ),
                  controller.transactionType == "mission"
                      ? SizedBox()
                      : ListTile(
                        title: Text('topay'.tr),
                        trailing: Text(
                          (controller.total + controller.user.toPay)
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
                    controller.dateTime == 0
                        ? Text('select_date'.tr)
                        : Text(
                          controller.dateTime.formatDate() ?? '-- / -- / ----',
                        ),
                trailing: OutlinedButton.icon(
                  icon: Icon(Icons.edit_calendar),
                  onPressed: controller.editTime,
                  label: Text('edit'),
                ),
              ),
            ),
            controller.transactionType == "mission"
                ? SizedBox()
                : GetBuilder<TransactionFormController<T>>(
                  id: 'checkout',
                  init: controller,
                  initState: (_) {},
                  builder: (_) {
                    return TextFormField(
                      textDirection: TextDirection.ltr,
                      autovalidateMode: AutovalidateMode.disabled,
                      controller: controller.payment,
                      focusNode: controller.paymentFn,
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
                            int.tryParse(controller.payment.text) != null
                                ? null
                                : SizedBox(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // label: Text('${'payment'.tr}'),
                        prefixIcon: TextButton(
                          onPressed: () {
                            controller.payment.text =
                                (controller.user.toPay + controller.total)
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
