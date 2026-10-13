import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/warehouse.dart';
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
    var theme = Get.find<HomeController>().theme;
    var colorScheme = theme.colorScheme;
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
            elevation: 0,
            backgroundColor: colorScheme.surfaceContainer,
            surfaceTintColor: Colors.transparent,
            titleSpacing: 12,
            title: Focus(
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                    controller.previous();
                    return KeyEventResult.skipRemainingHandlers;
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                    controller.next();
                    return KeyEventResult.skipRemainingHandlers;
                  } else if (event.logicalKey == LogicalKeyboardKey.enter ||
                      event.logicalKey == LogicalKeyboardKey.numpadEnter) {
                    Get.find<StockTransactionController<T>>().setQte(
                      controller.selected,
                    );
                    return KeyEventResult.skipRemainingHandlers;
                  }
                }
                return KeyEventResult.ignored;
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withOpacity(0.4),
                  ),
                ),
                child: TextField(
                  controller: controller.search,
                  focusNode: controller.searchFn,
                  autofocus: true,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  cursorColor: colorScheme.primary,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "${'search'.tr} (CTRL+F)",
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: controller.search,
                      builder: (context, value, _) {
                        if (value.text.isEmpty) return const SizedBox.shrink();
                        return IconButton(
                          icon: Icon(
                            Icons.cancel_rounded,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () {
                            controller.search.clear();
                            controller.getAll();
                          },
                        );
                      },
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onChanged: (_) => controller.getAll(),
                  onSubmitted: (_) => controller.searchFn.requestFocus(),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  controller.gridView = !controller.gridView;
                },
                // color: Colors.white,
                icon: Icon(
                  controller.gridView ? Icons.grid_view_outlined : Icons.list,
                ),
              ),
              // Employee Selector Chip
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Obx(() {
                  final hasSelectedEmployee =
                      controller.selectedWarehouse.id != null ||
                      controller.selectedWarehouse.name != null;
                  final employeeName =
                      hasSelectedEmployee
                          ? controller.selectedWarehouse.name!
                          : "all".tr;

                  return Center(
                    child: Material(
                      color:
                          hasSelectedEmployee
                              ? colorScheme.primaryContainer
                              : colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(4),
                      clipBehavior: Clip.antiAlias,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Filter Selector Pill
                          InkWell(
                            onTap: controller.selectWarehouse,
                            borderRadius: BorderRadius.horizontal(
                              left: const Radius.circular(20),
                              right: Radius.circular(
                                hasSelectedEmployee ? 0 : 20,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (hasSelectedEmployee)
                                    Icon(Icons.warehouse_rounded)
                                  else
                                    Icon(Icons.warehouse_rounded),
                                  const SizedBox(width: 8),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 90,
                                    ),
                                    child: Text(
                                      employeeName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color:
                                                hasSelectedEmployee
                                                    ? colorScheme
                                                        .onPrimaryContainer
                                                    : colorScheme.onSurface,
                                          ),
                                    ),
                                  ),
                                  if (!hasSelectedEmployee) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 16,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),

                          // Clear Filter Button
                          if (hasSelectedEmployee)
                            InkWell(
                              onTap: () {
                                controller.selectedWarehouse = Warehouse();
                                controller.getAll();
                              },
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 4,
                                  right: 8,
                                  top: 6,
                                  bottom: 6,
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 15,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),

          body: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Obx(
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
                Get.find<ProductController>().selected = product;
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
              selectedTileColor:
                  Get.find<HomeController>()
                      .theme
                      .colorScheme
                      .surfaceContainerHigh,
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
                  product.leading(),
                  Container(
                    decoration: BoxDecoration(),
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
