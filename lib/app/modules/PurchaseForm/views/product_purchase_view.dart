import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/PurchaseForm/views/cart_grid_purchase_button.dart';
import 'package:tracora/app/modules/PurchaseForm/views/cart_list_purchase_button.dart';
import 'package:tracora/app/modules/PurchaseForm/controllers/purchase_form_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class ProductPurchaseShoppingView extends GetView<ProductController> {
  const ProductPurchaseShoppingView({super.key});
  @override
  Widget build(BuildContext context) {
    PurchaseFormController purchaseFormController =
        Get.find<PurchaseFormController>();
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

          body: Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child:
                  controller.gridView
                      ? gridView(purchaseFormController)
                      : listView(purchaseFormController),
            ),
          ),
        ),
      ),
    );
  }

  Widget listView(PurchaseFormController purchaseFormController) {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: controller.products.length,
      itemBuilder: (c, i) {
        var product = controller.products[i];
        return listItem(product, purchaseFormController);
      },
    );
  }

  Widget listItem(
    Product product,
    PurchaseFormController purchaseFormController,
  ) {
    return GetBuilder<PurchaseFormController>(
      initState: (_) {},
      id: 'shop_${product.id}',
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            onTap: () {
              purchaseFormController.setQte(product);
            },
            subtitle: Text(product.sellPrice.formatPrice() ?? ''),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            tileColor:
                Get.find<HomeController>().isDark
                    ? Get.find<HomeController>()
                        .theme
                        .colorScheme
                        .surfaceContainerHigh
                    : Colors.white,
            contentPadding: EdgeInsets.only(
              right: 8,
              top: 0,
              bottom: 0,
              left: 8,
            ),
            leading: product.leading(),

            title: Text(product.translateName ?? 'product'.tr),
            trailing: CartListPurchaseButton(product: product),
          ),
        );
      },
    );
  }

  GridView gridView(PurchaseFormController purchaseFormController) {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      itemCount: controller.products.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (c, i) {
        var product = controller.products[i];
        return gridItem(purchaseFormController, product);
      },
    );
  }

  Container gridItem(
    PurchaseFormController purchaseFormController,
    Product product,
  ) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:
            Get.find<HomeController>().isDark
                ? Get.find<HomeController>()
                    .theme
                    .colorScheme
                    .surfaceContainerHigh
                : Colors.white,
      ),
      child: GestureDetector(
        onTap: () => purchaseFormController.setQte(product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(image: product.toDecorationImage()),
                child: GetBuilder<PurchaseFormController>(
                  initState: (_) {},
                  id: 'shop_${product.id}',
                  builder: (_) {
                    return Align(
                      alignment: Alignment.topRight,
                      child: CartGridPurchaseButton(product: product),
                    );
                  },
                ),
              ),
            ),
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
                      'stock ${product.stock.formatNumber()}',
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
                    product.buyPrice.formatPrice() ?? '',
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
