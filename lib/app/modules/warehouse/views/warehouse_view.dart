import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:tracora/app/data/models/warehouse.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/modules/warehouse_details/views/warehouse_details_view.dart';
import 'package:tracora/app/modules/warehouse_form/controllers/warehouse_form_controller.dart';
import 'package:tracora/app/modules/warehouse_form/views/warehouse_form_view.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:tracora/app/widgets/empty_widget.dart';
import 'package:tracora/app/widgets/stock_transaction_tabs.dart';

import '../controllers/warehouse_controller.dart';

class WarehouseView extends GetView<WarehouseController> {
  const WarehouseView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Get.arguments?["select"] == true
              ? SizedBox()
              : StockTransactionTabs(
                title: "warehouses".tr,
                formTitle:
                    Get.find<WarehouseFormController>().warehouse.id == null
                        ? ('${'new_warehouse'.tr} F1')
                        : (Get.find<WarehouseFormController>().warehouse.name ??
                            Get.find<WarehouseFormController>()
                                .warehouse
                                .nameAr ??
                            'form'),
                onCloseForm: () {
                  Get.find<WarehouseFormController>().init(Warehouse());
                  controller.showForm = false;
                },
                onFormTap: () => controller.showForm = true,
                onHideForm: () => controller.showForm = false,
                showForm: controller.showForm,
              ),
          Expanded(child: controller.showForm ? WarehouseFormView() : users()),
        ],
      ),
    );
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
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(16)),
              // border: Border.all(
              //   width: 0.1,
              //   color: Get.find<HomeController>().theme.colorScheme.onSurface,
              // ),
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
              child: WarehouseDetailsView(),
            ),
      ],
    );
  }

  list() {
    var theme = Get.find<HomeController>().theme;
    var colorScheme = theme.colorScheme;
    return Scaffold(
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
          // Employee Selector Chip
          // Padding(
          //   padding: const EdgeInsets.only(right: 12.0),
          //   child: Obx(() {
          //     final hasSelectedEmployee =
          //         controller.selectedWarehouse.id != null ||
          //         controller.selectedWarehouse.name != null;
          //     final employeeName =
          //         hasSelectedEmployee
          //             ? controller.selectedWarehouse.name!
          //             : "all".tr;

          //     return Center(
          //       child: Material(
          //         color:
          //             hasSelectedEmployee
          //                 ? colorScheme.primaryContainer
          //                 : colorScheme.surfaceContainerHigh,
          //         borderRadius: BorderRadius.circular(20),
          //         clipBehavior: Clip.antiAlias,
          //         child: Row(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             // Filter Selector Pill
          //             InkWell(
          //               onTap: controller.selectWarehouse,
          //               borderRadius: BorderRadius.horizontal(
          //                 left: const Radius.circular(20),
          //                 right: Radius.circular(hasSelectedEmployee ? 0 : 20),
          //               ),
          //               child: Padding(
          //                 padding: const EdgeInsets.symmetric(
          //                   horizontal: 10,
          //                   vertical: 6,
          //                 ),
          //                 child: Row(
          //                   mainAxisSize: MainAxisSize.min,
          //                   children: [
          //                     if (hasSelectedEmployee)
          //                       Icon(Icons.warehouse_rounded)
          //                     else
          //                       Icon(Icons.warehouse_rounded),
          //                     const SizedBox(width: 8),
          //                     ConstrainedBox(
          //                       constraints: const BoxConstraints(maxWidth: 90),
          //                       child: Text(
          //                         employeeName,
          //                         maxLines: 1,
          //                         overflow: TextOverflow.ellipsis,
          //                         style: theme.textTheme.labelMedium?.copyWith(
          //                           fontWeight: FontWeight.w600,
          //                           color:
          //                               hasSelectedEmployee
          //                                   ? colorScheme.onPrimaryContainer
          //                                   : colorScheme.onSurface,
          //                         ),
          //                       ),
          //                     ),
          //                     if (!hasSelectedEmployee) ...[
          //                       const SizedBox(width: 4),
          //                       Icon(
          //                         Icons.keyboard_arrow_down_rounded,
          //                         size: 16,
          //                         color: colorScheme.onSurfaceVariant,
          //                       ),
          //                     ],
          //                   ],
          //                 ),
          //               ),
          //             ),

          //             // Clear Filter Button
          //             if (hasSelectedEmployee)
          //               InkWell(
          //                 onTap: () {
          //                   controller.selectedWarehouse = Warehouse();
          //                   controller.getAll();
          //                 },
          //                 borderRadius: const BorderRadius.horizontal(
          //                   right: Radius.circular(20),
          //                 ),
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(
          //                     left: 4,
          //                     right: 8,
          //                     top: 6,
          //                     bottom: 6,
          //                   ),
          //                   child: Icon(
          //                     Icons.close_rounded,
          //                     size: 15,
          //                     color: colorScheme.onPrimaryContainer,
          //                   ),
          //                 ),
          //               ),
          //           ],
          //         ),
          //       ),
          //     );
          //   }),
          // ),
        ],
      ),

      body: Obx(
        () =>
            controller.warehouses.isEmpty && !controller.loading
                ? EmptyWidget()
                : Obx(() {
                  return listView();
                }),
      ),
    );
  }

  Widget listView() {
    return ListView.builder(
      controller: controller.scrollController,
      padding: EdgeInsets.all(8),
      itemCount: controller.warehouses.length,
      itemBuilder: (c, i) {
        var warehouse = controller.warehouses[i];
        return listItem(warehouse);
      },
    );
  }

  Padding listItem(Warehouse warehouse) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Obx(
        () => ListTile(
          selected: controller.selected.id == warehouse.id,
          key:
              warehouse.id == controller.selected.id
                  ? controller.selectedKey
                  : null,
          onTap: () {
            controller.toDetails(warehouse);
          },
          leading: Icon(Icons.warehouse_rounded),
          subtitle: Text(warehouse.description ?? ''),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color:
                  controller.selected.id == warehouse.id
                      ? Colors.green
                      : Colors.grey.withAlpha(100),
            ),
          ),
          selectedTileColor:
              Get.find<HomeController>().theme.colorScheme.surfaceContainer,
          contentPadding: EdgeInsets.only(right: 8, top: 0, bottom: 0, left: 8),
          trailing: Icon(Icons.abc),
          title: Text(warehouse.translateName ?? 'warehouse'.tr),
        ),
      ),
    );
  }

  // GridView gridView() {
  //   return GridView.builder(
  //     padding: EdgeInsets.all(8),
  //     itemCount: controller.warehouses.length,
  //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
  //       maxCrossAxisExtent: 250,
  //       crossAxisSpacing: 8,
  //       mainAxisSpacing: 8,
  //       childAspectRatio: 0.7,
  //     ),
  //     itemBuilder: (c, i) {
  //       var warehouse = controller.warehouses[i];
  //       return gridItem(warehouse);
  //     },
  //   );
  // }

  // Container gridItem(Warehouse warehouse) {
  //   return Container(
  //     clipBehavior: Clip.antiAlias,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(8),
  //       color:
  //           !Get.find<HomeController>().isDark
  //               ? Colors.white
  //               : Get.find<HomeController>()
  //                   .theme
  //                   .colorScheme
  //                   .surfaceContainerHigh,
  //     ),
  //     child: GestureDetector(
  //       onTap: () {
  //         Get.toNamed(Routes.PRODUCT_FORM, arguments: {"warehouse": warehouse});
  //       },
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           Expanded(child: warehouse.leading()),
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Text(
  //               warehouse.translateName ?? '',
  //               style: TextStyle(fontSize: 16),
  //             ),
  //           ),

  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: Text(
  //                     '${warehouse.rest?.formatNumber() ?? '0'} ${warehouse.unity ?? 'u'.tr}',
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                       color:
  //                           warehouse.rest == 0
  //                               ? Colors.red
  //                               : (warehouse.rest ?? 0) < (warehouse.alert ?? 0)
  //                               ? Colors.amber
  //                               : Colors.green,
  //                     ),
  //                   ),
  //                 ),
  //                 Text(
  //                   '${warehouse.sellPrice?.toStringAsFixed(0) ?? 0.00} ${'dzd'.tr}',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: Colors.green,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
