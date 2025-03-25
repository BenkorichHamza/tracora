import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/mission_model.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/MissionForm/controllers/mission_form_controller.dart';
import 'package:tracora/app/modules/MissionForm/views/cart_list_mission_button.dart';
import 'package:tracora/app/modules/PurchaseForm/views/cart_list_purchase_button.dart';
import 'package:tracora/app/modules/PurchaseForm/controllers/purchase_form_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';

class MissionCheckoutPage extends GetView<MissionFormController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("mission".tr),
        centerTitle: true,
        backgroundColor:
            Get.find<HomeController>().theme.scaffoldBackgroundColor,
      ),
      body: Obx(
        () => ListView(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        // border: Border.all(width: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        color:
                            Get.find<HomeController>()
                                .theme
                                .scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1,
                            spreadRadius: 1,

                            color: Colors.black12,
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: controller.sellectSupplier,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    child:
                                        !(controller.employee.img?.isURL ??
                                                false)
                                            ? Icon(Icons.person, size: 60)
                                            : null,
                                    backgroundImage:
                                        !(controller.employee.img?.isURL ??
                                                false)
                                            ? null
                                            : CachedNetworkImageProvider(
                                              controller.employee.img ?? '',
                                            ),
                                  ),
                                  SizedBox(height: 8),
                                  Center(
                                    child:
                                        controller.employee.id == null
                                            ? Text('select_employee'.tr)
                                            : Text(
                                              controller.employee.email ?? '',
                                              style: TextStyle(fontSize: 16),
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

                  ...List.generate(controller.missionProducts.length, (i) {
                    var missionProduct = controller.missionProducts[i];
                    return cartItem(missionProduct);
                  }),
                  Divider(),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Obx(
                () => ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onTap: () => controller.editTime(),
                  leading: Icon(Icons.calendar_month),
                  title:
                      controller.startAt == 0
                          ? Text('select_date'.tr)
                          : Text(
                            controller.startAt.formatDate() ?? '-- / -- / ----',
                          ),
                  trailing: OutlinedButton.icon(
                    icon: Icon(Icons.edit_calendar),
                    onPressed: controller.editTime,
                    label: Text('edit'),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                color:
                    Get.find<HomeController>()
                        .dark
                        .colorScheme
                        .primaryContainer,
                child: InkWell(
                  borderRadius: BorderRadius.circular(32),
                  onTap: controller.save,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'save'.tr,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cartItem(MissionProduct missionProduct) {
    var product = missionProduct.product;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        onTap: () {
          controller.setQte(product ?? Product());
        },
        subtitle: Text(product?.sellPrice.formatPrice() ?? ''),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

        contentPadding: EdgeInsets.only(right: 8, top: 0, bottom: 0, left: 8),
        leading: product?.leading(),
        title: Text(product?.translateName ?? 'product'.tr),
        trailing: CartListMissionButton(product: product ?? Product()),
      ),
    );
  }
}
