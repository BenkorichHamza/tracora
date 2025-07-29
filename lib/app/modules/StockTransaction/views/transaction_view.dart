import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:tracora/app/core/intents.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/helper/extensions.dart';
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
          StockTransactionTabs(
            title: controller.title,
            formTitle:
                Get.find<TransactionFormController<T>>().transaction.id == null
                    ? (controller.newTitle)
                    : (Get.find<TransactionFormController<T>>()
                            .transaction
                            .user
                            ?.firstName ??
                        Get.find<TransactionFormController<T>>()
                            .user
                            .firstName ??
                        'form'.tr),
            onCloseForm: () {
              Get.find<TransactionFormController<T>>().init(StockTransaction());
              controller.showForm = false;
            },
            onFormTap: () => controller.showForm = true,
            onHideForm: () => controller.showForm = false,
            showForm: controller.showForm,
          ),
          Expanded(
            child:
                controller.showForm
                    ? TransactionFormView<T>()
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
        foregroundColor: Colors.white,
        backgroundColor:
            Get.find<HomeController>().dark.colorScheme.primaryContainer,

        title: Obx(
          () =>
              controller.showSearch
                  ? TextField(
                    controller: controller.search,
                    focusNode: controller.searchFn,
                    autofocus: true,
                    autocorrect: true,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "search".tr,
                    ),
                    onChanged: (v) {
                      controller.getAll();
                    },
                  )
                  : Text(controller.title),
        ),
        actions: [
          IconButton(
            onPressed: () {
              controller.showSearch = !controller.showSearch;
              controller.searchFn.requestFocus(controller.focusNode);
            },
            color: Colors.white,
            icon: Icon(controller.showSearch ? Icons.close : Icons.search),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250),
              child: EmployeeSelector(
                onSelect: (v) {
                  controller.employee = v;
                  controller.getAll();
                },
              ),
            ),
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
                    itemBuilder: (c, i) {
                      var item = controller.transactions[i];
                      return GetBuilder<StockTransactionController<T>>(
                        id: 'item_${item.id}',
                        init: controller,
                        initState: (_) {},
                        builder: (c) {
                          return StockTransactionTile(
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
