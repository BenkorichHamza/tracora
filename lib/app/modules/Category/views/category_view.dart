import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/modules/home/views/sync_view.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:tracora/app/widgets/empty_widget.dart';

import '../controllers/category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});
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
                      : Text('categories'.tr),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  controller.showSearch = true;
                },
                icon: Icon(Icons.search),
              ),

              Get.arguments?['select'] != true
                  ? SizedBox()
                  : OutlinedButton.icon(
                    label: Text('select'.tr),
                    onPressed: () {
                      Get.back(
                        result:
                            controller.categories
                                .where(
                                  (c) => controller.selected.contains(c.id),
                                )
                                .toList(),
                      );
                    },
                    icon: Icon(Icons.save),
                  ),
              SyncView(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.toNamed(Routes.CATEGORY_FORM);
            },
            child: Icon(Icons.add),
          ),
          body: Obx(
            () =>
                controller.categories.isEmpty && !controller.loading
                    ? EmptyWidget()
                    : GridView.builder(
                      itemCount: controller.categories.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 180,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (c, i) {
                        return Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color:
                                Get.find<HomeController>()
                                    .theme
                                    .colorScheme
                                    .surfaceContainerHigh,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Get.arguments?["select"] == true
                                  ? controller.toggleSelected(
                                    controller.categories[i].id ?? (-1),
                                  )
                                  : Get.toNamed(
                                    Routes.CATEGORY_FORM,
                                    arguments: {
                                      "category": controller.categories[i],
                                    },
                                  );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Obx(
                                    () => Container(
                                      child:
                                          !controller.selected.contains(
                                                controller.categories[i].id ??
                                                    (-1),
                                              )
                                              ? null
                                              : Align(
                                                alignment: Alignment.topRight,
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                ),
                                              ),
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image:
                                            controller.categories[i]
                                                .toDecorationImage(),
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Center(
                                    child: Text(
                                      controller.categories[i].translateName ??
                                          '',
                                    ),
                                  ),
                                ),
                              ],
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
