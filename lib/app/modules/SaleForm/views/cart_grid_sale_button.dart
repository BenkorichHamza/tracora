import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/SaleForm/controllers/sale_form_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class CartGridSaleButton extends GetView<SaleFormController> {
  final Product product;

  CartGridSaleButton({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    return controller.qteOf(product) <= 0
        ? IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor:
                Get.find<HomeController>().dark.colorScheme.primaryContainer,
            foregroundColor: Colors.white,
          ),
          onPressed: () => controller.increment(product),
          icon: const Icon(CupertinoIcons.shopping_cart),
        )
        : Container(
          // height: 46,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Get.find<HomeController>().dark.colorScheme.primaryContainer,
          ),
          child: SizedBox(
            height: 120,
            width: 40,
            child: Column(
              children: [
                IconButton(
                  onPressed: () => controller.increment(product),
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      controller.qteOf(product).formatNumber() ?? '0',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => controller.decrement(product),
                  icon:
                      controller.qteOf(product) == 1
                          ? const Icon(
                            Icons.delete_outline,
                            color: Colors.amber,
                          )
                          : const Icon(Icons.remove, color: Colors.white),
                ),
              ],
            ),
          ),
        );
  }
}
