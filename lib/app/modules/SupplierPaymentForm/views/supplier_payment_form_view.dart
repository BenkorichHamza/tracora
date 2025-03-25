import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

import '../controllers/supplier_payment_form_controller.dart';

class SupplierPaymentFormView extends GetView<SupplierPaymentFormController> {
  const SupplierPaymentFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("supplier_payment".tr),
        centerTitle: true,
        backgroundColor:
            Get.find<HomeController>().theme.scaffoldBackgroundColor,
      ),
      body: Obx(
        () => ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: controller.sellectSupplier,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            controller.supplier.circleAvatar(radius: 60),
                            SizedBox(height: 8),
                            Center(
                              child:
                                  controller.supplier.id == null
                                      ? Text('select_supplier'.tr)
                                      : Text(
                                        '${controller.supplier.firstName ?? ''} | ${controller.supplier.companyName ?? ''}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                            ),

                            controller.supplier.id == null
                                ? Text(' ')
                                : Center(
                                  child: Text(
                                    '${'credit'.tr} | ${controller.supplier.toPay.formatPrice()}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          controller.supplier.toPay <= 0
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Obx(
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
            ),
            GetBuilder<SupplierPaymentFormController>(
              id: 'checkout',
              init: controller,
              initState: (_) {},
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: TextFormField(
                    textDirection: TextDirection.ltr,
                    autovalidateMode: AutovalidateMode.disabled,
                    controller: controller.payment,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                        borderRadius: BorderRadius.circular(100),
                      ),
                      // label: Text('${'payment'.tr}'),
                      prefixIcon: TextButton(
                        onPressed: () {
                          controller.payment.text =
                              (controller.supplier.toPay).floor().toString();
                          controller.update(['checkout']);
                        },
                        child: Text('pay_all'.tr),
                      ),
                      suffix: Text(
                        '${'dzd'.tr} ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                color:
                    Get.find<HomeController>()
                        .dark
                        .colorScheme
                        .primaryContainer,
                child: InkWell(
                  borderRadius: BorderRadius.circular(32),
                  onTap: controller.save,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'pay'.tr,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
}
