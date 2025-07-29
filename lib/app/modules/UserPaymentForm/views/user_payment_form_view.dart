import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/UserPayment/controllers/user_payment_controller.dart';
import 'package:tracora/app/modules/UserPaymentForm/controllers/user_payment_form_controller.dart';
import 'package:tracora/app/modules/TransactionForm/views/product_shopping_view.dart';
import 'package:tracora/app/modules/TransactionForm/views/transaction_cart_bar.dart';
import 'package:tracora/app/modules/TransactionForm/views/transaction_checkout.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class UserPaymentFormView<T> extends GetView<UserPaymentFormController<T>> {
  const UserPaymentFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          margin: EdgeInsets.all(4),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            // border: Border.all(width: 0.2),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    // margin: EdgeInsets.all(8),
                    // padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            // border: Border.all(width: 0.5),
                            borderRadius: BorderRadius.circular(16),
                            color:
                                Get.find<HomeController>()
                                    .theme
                                    .scaffoldBackgroundColor,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 1,

                                color: Colors.black12,
                              ),
                            ],
                          ),
                          child: Obx(
                            () => InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: controller.selectUser,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        controller.user.circleAvatar(
                                          radius: 60,
                                        ),
                                        SizedBox(height: 8),
                                        Center(
                                          child:
                                              controller.user.id == null
                                                  ? Text(controller.select_user)
                                                  : Text(
                                                    '${controller.user.firstName ?? ''} | ${controller.user.companyName ?? ''}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                        ),

                                        controller.user.id == null
                                            ? Text(' ')
                                            : Center(
                                              child: Text(
                                                '${'credit'.tr} | ${controller.user.toPay.formatPrice()}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      controller.user.toPay <= 0
                                                          ? Colors.green
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
                        ),

                        Obx(
                          () => ListTile(
                            title: Text('current_credit'),
                            trailing: Text(
                              controller.user.toPay.formatPrice() ??
                                  0.formatPrice()!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                        controller.transaction.id == null
                            ? SizedBox()
                            : Obx(
                              () => ListTile(
                                title: Text('old_credit'),
                                trailing: Text(
                                  controller.transaction.credit.formatPrice() ??
                                      0.formatPrice()!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.orange,
                                  ),
                                ),
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
                                controller.dateTime.formatDate() ??
                                    '-- / -- / ----',
                              ),
                      trailing: OutlinedButton.icon(
                        icon: Icon(Icons.edit_calendar),
                        onPressed: controller.editTime,
                        label: Text('edit'),
                      ),
                    ),
                  ),
                  GetBuilder<UserPaymentFormController<T>>(
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
                                  (controller.user.toPay).floor().toString();
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
                        Get.find<HomeController>()
                            .dark
                            .colorScheme
                            .primaryContainer,
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
          ),
        ),
      ),
    );
  }
}
