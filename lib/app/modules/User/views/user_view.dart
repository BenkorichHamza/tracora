import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/CustomerDetails/bindings/user_details_binding.dart';
import 'package:tracora/app/modules/CustomerDetails/views/user_details_view.dart';
import 'package:tracora/app/modules/UserForm/controllers/user_form_controller.dart';
import 'package:tracora/app/modules/UserForm/views/user_form_view.dart';
import 'package:tracora/app/modules/PurchaseForm/controllers/purchase_form_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/modules/home/views/sync_view.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:tracora/app/widgets/empty_widget.dart';
import 'package:tracora/app/widgets/stock_transaction_tabs.dart';
import 'package:tracora/app/widgets/user_tile.dart';

import '../controllers/user_controller.dart';

class UserView<T> extends GetView<UserController<T>> {
  const UserView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          StockTransactionTabs(
            title: "transaction",
            formTitle:
                Get.find<UserFormController<T>>().user.id == null
                    ? ('new_user'.tr)
                    : (Get.find<UserFormController<T>>().user.firstName ??
                        Get.find<UserFormController<T>>().user.firstName ??
                        'form'),
            onCloseForm: () {
              Get.find<UserFormController<T>>().init(UserModel());
              controller.showForm = false;
            },
            onFormTap: () => controller.showForm = true,
            onHideForm: () => controller.showForm = false,
            showForm: controller.showForm,
          ),
          Expanded(
            child: controller.showForm ? CustomerFormView<T>() : users(),
          ),
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
              child: UserDetailsView<T>(),
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
                  : Text('users'.tr),
        ),
        actions: [
          IconButton(
            onPressed: () {
              controller.showSearch = !controller.showSearch;
            },
            color: Colors.white,
            icon: Icon(controller.showSearch ? Icons.close : Icons.search),
          ),
          SyncView(),
        ],
      ),

      body: Obx(
        () =>
            controller.users.isEmpty && !controller.loading
                ? EmptyWidget()
                : Obx(() {
                  return ListView.builder(
                    itemCount: controller.users.length,
                    itemBuilder: (c, i) {
                      var item = controller.users[i];
                      return GetBuilder<UserController<T>>(
                        id: 'item_${item.id}',
                        init: controller,
                        initState: (_) {},
                        builder: (c) {
                          print(item.id);
                          return UserTile(
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
