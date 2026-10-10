import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/User/controllers/user_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/widgets/panel.dart';
import 'package:tracora/app/widgets/text_field.dart';

import '../controllers/user_form_controller.dart';

class CustomerFormView<T> extends GetView<UserFormController<T>> {
  const CustomerFormView({super.key});
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
                  // key: controller.formKey,
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
                              controller: controller.phone,
                              label: "phone_number".tr,
                              validator:
                                  (v) =>
                                      (v ?? '').length < 9
                                          ? "not_valid_phone".tr
                                          : null,
                            ),
                            SizedBox(height: 16),
                            InputField(
                              controller: controller.address,
                              label: "address".tr,
                              validator:
                                  (v) =>
                                      (v ?? '').length < 3
                                          ? "less_than_3".tr
                                          : null,
                            ),
                            controller.userType == "employee"
                                ? SizedBox()
                                : SizedBox(height: 16),
                            controller.userType == "employee"
                                ? SizedBox()
                                : InputField(
                                  controller: controller.companyName,
                                  validator:
                                      (v) =>
                                          (v ?? '').length < 3
                                              ? "less_than_3".tr
                                              : null,

                                  label: 'company_name'.tr,
                                ),
                            SizedBox(height: 16),
                            InputField(
                              controller: controller.email,
                              label: "email".tr,
                              validator:
                                  (v) =>
                                      (v ?? '').isEmail
                                          ? null
                                          : 'not_valid_email'.tr,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Panel(
                          title: "tarification".tr,
                          children: [
                            InputField(
                              controller: controller.nin,
                              label: "nin".tr,
                            ),
                            controller.userType == "employee"
                                ? SizedBox()
                                : SizedBox(height: 16),
                            controller.userType == "employee"
                                ? SizedBox()
                                : InputField(
                                  controller: controller.nif,
                                  label: "nif".tr,
                                ),
                            SizedBox(height: 16),
                            InputField(
                              controller: controller.nis,
                              label: "nis".tr,
                            ),
                          ],
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
                                      Get.find<UserController<T>>().showForm =
                                          false;
                                      controller.init(UserModel());
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
                                      controller.init(UserModel());
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
                                    Get.find<UserController<T>>().showForm =
                                        false;
                                    controller.init(UserModel());
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
}
