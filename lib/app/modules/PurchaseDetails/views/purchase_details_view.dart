import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';

import '../controllers/purchase_details_controller.dart';

class PurchaseDetailsView extends GetView<PurchaseDetailsController> {
  const PurchaseDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            ((controller.purchase.dateTime ?? controller.purchase.createdAt)
                    ?.formatDate() ??
                ''),
          ),
          backgroundColor:
              Get.find<HomeController>().theme.scaffoldBackgroundColor,
          actions: [
            IconButton(
              onPressed: () {
                Get.lazyPut(() => ProductController());
                controller.changed = true;
                Get.toNamed(
                  Routes.PURCHASE_FORM,
                  arguments: {"purchase": controller.purchase},
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
                  : SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(8),

                        // border: Border.all(width: 0.5),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          controller.purchase.user?.circleAvatar(radius: 60) ??
                              SizedBox(),
                          Center(
                            child: Text(
                              '${controller.purchase.user?.firstName} | ${controller.purchase.user?.companyName}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Center(
                          //   child: Text(
                          //     '${'credit'.tr} | ${controller.purchase.user?.toPay.formatPrice()}',
                          //     style: TextStyle(
                          //       fontSize: 18,
                          //       fontWeight: FontWeight.bold,
                          //       color:
                          //           (controller.purchase.user?.toPay ?? 0) <= 0
                          //               ? Colors.green
                          //               : Colors.deepOrange,
                          //     ),
                          //   ),
                          // ),
                          ...List.generate(
                            controller.productTransactions.length,
                            (i) {
                              var transaction =
                                  controller.productTransactions[i];
                              return cartItem(transaction);
                            },
                          ),
                          Divider(),
                          ListTile(
                            title: Text('total'),
                            trailing: Text(
                              controller.purchase.total?.formatPrice() ??
                                  0.formatPrice()!,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          ListTile(
                            title: Text('old_credit'),
                            trailing: Text(
                              controller.purchase.user?.toPay.formatPrice() ??
                                  0.formatPrice()!,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          ListTile(
                            title: Text('payment'),
                            trailing: Text(
                              controller.purchase.payment.formatPrice() ??
                                  0.formatPrice()!,
                              style: TextStyle(fontSize: 16),
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

  Widget cartItem(ProductTransaction transaction) {
    var product = transaction.product;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: product?.leading(),
        contentPadding: EdgeInsets.symmetric(horizontal: 4),
        title: Text(product?.translateName ?? ''),
        trailing: SizedBox(
          width: 180,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'qte'.tr + ' ' + (transaction.qte.formatNumber() ?? '0'),
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              Expanded(
                child: Text(
                  (transaction.total.formatPrice() ?? '0'),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
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
