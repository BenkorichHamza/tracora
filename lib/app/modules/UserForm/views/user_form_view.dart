import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

import '../controllers/user_form_controller.dart';

class CustomerFormView<T> extends GetView<UserFormController<T>> {
  const CustomerFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 550),
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              // Obx(
              //   () => Center(
              //     child: Container(
              //       height: 200,
              //       width: 200,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(1000),
              //         color:
              //             Get.find<HomeController>()
              //                 .theme
              //                 .colorScheme
              //                 .surfaceContainerHighest,
              //         image: controller.img.toDecorationImage(),
              //       ),
              //       child: InkWell(
              //         borderRadius: BorderRadius.circular(1000),
              //         onTap: controller.pickImage,
              //         child:
              //             controller.img.toDecorationImage() != null
              //                 ? Align(
              //                   alignment: Alignment.topRight,
              //                   child: IconButton.filled(
              //                     onPressed: () => controller.img = '',
              //                     icon: Icon(Icons.clear),
              //                   ),
              //                 )
              //                 : Icon(Icons.image_outlined, size: 100),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 8),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.name,
                validator:
                    (v) => (v ?? '').length < 3 ? "less_than_3".tr : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('name'.tr),
                ),
              ),
              controller.userType == "employee"
                  ? SizedBox()
                  : SizedBox(height: 8),
              controller.userType == "employee"
                  ? SizedBox()
                  : controller.userType == "employee"
                  ? SizedBox()
                  : TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: controller.companyName,
                    validator:
                        (v) => (v ?? '').length < 3 ? "less_than_3".tr : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('company_name'.tr),
                    ),
                  ),
              SizedBox(height: 8),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.email,
                validator:
                    (v) => (v ?? '').isEmail ? null : 'not_valid_email'.tr,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('email'.tr),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.phone,
                validator:
                    (v) => (v ?? '').length < 9 ? "not_valid_phone".tr : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('phone'.tr),
                ),
              ),
              controller.userType == "employee"
                  ? SizedBox()
                  : SizedBox(height: 8),
              controller.userType == "employee"
                  ? SizedBox()
                  : TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: controller.nin,
                    // validator: (v) => (v ?? '').length < 3 ? "less_than_3".tr : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('nin'.tr),
                    ),
                  ),
              controller.userType == "employee"
                  ? SizedBox()
                  : SizedBox(height: 8),
              controller.userType == "employee"
                  ? SizedBox()
                  : TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: controller.nif,
                    // validator: (v) => (v ?? '').length < 3 ? "less_than_3".tr : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('nif'.tr),
                    ),
                  ),
              controller.userType == "employee"
                  ? SizedBox()
                  : SizedBox(height: 8),
              controller.userType == "employee"
                  ? SizedBox()
                  : TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: controller.nis,
                    // validator: (v) => (v ?? '').length < 3 ? "less_than_3".tr : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('nis'.tr),
                    ),
                  ),
              controller.userType == "employee"
                  ? SizedBox()
                  : SizedBox(height: 8),

              controller.userType == "employee"
                  ? SizedBox()
                  : TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: controller.address,
                    validator:
                        (v) => (v ?? '').length < 3 ? "less_than_3".tr : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('address'.tr),
                    ),
                  ),
              SizedBox(height: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(fixedSize: Size.fromHeight(50)),
                onPressed: controller.save,
                child: Text('save'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
