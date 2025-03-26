import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:tracora/app/widgets/empty_widget.dart';

import '../controllers/product_controller.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});
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
                          controller.filter();
                        },
                      )
                      : Text('products'.tr),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  controller.showSearch = true;
                },
                icon: Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {
                  controller.gridView = !controller.gridView;
                },
                icon: Icon(
                  controller.gridView ? Icons.grid_view_outlined : Icons.list,
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.toNamed(Routes.PRODUCT_FORM);
            },
            child: Icon(Icons.add),
          ),
          body: Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child:
                  controller.products.isEmpty && !controller.loading
                      ? EmptyWidget()
                      : controller.gridView
                      ? gridView()
                      : listView(),
            ),
          ),
        ),
      ),
    );
  }

  Widget listView() {
    return NotificationListener(
      onNotification: (n) {
        if (n is ScrollEndNotification) {
          if (n.metrics.pixels == n.metrics.maxScrollExtent) {
            controller.loadMore();
          }
        }
        return true;
      },

      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: controller.products.length,
        itemBuilder: (c, i) {
          var product = controller.products[i];
          return listItem(product);
        },
      ),
    );
  }

  Padding listItem(Product product) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        onTap: () {
          Get.toNamed(Routes.PRODUCT_FORM, arguments: {"product": product});
        },
        subtitle: Text(product.sellPrice.formatPrice() ?? ''),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor:
            Get.find<HomeController>().isDark
                ? Get.find<HomeController>()
                    .theme
                    .colorScheme
                    .surfaceContainerHigh
                : Colors.white,
        contentPadding: EdgeInsets.only(right: 8, top: 0, bottom: 0, left: 8),
        leading: product.leading(),
        title: Text(product.translateName ?? 'product'.tr),
        trailing: Chip(
          label: Text('stock ${product.stock.formatNumber() ?? '0'}'),
          color:
              (product.stock ?? 0) == 0
                  ? WidgetStateColor.resolveWith((s) => Colors.redAccent)
                  : (product.stock ?? 0) < (product.alert ?? 10)
                  ? WidgetStateColor.resolveWith((s) => Colors.orange)
                  : null,
        ),
      ),
    );
  }

  Widget gridView() {
    return NotificationListener(
      onNotification: (n) {
        if (n is ScrollEndNotification) {
          if (n.metrics.pixels == n.metrics.maxScrollExtent) {
            controller.loadMore();
          }
        }
        return true;
      },
      child: GridView.builder(
        padding: EdgeInsets.all(8),
        itemCount: controller.products.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (c, i) {
          var product = controller.products[i];
          return gridItem(product);
        },
      ),
    );
  }

  Container gridItem(Product product) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:
            !Get.find<HomeController>().isDark
                ? Colors.white
                : Get.find<HomeController>()
                    .theme
                    .colorScheme
                    .surfaceContainerHigh,
      ),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(Routes.PRODUCT_FORM, arguments: {"product": product});
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: product.leading()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.translateName ?? '',
                style: TextStyle(fontSize: 16),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${product.stock?.formatNumber() ?? '0'} ${product.unity ?? 'u'.tr}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            product.stock == 0
                                ? Colors.red
                                : (product.stock ?? 0) < (product.alert ?? 0)
                                ? Colors.amber
                                : Colors.green,
                      ),
                    ),
                  ),
                  Text(
                    '${product.sellPrice?.toStringAsFixed(0) ?? 0.00} ${'dzd'.tr}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
