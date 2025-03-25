import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/Sale/controllers/sale_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
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
                      : Text('sales'.tr),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  controller.showSearch = true;
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Get.lazyPut(() => ProductController());
              var r = await Get.toNamed(Routes.SALE_FORM);
              if (r == true) {
                controller.getAll();
              }
            },
            child: Icon(Icons.add),
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
                            Get.lazyPut(() => ProductController());
                            var b = await Get.toNamed(
                              Routes.SALE_DETAILS,
                              arguments: {"sale": sale},
                            );
                            if (b == true) {
                              controller.getAll();
                            }
                          },
                          leading: sale.user?.circleAvatar(),
                          title: Text(sale.user?.firstName ?? ''),
                          subtitle: Text(
                            (sale.dateTime ?? sale.createdAt)
                                    .formatDateTime() ??
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
        ),
      ),
    );
  }
}
