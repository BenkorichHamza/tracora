import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

import '../controllers/category_form_controller.dart';

class CategoryFormView extends GetView<CategoryFormController> {
  const CategoryFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.category.id == null
              ? 'new_category'.tr
              : (controller.category.name ?? ''),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Obx(
              () => InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: controller.pickImage,
                child: Container(
                  child:
                      (controller.img).isNotEmpty
                          ? Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton.filled(
                                  onPressed: () => controller.img = '',
                                  icon: Icon(Icons.clear),
                                ),
                              ),
                            ],
                          )
                          : Icon(Icons.image_outlined, size: 100),
                  decoration: BoxDecoration(
                    image:
                        controller.img.isEmpty
                            ? controller.category.toDecorationImage()
                            : controller.img.toDecorationImage(),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller.name,
            validator: (v) => (v ?? '').length < 3 ? "less_than_3".tr : null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('category_name'.tr),
            ),
          ),
          SizedBox(height: 32),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller.nameAr,
            validator: (v) => (v ?? '').length < 3 ? "less_than_3".tr : null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('category_name_ar'.tr),
            ),
          ),
          SizedBox(height: 32),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller.order,
            validator:
                (v) => int.tryParse(v ?? '') == null ? "not_integer".tr : null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('category_order'.tr),
            ),
          ),
          SizedBox(height: 32),
          OutlinedButton(
            style: OutlinedButton.styleFrom(fixedSize: Size.fromHeight(50)),
            onPressed: controller.save,
            child: Text('save'.tr),
          ),
          SizedBox(height: 64),
          TextButton(
            style: TextButton.styleFrom(
              overlayColor: Colors.red,
              foregroundColor: Colors.red,
            ),
            onPressed: controller.delete,
            child: Text('delete_category'.tr),
          ),
        ],
      ),
    );
  }
}
