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

class WarehouseSelectView extends GetView<WarehouseController> {
  const WarehouseSelectView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          // StockTransactionTabs(
          //   title: "warehouses".tr,
          //   formTitle:
          //       Get.find<WarehouseFormController>().warehouse.id == null
          //           ? ('${'new_warehouse'.tr} F1')
          //           : (Get.find<WarehouseFormController>().warehouse.name ??
          //               Get.find<WarehouseFormController>().warehouse.nameAr ??
          //               'form'),
          //   onCloseForm: () {
          //     Get.find<WarehouseFormController>().init(Warehouse());
          //     controller.showForm = false;
          //   },
          //   onFormTap: () => controller.showForm = true,
          //   onHideForm: () => controller.showForm = false,
          //   showForm: controller.showForm,
          // ),
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
              child: WarehouseDetailsView(),
            ),
      ],
    );
  }

  list() {
    return Scaffold(
      // appBar: AppBar(
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
      //   ],
      // ),
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
      itemCount: controller.warehouses.length + 1,
      itemBuilder: (c, i) {
        if (i == 0) {
          return ListTile(
            title: Text('select_warehouse'),
            leading: Icon(Icons.warehouse),
            onTap: () => Get.back(result: Warehouse()),
          );
        }
        var warehouse = controller.warehouses[i - 1];
        return listItem(warehouse);
      },
    );
  }

  Padding listItem(Warehouse warehouse) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Obx(
        () => ListTile(
          // selected: controller.selected.id == warehouse.id,
          key:
              warehouse.id == controller.selected.id
                  ? controller.selectedKey
                  : null,
          onTap: () {
            Get.back(result: warehouse);
          },
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
          tileColor:
              Get.find<HomeController>().isDark
                  ? Get.find<HomeController>()
                      .theme
                      .colorScheme
                      .surfaceContainerHigh
                  : Colors.white,
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
