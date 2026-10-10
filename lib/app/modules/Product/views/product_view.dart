import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:tracora/app/core/intents.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/warehouse.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/views/pos_product_view.dart';
import 'package:tracora/app/modules/ProductDetails/views/product_details_view.dart';
import 'package:tracora/app/modules/ProductForm/controllers/product_form_controller.dart';
import 'package:tracora/app/modules/ProductForm/views/product_form_view.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/modules/home/views/sync_view.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:tracora/app/widgets/empty_widget.dart';
import 'package:tracora/app/widgets/stock_transaction_tabs.dart';

import '../controllers/product_controller.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return PosProductPage();
    } else {
      return Obx(
        () => Column(
          children: [
            StockTransactionTabs(
              title: "products".tr,
              formTitle:
                  Get.find<ProductFormController>().product.id == null
                      ? ('${'new_product'.tr} F1')
                      : (Get.find<ProductFormController>().product.name ??
                          Get.find<ProductFormController>().product.nameAr ??
                          'form'),
              onCloseForm: () {
                Get.find<ProductFormController>().init(Product());
                controller.showForm = false;
              },
              onFormTap: () => controller.showForm = true,
              onHideForm: () => controller.showForm = false,
              showForm: controller.showForm,
            ),
            Expanded(child: controller.showForm ? ProductFormView() : users()),
          ],
        ),
      );
    }
  }

  Row users() {
    return Row(
      children: [
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(4),
            // padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16)),
              border: Border.all(
                width: 0.1,
                color: Get.find<HomeController>().theme.colorScheme.onSurface,
              ),
            ),
            child: list(),
          ),
        ),

        Get.arguments?["select"] == true
            ? SizedBox()
            : Container(
              clipBehavior: Clip.antiAlias,
              width: 400,
              margin: EdgeInsets.all(4),
              // padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(16)),
                // border: Border.all(
                //   width: 0.1,
                //   color: Get.find<HomeController>().theme.colorScheme.onSurface,
                // ),
              ),
              child: ProductDetailsView(),
            ),
      ],
    );
  }

  Scaffold list() {
    var theme = Get.find<HomeController>().theme;
    var colorScheme = theme.colorScheme;
    return Scaffold(
      appBar:
      // AppBar(
      //   // Make all icons and text white by default:
      //   foregroundColor: Colors.white,
      //   backgroundColor:
      //       Get.find<HomeController>().dark.colorScheme.primaryContainer,
      //   // Always show the TextField as the title
      //   title: Focus(
      //     onKeyEvent: (node, event) {
      //       // only intercept key-down, arrow-up
      //       if (event is KeyDownEvent &&
      //           event.logicalKey == LogicalKeyboardKey.arrowUp) {
      //         controller.previous();
      //         return KeyEventResult.skipRemainingHandlers;
      //       } else if (event is KeyDownEvent &&
      //           event.logicalKey == LogicalKeyboardKey.arrowDown) {
      //         controller.next();
      //         return KeyEventResult.skipRemainingHandlers;
      //       }
      //       // otherwise ignore and let the normal flow resume
      //       return KeyEventResult.ignored;
      //     },
      //     child: TextField(
      //       controller: controller.search,
      //       autofocus: true,
      //       focusNode: controller.searchFn,
      //       style: TextStyle(color: Colors.white), // typed text is white
      //       cursorColor: Colors.white, // cursor is white
      //       decoration: InputDecoration(
      //         isDense: true,
      //         contentPadding: EdgeInsets.symmetric(vertical: 8),
      //         hintText: "${'search'.tr} CTRL+F",
      //         hintStyle: TextStyle(color: Colors.white54), // hint is semi-white
      //         border: UnderlineInputBorder(
      //           borderSide: BorderSide(color: Colors.white54),
      //         ),
      //         enabledBorder: UnderlineInputBorder(
      //           borderSide: BorderSide(color: Colors.white54),
      //         ),
      //         focusedBorder: UnderlineInputBorder(
      //           borderSide: BorderSide(color: Colors.white),
      //         ),
      //         suffixIcon: IconButton(
      //           icon: Icon(Icons.clear, color: Colors.white),
      //           onPressed: () {
      //             controller.search.clear();
      //             controller.getAll();
      //           },
      //         ),
      //       ),
      //       onChanged: (_) => controller.getAll(),
      //       onSubmitted: (_) => controller.searchFn.requestFocus(),
      //     ),
      //   ),
      //   actions: [
      //     // Example additional action, all icons are white by default
      //     // IconButton(
      //     //   icon: Icon(Icons.import_export),
      //     //   onPressed: controller.importExcelFile,
      //     //   tooltip: 'excel_import'.tr,
      //     // ),
      //     // IconButton(
      //     //   icon: Icon(Icons.refresh),
      //     //   onPressed: controller.getAll,
      //     //   tooltip: 'refresh',
      //     // ),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Obx(
      //         () => ElevatedButton.icon(
      //           icon: Icon(Icons.warehouse),
      //           onPressed: () {
      //             controller.selectWarehouse();
      //           },
      //           label: Text(
      //             controller.selectedWarehouse.name ?? 'select_warehouse',
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      AppBar(
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
              // onSubmitted: (_) => controller.searchFn.requestFocus(),
            ),
          ),
        ),
        actions: [
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
                  borderRadius: BorderRadius.circular(20),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Filter Selector Pill
                      InkWell(
                        onTap: controller.selectWarehouse,
                        borderRadius: BorderRadius.horizontal(
                          left: const Radius.circular(20),
                          right: Radius.circular(hasSelectedEmployee ? 0 : 20),
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
                                constraints: const BoxConstraints(maxWidth: 90),
                                child: Text(
                                  employeeName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        hasSelectedEmployee
                                            ? colorScheme.onPrimaryContainer
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
      body: Obx(
        () =>
            controller.products.isEmpty && !controller.loading
                ? EmptyWidget()
                : Obx(() {
                  return controller.gridView ? gridView() : listView();
                }),
      ),
    );
  }

  // build(BuildContext context) {
  //   return Obx(
  //     () => PopScope(
  //       canPop: !controller.showSearch,
  //       onPopInvokedWithResult: (b, _) {
  //         controller.showSearch = false;
  //       },
  //       child: Scaffold(
  //         appBar: AppBar(
  //           backgroundColor:
  //               Get.find<HomeController>().theme.scaffoldBackgroundColor,
  //           title: Obx(
  //             () =>
  //                 controller.showSearch
  //                     ? TextField(
  //                       controller: controller.search,
  //                       autofocus: true,
  //                       autocorrect: true,
  //                       decoration: InputDecoration(
  //                         border: InputBorder.none,
  //                         hintText: "search".tr,
  //                       ),
  //                       onChanged: (v) {
  //                         controller.getAll();
  //                       },
  //                     )
  //                     : Text('products'.tr),
  //           ),
  //           actions: [
  //             IconButton(
  //               onPressed: () {
  //                 controller.showSearch = true;
  //               },
  //               icon: Icon(Icons.search),
  //             ),
  //             IconButton(
  //               onPressed: () {
  //                 controller.gridView = !controller.gridView;
  //               },
  //               icon: Icon(
  //                 controller.gridView ? Icons.grid_view_outlined : Icons.list,
  //               ),
  //             ),
  //           ],
  //         ),
  //         floatingActionButton: FloatingActionButton(
  //           onPressed: () {
  //             Get.toNamed(Routes.PRODUCT_FORM);
  //           },
  //           child: Icon(Icons.add),
  //         ),
  //         body: Obx(
  //           () => AnimatedSwitcher(
  //             duration: const Duration(milliseconds: 500),
  //             transitionBuilder: (Widget child, Animation<double> animation) {
  //               return ScaleTransition(scale: animation, child: child);
  //             },
  //             child:
  //                 controller.products.isEmpty && !controller.loading
  //                     ? EmptyWidget()
  //                     : controller.gridView
  //                     ? gridView()
  //                     : listView(),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget listView() {
    return ListView.builder(
      controller: controller.scrollController,
      padding: EdgeInsets.all(8),
      itemCount: controller.products.length,
      itemBuilder: (c, i) {
        var product = controller.products[i];
        return listItem(product);
      },
    );
  }

  Padding listItem(Product product) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Obx(
        () => ListTile(
          selected: controller.selected.id == product.id,
          key:
              product.id == controller.selected.id
                  ? controller.selectedKey
                  : null,
          onTap: () {
            controller.toDetails(product);
          },
          subtitle: Text(product.sellPrice.formatPrice() ?? ''),
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
              Get.find<HomeController>().theme.colorScheme.surfaceContainer,
          contentPadding: EdgeInsets.only(right: 8, top: 0, bottom: 0, left: 8),
          leading: product.leading(),
          title: Text(product.translateName ?? 'product'.tr),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Garage stock chip
              Chip(
                label: Text(
                  'stock: ${((product.rest ?? 0)).formatNumber()}',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: () {
                  final rest = (product.rest ?? 0);
                  final alert = product.alert ?? 10;
                  if (rest <= 0) return Colors.redAccent;
                  if (rest < alert) return Colors.orange;
                  return Colors.blueGrey; // you can pick a neutral color
                }(),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GridView gridView() {
    return GridView.builder(
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
          // Get.toNamed(Routes.PRODUCT_FORM, arguments: {"product": product});
          controller.toDetails(product);
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
                      '${product.rest?.formatNumber() ?? '0'} ${product.unity ?? 'u'.tr}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            product.rest == 0
                                ? Colors.red
                                : (product.rest ?? 0) < (product.alert ?? 0)
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
