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
          Row(children: [Expanded(child: TransactionTabs<T>())]),
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
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              border: Border.all(
                width: 0.5,
                color:
                    Get.find<HomeController>()
                        .theme
                        .colorScheme
                        .surfaceContainerHigh,
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
          child: StockTransactionDetailsView<T>(),
        ),
      ],
    );
  }

  Scaffold list() {
    var theme = Get.find<HomeController>().theme;
    var colorScheme = Get.find<HomeController>().theme.colorScheme;
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
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Obx(() {
              final hasSelectedEmployee =
                  controller.employee.id != null ||
                  controller.employee.firstName != null;
              final employeeName =
                  hasSelectedEmployee
                      ? controller.employee.firstName!
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
                        onTap: controller.selectEmployee,
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
                                controller.employee.circleAvatar(radius: 11)
                              else
                                CircleAvatar(
                                  radius: 11,
                                  backgroundColor: colorScheme.primary
                                      .withOpacity(0.12),
                                  child: Icon(
                                    Icons.people_alt_rounded,
                                    size: 13,
                                    color: colorScheme.primary,
                                  ),
                                ),
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
                            controller.employee = UserModel();
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
        padding: const EdgeInsets.all(2.0),
        child: Obx(
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
      ),
    );
  }
}
