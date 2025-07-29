import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/stock_transaction_repository.dart';
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
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(
                          () =>
                              controller.stockTransaction.status == 1
                                  ? SizedBox()
                                  : ElevatedButton.icon(
                                    onPressed: () {
                                      controller.approve();
                                    },
                                    label: Text("approve".tr),
                                  ),
                        ),
                      ),
                    ],
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
                                            ...products(),
                                            Divider(),
                                            controller.transactionType ==
                                                    "mission"
                                                ? SizedBox()
                                                : cart(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                actions(),
                              ],
                            ),
                  ),
                ),
      ),
    );
  }

  Row actions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.print_outlined),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 18),
              backgroundColor:
                  Get.find<HomeController>().dark.colorScheme.primaryContainer,
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
    );
  }

  List<Widget> products() {
    return List.generate(controller.productTransactions.length, (i) {
      return ProductTransactionTile(
        productTransaction: controller.productTransactions[i],
      );
    });
  }

  Container cart() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors:
              controller.stockTransaction.status == 1
                  ? [
                    Color.fromARGB(255, 25, 62, 8),
                    Color.fromARGB(255, 26, 48, 15),
                  ] // Vert validé
                  : [Color(0xFFd31027), Color(0xFFea384d)], // Rouge non validé
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Header avec utilisateur et statut
          Row(
            children: [
              controller.stockTransaction.user?.circleAvatar(radius: 20) ??
                  SizedBox(),
              SizedBox(width: 12),
              Text(
                controller.stockTransaction.user?.firstName ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Icon(
                controller.stockTransaction.status == 1
                    ? Icons.check_circle
                    : Icons.warning_amber_rounded,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 4),
              Text(
                controller.stockTransaction.status == 1
                    ? 'Validée'
                    : 'Non validée',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 16),

          // 💸 Infos de paiement
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Text(
                      controller.stockTransaction.total.formatPrice() ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Ancien crédit',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Text(
                      controller.stockTransaction.credit.formatPrice() ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Payé',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Text(
                      controller.stockTransaction.payment.formatPrice() ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
