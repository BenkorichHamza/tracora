import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import 'package:get/get.dart';
import 'package:tracora/app/core/intents.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/modules/FeesPayment/views/fees_payment_view.dart';
import 'package:tracora/app/modules/Setting/views/setting_view.dart';
import 'package:tracora/app/modules/User/views/user_view.dart';
import 'package:tracora/app/modules/UserPayment/views/user_payment_view.dart';
import 'package:tracora/app/modules/Login/views/login_view.dart';
import 'package:tracora/app/modules/Product/views/product_view.dart';
import 'package:tracora/app/modules/StockTransaction/views/transaction_view.dart';
import 'package:tracora/app/modules/home/views/super_admin_menu.dart';
import 'package:tracora/app/modules/home/views/sync_view.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
            NewIntent(),
        LogicalKeySet(LogicalKeyboardKey.delete): DeleteIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF):
            SearchIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): NextIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowUp): PreviousIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): EscapeIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyW):
            CloseIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
            SaveIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyE):
            EditIntent(),
      },

      child: Obx(
        () => Actions(
          actions:
              controller.index == 0
                  ? {}
                  : <Type, Action<Intent>>{
                    NewIntent: CallbackAction<NewIntent>(
                      onInvoke: (intent) {
                        controller.aciveController?.keys.first.showForm = true;
                        controller.aciveController?.values.first.init();
                      },
                    ),
                    CloseIntent: CallbackAction<CloseIntent>(
                      onInvoke: (intent) {
                        controller.aciveController?.keys.first.showForm = false;
                      },
                    ),
                    DeleteIntent: CallbackAction<DeleteIntent>(
                      onInvoke: (intent) {
                        controller.aciveController?.keys.first.delete();
                      },
                    ),
                    SearchIntent: CallbackAction<SearchIntent>(
                      onInvoke: (intent) {
                        controller.aciveController?.keys.first.showSearch =
                            controller.aciveController?.keys.first.showSearch;
                        controller.aciveController?.keys.first.searchFn
                            .requestFocus();
                      },
                    ),
                    NextIntent: CallbackAction<NextIntent>(
                      onInvoke: (intent) {
                        controller.aciveController?.keys.first.next();
                      },
                    ),
                    PreviousIntent: CallbackAction<PreviousIntent>(
                      onInvoke: (intent) {
                        controller.aciveController?.keys.first.previous();
                      },
                    ),
                    EscapeIntent: CallbackAction<EscapeIntent>(
                      onInvoke: (intent) {
                        controller.aciveController?.keys.first.showSearch =
                            false;
                      },
                    ),
                    SaveIntent: CallbackAction<SaveIntent>(
                      onInvoke: (intent) {
                        if (controller.aciveController?.keys.first.showForm !=
                            true) {
                          return;
                        }
                        controller.aciveController?.values.first.save();
                      },
                    ),
                    EditIntent: CallbackAction<EditIntent>(
                      onInvoke: (intent) {
                        if (controller.aciveController?.keys.first.showForm ==
                            true) {
                          return;
                        }
                        controller.aciveController?.keys.first.detailsController
                            .edit();
                      },
                    ),
                  },

          child: Focus(
            autofocus: true,
            child: Obx(
              () =>
                  controller.employee.id == null
                      ? LoginView()
                      : Obx(
                        () =>
                            !controller.settingsLoaded
                                ? const Scaffold(
                                  backgroundColor: Color.fromRGBO(
                                    0,
                                    180,
                                    80,
                                    1,
                                  ),
                                )
                                : Theme(
                                  data: controller.theme,
                                  child: OrientationBuilder(
                                    builder: (context, o) {
                                      var w = MediaQuery.of(context).size.width;
                                      return AdvancedDrawer(
                                        openRatio:
                                            Get.width < 600 ? 0.75 : 300 / w,
                                        rtlOpening:
                                            Get.locale?.languageCode == "ar",
                                        controller: controller.drawerCtrl,
                                        drawer: drawer(),
                                        backdropColor: controller
                                            .theme
                                            .scaffoldBackgroundColor
                                            .withOpacity(0.95),
                                        child: Scaffold(
                                          appBar:
                                              Platform.isWindows
                                                  ? null
                                                  : AppBar(
                                                    actions: [SyncView()],
                                                    backgroundColor:
                                                        controller
                                                            .theme
                                                            .scaffoldBackgroundColor,
                                                    title: Text('tracora'.tr),
                                                    centerTitle: true,
                                                    leading: IconButton(
                                                      icon: ValueListenableBuilder<
                                                        AdvancedDrawerValue
                                                      >(
                                                        valueListenable:
                                                            controller
                                                                .drawerCtrl,
                                                        builder: (
                                                          context,
                                                          value,
                                                          child,
                                                        ) {
                                                          return AnimatedSwitcher(
                                                            duration:
                                                                const Duration(
                                                                  milliseconds:
                                                                      250,
                                                                ),
                                                            child:
                                                                value.visible
                                                                    ? const Icon(
                                                                      Icons
                                                                          .clear,
                                                                    )
                                                                    : const Icon(
                                                                      Icons
                                                                          .menu,
                                                                    ),
                                                          );
                                                        },
                                                      ),
                                                      onPressed:
                                                          controller
                                                              .drawerCtrl
                                                              .showDrawer,
                                                    ),
                                                  ),
                                          body:
                                              Platform.isWindows
                                                  ? Row(
                                                    children: [
                                                      navigationRail(),
                                                      Expanded(child: views()),
                                                    ],
                                                  )
                                                  : content(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                      ),
            ),
          ),
        ),
      ),
    );
  }

  Container sideMenu() {
    return Container(
      width: 240,
      padding: EdgeInsets.all(8),
      child: ListView(
        children: [
          menuTile(0, "Dashboard", icon: Icons.dashboard),
          menuTile(1, "Sales", img: "sales.png"),
          menuTile(2, "Purchases", img: "purchase.png"),
          menuTile(3, "Missions", img: "mission.png"),
          menuTile(4, "Customer payment", img: "money-in.png"),
          menuTile(5, "Supplier payment", img: "money-out.png"),
          menuTile(6, "Customers", img: "customer.png"),
          menuTile(7, "Suppliers", img: "supplier.png"),
          menuTile(8, "Employees", img: "supplier.png"),
          menuTile(9, "Fees", img: "reduction.png"),
          menuTile(10, "Products", img: "inventory.png"),
        ],
      ),
    );
  }

  Widget menuTile(int index, String label, {String? img, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ListTile(
        tileColor:
            controller.index == index
                ? controller.theme.colorScheme.surfaceContainerHighest
                : null,
        onTap: () {
          controller.tabCtrl.index = index;
          controller.index = index;
        },
        // dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: 3, vertical: 0),
        minVerticalPadding: 0,
        leading:
            icon == null
                ? img == null
                    ? null
                    : Image.asset("assets/$img", height: 35, width: 35)
                : Icon(Icons.dashboard),
        title: Text(label),
      ),
    );
  }

  TabBarView views() {
    return TabBarView(
      controller: controller.tabCtrl,
      children: [
        dashboard(),
        StockTransactionView<Sale>(),
        StockTransactionView<Purchase>(),
        StockTransactionView<Mission>(),
        UserPaymentView<Sale>(),
        UserPaymentView<Purchase>(),
        UserView<Customer>(),
        UserView<Supplier>(),
        UserView<Employee>(),
        FeesPaymentView(),
        ProductView(),
      ],
    );
  }

  GridView dashboard() {
    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
      ),
      children: pages().map((p) => menuItem(p)).toList(),
    );
  }

  Obx navigationRail() {
    return Obx(
      () => NavigationRail(
        unselectedLabelTextStyle: TextStyle(fontSize: 16),
        selectedLabelTextStyle: TextStyle(fontSize: 16),

        backgroundColor: controller.theme.scaffoldBackgroundColor,
        onDestinationSelected: (i) {
          controller.index = i;
          controller.tabCtrl.index = i;
        },
        trailing: IconButton(
          onPressed: () => controller.extended = !controller.extended,
          icon: Icon(Icons.explore),
        ),
        extended: controller.extended,
        selectedIndex: controller.index,
        leading: FittedBox(child: CircleAvatar(child: Icon(Icons.person))),
        destinations: [
          NavigationRailDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: Text('dashboard'),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/sales.png", height: 28, width: 28),
            label: Text('sales'),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/purchase.png", height: 28, width: 28),
            label: Text('purchases'),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/mission.png", height: 28, width: 28),
            label: Text('missions'),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/money-in.png", height: 28, width: 28),
            label: Text('customer_payment'),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/money-out.png", height: 28, width: 28),
            label: Text('supplier_payment'),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/customer.png", height: 28, width: 28),
            label: Text('customers'),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/supplier.png", height: 28, width: 28),
            label: Text('suppliers'),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/supplier.png", height: 28, width: 28),
            label: Text('employees'),
          ),

          NavigationRailDestination(
            icon: Image.asset("assets/reduction.png", height: 28, width: 28),
            label: Text('fees'.tr),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/inventory.png", height: 28, width: 28),
            label: Text('products'.tr),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/settings.png", height: 28, width: 28),
            label: Text('settings'.tr),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/settings.png", height: 28, width: 28),
            label: Text('missions'.tr),
          ),
        ],
      ),
    );
  }

  Center content() {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        child: Center(
          child: ListView(
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
              Row(
                children: [
                  Expanded(child: menuItem(pages()[12])),
                  Expanded(child: SizedBox()),

                  Expanded(child: SizedBox()),
                ],
              ),
            ],
          ),
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
        "route": "Product",
      },
      {
        "title": "missions".tr,
        "img": "assets/settings.png",
        "route": Routes.MISSION,
      },
    ];
  }

  Widget drawer() {
    return Obx(
      () => Theme(
        data: controller.theme,
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 8),
            CircleAvatar(
              radius: 80,
              child:
                  (FirebaseAuth.instance.currentUser?.photoURL ?? '').isNotEmpty
                      ? null
                      : Icon(Icons.person, size: 80),
              backgroundImage:
                  (FirebaseAuth.instance.currentUser?.photoURL ?? '').isEmpty
                      ? null
                      : NetworkImage(
                        FirebaseAuth.instance.currentUser?.photoURL ?? '',
                      ),
            ),
            ListTile(
              title: Center(
                child: Text('${FirebaseAuth.instance.currentUser?.email}'),
              ),
            ),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: () => controller.logout(),
                        label: Text('logout'.tr),
                        icon: const Icon(Icons.logout),
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
