import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/TransactionForm/views/cart_grid_transaction_button.dart';
import 'package:tracora/app/modules/TransactionForm/views/cart_list_transaction_button.dart';
import 'package:tracora/app/modules/TransactionForm/controllers/transaction_form_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class ProductShoppingView<T> extends GetView<ProductController> {
  const ProductShoppingView({super.key});
  @override
  Widget build(BuildContext context) {
    TransactionFormController<T> saleFormController =
        Get.find<TransactionFormController<T>>();
    return Obx(
      () => PopScope(
        canPop: !controller.showSearch,
        onPopInvokedWithResult: (b, _) {
          controller.showSearch = false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:
                Get.find<HomeController>().dark.colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            foregroundColor: Colors.white,
            title: Theme(
              data: Get.find<HomeController>().dark,
              child: TextField(
                controller: controller.search,
                autofocus: true,
                cursorColor: Colors.white,

                style: TextStyle(fontSize: 16, color: Colors.white),
                autocorrect: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "search".tr,
                  suffixIconColor: Colors.white,
                ),
                onChanged: (v) {
                  controller.getAll();
                },
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  controller.showSearch = true;
                },
                icon: Icon(Icons.search),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  controller.gridView = !controller.gridView;
                },
                color: Colors.white,
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
                      ? gridView(saleFormController)
                      : listView(saleFormController),
            ),
          ),
        ),
      ),
    );
  }

  Widget listView(TransactionFormController<T> saleFormController) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: controller.products.length,
        itemBuilder: (c, i) {
          var product = controller.products[i];
          return listItem(product, saleFormController);
        },
      ),
    );
  }

  Widget listItem(
    Product product,
    TransactionFormController<T> saleFormController,
  ) {
    return GetBuilder<TransactionFormController<T>>(
      initState: (_) {},
      id: 'shop_${product.id}',
      builder: (c) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            onTap: () {
              saleFormController.setQte(product);
            },
            subtitle: Text(product.getPrice<T>().formatPrice() ?? '0'),
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
            trailing: CartListButton<T>(product: product),
          ),
        );
      },
    );
  }

  GridView gridView(TransactionFormController<T> saleFormController) {
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
        return gridItem(saleFormController, product);
      },
    );
  }

  Widget gridItem(
    TransactionFormController<T> transactionFormController,
    Product product,
  ) {
    return GestureDetector(
      onTap: () => transactionFormController.setQte(product),
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  product.toDecorationImage() != null
                      ? SizedBox()
                      : product.leading(),
                  Container(
                    decoration: BoxDecoration(
                      image: product.toDecorationImage(),
                    ),
                    child: GetBuilder<TransactionFormController<T>>(
                      initState: (_) {},
                      id: 'shop_${product.id}',
                      builder: (_) {
                        return Align(
                          alignment: Alignment.topRight,
                          child: CartGridButton<T>(product: product),
                        );
                      },
                    ),
                  ),
                ],
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
                    product.getPrice<T>().formatPrice() ?? '',
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
