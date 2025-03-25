import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/modules/PurchaseForm/views/product_purchase_view.dart';
import 'package:tracora/app/modules/PurchaseForm/views/purchase_cart_bar.dart';
import 'package:tracora/app/modules/PurchaseForm/views/purchase_checkout.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

import '../controllers/purchase_form_controller.dart';

class PurchaseFormView extends GetView<PurchaseFormController> {
  const PurchaseFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('purchase_form'.tr), centerTitle: true),
      body: Stack(
        children: [
          ProductPurchaseShoppingView(),

          Obx(
            () =>
                controller.productTransactions.isEmpty
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
                        openBuilder: (c, a) => PurchaseCheckoutPage(),
                        closedBuilder: (c, a) => PurchaseCartBar(),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
