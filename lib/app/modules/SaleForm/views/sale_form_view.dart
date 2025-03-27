import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/modules/SaleForm/views/product_sale_view.dart';
import 'package:tracora/app/modules/SaleForm/views/sale_cart_bar.dart';
import 'package:tracora/app/modules/SaleForm/views/sale_checkout.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

import '../controllers/sale_form_controller.dart';

class SaleFormView extends GetView<SaleFormController> {
  const SaleFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('sale_form'.tr), centerTitle: true),
      body: Row(
        children: [
          Expanded(child: ProductSaleShoppingView()),
          Container(
            width: 400,
            margin: EdgeInsets.all(4),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 0.2),
            ),
            child: SaleCheckoutPage(),
          ),
        ],
      ),
    );
  }
}
