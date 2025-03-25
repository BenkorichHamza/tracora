import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:tracora/app/modules/home/views/super_admin_menu.dart';
import 'package:tracora/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          !controller.settingsLoaded
              ? const Scaffold(backgroundColor: Color.fromRGBO(0, 180, 80, 1))
              : Theme(
                data: controller.theme,
                child: OrientationBuilder(
                  builder: (context, o) {
                    var w = MediaQuery.of(context).size.width;
                    return AdvancedDrawer(
                      openRatio: Get.width < 600 ? 0.75 : 300 / w,
                      rtlOpening: Get.locale?.languageCode == "ar",
                      controller: controller.drawerCtrl,
                      drawer: drawer(),
                      backdropColor: controller.theme.scaffoldBackgroundColor
                          .withOpacity(0.95),
                      child: Scaffold(
                        appBar: AppBar(
                          backgroundColor:
                              controller.theme.scaffoldBackgroundColor,
                          title: Text('tracora'.tr),
                          centerTitle: true,
                          leading: IconButton(
                            icon: ValueListenableBuilder<AdvancedDrawerValue>(
                              valueListenable: controller.drawerCtrl,
                              builder: (context, value, child) {
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  child:
                                      value.visible
                                          ? const Icon(Icons.clear)
                                          : const Icon(Icons.menu),
                                );
                              },
                            ),
                            onPressed: controller.drawerCtrl.showDrawer,
                          ),
                        ),
                        body: ListView(
                          padding: EdgeInsets.all(16),
                          children: [
                            Row(
                              children: [
                                Expanded(child: menuItem(pages()[0])),
                                Expanded(child: menuItem(pages()[1])),
                                Expanded(child: menuItem(pages()[2])),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: menuItem(pages()[3])),
                                Expanded(child: menuItem(pages()[4])),
                                Expanded(child: menuItem(pages()[5])),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: menuItem(pages()[6])),
                                Expanded(child: menuItem(pages()[7])),
                                Expanded(child: menuItem(pages()[8])),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: menuItem(pages()[9])),
                                Expanded(child: menuItem(pages()[10])),
                                Expanded(child: menuItem(pages()[11])),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: menuItem(pages()[12]),
                            //     ),
                            //     Expanded(child: SizedBox()),

                            //     Expanded(child: SizedBox()),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }

  GridView menu() {
    return GridView.count(
      padding: EdgeInsets.all(16),
      crossAxisCount: 3,
      childAspectRatio: 1,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      children: pages().map((e) => menuItem(e)).toList(),
    );
  }

  Container menuItem(Map<String, String> e) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: controller.theme.colorScheme.surfaceDim,
        // border: Border.all(width: 0.1),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.toNamed(e['route'] ?? ''),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(e["img"] ?? ""),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(e['title'] ?? ''),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> pages() {
    return [
      {
        "title": "products".tr,
        "img": "assets/inventory.png",
        "route": Routes.PRODUCT,
      },
      {
        "title": "brands".tr,
        "img": "assets/brand-image.png",
        "route": Routes.BRAND,
      },
      {
        "title": "categories".tr,
        "img": "assets/shapes.png",
        "route": Routes.CATEGORY,
      },
      {
        "title": "customers".tr,
        "img": "assets/customer.png",
        "route": Routes.CUSTOMER,
      },
      {"title": "sales".tr, "img": "assets/sales.png", "route": Routes.SALE},
      {
        "title": "paymentin".tr,
        "img": "assets/money-in.png",
        "route": Routes.CUSTOMER_PAYMENT,
      },
      {
        "title": "suppliers".tr,
        "img": "assets/supplier.png",
        "route": Routes.SUPPLIER,
      },

      {
        "title": "purchases".tr,
        "img": "assets/purchase.png",
        "route": Routes.PURCHASE,
      },

      {
        "title": "paymentout".tr,
        "img": "assets/money-out.png",
        "route": Routes.SUPPLIER_PAYMENT,
      },
      {
        "title": "fees".tr,
        "img": "assets/reduction.png",
        "route": Routes.FEES_PAYMENT,
      },
      {
        "title": "stats".tr,
        "img": "assets/stats.png",
        "route": Routes.STATISTIC,
      },
      {
        "title": "settings".tr,
        "img": "assets/settings.png",
        "route": Routes.SETTINGS,
      },
      // {
      //   "title": "missions".tr,
      //   "img": "assets/settings.png",
      //   "route": Routes.MISSION,
      // },
    ];
  }

  Widget drawer() {
    return Obx(
      () => Theme(
        data: controller.theme,
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 8),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SuperAdminMenu(),
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(4),
                          tileColor:
                              controller.lang == "ar"
                                  ? controller
                                      .theme
                                      .colorScheme
                                      .primaryContainer
                                  : controller.theme.colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          // selected: true,
                          onTap: () {
                            controller.updateLocale('ar');
                          },
                          title: const Text('العربية'),
                          trailing:
                              controller.lang != 'ar'
                                  ? const SizedBox()
                                  : const Icon(
                                    Icons.check_circle_outline,
                                    size: 50,
                                    color: Colors.green,
                                  ),
                          leading: const CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage('assets/algeria.png'),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(4),
                        tileColor:
                            controller.lang == "fr"
                                ? controller.theme.colorScheme.primaryContainer
                                : controller.theme.colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        // selected: true,
                        onTap: () {
                          controller.updateLocale('fr');
                        },
                        title: const Text('Français'),
                        trailing:
                            controller.lang != 'fr'
                                ? const SizedBox()
                                : const Icon(
                                  Icons.check_circle_outline,
                                  size: 50,
                                  color: Colors.green,
                                ),
                        leading: const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage('assets/france.png'),
                        ),
                      ),
                    ),
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(4),
                          tileColor:
                              controller.lang == "en"
                                  ? controller
                                      .theme
                                      .colorScheme
                                      .primaryContainer
                                  : controller.theme.colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          // selected: true,
                          onTap: () {
                            controller.updateLocale('en');
                          },
                          title: const Text('English'),
                          trailing:
                              Get.locale?.languageCode != 'en'
                                  ? const SizedBox()
                                  : const Icon(
                                    Icons.check_circle_outline,
                                    size: 50,
                                    color: Colors.green,
                                  ),
                          leading: const CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(
                              'assets/united-kingdom.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          // selected: true,
                          onTap: () {
                            controller.changeThemeMode(!controller.isDark);
                          },
                          title: Text('theme'.tr),
                          trailing: Switch(
                            value: controller.isDark,
                            thumbIcon: WidgetStatePropertyAll(
                              Icon(
                                controller.isDark
                                    ? Icons.dark_mode_outlined
                                    : Icons.light_mode_outlined,
                              ),
                            ),
                            onChanged: (v) {
                              controller.changeThemeMode(v);
                            },
                          ),
                          leading: CircleAvatar(
                            radius: 25,
                            child: Icon(
                              controller.isDark
                                  ? Icons.dark_mode_outlined
                                  : Icons.light_mode_outlined,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Obx(
                    //   () => Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Row(
                    //       children: [
                    //         Expanded(
                    //           child: Visibility(
                    //             visible: controller.updateAvailable,
                    //             child: ElevatedButton.icon(
                    //               onPressed: () => controller.updateApp(),
                    //               label: Text('update'.tr),
                    //               icon: const Icon(Icons.update),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: TextButton.icon(
                    //     onPressed: controller.openPrivacyPolicy,
                    //     label: Text('politique'.tr),
                    //     icon: const Icon(Icons.privacy_tip_outlined),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
