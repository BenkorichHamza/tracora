import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/SupplierPaymentDetails/controllers/supplier_payment_details_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';

class SupplierPaymentDetailsView
    extends GetView<SupplierPaymentDetailsController> {
  const SupplierPaymentDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              Get.find<HomeController>().theme.scaffoldBackgroundColor,
          actions: [
            IconButton(
              onPressed: () {
                Get.lazyPut(() => ProductController());
                controller.changed = true;
                Get.toNamed(
                  Routes.SUPPLIER_PAYMENT_FORM,
                  arguments: {"moneyTransaction": controller.moneyTransaction},
                );
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
                      Stack(
                        children: [
                          Column(
                            children: [
                              controller.user.circleAvatar(radius: 60),
                              SizedBox(height: 8),
                              Center(
                                child: Text(
                                  '${controller.user.firstName ?? ''} | ${controller.user.companyName ?? ''}',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                              // Center(
                              //   child: Text(
                              //     '${'credit'.tr} | ${controller.user.toPay.formatPrice()}',
                              //     style: TextStyle(
                              //       fontSize: 18,
                              //       fontWeight: FontWeight.bold,
                              //       color:
                              //           controller.user.toPay <= 0
                              //               ? Colors.green
                              //               : Colors.deepOrange,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 32),

                      Column(
                        children: [
                          Text(
                            ((controller.moneyTransaction.amount ?? 0))
                                    .formatPrice() ??
                                '0 DA',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text('payment'.tr),
                        ],
                      ),
                      Obx(
                        () => ListTile(
                          leading: Icon(Icons.calendar_month),
                          title: Text('date_time'.tr),
                          trailing:
                              (controller.moneyTransaction.dateTime ?? 0) == 0
                                  ? Text(
                                    controller.moneyTransaction.createdAt
                                            ?.formatDateTime() ??
                                        '-- / -- / ----',
                                    style: TextStyle(fontSize: 16),
                                  )
                                  : Text(
                                    controller.moneyTransaction.dateTime
                                            .formatDateTime() ??
                                        '-- / -- / ----',
                                    style: TextStyle(fontSize: 16),
                                  ),
                        ),
                      ),
                      Obx(
                        () => ListTile(
                          leading: Icon(Icons.calendar_month),
                          title: Text('updated_at'.tr),
                          trailing: Text(
                            controller.moneyTransaction.updatedAt
                                    ?.formatDateTime() ??
                                '-- / -- / ----',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Obx(
                        () => ListTile(
                          leading: Icon(Icons.calendar_month),
                          title: Text('created_at'.tr),
                          trailing: Text(
                            controller.moneyTransaction.createdAt
                                    ?.formatDateTime() ??
                                '-- / -- / ----',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
