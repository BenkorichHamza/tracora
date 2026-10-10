import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/data/models/warehouse.dart';
import 'package:tracora/app/modules/warehouse/controllers/warehouse_controller.dart';
import 'package:tracora/app/widgets/panel.dart';
import 'package:tracora/app/widgets/text_field.dart';

import '../controllers/warehouse_form_controller.dart';

class WarehouseFormView extends GetView<WarehouseFormController> {
  const WarehouseFormView({super.key});
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
                        Panel(
                          title: "personal_informations".tr,
                          children: [
                            InputField(
                              autoFocus: true,
                              controller: controller.name,
                              label: "name".tr,
                              isRequired: true,
                              validator:
                                  (v) =>
                                      (v ?? '').length < 3
                                          ? "less_than_3".tr
                                          : null,
                            ),
                            SizedBox(height: 16),
                            InputField(
                              controller: controller.description,
                              label: "description".tr,
                              validator:
                                  (v) =>
                                      (v ?? '').length < 3
                                          ? "less_than_3".tr
                                          : null,
                            ),
                            SizedBox(height: 16),

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
                                          Get.find<WarehouseController>()
                                              .showForm = false;
                                          controller.init(Warehouse());
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        elevation: 2,
                                        iconColor: Colors.white,
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Get.arguments?["select"] == true
                                      ? SizedBox()
                                      : SizedBox(width: 16),
                                  Get.arguments?["select"] == true
                                      ? SizedBox()
                                      : FocusTraversalOrder(
                                        order: NumericFocusOrder(15),
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            controller.save(() {
                                              controller.init(Warehouse());
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            elevation: 2,
                                            iconColor: Colors.white,
                                            backgroundColor: Colors.deepOrange,
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                  Get.arguments?["select"] == true
                                      ? SizedBox()
                                      : SizedBox(width: 16),
                                  Get.arguments?["select"] == true
                                      ? SizedBox()
                                      : FocusTraversalOrder(
                                        order: NumericFocusOrder(15),
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Get.find<WarehouseController>()
                                                .showForm = false;
                                            controller.init(Warehouse());
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
}
