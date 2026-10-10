import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

import '../controllers/brand_form_controller.dart';

class BrandFormView extends GetView<BrandFormController> {
  const BrandFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.brand.id == null
              ? 'new_brand'.tr
              : (controller.brand.name ?? ''),
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
                      controller.image.isNotEmpty
                          ? Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton.filled(
                                  onPressed: () => controller.image = '',
                                  icon: Icon(Icons.clear),
                                ),
                              ),
                            ],
                          )
                          : Icon(Icons.image_outlined, size: 100),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color:
                        Get.find<HomeController>()
                            .theme
                            .colorScheme
                            .surfaceContainerHighest,
                    image:
                        controller.image.isEmpty
                            ? controller.brand.toDecorationImage()
                            : DecorationImage(
                              image: MemoryImage(
                                File(controller.image).readAsBytesSync(),
                              ),
                            ),
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
              label: Text('brand_name'.tr),
            ),
          ),
          SizedBox(height: 32),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller.nameAr,
            validator: (v) => (v ?? '').length < 3 ? "less_than_3".tr : null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('brand_name_ar'.tr),
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
            child: Text('delete_brand'.tr),
          ),
        ],
      ),
    );
  }
}
