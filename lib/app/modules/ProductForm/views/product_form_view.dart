import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:tracora/app/core/intents.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/widgets/number_field.dart';
import 'package:tracora/app/widgets/panel.dart';
import 'package:tracora/app/widgets/text_field.dart';

import '../controllers/product_form_controller.dart';

class ProductFormView extends GetView<ProductFormController> {
  const ProductFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FocusScope(
        autofocus: true,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1000),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.all(16),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Form(
                  key: controller.formKey,
                  child: FocusTraversalGroup(
                    policy: OrderedTraversalPolicy(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Panels side by side
                        Row(
                          children: [
                            Expanded(
                              child: Panel(
                                title: 'product_info'.tr,
                                children: [
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(1),
                                    child: InputField(
                                      controller: controller.code,
                                      label: 'product_code'.tr,
                                      autoFocus: true,
                                    ),
                                  ),
                                  _spacer,
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(2),
                                    child: InputField(
                                      controller: controller.barcode,
                                      label: 'barcode'.tr,
                                      validator:
                                          (v) =>
                                              (v ?? '').isEmpty
                                                  ? null
                                                  : (v!.length < 3
                                                      ? 'less_than_3'.tr
                                                      : null),
                                    ),
                                  ),
                                  _spacer,
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(3),
                                    child: InputField(
                                      controller: controller.name,
                                      isRequired: true,
                                      label: 'product_name'.tr,
                                      validator:
                                          (v) =>
                                              (v ?? '').length < 3
                                                  ? 'less_than_3'.tr
                                                  : null,
                                    ),
                                  ),
                                  _spacer,
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(4),
                                    child: InputField(
                                      controller: controller.unity,
                                      label: 'unity'.tr,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 24),
                            Expanded(
                              child: Panel(
                                title: 'stock_info'.tr,
                                children: [
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(5),
                                    child: NumberField(
                                      controller: controller.packaging,
                                      label: 'package_qte'.tr,
                                    ),
                                  ),
                                  _spacer,
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(6),
                                    child: NumberField(
                                      controller: controller.stock,
                                      label: 'initial_stock'.tr,
                                    ),
                                  ),
                                  _spacer,
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(7),
                                    child: NumberField(
                                      controller: controller.stockValue,
                                      label: 'stock_value'.tr,
                                    ),
                                  ),
                                  _spacer,
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(8),
                                    child: NumberField(
                                      controller: controller.alert,
                                      label: 'alert_stock'.tr,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        // Pricing panel below
                        Center(
                          child: Panel(
                            title: 'pricing'.tr,
                            children: [
                              FocusTraversalOrder(
                                order: NumericFocusOrder(9),
                                child: NumberField(
                                  controller: controller.buyPrice,
                                  label: 'buy_price'.tr,
                                  isRequired: true,
                                ),
                              ),
                              _spacer,
                              FocusTraversalOrder(
                                order: NumericFocusOrder(10),
                                child: NumberField(
                                  controller: controller.sellPrice,
                                  label: 'sell_price'.tr,
                                  isRequired: true,
                                ),
                              ),
                              _spacer,
                              FocusTraversalOrder(
                                order: NumericFocusOrder(11),
                                child: NumberField(
                                  controller: controller.sellPrice1,
                                  label: 'sell_price_1'.tr,
                                ),
                              ),
                              _spacer,
                              FocusTraversalOrder(
                                order: NumericFocusOrder(12),
                                child: NumberField(
                                  controller: controller.sellPrice2,
                                  label: 'sell_price_2'.tr,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32),
                        // Save button
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FocusTraversalOrder(
                                order: NumericFocusOrder(13),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    controller.save(() {
                                      Get.find<ProductController>().showForm =
                                          false;
                                      controller.init(Product());
                                    });
                                  },
                                  icon: Icon(Icons.save, size: 20),
                                  label: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      "${'save_cancel'.tr} (F4)",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 2,
                                    iconColor: Colors.white,
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              FocusTraversalOrder(
                                order: NumericFocusOrder(15),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    controller.save(() {
                                      controller.init(Product());
                                    });
                                  },
                                  icon: Icon(Icons.save, size: 20),
                                  label: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      "${'save_create'.tr} (F5)",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 2,
                                    iconColor: Colors.white,
                                    backgroundColor: Colors.deepOrange,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              FocusTraversalOrder(
                                order: NumericFocusOrder(15),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Get.find<ProductController>().showForm =
                                        false;
                                    controller.init(Product());
                                  },
                                  icon: Icon(Icons.cancel, size: 20),

                                  label: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      "${'cancel'.tr} (ECHAP)",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    iconColor: Colors.white,
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _spacer => SizedBox(height: 16);
}
