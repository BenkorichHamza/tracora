import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

import '../controllers/fees_payment_form_controller.dart';

class FeesPaymentFormView extends GetView<FeesPaymentFormController> {
  const FeesPaymentFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("checkout".tr),
        backgroundColor:
            Get.find<HomeController>().theme.scaffoldBackgroundColor,
      ),
      body: Obx(
        () => ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Padding(
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
            ),

            GetBuilder<FeesPaymentFormController>(
              id: 'checkout',
              init: controller,
              initState: (_) {},
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  child: TextFormField(
                    textDirection: TextDirection.ltr,
                    autovalidateMode: AutovalidateMode.disabled,
                    controller: controller.description,

                    onChanged: (v) => controller.update(['checkout']),
                    decoration: InputDecoration(
                      error:
                          controller.description.text.length >= 3
                              ? null
                              : SizedBox(),
                      border: OutlineInputBorder(),
                      label: Text('   ${'title'.tr}'),
                    ),
                  ),
                );
              },
            ),
            GetBuilder<FeesPaymentFormController>(
              id: 'checkout',
              init: controller,
              initState: (_) {},
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
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
                      suffix: Text(
                        '${'dzd'.tr} ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              color:
                  Get.find<HomeController>().dark.colorScheme.primaryContainer,
              child: InkWell(
                borderRadius: BorderRadius.circular(64),
                onTap: controller.save,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'save'.tr,
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
          ],
        ),
      ),
    );
  }
}
