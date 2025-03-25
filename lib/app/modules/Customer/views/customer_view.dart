import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/modules/home/views/sync_view.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:tracora/app/widgets/empty_widget.dart';

import '../controllers/customer_controller.dart';

class CustomerView extends GetView<CustomerController> {
  const CustomerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: !controller.showSearch,
        onPopInvokedWithResult: (b, _) {
          controller.showSearch = false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:
                Get.find<HomeController>().theme.scaffoldBackgroundColor,
            title: Obx(
              () =>
                  controller.showSearch
                      ? TextField(
                        controller: controller.search,
                        autofocus: true,
                        autocorrect: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "search".tr,
                        ),
                        onChanged: (v) {
                          controller.getAll();
                        },
                      )
                      : Text('customers'.tr),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  controller.showSearch = true;
                },
                icon: Icon(Icons.search),
              ),
              SyncView(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.toNamed(Routes.CUSTOMER_FORM);
            },
            child: Icon(Icons.add),
          ),
          body: Obx(
            () =>
                controller.customers.isEmpty && !controller.loading
                    ? EmptyWidget()
                    : ListView.builder(
                      // separatorBuilder:
                      //     (c, i) => Divider(height: 0,, endIndent: 16, indent: 16),
                      itemCount: controller.customers.length,

                      itemBuilder: (c, i) {
                        var user = controller.customers[i];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          onTap: () {
                            if (Get.arguments?['select'] == true) {
                              Get.back(result: user);
                              return;
                            }
                            Get.toNamed(
                              Routes.CUSTOMER_DETAILS,
                              arguments: {"user": user},
                            );
                          },
                          leading: user.circleAvatar(),
                          title: Text(user.firstName ?? ''),
                          subtitle: Text(user.companyName ?? ''),
                          trailing: Tooltip(
                            message: "credit".tr,

                            child: Material(
                              color:
                                  Get.find<HomeController>()
                                      .dark
                                      .colorScheme
                                      .primaryContainer,
                              borderRadius: BorderRadius.circular(100),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                child: Text(
                                  '${user.toPay.formatPrice() ?? ''}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ),
      ),
    );
  }
}
