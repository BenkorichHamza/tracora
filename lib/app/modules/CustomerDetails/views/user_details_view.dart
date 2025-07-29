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
import 'package:tracora/app/modules/CustomerDetails/views/employee_detais.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/StockTransactionDetails/views/stock_transaction_details_view.dart';
import 'package:tracora/app/modules/UserPayment/controllers/user_payment_controller.dart';
import 'package:tracora/app/modules/UserPaymentDetails/views/user_payment_details_view.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:tracora/app/widgets/empty_widget.dart';
import 'package:tracora/app/widgets/money_transaction_tile.dart';
import 'package:tracora/app/widgets/stock_transaction_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/user_details_controller.dart';

class UserDetailsView<T> extends GetView<UserDetailsController<T>> {
  const UserDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.user.id == null
              ? Scaffold()
              : T == Employee
              ? EmployeeDetailsView()
              : Scaffold(
                appBar: AppBar(
                  title: Text(
                    controller.user.firstName ??
                        controller.user.companyName ??
                        '',
                  ),
                  actions: [
                    Obx(() => controller.user.circleAvatar(radius: 22)),
                    SizedBox(width: 8),
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
                      Tab(text: "profile", icon: Icon(Icons.person)),
                      controller.userType == "customer"
                          ? Tab(
                            text: "sales",
                            icon: Image.asset(
                              "assets/sales.png",
                              height: 25,
                              width: 25,
                            ),
                          )
                          : controller.userType == "employee"
                          ? Tab(
                            text: "sales",
                            icon: Image.asset(
                              "assets/sales.png",
                              height: 25,
                              width: 25,
                            ),
                          )
                          : Tab(
                            text: "purchases",
                            icon: Image.asset(
                              "assets/purchase.png",
                              height: 25,
                              width: 25,
                            ),
                          ),
                      controller.userType == "customer"
                          ? Tab(
                            text: "payments",
                            icon: Image.asset(
                              "assets/money-in.png",
                              height: 25,
                              width: 25,
                            ),
                          )
                          : Tab(
                            text: "payments",
                            icon: Image.asset(
                              "assets/money-out.png",
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
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        controller: controller.tabCtrl,
                        children: [
                          profile(),
                          stockTransactions(),
                          moneyTransactions(),
                          Center(
                            child: Obx(
                              () => ListView.builder(
                                itemCount:
                                    controller.productTransactions.length,
                                itemBuilder: (context, index) {
                                  final transaction =
                                      controller.productTransactions[index];
                                  return listItem(transaction);
                                },
                              ),
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
                            onPressed: controller.print,
                            label: Text('print_invoice'.tr),
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
              ),
    );
  }

  Container moneyTransactions() {
    return Container(
      child: Obx(
        () =>
            controller.moneyTransactions.isEmpty
                ? EmptyWidget()
                : ListView.builder(
                  itemCount: controller.moneyTransactions.length,

                  itemBuilder: (c, i) {
                    var moneyTransaction = controller.moneyTransactions[i];
                    return MoneyTransactionTile(
                      onValidate: (item) {
                        print(item.status);
                      },
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
                      item: moneyTransaction,
                      highest: i.isEven,
                      selected: false,
                    );
                  },
                ),
      ),
    );
  }

  Widget stockTransactions() {
    return Obx(
      () =>
          controller.stockTransactions.isEmpty
              ? EmptyWidget()
              : ListView.builder(
                itemCount: controller.stockTransactions.length,

                itemBuilder: (c, i) {
                  var transaction = controller.stockTransactions[i];
                  return StockTransactionTile(
                    onValidate: (item) {
                      StockTransactionRepository<T>().insert(
                        item.copyWith(status: 1),
                        sync: false,
                      );
                      FirebaseFirestore.instance
                          .collection("collections")
                          .doc(Get.find<HomeController>().collection)
                          .collection("missions")
                          .doc(item.missionIds ?? "default")
                          .collection("stockTransactions")
                          .doc(item.ids ?? "default")
                          .update({"status": 1})
                          .catchError((e) {
                            ErrorHandler.handleError(e);
                          });
                    },
                    onTap: (t) {
                      showDialog(
                        context: Get.context!,

                        builder: (c) {
                          Get.find<StockTransactionController<Sale>>()
                              .toDetails(transaction);
                          return Center(
                            child: Dialog(
                              backgroundColor: Colors.transparent,
                              clipBehavior: Clip.antiAlias,
                              elevation: 10,
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 450),

                                child: Center(
                                  child: StockTransactionDetailsView<Sale>(),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    item: transaction,
                    highest: i.isEven,
                    selected: false,
                  );
                },
              ),
    );
  }

  Padding listItem(ProductTransaction productTransaction) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        onTap: () {},
        subtitle: Text(productTransaction.price.formatPrice() ?? ''),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor:
            Get.find<HomeController>().isDark
                ? Get.find<HomeController>()
                    .theme
                    .colorScheme
                    .surfaceContainerHigh
                : Colors.white,
        contentPadding: EdgeInsets.only(right: 8, top: 0, bottom: 0, left: 8),
        leading: productTransaction.product?.leading(),
        title: Text(productTransaction.product?.translateName ?? 'product'.tr),
        trailing: Material(
          borderRadius: BorderRadius.circular(100),
          color: Get.find<HomeController>().dark.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'qte ${productTransaction.qte.formatNumber() ?? '0'}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget profile() {
    return Obx(
      () => ListView(
        padding: EdgeInsets.all(16),
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
              Center(
                child: Text(
                  '${'credit'.tr} | ${controller.user.toPay.formatPrice()}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        controller.user.toPay <= 0
                            ? Colors.green
                            : Colors.deepOrange,
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(
              (controller.user.phone ?? '').isNotEmpty
                  ? controller.user.phone!
                  : 'phone'.tr,
            ),
            trailing: IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor:
                    Get.find<HomeController>()
                        .dark
                        .colorScheme
                        .primaryContainer,
              ),
              onPressed:
                  !(controller.user.phone ?? '').isPhoneNumber
                      ? null
                      : () {
                        launchUrl(
                          Uri(scheme: 'tel', path: controller.user.phone!),
                        );
                      },
              icon: Icon(
                Icons.call,
                color:
                    (controller.user.phone ?? '').isPhoneNumber
                        ? Colors.white
                        : null,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(
              (controller.user.email ?? '').isNotEmpty
                  ? controller.user.email!
                  : 'email'.tr,
            ),
            trailing: IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor:
                    Get.find<HomeController>()
                        .dark
                        .colorScheme
                        .primaryContainer,
              ),
              onPressed:
                  !(controller.user.email ?? '').isEmail
                      ? null
                      : () {
                        launchUrl(
                          Uri(scheme: 'mailto', path: controller.user.email!),
                        );
                      },
              icon: Icon(
                Icons.mail,
                color:
                    (controller.user.email ?? '').isEmail ? Colors.white : null,
              ),
            ),
          ),
          ListTile(
            title: Text(
              (controller.user.nin ?? '').isEmpty
                  ? 'nin'
                  : (controller.user.nin ?? ''),
            ),
            leading: CircleAvatar(child: Text('NIN')),
          ),
          ListTile(
            title: Text(
              (controller.user.nis ?? '').isEmpty
                  ? 'nis'
                  : (controller.user.nis ?? ''),
            ),
            leading: CircleAvatar(child: Text('NIS')),
          ),
          ListTile(
            title: Text(
              (controller.user.nif ?? '').isEmpty
                  ? 'nif'
                  : (controller.user.nif ?? ''),
            ),
            leading: CircleAvatar(child: Text('NIF')),
          ),
        ],
      ),
    );
  }
}
