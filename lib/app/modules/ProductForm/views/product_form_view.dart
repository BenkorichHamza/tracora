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
      appBar: AppBar(title: Text('Product Details'), centerTitle: true),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1000),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Three columns: Image | Field group A | Field group B
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Column 1: Image
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: SizedBox(
                              height: 250,
                              width: 250,
                              child: productImage(),
                            ),
                          ),
                        ),

                        SizedBox(width: 24),

                        // Column 2: fields group A
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              _numberField(
                                controller: controller.stock,
                                label: 'initial_stock'.tr,
                                isDecimal: true,
                              ),
                              SizedBox(height: 16),
                              _numberField(
                                controller: controller.alert,
                                label: 'alert_stock'.tr,
                              ),
                              SizedBox(height: 16),
                              _textField(
                                controller: controller.unity,
                                label: 'unity'.tr,
                              ),
                              SizedBox(height: 16),
                              _textField(
                                controller: controller.barcode,
                                label: 'barcode'.tr,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 24),

                        // Column 3: fields group B
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              _textField(
                                controller: controller.name,
                                label: 'product_name'.tr,
                                validator:
                                    (v) =>
                                        (v ?? '').length < 3
                                            ? 'less_than_3'.tr
                                            : null,
                              ),
                              SizedBox(height: 16),
                              _numberField(
                                controller: controller.buyPrice,
                                label: 'buy_price'.tr,
                              ),
                              SizedBox(height: 16),
                              _numberField(
                                controller: controller.sellPrice,
                                label: 'sell_price'.tr,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32),

                    // Save button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: controller.save,
                        icon: Icon(Icons.save),
                        label: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Text(
                            'save'.tr,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _numberField({
    required TextEditingController controller,
    required String label,
    bool isDecimal = false,
  }) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator:
          (v) =>
              (v ?? '').isEmpty
                  ? null
                  : double.tryParse(v!) == null
                  ? 'not_double'.tr
                  : null,
      keyboardType: TextInputType.numberWithOptions(
        decimal: isDecimal,
        signed: false,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(isDecimal ? r"[0-9.]" : r"[0-9]"),
        ),
      ],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
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
                controller.img.isNotEmpty
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
                    : controller.product.data != null
                    ? null
                    : Icon(Icons.image_outlined, size: 100),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color:
                  Get.find<HomeController>()
                      .theme
                      .colorScheme
                      .surfaceContainerHighest,
              image:
                  controller.img.toDecorationImage() ??
                  controller.product.toDecorationImage(),
            ),
          ),
        ),
      ),
    );
  }
}
