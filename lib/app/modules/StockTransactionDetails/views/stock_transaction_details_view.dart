import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/widgets/product_transaction_tile.dart';
import 'package:tracora/app/widgets/qr_code.dart';
import 'package:tracora/app/widgets/user_tile.dart';

import '../controllers/stock_transaction_details_controller.dart';

class StockTransactionDetailsView<T>
    extends GetView<StockTransactionDetailsController<T>> {
  const StockTransactionDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Obx(
        () =>
            controller.stockTransaction.id == null
                ? Scaffold()
                : Scaffold(
                  appBar: AppBar(
                    foregroundColor: Colors.white,
                    title: Text(
                      ((controller.stockTransaction.dateTime ??
                                  controller.stockTransaction.createdAt)
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
                                            controller.stockTransaction.user
                                                    ?.circleAvatar(
                                                      radius: 60,
                                                    ) ??
                                                SizedBox(),
                                            Center(
                                              child: Text(
                                                '${controller.stockTransaction.user?.firstName} | ${controller.stockTransaction.user?.companyName}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            controller.transactionType ==
                                                    "mission"
                                                ? SizedBox()
                                                : Center(
                                                  child: Text(
                                                    'credit ${controller.stockTransaction.user?.toPay.formatPrice()}',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          controller
                                                                      .stockTransaction
                                                                      .user
                                                                      ?.toPay ==
                                                                  0
                                                              ? Colors.green
                                                              : (controller
                                                                          .stockTransaction
                                                                          .user
                                                                          ?.toPay ??
                                                                      0) <
                                                                  0
                                                              ? Colors.amber
                                                              : Colors.orange,
                                                    ),
                                                  ),
                                                ),

                                            ...List.generate(
                                              controller
                                                  .productTransactions
                                                  .length,
                                              (i) {
                                                return ProductTransactionTile(
                                                  productTransaction:
                                                      controller
                                                          .productTransactions[i],
                                                );
                                              },
                                            ),
                                            Divider(),
                                            controller.transactionType ==
                                                    "mission"
                                                ? SizedBox()
                                                : ListTile(
                                                  title: Text('total'),
                                                  trailing: Text(
                                                    controller
                                                            .stockTransaction
                                                            .total
                                                            ?.formatPrice() ??
                                                        0.formatPrice()!,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                            controller.transactionType ==
                                                    "mission"
                                                ? SizedBox()
                                                : ListTile(
                                                  title: Text('old_credit'),
                                                  trailing: Text(
                                                    controller
                                                            .stockTransaction
                                                            .credit
                                                            .formatPrice() ??
                                                        0.formatPrice()!,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                            controller.transactionType ==
                                                    "mission"
                                                ? SizedBox()
                                                : ListTile(
                                                  title: Text('payment'),
                                                  trailing: Text(
                                                    controller
                                                            .stockTransaction
                                                            .payment
                                                            .formatPrice() ??
                                                        0.formatPrice()!,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                            T != Mission
                                                ? SizedBox()
                                                : Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: QrCode(
                                                    controller
                                                            .stockTransaction
                                                            .ids ??
                                                        '123',
                                                    size: 200,
                                                  ),
                                                ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                UserTile(
                                  onTap: (v) {},
                                  item:
                                      controller.stockTransaction.employee ??
                                      UserModel(),
                                  highest: false,
                                  selected: false,
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
                                        onPressed: controller.printTicket,
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
