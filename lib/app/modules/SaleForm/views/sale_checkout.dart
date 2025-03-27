import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/SaleForm/views/cart_list_sale_button.dart';
import 'package:tracora/app/modules/SaleForm/controllers/sale_form_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';

class SaleCheckoutPage extends GetView<SaleFormController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("checkout".tr),
      //   centerTitle: true,
      //   backgroundColor:
      //       Get.find<HomeController>().theme.scaffoldBackgroundColor,
      // ),
      body: Obx(
        () => ListView(
          children: [
            Container(
              // margin: EdgeInsets.all(8),
              // padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
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
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: controller.selectCustomer,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                controller.customer.circleAvatar(radius: 60),
                                SizedBox(height: 8),
                                Center(
                                  child:
                                      controller.customer.id == null
                                          ? Text('select_customer'.tr)
                                          : Text(
                                            '${controller.customer.firstName ?? ''} | ${controller.customer.companyName ?? ''}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                ),

                                controller.customer.id == null
                                    ? Text(' ')
                                    : Center(
                                      child: Text(
                                        '${'credit'.tr} | ${controller.customer.toPay.formatPrice()}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              controller.customer.toPay <= 0
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

                  ...List.generate(controller.productTransactions.length, (i) {
                    var transaction = controller.productTransactions[i];
                    return cartItem(transaction);
                  }),
                  Divider(),
                  ListTile(
                    title: Text('total'),
                    trailing: Text(
                      controller.total.formatPrice()!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    title: Text('old_credit'),
                    trailing: Text(
                      controller.customer.toPay.formatPrice() ??
                          0.formatPrice()!,
                      style: TextStyle(fontSize: 16, color: Colors.orange),
                    ),
                  ),
                  ListTile(
                    title: Text('topay'.tr),
                    trailing: Text(
                      (controller.total + controller.customer.toPay)
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
            GetBuilder<SaleFormController>(
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

                      if (text.characters.where((c) => c == ".").length > 1) {
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
                            (controller.customer.toPay + controller.total)
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
                      'validate_sale'.tr,
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
      subtitle: Text(product?.sellPrice.formatPrice() ?? ''),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

      contentPadding: EdgeInsets.only(right: 8, top: 0, bottom: 0, left: 8),
      leading: product?.leading(),
      title: Text(product?.translateName ?? 'product'.tr),
      trailing: CartListSaleButton(product: product ?? Product()),
    );
  }
}
