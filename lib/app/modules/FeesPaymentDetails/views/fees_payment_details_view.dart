import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/FeesPaymentDetails/controllers/fees_payment_details_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';

class FeesPaymentDetailsView extends GetView<FeesPaymentDetailsController> {
  const FeesPaymentDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              Get.find<HomeController>().theme.scaffoldBackgroundColor,
          title: Text(
            controller.moneyTransaction.description ?? 'fees_payment'.tr,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.lazyPut(() => ProductController());
                controller.changed = true;
                Get.toNamed(Routes.FEES_PAYMENT_FORM, arguments: Get.arguments);
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(onPressed: controller.delete, icon: Icon(Icons.delete)),
          ],
        ),
        body: Obx(
          () =>
              controller.loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Card(
                          color:
                              Get.find<HomeController>().isDark
                                  ? Get.find<HomeController>()
                                      .theme
                                      .colorScheme
                                      .surfaceContainerHigh
                                  : null,
                          clipBehavior: Clip.antiAlias,
                          child: Obx(
                            () => ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              leading: CircleAvatar(
                                radius: 27,
                                backgroundColor: Colors.transparent,
                                child: Icon(Icons.money),
                              ),

                              title: Text(
                                controller.moneyTransaction.description ??
                                    'fees_payment'.tr,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Card(
                          color:
                              Get.find<HomeController>().isDark
                                  ? Get.find<HomeController>()
                                      .theme
                                      .colorScheme
                                      .surfaceContainerHigh
                                  : null,
                          clipBehavior: Clip.antiAlias,
                          child: Obx(
                            () => ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              leading: Icon(Icons.calendar_month),
                              title:
                                  (controller.moneyTransaction.dateTime ?? 0) ==
                                          0
                                      ? Text(
                                        controller.moneyTransaction.createdAt
                                                ?.formatDateTime() ??
                                            '-- / -- / ----',
                                      )
                                      : Text(
                                        controller.moneyTransaction.dateTime
                                                .formatDate() ??
                                            '-- / -- / ----',
                                      ),
                            ),
                          ),
                        ),
                      ),

                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('payment'.tr),
                              trailing: Text(
                                ((controller.moneyTransaction.amount ?? 0))
                                        .formatPrice() ??
                                    '0 DA',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
