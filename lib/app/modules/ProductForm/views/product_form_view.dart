import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

import '../controllers/product_form_controller.dart';

class ProductFormView extends GetView<ProductFormController> {
  const ProductFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.product.id == null
              ? 'new_product'.tr
              : (controller.product.name ?? ''),
        ),
        centerTitle: true,
        backgroundColor:
            Get.find<HomeController>().theme.scaffoldBackgroundColor,
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller.name,
                        textInputAction: TextInputAction.next,

                        validator:
                            (v) =>
                                (v ?? '').length < 3 ? "less_than_3".tr : null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('product_name'.tr),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller.nameAr,
                        textInputAction: TextInputAction.next,
                        validator:
                            (v) =>
                                (v ?? '').isEmpty
                                    ? null
                                    : (v ?? '').length < 3
                                    ? "less_than_3".tr
                                    : null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('product_name_ar'.tr),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller.buyPrice,
                        textInputAction: TextInputAction.next,
                        validator:
                            (v) =>
                                double.tryParse(v ?? '') == null
                                    ? "not_double".tr
                                    : null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('buy_price'.tr),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller.sellPrice,
                        textInputAction: TextInputAction.next,
                        validator:
                            (v) =>
                                double.tryParse(v ?? '') == null
                                    ? "not_double".tr
                                    : null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('sell_price'.tr),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller.barcode,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('barcode'.tr),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: controller.scanBarcode,
                      icon: Icon(Icons.qr_code_scanner_outlined),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: controller.packaging,
                            textInputAction: TextInputAction.next,
                            validator:
                                (v) =>
                                    (v ?? '').isEmpty
                                        ? null
                                        : double.tryParse(v ?? '') == null
                                        ? "not_double".tr
                                        : null,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r"[0-9.]"),
                              ),
                              TextInputFormatter.withFunction((
                                oldValue,
                                newValue,
                              ) {
                                final text = newValue.text;
                                if (text.contains('.') &&
                                    text.split('.').last.length > 2) {
                                  return oldValue;
                                }
                                if (text.startsWith('00')) {
                                  return oldValue;
                                }
                                if (text.startsWith('.')) {
                                  return oldValue;
                                }

                                if (text.startsWith('0') &&
                                    !text.startsWith('0.') &&
                                    text.length > 1) {
                                  return oldValue.copyWith(
                                    text: int.tryParse(text)?.toString() ?? '0',
                                  );
                                }
                                if (text.characters
                                        .where((c) => c == ".")
                                        .length >
                                    1) {
                                  return oldValue;
                                }

                                return newValue;
                              }),
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('packaging'.tr),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: controller.unity,
                            textAlign: TextAlign.center,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('unity'.tr),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: controller.alert,
                            textInputAction: TextInputAction.next,
                            validator:
                                (v) =>
                                    (v ?? '').isEmpty
                                        ? null
                                        : double.tryParse(v ?? '') == null
                                        ? "not_double".tr
                                        : null,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r"[0-9.]"),
                              ),
                              TextInputFormatter.withFunction((
                                oldValue,
                                newValue,
                              ) {
                                final text = newValue.text;
                                if (text.contains('.') &&
                                    text.split('.').last.length > 2) {
                                  return oldValue;
                                }
                                if (text.startsWith('00')) {
                                  return oldValue;
                                }
                                if (text.startsWith('.')) {
                                  return oldValue;
                                }

                                if (text.startsWith('0') &&
                                    !text.startsWith('0.') &&
                                    text.length > 1) {
                                  return oldValue.copyWith(
                                    text: int.tryParse(text)?.toString() ?? '0',
                                  );
                                }
                                if (text.characters
                                        .where((c) => c == ".")
                                        .length >
                                    1) {
                                  return oldValue;
                                }

                                return newValue;
                              }),
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('alert_stock'.tr),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    Container(height: 210, child: productImage()),
                  ],
                ),
                SizedBox(height: 16),
                Obx(
                  () => Card(
                    clipBehavior: Clip.antiAlias,
                    color:
                        Get.find<HomeController>().isDark
                            ? Get.find<HomeController>()
                                .theme
                                .colorScheme
                                .surfaceContainerHighest
                            : Colors.white,
                    child: ListTile(
                      title: Text(
                        controller.brand.id == null
                            ? 'select_brand'.tr
                            : controller.brand.translateName ?? 'brand'.tr,
                      ),
                      leading:
                          controller.brand.data == null
                              ? Icon(Icons.image)
                              : AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  margin: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    image: controller.brand.toDecorationImage(),
                                  ),
                                ),
                              ),
                      onTap: () {
                        controller.getBrand();
                      },
                    ),
                  ),
                ),
                Obx(
                  () => Card(
                    color:
                        Get.find<HomeController>().isDark
                            ? Get.find<HomeController>()
                                .theme
                                .colorScheme
                                .surfaceContainerHighest
                            : Colors.white,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children:
                          controller.categories
                              .map<Widget>(
                                (category) => Chip(
                                  avatar:
                                      !File(category.img ?? '').existsSync()
                                          ? Icon(Icons.image)
                                          : CircleAvatar(
                                            backgroundImage: FileImage(
                                              File(category.img ?? ''),
                                            ),
                                          ),
                                  label: Text(
                                    category.translateName ?? 'category'.tr,
                                  ),
                                  deleteIcon: Icon(Icons.close),
                                  onDeleted: () {
                                    controller.toggle(category);
                                  },
                                ),
                              )
                              .toList() +
                          [
                            TextButton.icon(
                              icon: Icon(Icons.category_outlined),
                              onPressed: controller.getCategories,
                              label: Text('add_categories'.tr),
                            ),
                          ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size.fromHeight(50),
                  ),
                  onPressed: controller.save,
                  child: Text('save'.tr),
                ),
                SizedBox(height: 64),

                controller.product.id == null
                    ? SizedBox()
                    : TextButton(
                      style: TextButton.styleFrom(
                        overlayColor: Colors.red,
                        foregroundColor: Colors.red,
                      ),
                      onPressed: controller.delete,
                      child: Text('delete_product'.tr),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AspectRatio productImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: Obx(
        () => InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: controller.pickImage,
          child: Container(
            child:
                File(controller.img).existsSync()
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
              borderRadius: BorderRadius.circular(16),
              color:
                  Get.find<HomeController>()
                      .theme
                      .colorScheme
                      .surfaceContainerHighest,
              image:
                  !File(controller.img).existsSync()
                      ? null
                      : DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(controller.img)),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
