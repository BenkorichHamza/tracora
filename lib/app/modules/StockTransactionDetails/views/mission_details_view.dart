import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/StockTransactionDetails/views/stock_transaction_details_view.dart';
import 'package:tracora/app/modules/UserPayment/controllers/user_payment_controller.dart';
import 'package:tracora/app/modules/UserPaymentDetails/views/user_payment_details_view.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/widgets/empty_widget.dart';
import 'package:tracora/app/widgets/money_transaction_tile.dart';
import 'package:tracora/app/widgets/product_transaction_tile.dart';
import 'package:tracora/app/widgets/qr_code.dart';
import 'package:tracora/app/widgets/stock_transaction_tile.dart';

import '../controllers/stock_transaction_details_controller.dart';

class MissionDetailsView
    extends GetView<StockTransactionDetailsController<Mission>> {
  const MissionDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Obx(
        () =>
            controller.stockTransaction.id == null
                ? Scaffold()
                : Scaffold(
                  appBar: AppBar(
                    title: Text(
                      ((controller.stockTransaction.dateTime ??
                                  controller.stockTransaction.createdAt)
                              ?.formatDate() ??
                          ''),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Get.find<HomeController>()
                            .dark
                            .colorScheme
                            .primaryContainer,
                    bottom: TabBar(
                      labelColor: Colors.white,
                      indicatorColor: Colors.white,
                      unselectedLabelColor: Colors.white60,
                      controller: controller.tabCtrl,
                      tabs: [
                        Tab(
                          text: "details",
                          icon: Image.asset(
                            "assets/mission.png",
                            height: 25,
                            width: 25,
                          ),
                        ),
                        Tab(
                          text: "products",
                          icon: Image.asset(
                            "assets/inventory.png",
                            height: 25,
                            width: 25,
                          ),
                        ),
                        Tab(
                          text: "sales",
                          icon: Image.asset(
                            "assets/sales.png",
                            height: 25,
                            width: 25,
                          ),
                        ),

                        Tab(
                          text: "payments-in",
                          icon: Image.asset(
                            "assets/money-in.png",
                            height: 25,
                            width: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    controller: controller.tabCtrl,
                    children: [details(), products(), sales(), payments()],
                  ),
                ),
      ),
    );
  }

  sales() {
    return Obx(
      () =>
          controller.missionSales.isEmpty
              ? EmptyWidget()
              : Obx(
                () => ListView.builder(
                  itemCount:
                      controller.missionSales
                          .where((e) => e.type == "sale")
                          .length,
                  itemBuilder:
                      (c, i) => StockTransactionTile(
                        onTap: (t) {
                          showDialog(
                            context: Get.context!,

                            builder: (c) {
                              Get.find<StockTransactionController<Sale>>()
                                  .toDetails(t);
                              return Center(
                                child: Dialog(
                                  backgroundColor: Colors.transparent,
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 10,
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: 450),

                                    child: Center(
                                      child:
                                          StockTransactionDetailsView<Sale>(),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        item:
                            controller.missionSales
                                .where((e) => e.type == "sale")
                                .toList()[i],
                        highest: false,
                        selected: false,
                      ),
                ),
              ),
    );
  }

  payments() {
    return Obx(
      () =>
          controller.missionPayments.isEmpty
              ? EmptyWidget()
              : Obx(
                () => ListView.builder(
                  itemCount: controller.missionPayments.length,
                  itemBuilder:
                      (c, i) => MoneyTransactionTile(
                        onTap: (t) {
                          showDialog(
                            context: Get.context!,

                            builder: (c) {
                              Get.find<UserPaymentController<Sale>>().toDetails(
                                t,
                              );
                              return Center(
                                child: Dialog(
                                  backgroundColor: Colors.transparent,
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 10,
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: 450),

                                    child: Center(
                                      child: UserPaymentDetailsView<Sale>(),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        item: controller.missionPayments[i],
                        highest: false,
                        selected: false,
                      ),
                ),
              ),
    );
  }

  ListView products() {
    return ListView.builder(
      itemCount: controller.productTransactions.length,
      itemBuilder: (c, i) {
        var pt = controller.productTransactions[i];
        return ProductTransactionTile(productTransaction: pt);
      },
    );
  }

  Obx details() {
    return Obx(
      () =>
          controller.loading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.symmetric(vertical: 8),

                        child: Obx(
                          () => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              controller.stockTransaction.user?.circleAvatar(
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
                              controller.transactionType == "mission"
                                  ? SizedBox()
                                  : Center(
                                    child: Text(
                                      'credit ${controller.stockTransaction.user?.toPay.formatPrice()}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
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
                                controller.productTransactions.length,
                                (i) {
                                  return ProductTransactionTile(
                                    productTransaction:
                                        controller.productTransactions[i],
                                  );
                                },
                              ),
                              Divider(),
                              controller.transactionType == "mission"
                                  ? SizedBox()
                                  : ListTile(
                                    title: Text('total'),
                                    trailing: Text(
                                      controller.stockTransaction.total
                                              ?.formatPrice() ??
                                          0.formatPrice()!,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                              controller.transactionType == "mission"
                                  ? SizedBox()
                                  : ListTile(
                                    title: Text('old_credit'),
                                    trailing: Text(
                                      controller.stockTransaction.credit
                                              .formatPrice() ??
                                          0.formatPrice()!,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                              controller.transactionType == "mission"
                                  ? SizedBox()
                                  : ListTile(
                                    title: Text('payment'),
                                    trailing: Text(
                                      controller.stockTransaction.payment
                                              .formatPrice() ??
                                          0.formatPrice()!,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              Center(
                                child: Obx(
                                  () => Stack(
                                    children: [
                                      Opacity(
                                        opacity: controller.sync ? 1 : 0.2,
                                        child: Center(
                                          child: QrCode(
                                            controller.stockTransaction.ids ??
                                                '123',
                                            size: 200,
                                          ),
                                        ),
                                      ),

                                      Obx(
                                        () =>
                                            controller.sync
                                                ? SizedBox()
                                                : Positioned(
                                                  top: 0,
                                                  bottom: 0,
                                                  right: 0,
                                                  left: 0,

                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                      ),
                                    ],
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
                            padding: EdgeInsets.symmetric(vertical: 18),
                            backgroundColor:
                                Get.find<HomeController>()
                                    .dark
                                    .colorScheme
                                    .primaryContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
                            padding: EdgeInsets.symmetric(vertical: 18),
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
                            padding: EdgeInsets.symmetric(vertical: 18),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
    );
  }
}
