import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class SyncView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GetBuilder<HomeController>(
          init: controller,
          id: "sync",
          initState: (_) {},
          builder: (_) {
            return SizedBox(
              width: 15,
              child: Obx(
                () => Icon(
                  Icons.arrow_downward_sharp,
                  color: controller.cache ? Colors.red : Colors.green,
                ),
              ),
            );
          },
        ),
        SizedBox(width: 2),
        GetBuilder<HomeController>(
          init: controller,
          initState: (_) {},
          id: "sync",
          builder: (_) {
            return SizedBox(
              width: 15,
              child: Obx(
                () => Icon(
                  Icons.arrow_upward,
                  color: controller.pending ? Colors.red : Colors.green,
                ),
              ),
            );
          },
        ),
        SizedBox(width: 32),
      ],
    );
  }
}
