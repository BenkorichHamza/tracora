import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/TransactionForm/views/cart_grid_transaction_button.dart';
import 'package:tracora/app/modules/TransactionForm/views/cart_list_transaction_button.dart';
import 'package:tracora/app/modules/TransactionForm/controllers/transaction_form_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class ProductShoppingView<T> extends GetView<ProductController> {
  const ProductShoppingView({super.key});
  @override
  Widget build(BuildContext context) {
    StockTransactionController<T> saleFormController =
        Get.find<StockTransactionController<T>>();
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
              child: Focus(
                onKeyEvent: (node, event) {
                  // only intercept key-down, arrow-up
                  if (event is KeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.arrowUp) {
                    controller.previous();
                    return KeyEventResult.skipRemainingHandlers;
                  } else if (event is KeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.arrowDown) {
                    controller.next();
                    return KeyEventResult.skipRemainingHandlers;
                  }
                  // otherwise ignore and let the normal flow resume
                  return KeyEventResult.ignored;
                },
                child: TextField(
                  controller: controller.search,
                  autofocus: true,
                  focusNode: controller.searchFn,
                  style: TextStyle(color: Colors.white), // typed text is white
                  cursorColor: Colors.white, // cursor is white
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    hintText: "${'search'.tr} CTRL+F",
                    hintStyle: TextStyle(
                      color: Colors.white54,
                    ), // hint is semi-white
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: Colors.white),
                      onPressed: () {
                        controller.search.clear();
                        controller.getAll();
                      },
                    ),
                  ),
                  onChanged: (_) => controller.getAll(),
                  onSubmitted:
                      (v) => saleFormController.setQte(controller.selected),
                ),
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

  Widget listView(StockTransactionController<T> saleFormController) {
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
    StockTransactionController<T> saleFormController,
  ) {
    return GetBuilder<TransactionFormController<T>>(
      initState: (_) {},
      id: 'shop_${product.id}',
      builder: (c) {
        return Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              selected: controller.selected.id == product.id,
              onTap: () {
                saleFormController.setQte(product);
              },
              subtitle: Text(
                product
                        .getPrice<T>(Get.find<HomeController>().sellMode)
                        .formatPrice() ??
                    '0',
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color:
                      controller.selected.id == product.id
                          ? Colors.green
                          : Colors.grey.withAlpha(100),
                ),
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
          ),
        );
      },
    );
  }

  GridView gridView(StockTransactionController<T> saleFormController) {
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
    StockTransactionController<T> transactionFormController,
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
                    product
                            .getPrice<T>(Get.find<HomeController>().sellMode)
                            .formatPrice() ??
                        '',
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
