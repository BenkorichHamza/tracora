import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/modules/MissionForm/views/mission_checkout.dart';
import 'package:tracora/app/modules/MissionForm/views/misson_cart_bar.dart';
import 'package:tracora/app/modules/MissionForm/views/product_mission_view.dart';
import 'package:tracora/app/modules/Product/views/product_view.dart';
import 'package:tracora/app/modules/PurchaseForm/views/product_purchase_view.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

import '../controllers/mission_form_controller.dart';

class MissionFormView extends GetView<MissionFormController> {
  const MissionFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProductMissionView(),

        Obx(
          () =>
              controller.missionProducts.isEmpty
                  ? SizedBox()
                  : Positioned(
                    right: 8,
                    left: 8,
                    bottom: 12,
                    child: OpenContainer(
                      openShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      closedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      openColor:
                          Get.find<HomeController>()
                              .theme
                              .scaffoldBackgroundColor,
                      closedColor:
                          Get.find<HomeController>()
                              .theme
                              .scaffoldBackgroundColor,
                      transitionDuration: Duration(seconds: 1),
                      openBuilder: (c, a) => MissionCheckoutPage(),
                      closedBuilder: (c, a) => MissionCartBar(),
                    ),
                  ),
        ),
      ],
    );
  }
}
