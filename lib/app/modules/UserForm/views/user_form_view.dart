import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/data/models/role.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/RolePermission/controllers/role_permission_controller.dart';
import 'package:tracora/app/modules/RolePermission/views/role_selection_view.dart';
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
                            SizedBox(height: 16),
                            Obx(
                              () => ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                title:
                                    controller.warehouse.id == null
                                        ? Text("select_warehouse".tr)
                                        : Text(controller.warehouse.name ?? ''),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                onTap: () {
                                  controller.selectWarehouse();
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            InputField(
                              controller: controller.password,
                              label: "password".tr,
                              validator:
                                  (v) =>
                                      (v ?? '').length >= 6
                                          ? null
                                          : 'not_valid_password'.tr,
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
                            controller.userType == "employee"
                                ? SizedBox(height: 16)
                                : SizedBox(),
                            controller.userType == "employee"
                                ? Obx(() {
                                  final roles = controller.roles;

                                  return Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.surfaceContainerLow,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.outlineVariant,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Assigned Roles',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextButton.icon(
                                              onPressed: () async {
                                                Get.find<
                                                      RolePermissionController
                                                    >()
                                                    .getAll();
                                                Get.find<
                                                      RolePermissionController
                                                    >()
                                                    .selected = controller
                                                        .roles;
                                                final result = await showDialog<
                                                  List<Role>
                                                >(
                                                  context: context,
                                                  builder:
                                                      (c) => Center(
                                                        child: SizedBox(
                                                          width: 500,
                                                          child:
                                                              RoleSelectionView(),
                                                        ),
                                                      ),
                                                );
                                                if (result != null) {
                                                  controller.roles = result;
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.add_rounded,
                                                size: 18,
                                              ),
                                              label: Text(
                                                roles.isEmpty
                                                    ? 'Add Roles'
                                                    : 'Edit',
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        if (roles.isEmpty)
                                          Text(
                                            'No roles assigned yet.',
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.outline,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          )
                                        else
                                          Wrap(
                                            spacing: 8.0,
                                            runSpacing: 8.0,
                                            children:
                                                roles.map((role) {
                                                  return Chip(
                                                    avatar: const Icon(
                                                      Icons.shield_outlined,
                                                      size: 16,
                                                    ),
                                                    label: Text(
                                                      role.name ??
                                                          'Unnamed Role',
                                                    ),
                                                    deleteIcon: const Icon(
                                                      Icons.close_rounded,
                                                      size: 16,
                                                    ),
                                                    onDeleted: () {
                                                      // Requires an RxList (e.g., RxList<Role>) in your controller
                                                      controller.roles.remove(
                                                        role,
                                                      );
                                                      controller
                                                          .roles = controller
                                                          .roles
                                                          .sublist(0);
                                                    },
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    side: BorderSide.none,
                                                    backgroundColor: Theme.of(
                                                          context,
                                                        )
                                                        .colorScheme
                                                        .primaryContainer
                                                        .withOpacity(0.5),
                                                  );
                                                }).toList(),
                                          ),
                                      ],
                                    ),
                                  );
                                })
                                : SizedBox(),
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
