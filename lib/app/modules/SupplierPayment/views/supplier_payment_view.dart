import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/SupplierPayment/controllers/supplier_payment_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/modules/home/views/sync_view.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:tracora/app/widgets/empty_widget.dart';

class SupplierPaymentView extends GetView<SupplierPaymentController> {
  const SupplierPaymentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: !controller.showSearch,
        onPopInvokedWithResult: (b, _) {
          controller.showSearch = false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:
                Get.find<HomeController>().theme.scaffoldBackgroundColor,
            title: Obx(
              () =>
                  controller.showSearch
                      ? TextField(
                        controller: controller.search,
                        autofocus: true,
                        autocorrect: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "search".tr,
                        ),
                        onChanged: (v) {
                          controller.getAll();
                        },
                      )
                      : Text('supplier_payments'.tr),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  controller.showSearch = true;
                },
                icon: Icon(Icons.search),
              ),
              SyncView(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Get.lazyPut(() => ProductController());
              var r = await Get.toNamed(Routes.SUPPLIER_PAYMENT_FORM);
              if (r == true) {
                controller.getAll();
              }
            },
            child: Icon(Icons.add),
          ),
          body: Obx(
            () =>
                controller.moneyTransactions.isEmpty && !controller.loading
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
                              Routes.SUPPLIER_PAYMENT_DETAILS,
                              arguments: {"moneyTransaction": moneyTransaction},
                            );
                            if (b == true) {
                              controller.getAll();
                            }
                          },
                          leading: moneyTransaction.user?.circleAvatar(),
                          title: Text(moneyTransaction.user?.firstName ?? ''),
                          subtitle: Text(
                            (moneyTransaction.dateTime ??
                                        moneyTransaction.createdAt)
                                    .formatDateTime() ??
                                '',
                          ),
                          trailing: Material(
                            color:
                                Get.find<HomeController>()
                                    .dark
                                    .colorScheme
                                    .primaryContainer,
                            borderRadius: BorderRadius.circular(100),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              child: Text(
                                (moneyTransaction.amount ?? 0).formatPrice() ??
                                    '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ),
      ),
    );
  }
}
