import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/Sale/controllers/sale_controller.dart';
import 'package:tracora/app/modules/SaleDetails/controllers/sale_details_controller.dart';
import 'package:tracora/app/modules/SaleDetails/views/sale_details_view.dart';
import 'package:tracora/app/modules/SaleForm/controllers/sale_form_controller.dart';
import 'package:tracora/app/modules/SaleForm/views/sale_form_view.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/modules/home/views/sync_view.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:tracora/app/widgets/empty_widget.dart';

class SaleView extends GetView<SaleController> {
  const SaleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: !controller.showSearch,
        onPopInvokedWithResult: (b, _) {
          controller.showSearch = false;
        },
        child: Column(
          children: [
            tabs(),
            Expanded(
              child:
                  controller.showForm
                      ? SaleFormView()
                      : Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(4),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(width: 0.2),
                              ),
                              child: list(),
                            ),
                          ),
                          Container(
                            width: 400,
                            margin: EdgeInsets.all(4),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(width: 0.2),
                            ),
                            child: SaleDetailsView(),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  tabs() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            onTap: () => controller.showForm = false,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),

                border:
                    controller.showForm
                        ? Border.all(width: 0, color: Colors.transparent)
                        : Border(
                          top: BorderSide(width: 1.5, color: Colors.green),
                          right: BorderSide(width: 1.5, color: Colors.green),
                          left: BorderSide(width: 1.5, color: Colors.green),
                          bottom: BorderSide.none,
                        ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'sales'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),
          SizedBox(width: 4),
          GetBuilder<SaleFormController>(
            builder:
                (c) => InkWell(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  onTap: () => controller.showForm = true,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),

                      border:
                          !controller.showForm
                              ? Border.all(width: 0, color: Colors.transparent)
                              : Border(
                                top: BorderSide(
                                  width: 1.5,
                                  color: Colors.green,
                                ),
                                right: BorderSide(
                                  width: 1.5,
                                  color: Colors.green,
                                ),
                                left: BorderSide(
                                  width: 1.5,
                                  color: Colors.green,
                                ),
                                bottom: BorderSide.none,
                              ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),

                          child: Text(
                            c.sale.id == null
                                ? ('new_sale'.tr)
                                : ('${c.sale.user?.firstName}'),

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        !controller.showForm
                            ? SizedBox()
                            : InkWell(
                              onTap: () {
                                c.init(StockTransaction());
                                controller.showForm = false;
                              },
                              borderRadius: BorderRadius.circular(100),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(Icons.cancel),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Scaffold list() {
    return Scaffold(
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
                  : Text('sales'.tr),
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

      body: Obx(
        () =>
            controller.sales.isEmpty && !controller.loading
                ? EmptyWidget()
                : ListView.builder(
                  itemCount: controller.sales.length,

                  itemBuilder: (c, i) {
                    var sale = controller.sales[i];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      onTap: () async {
                        Get.find<SaleDetailsController>().stockTransaction =
                            sale;
                        Get.find<SaleDetailsController>()
                            .getProductTransactions();
                      },
                      leading: sale.user?.circleAvatar(),
                      title: Text(sale.user?.firstName ?? ''),
                      subtitle: Text(
                        (sale.dateTime ?? sale.createdAt).formatDateTime() ??
                            '',
                      ),
                      trailing: Text(
                        (sale.topay ?? 0).formatPrice() ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
