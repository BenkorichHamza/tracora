import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
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
                  : Text('transactions'.tr),
        ),
        actions: [
          IconButton(
            onPressed: () {
              controller.showSearch = !controller.showSearch;
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
                      return GetBuilder<FeesPaymentController>(
                        id: 'item_${item.id}',
                        init: controller,
                        initState: (_) {},
                        builder: (c) {
                          return FeeTransactionTile(
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
