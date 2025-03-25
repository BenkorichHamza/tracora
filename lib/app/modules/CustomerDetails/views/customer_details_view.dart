import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:tracora/app/widgets/empty_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/customer_details_controller.dart';

class CustomerDetailsView extends GetView<CustomerDetailsController> {
  const CustomerDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.user.firstName ?? controller.user.companyName ?? '',
        ),
        actions: [
          Obx(() => controller.user.circleAvatar(radius: 22)),
          SizedBox(width: 8),
        ],
        backgroundColor:
            Get.find<HomeController>().theme.scaffoldBackgroundColor,
        bottom: TabBar(
          controller: controller.tabCtrl,
          tabs: [
            Tab(text: "profile", icon: Icon(Icons.person)),
            Tab(
              text: "sales",
              icon: Image.asset("assets/sales.png", height: 25, width: 25),
            ),

            Tab(
              text: "payments",
              icon: Image.asset("assets/money-in.png", height: 25, width: 25),
            ),
            Tab(
              text: "products",
              icon: Image.asset("assets/inventory.png", height: 25, width: 25),
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
                      itemCount: controller.productTransactions.length,
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
        ],
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
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      onTap: () async {
                        Get.lazyPut(() => ProductController());
                        var b = await Get.toNamed(
                          Routes.CUSTOMER_PAYMENT_DETAILS,
                          arguments: {"moneyTransaction": moneyTransaction},
                        );
                        if (b == true) {
                          controller.getMoneyTransactions();
                        }
                      },
                      leading: moneyTransaction.user?.circleAvatar(radius: 20),
                      title: Text(moneyTransaction.user?.firstName ?? ''),
                      subtitle: Text(
                        (moneyTransaction.dateTime ??
                                    moneyTransaction.createdAt)
                                .formatDateTime() ??
                            '',
                      ),
                      trailing: Material(
                        borderRadius: BorderRadius.circular(100),
                        color:
                            Get.find<HomeController>()
                                .dark
                                .colorScheme
                                .primaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: Text(
                            moneyTransaction.amount.formatPrice() ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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
                  var sale = controller.stockTransactions[i];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    onTap: () async {
                      Get.lazyPut(() => ProductController());
                      var b = await Get.toNamed(
                        Routes.SALE_DETAILS,
                        arguments: {"sale": sale},
                      );
                      if (b == true) {
                        controller.getMoneyTransactions();
                      }
                    },
                    leading: sale.user?.circleAvatar(radius: 20),
                    title: Text(sale.user?.firstName ?? ''),
                    subtitle: Text(
                      (sale.dateTime ?? sale.createdAt).formatDateTime() ?? '',
                    ),
                    trailing: Material(
                      borderRadius: BorderRadius.circular(100),
                      color:
                          Get.find<HomeController>()
                              .dark
                              .colorScheme
                              .primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Text(
                          '${sale.topay.formatPrice() ?? ''}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
              Positioned(
                right: 0,
                top: 0,
                child: OutlinedButton.icon(
                  icon: Icon(Icons.edit),
                  onPressed:
                      () => Get.toNamed(
                        Routes.CUSTOMER_FORM,
                        arguments: {'customer': controller.user},
                      ),
                  label: Text('edit'.tr),
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
