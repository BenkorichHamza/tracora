import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/widgets/empty_widget.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/driver_controller.dart';

class DriverView extends GetView<DriverController> {
  const DriverView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('employees'.tr),
        centerTitle: true,
        backgroundColor:
            Get.find<HomeController>().theme.scaffoldBackgroundColor,
      ),
      body: Obx(
        () =>
            controller.firstLoad
                ? Center(child: CircularProgressIndicator())
                : controller.drivers.isEmpty
                ? EmptyWidget()
                : ListView.builder(
                  itemCount: controller.filteredDrivers.length,
                  itemBuilder: (c, i) {
                    var driver = controller.filteredDrivers[i];
                    return Card(
                      child: InkWell(
                        onTap:
                            Get.arguments?["select"] != true
                                ? null
                                : () => Get.back(result: driver),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(driver.name ?? 'driver'.tr),
                              subtitle: Text(driver.email ?? 'driver'.tr),
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  driver.img ?? '',
                                  errorListener: (e) {},
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(driver.phone ?? 'phone'.tr),
                              leading: Icon(Icons.call),
                              trailing: IconButton.filled(
                                color: Colors.white,
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      Get.find<HomeController>()
                                          .dark
                                          .colorScheme
                                          .primaryContainer,
                                  foregroundColor: Colors.white,
                                ),

                                onPressed:
                                    driver.phone?.isPhoneNumber != true
                                        ? null
                                        : () {
                                          launchUrl(
                                            Uri.parse('tel:${driver.phone}'),
                                          );
                                        },
                                icon: Icon(Icons.call),
                              ),
                            ),
                            SwitchListTile(
                              title: Text('active'.tr),
                              value: driver.active ?? false,
                              onChanged: (v) {
                                FirebaseFirestore.instance
                                    .collection("employees")
                                    .doc(driver.id)
                                    .set({
                                      "active": v,
                                    }, SetOptions(merge: true));
                              },
                            ),
                            SwitchListTile(
                              title: Text('admin'.tr),
                              value: driver.admin ?? false,
                              onChanged: (v) {
                                FirebaseFirestore.instance
                                    .collection("employees")
                                    .doc(driver.id)
                                    .set({"admin": v}, SetOptions(merge: true));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
