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
      child: Obx(
        () =>
            controller.moneyTransaction.id == null
                ? Scaffold()
                : Scaffold(
                  appBar: AppBar(
                    backgroundColor:
                        Get.find<HomeController>()
                            .dark
                            .colorScheme
                            .primaryContainer,
                    foregroundColor: Colors.white,
                    title: Text(
                      controller.moneyTransaction.description ??
                          'fees_payment'.tr,
                    ),
                    actions: [
                      IconButton(
                        onPressed: controller.edit,
                        icon: Icon(Icons.edit),
                        color: Colors.white,
                      ),
                      IconButton(
                        onPressed: controller.delete,
                        icon: Icon(Icons.delete),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  body: Obx(
                    () =>
                        controller.loading
                            ? Center(child: CircularProgressIndicator())
                            : Column(
                              children: [
                                Expanded(
                                  child: ListView(
                                    children: [
                                      Container(
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          color: Colors.transparent,

                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: AssetImage(
                                              "assets/reduction.png",
                                            ),
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => ListTile(
                                          leading: Icon(Icons.money),

                                          title: Text(
                                            controller
                                                    .moneyTransaction
                                                    .description ??
                                                'fees_payment'.tr,
                                          ),
                                          subtitle: Text('description'.tr),
                                        ),
                                      ),
                                      Obx(
                                        () => ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          leading: Icon(Icons.calendar_month),
                                          title:
                                              (controller
                                                              .moneyTransaction
                                                              .dateTime ??
                                                          0) ==
                                                      0
                                                  ? Text(
                                                    controller
                                                            .moneyTransaction
                                                            .createdAt
                                                            ?.formatDateTime() ??
                                                        '-- / -- / ----',
                                                  )
                                                  : Text(
                                                    controller
                                                            .moneyTransaction
                                                            .dateTime
                                                            .formatDate() ??
                                                        '-- / -- / ----',
                                                  ),
                                          subtitle: Text('date'.tr),
                                        ),
                                      ),

                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),

                                        child: Column(
                                          children: [
                                            Text(
                                              ((controller
                                                              .moneyTransaction
                                                              .amount ??
                                                          0))
                                                      .formatPrice() ??
                                                  '0 DA',
                                              style: TextStyle(
                                                fontSize: 36,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text('payment'.tr),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        icon: Icon(Icons.print_outlined),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 18,
                                          ),
                                          backgroundColor:
                                              Get.find<HomeController>()
                                                  .dark
                                                  .colorScheme
                                                  .primaryContainer,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: controller.print,
                                        label: Text('print_ticket'.tr),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        icon: Icon(Icons.edit),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 18,
                                          ),
                                          backgroundColor: Colors.orange,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: controller.edit,
                                        label: Text('edit_sale'.tr),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        icon: Icon(Icons.delete_outline),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 18,
                                          ),
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: controller.delete,
                                        label: Text('delete_sale'.tr),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                  ),
                ),
      ),
    );
  }
}
