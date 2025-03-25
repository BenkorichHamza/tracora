import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';

import '../controllers/mission_controller.dart';

class MissionView extends GetView<MissionController> {
  const MissionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('missions'.tr),
        centerTitle: true,
        backgroundColor:
            Get.find<HomeController>().theme.scaffoldBackgroundColor,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.lazyPut(() => ProductController());
          Get.toNamed(Routes.MISSION_FORM);
        },
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.missions.length,
          itemBuilder: (c, i) {
            var mission = controller.missions[i];
            return ListTile(
              onTap: () {
                Get.lazyPut(() => ProductController());
                Get.toNamed(
                  Routes.MISSION_FORM,
                  arguments: {"mission": mission},
                );
              },
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  mission.employee?.img ?? '',
                ),
              ),
              subtitle: Text(mission.employee?.email ?? 'email'),
              title: Text(mission.startAt?.formatDate() ?? ''),
            );
          },
        ),
      ),
    );
  }
}
