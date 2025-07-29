import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/repositories/stock_transaction_repository.dart';
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
                    actions: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Center(
                          child: Obx(
                            () =>
                                controller.synchronisationLoading
                                    ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : IconButton(
                                      onPressed: () {
                                        controller.synchronize();
                                      },
                                      icon: Icon(
                                        Icons.sync_sharp,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ],
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
                () => Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors:
                              controller.missionSales.every(
                                    (sale) => sale.status == 1,
                                  )
                                  ? [
                                    Color(0xFF56ab2f),
                                    Color(0xFFa8e063),
                                  ] // vert si tout validé
                                  : [
                                    Color(0xFFd31027),
                                    Color(0xFFea384d),
                                  ], // rouge si non validé
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
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                controller.stockTransaction.user?.circleAvatar(
                                      radius: 15,
                                    ) ??
                                    SizedBox(),
                                SizedBox(width: 12),
                                Text(
                                  controller.stockTransaction.user?.firstName ??
                                      '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  controller.missionPayments.every(
                                        (payment) => payment.status == 1,
                                      )
                                      ? Icons.check_circle
                                      : Icons.warning_amber_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  controller.missionSales.every(
                                        (sale) => sale.status == 1,
                                      )
                                      ? 'Validée'
                                      : 'Non validée',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),

                            // Contenu principal (Total vendu / versé)
                            Row(
                              children: [
                                // Icône
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.attach_money,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                SizedBox(width: 16),

                                // Valeurs
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Total vendu
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Total vendu',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.85,
                                              ),
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            '${controller.totalSaled.formatNumber()} DA',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Total versé
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Total versé',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.85,
                                              ),
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            '${controller.totalSalePayments.formatNumber()} DA',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            controller.missionSales
                                .where((e) => e.type == "sale")
                                .length,
                        itemBuilder:
                            (c, i) => StockTransactionTile(
                              onValidate: (item) {},
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
                                          constraints: BoxConstraints(
                                            maxWidth: 450,
                                          ),

                                          child: Center(
                                            child:
                                                StockTransactionDetailsView<
                                                  Sale
                                                >(),
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
                  ],
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
                () => Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors:
                              controller.missionPayments.every(
                                    (sale) => sale.status == 1,
                                  )
                                  ? [
                                    Color(0xFF56ab2f),
                                    Color(0xFFa8e063),
                                  ] // vert si tout validé
                                  : [
                                    Color(0xFFd31027),
                                    Color(0xFFea384d),
                                  ], // rouge si non validé
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
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Validation indicator
                            Row(
                              children: [
                                controller.stockTransaction.user?.circleAvatar(
                                      radius: 15,
                                    ) ??
                                    SizedBox(),
                                SizedBox(width: 12),
                                Text(
                                  controller.stockTransaction.user?.firstName ??
                                      '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  controller.missionPayments.every(
                                        (payment) => payment.status == 1,
                                      )
                                      ? Icons.check_circle
                                      : Icons.warning_amber_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  controller.missionSales.every(
                                        (sale) => sale.status == 1,
                                      )
                                      ? 'Validée'
                                      : 'Non validée',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            // Main content (Total payment)
                            Row(
                              children: [
                                // Icon for payments
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.payment,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                SizedBox(width: 16),

                                // Total payment value
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Total Payment label
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Total versé',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.85,
                                              ),
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            '${controller.totalSalePayments.formatNumber()} DA',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.missionPayments.length,
                        itemBuilder:
                            (c, i) => MoneyTransactionTile(
                              onValidate: (item) {
                                print(item.status);
                              },
                              onTap: (t) {
                                showDialog(
                                  context: Get.context!,

                                  builder: (c) {
                                    Get.find<UserPaymentController<Sale>>()
                                        .toDetails(t);
                                    return Center(
                                      child: Dialog(
                                        backgroundColor: Colors.transparent,
                                        clipBehavior: Clip.antiAlias,
                                        elevation: 10,
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: 450,
                                          ),

                                          child: Center(
                                            child:
                                                UserPaymentDetailsView<Sale>(),
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
                  ],
                ),
              ),
    );
  }

  ListView products() {
    return ListView.builder(
      itemCount: controller.productTransactions.length,
      itemBuilder: (c, i) {
        var pt = controller.productTransactions[i];
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                pt.product?.leading() ?? SizedBox(),
                SizedBox(width: 8),

                // Nom du produit
                Expanded(
                  child: Text(
                    pt.product?.name ?? '',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(width: 8),

                // Quantités (Qte / Saled / Rest)
                SizedBox(
                  width: 35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Q',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        '${pt.qte?.formatNumber() ?? 0}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(
                  width: 35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'S',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        controller.saledQteOf(pt).formatNumber() ?? '',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(
                  width: 35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'R',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        controller.restQteOf(pt).formatNumber() ?? '',
                        style: TextStyle(
                          color:
                              controller.restQteOf(pt) > 0
                                  ? Colors.green
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
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
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors:
                            Get.find<HomeController>().theme == ThemeMode.light
                                ? (controller.missionSales.every(
                                          (s) => s.status == 1,
                                        ) &&
                                        controller.missionPayments.every(
                                          (p) => p.status == 1,
                                        ))
                                    ? [Color(0xFF56ab2f), Color(0xFFa8e063)]
                                    : [Color(0xFFd31027), Color(0xFFea384d)]
                                : (controller.missionSales.every(
                                      (s) => s.status == 1,
                                    ) &&
                                    controller.missionPayments.every(
                                      (p) => p.status == 1,
                                    ))
                                ? [Color(0xFF56ab2f), Color(0xFFa8e063)]
                                : [Color(0xFF9b1c2f), Color(0xFFf06292)],
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
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ Indicateurs de validation combinés
                          Row(
                            children: [
                              controller.stockTransaction.user?.circleAvatar(
                                    radius: 15,
                                  ) ??
                                  SizedBox(),
                              SizedBox(width: 12),
                              Text(
                                controller.stockTransaction.user?.firstName ??
                                    '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                (controller.missionSales.every(
                                          (s) => s.status == 1,
                                        ) &&
                                        controller.missionPayments.every(
                                          (p) => p.status == 1,
                                        ))
                                    ? Icons.check_circle
                                    : Icons.warning_amber_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 4),
                              Text(
                                (controller.missionSales.every(
                                          (s) => s.status == 1,
                                        ) &&
                                        controller.missionPayments.every(
                                          (p) => p.status == 1,
                                        ))
                                    ? 'Validée'
                                    : 'Non validée',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12),

                          // 💰 Total Caisse - version plus grande
                          Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Total Caisse:',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.totalCaisse.formatPrice() ?? '',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.symmetric(vertical: 8),

                        child: Obx(
                          () => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
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
                                            'collections/${Get.find<HomeController>().collection}/missions/${controller.stockTransaction.ids ?? '123'}',
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
                  ListTile(
                    leading: Icon(
                      {
                            3: Icons.archive_outlined,
                            2: Icons.play_arrow_outlined,
                            1: Icons.done_outlined,
                            0: Icons.block_outlined,
                          }[controller.stockTransaction.status] ??
                          Icons.info_outlined,
                      color:
                          {
                            3: Colors.green,
                            2: Colors.orange,
                            1: Colors.green,
                            0: Colors.red,
                          }[controller.stockTransaction.status] ??
                          Colors.grey,
                    ),
                    title: Text('status'.tr, style: TextStyle(fontSize: 16)),
                    subtitle: Text(
                      {
                            3: 'archived'.tr,
                            2: 'in_progress'.tr,
                            1: 'completed'.tr,
                            0: 'blocked'.tr,
                          }[controller.stockTransaction.status] ??
                          '',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: PopupMenuButton<int>(
                      onSelected: (v) async {
                        await StockTransactionRepository<Mission>().insert(
                          mission: true,
                          controller.stockTransaction.copyWith(
                            status: v,
                            productTransactions: controller.productTransactions,
                          ),
                        );
                        controller.getStockTransaction();
                      },
                      itemBuilder:
                          (c) => [
                            PopupMenuItem(value: 3, child: Text('archived'.tr)),
                            PopupMenuItem(
                              value: 2,
                              child: Text('in_progress'.tr),
                            ),
                            PopupMenuItem(
                              value: 1,
                              child: Text('completed'.tr),
                            ),
                            PopupMenuItem(value: 0, child: Text('blocked'.tr)),
                          ],
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
