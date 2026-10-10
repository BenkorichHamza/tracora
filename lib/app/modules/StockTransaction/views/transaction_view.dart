import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:tracora/app/core/intents.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/StockTransaction/views/transaction_forms.dart';
import 'package:tracora/app/modules/StockTransaction/views/transaction_tabs.dart';
import 'package:tracora/app/modules/StockTransactionDetails/controllers/stock_transaction_details_controller.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/StockTransactionDetails/views/mission_details_view.dart';
import 'package:tracora/app/modules/StockTransactionDetails/views/stock_transaction_details_view.dart';
import 'package:tracora/app/modules/TransactionForm/controllers/transaction_form_controller.dart';
import 'package:tracora/app/modules/TransactionForm/views/transaction_form_view.dart';
import 'package:tracora/app/modules/User/controllers/user_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/modules/home/views/sync_view.dart';
import 'package:tracora/app/widgets/employee_selector.dart';
import 'package:tracora/app/widgets/empty_widget.dart';
import 'package:tracora/app/widgets/stock_transaction_tabs.dart';
import 'package:tracora/app/widgets/stock_transaction_tile.dart';

class StockTransactionView<T> extends GetView<StockTransactionController<T>> {
  const StockTransactionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          // StockTransactionTabs(
          //   title: controller.title,
          //   formTitle:
          //       Get.find<TransactionFormController<T>>().transaction.id == null
          //           ? (controller.newTitle)
          //           : (Get.find<TransactionFormController<T>>()
          //                   .transaction
          //                   .user
          //                   ?.firstName ??
          //               Get.find<TransactionFormController<T>>()
          //                   .user
          //                   .firstName ??
          //               'form'.tr),
          //   onCloseForm: () {
          //     Get.find<TransactionFormController<T>>().init(StockTransaction());
          //     controller.showForm = false;
          //   },
          //   onFormTap: () => controller.showForm = true,
          //   onHideForm: () => controller.showForm = false,
          //   showForm: controller.showForm,
          // ),
          TransactionTabs<T>(),
          Expanded(
            child:
                controller.selectedFormIndex >= 0
                    ? TransactionFormsPage<T>()
                    // ? TransactionFormView<T>()
                    : stockTransactions(),
          ),
        ],
      ),
    );
  }

  Row stockTransactions() {
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
        Container(
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
          child:
              T == Mission
                  ? MissionDetailsView()
                  : StockTransactionDetailsView<T>(),
        ),
      ],
    );
  }

  Scaffold list() {
    return Scaffold(
      appBar: AppBar(
        // Make all icons and text white by default:
        foregroundColor: Colors.white,
        backgroundColor:
            Get.find<HomeController>().dark.colorScheme.primaryContainer,

        // Always show the TextField as the title
        title: Focus(
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
              hintStyle: TextStyle(color: Colors.white54), // hint is semi-white
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
            onSubmitted: (_) => controller.searchFn.requestFocus(),
          ),
        ),

        actions: [
          // Example additional action, all icons are white by default
          // IconButton(
          //   icon: Icon(Icons.import_export),
          //   onPressed: controller.importExcelFile,
          //   tooltip: 'excel_import'.tr,
          // ),
          // IconButton(
          //   icon: Icon(Icons.refresh),
          //   onPressed: controller.getAll,
          //   tooltip: 'refresh',
          // ),
        ],
      ),

      body: Obx(
        () =>
            controller.transactions.isEmpty && !controller.loading
                ? EmptyWidget()
                : Obx(() {
                  return ListView.builder(
                    controller: controller.scrollController,
                    itemCount: controller.transactions.length,
                    itemBuilder: (c, i) {
                      var item = controller.transactions[i];
                      return GetBuilder<StockTransactionController<T>>(
                        id: 'item_${item.id}',
                        init: controller,
                        initState: (_) {},
                        builder: (c) {
                          return StockTransactionTile(
                            key:
                                item.id == controller.selected.id
                                    ? controller.selectedKey
                                    : null,
                            onValidate: (item) {
                              print(item.status);
                            },
                            selected: controller.selected.id == item.id,
                            highest: i.isEven,
                            onTap: controller.toDetails,
                            item: item,
                          );
                        },
                      );
                    },
                  );
                }),
      ),
    );
  }
}
