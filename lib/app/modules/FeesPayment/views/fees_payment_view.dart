import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/FeesPaymentDetails/views/fees_payment_details_view.dart';
import 'package:tracora/app/modules/FeesPaymentForm/controllers/fees_payment_form_controller.dart';
import 'package:tracora/app/modules/FeesPaymentForm/views/fees_payment_form_view.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/FeesPayment/controllers/fees_payment_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/modules/home/views/sync_view.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:tracora/app/widgets/employee_selector.dart';
import 'package:tracora/app/widgets/empty_widget.dart';
import 'package:tracora/app/widgets/fee_transaction_tile.dart';
import 'package:tracora/app/widgets/money_transaction_tile.dart';
import 'package:tracora/app/widgets/stock_transaction_tabs.dart';
import 'package:tracora/app/widgets/stock_transaction_tile.dart';

class FeesPaymentView extends GetView<FeesPaymentController> {
  const FeesPaymentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          StockTransactionTabs(
            title: "fees",
            formTitle:
                Get.find<FeesPaymentFormController>().moneyTransaction.id ==
                        null
                    ? ('new_fee'.tr)
                    : (Get.find<FeesPaymentFormController>()
                            .moneyTransaction
                            .user
                            ?.firstName ??
                        Get.find<FeesPaymentFormController>()
                            .moneyTransaction
                            .description ??
                        'form'),
            onCloseForm: () {
              Get.find<FeesPaymentFormController>().init(MoneyTransaction());
              controller.showForm = false;
            },
            onFormTap: () => controller.showForm = true,
            onHideForm: () => controller.showForm = false,
            showForm: controller.showForm,
          ),
          Expanded(
            child: controller.showForm ? FeesPaymentFormView() : transactions(),
          ),
        ],
      ),
    );
  }

  Row transactions() {
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
          child: FeesPaymentDetailsView(),
        ),
      ],
    );
  }

  Scaffold list() {
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
            controller.transactions.isEmpty && !controller.loading
                ? EmptyWidget()
                : Obx(() {
                  return ListView.builder(
                    itemCount: controller.transactions.length,
                    controller: controller.scrollController,
                    itemBuilder: (c, i) {
                      var item = controller.transactions[i];
                      return GetBuilder<FeesPaymentController>(
                        id: 'item_${item.id}',
                        init: controller,
                        initState: (_) {},
                        builder: (c) {
                          return MoneyTransactionItem(
                            key:
                                item.id == controller.selected.id
                                    ? controller.selectedKey
                                    : null,
                            onValidate: (v) {},
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
