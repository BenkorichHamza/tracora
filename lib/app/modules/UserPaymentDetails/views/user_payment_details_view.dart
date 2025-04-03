import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/UserPaymentDetails/controllers/user_payment_details_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';

class UserPaymentDetailsView<T>
    extends GetView<UserPaymentDetailsController<T>> {
  const UserPaymentDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Obx(
        () =>
            controller.moneyTransaction.id == null
                ? Scaffold()
                : Scaffold(
                  appBar: AppBar(
                    foregroundColor: Colors.white,
                    title: Text(
                      ((controller.moneyTransaction.dateTime ??
                                  controller.moneyTransaction.createdAt)
                              ?.formatDate() ??
                          ''),
                    ),
                    backgroundColor:
                        Get.find<HomeController>()
                            .dark
                            .colorScheme
                            .primaryContainer,
                  ),
                  body: Obx(
                    () =>
                        controller.loading
                            ? Center(child: CircularProgressIndicator())
                            : Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),

                                      child: Obx(
                                        () => Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            controller.moneyTransaction.user
                                                    ?.circleAvatar(
                                                      radius: 60,
                                                    ) ??
                                                SizedBox(),
                                            Center(
                                              child: Text(
                                                '${controller.moneyTransaction.user?.firstName} | ${controller.moneyTransaction.user?.companyName}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                'credit ${controller.moneyTransaction.user?.toPay.formatPrice()}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      controller
                                                                  .moneyTransaction
                                                                  .user
                                                                  ?.toPay ==
                                                              0
                                                          ? Colors.green
                                                          : (controller
                                                                      .moneyTransaction
                                                                      .user
                                                                      ?.toPay ??
                                                                  0) <
                                                              0
                                                          ? Colors.amber
                                                          : Colors.orange,
                                                ),
                                              ),
                                            ),

                                            ListTile(
                                              title: Text('old_credit'),
                                              trailing: Text(
                                                controller
                                                        .moneyTransaction
                                                        .credit
                                                        .formatPrice() ??
                                                    0.formatPrice()!,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                            ListTile(
                                              title: Text('payment'),
                                              trailing: Text(
                                                controller
                                                        .moneyTransaction
                                                        .amount
                                                        .formatPrice() ??
                                                    0.formatPrice()!,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
