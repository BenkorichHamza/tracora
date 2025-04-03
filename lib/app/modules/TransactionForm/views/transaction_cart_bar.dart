import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/TransactionForm/controllers/transaction_form_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class TransactionCartBar<T> extends GetView<TransactionFormController<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Get.find<HomeController>().dark.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...controller.productTransactions
                          .where((e) => (e.qte ?? 0) > 0)
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: GestureDetector(
                                onTap:
                                    () => controller.setQte(
                                      e.product ?? Product(),
                                    ),
                                child: Badge(
                                  label: Text(e.qte.formatNumber() ?? '0'),
                                  alignment: Alignment.topCenter,
                                  child: Hero(
                                    tag: "product_${e.product?.id ?? 0}",
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.green,
                                          width: 1,
                                        ),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: e.product?.leading(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${controller.total.formatPrice()}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
