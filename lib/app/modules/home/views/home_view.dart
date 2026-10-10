import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:tracora/app/core/intents.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/sync_repository.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/FeesPayment/views/fees_payment_view.dart';
import 'package:tracora/app/modules/RolePermission/views/role_permission_view.dart';
import 'package:tracora/app/modules/Setting/views/setting_view.dart';
import 'package:tracora/app/modules/Statistic/views/statistic_view.dart';
import 'package:tracora/app/modules/Synchronisation/views/synchronisation_state.dart';
import 'package:tracora/app/modules/Synchronisation/views/synchronisation_view.dart';
import 'package:tracora/app/modules/User/views/user_view.dart';
import 'package:tracora/app/modules/UserPayment/views/user_payment_view.dart';
import 'package:tracora/app/modules/Login/views/login_view.dart';
import 'package:tracora/app/modules/Product/views/product_view.dart';
import 'package:tracora/app/modules/StockTransaction/views/transaction_view.dart';
import 'package:tracora/app/modules/home/views/pos_home.dart';
import 'package:tracora/app/modules/home/views/super_admin_menu.dart';
import 'package:tracora/app/modules/home/views/sync_view.dart';
import 'package:tracora/app/modules/warehouse/views/warehouse_view.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracora/app/widgets/toast_managet.dart';
import 'package:tracora/app/widgets/window_buttons.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Obx(
        () => Actions(
          actions: <Type, Action<Intent>>{
            NewIntent: CallbackAction<NewIntent>(
              onInvoke: (intent) {
                controller.aciveController?.keys.first.newIntent();
              },
            ),
            EditIntent: CallbackAction<EditIntent>(
              onInvoke: (intent) {
                controller.aciveController?.keys.first.editIntent();
              },
            ),
            EscapeIntent: CallbackAction<EscapeIntent>(
              onInvoke: (intent) {
                controller.aciveController?.keys.first.escapeIntent();
              },
            ),
            SaveIntent: CallbackAction<SaveIntent>(
              onInvoke: (intent) {
                controller.aciveController?.keys.first.saveIntent();
              },
            ),
            SaveAndNewIntent: CallbackAction<SaveAndNewIntent>(
              onInvoke: (intent) {
                controller.aciveController?.keys.first.saveAndNewIntent();
              },
            ),

            DeleteIntent: CallbackAction<DeleteIntent>(
              onInvoke: (intent) {
                controller.aciveController?.keys.first.deleteIntent();
              },
            ),
            SearchIntent: CallbackAction<SearchIntent>(
              onInvoke: (intent) {
                controller.aciveController?.keys.first.searchIntent();
              },
            ),
            NextIntent: CallbackAction<NextIntent>(
              onInvoke: (intent) {
                controller.aciveController?.keys.first.nextIntent();
              },
            ),
            PreviousIntent: CallbackAction<PreviousIntent>(
              onInvoke: (intent) {
                controller.aciveController?.keys.first.previousIntent();
              },
            ),
            PrintIntent: CallbackAction<PrintIntent>(
              onInvoke: (intent) {
                controller.aciveController?.keys.first.printIntent();
              },
            ),
          },

          child: Material(
            color: controller.theme.scaffoldBackgroundColor,
            child: Container(
              child: Row(
                children: [
                  controller.settingsLoaded
                      ? sideMenu(Get.context!)
                      : SizedBox(),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child:
                          // controller.employee.ids == null
                          //     ? LoginView()
                          //     :
                          Obx(
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
                                          var w =
                                              MediaQuery.of(context).size.width;
                                          return AdvancedDrawer(
                                            openRatio:
                                                Get.width < 600
                                                    ? 0.75
                                                    : 300 / w,
                                            rtlOpening:
                                                Get.locale?.languageCode ==
                                                "ar",
                                            controller: controller.drawerCtrl,
                                            drawer: drawer(),
                                            backdropColor: controller
                                                .theme
                                                .scaffoldBackgroundColor
                                                .withOpacity(0.95),
                                            child: Scaffold(
                                              body:
                                                  Platform.isWindows
                                                      ? Row(
                                                        children: [
                                                          // navigationRail(),
                                                          // sideMenu(),
                                                          Expanded(
                                                            child: views(),
                                                          ),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sideMenu(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // App Header / Brand Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      LucideIcons.box,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TRACORA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Company name',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 8),
                      Obx(() => controller.employee.circleAvatar(radius: 20)),
                    ],
                  ),
                ],
              ),
            ),

            SynchronisationStateView(),
            const SizedBox(height: 8),
            const Divider(height: 1, color: Color(0xFF334155)),

            // Navigation List
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                children: [
                  _buildSectionHeader('MAIN NAVIGATION'),
                  _menuTile(
                    controller,
                    0,
                    "Dashboard",
                    icon: LucideIcons.layoutDashboard,
                  ),
                  _menuTile(
                    controller,
                    1,
                    "Sales",
                    icon: LucideIcons.shoppingBag,
                    img: "sales.png",
                  ),
                  _menuTile(
                    controller,
                    2,
                    "Purchases",
                    icon: LucideIcons.truck,
                    img: "purchase.png",
                  ),
                  _menuTile(
                    controller,
                    3,
                    "Transfers",
                    icon: LucideIcons.arrowRightLeft,
                    img: "mission.png",
                  ),

                  const SizedBox(height: 16),
                  _buildSectionHeader('FINANCES'),
                  _menuTile(
                    controller,
                    4,
                    "Customer Payments",
                    icon: LucideIcons.arrowDownLeft,
                    img: "money-in.png",
                  ),
                  _menuTile(
                    controller,
                    5,
                    "Supplier Payments",
                    icon: LucideIcons.arrowUpRight,
                    img: "money-out.png",
                  ),
                  _menuTile(
                    controller,
                    6,
                    "Fees & Expenses",
                    icon: LucideIcons.receipt,
                    img: "reduction.png",
                  ),

                  const SizedBox(height: 16),
                  _buildSectionHeader('DIRECTORY & INVENTORY'),
                  _menuTile(
                    controller,
                    7,
                    "Customers",
                    icon: LucideIcons.users,
                    img: "customer.png",
                  ),
                  _menuTile(
                    controller,
                    8,
                    "Suppliers",
                    icon: LucideIcons.building2,
                    img: "supplier.png",
                  ),
                  _menuTile(
                    controller,
                    9,
                    "Employees",
                    icon: LucideIcons.userCheck,
                    img: "supplier.png",
                  ),
                  _menuTile(
                    controller,
                    10,
                    "Products",
                    icon: LucideIcons.package,
                    img: "inventory.png",
                  ),
                  _menuTile(
                    controller,
                    11,
                    "Warehouses",
                    icon: LucideIcons.warehouse,
                    img: "mission.png",
                  ),

                  const SizedBox(height: 16),
                  _buildSectionHeader('SYSTEM'),
                  _menuTile(
                    controller,
                    12,
                    "Synchronization",
                    icon: LucideIcons.refreshCw,
                    img: "cloud-sync.png",
                  ),
                  _menuTile(
                    controller,
                    13,
                    "Settings",
                    icon: LucideIcons.settings,
                    img: "cloud-sync.png",
                  ),
                  _menuTile(
                    controller,
                    14,
                    "Roles & Access",
                    icon: LucideIcons.shieldCheck,
                    img: "cloud-sync.png",
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFF334155)),

            // Bottom Auth Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                final isLoggedIn = controller.token.isNotEmpty;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      if (isLoggedIn) {
                        controller.logout();
                      } else {
                        controller.login();
                      }
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isLoggedIn
                                ? const Color(0xFFEF4444).withOpacity(0.1)
                                : const Color(0xFF6366F1).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color:
                              isLoggedIn
                                  ? const Color(0xFFEF4444).withOpacity(0.2)
                                  : const Color(0xFF6366F1).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isLoggedIn ? LucideIcons.logOut : LucideIcons.logIn,
                            size: 18,
                            color:
                                isLoggedIn
                                    ? const Color(0xFFF87171)
                                    : const Color(0xFF818CF8),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isLoggedIn ? 'logout'.tr : 'login'.tr,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color:
                                  isLoggedIn
                                      ? const Color(0xFFF87171)
                                      : const Color(0xFF818CF8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Color(0xFF64748B),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _menuTile(
    dynamic controller,
    int index,
    String label, {
    String? img,
    IconData? icon,
  }) {
    return Obx(() {
      final isSelected = controller.index == index;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              controller.tabCtrl.index = index;
              controller.index = index;
              controller.selectedNode.requestFocus();
            },
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFF6366F1).withOpacity(0.18)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border:
                    isSelected
                        ? Border.all(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                        )
                        : Border.all(color: Colors.transparent),
              ),
              child: Row(
                children: [
                  // Visual Leading Indicator / Icon
                  if (isSelected)
                    Container(
                      width: 4,
                      height: 18,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF818CF8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                  // Icon or Asset Image
                  if (icon != null)
                    Icon(
                      icon,
                      size: 18,
                      color:
                          isSelected
                              ? const Color(0xFF818CF8)
                              : const Color(0xFF94A3B8),
                    )
                  else if (img != null)
                    Image.asset(
                      "assets/$img",
                      height: 20,
                      width: 20,
                      errorBuilder:
                          (_, __, ___) => const Icon(
                            LucideIcons.fileText,
                            size: 18,
                            color: Color(0xFF94A3B8),
                          ),
                    )
                  else
                    const Icon(
                      LucideIcons.circle,
                      size: 18,
                      color: Color(0xFF94A3B8),
                    ),

                  const SizedBox(width: 12),

                  // Label Text
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w500,
                        color:
                            isSelected ? Colors.white : const Color(0xFFCBD5E1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  TabBarView views() {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: controller.tabCtrl,

      children: [
        FocusScope(node: controller.nodes[0], child: StatisticView()),
        FocusScope(
          node: controller.nodes[1],
          child: StockTransactionView<Sale>(),
        ),
        FocusScope(
          node: controller.nodes[2],
          child: StockTransactionView<Purchase>(),
        ),
        FocusScope(
          node: controller.nodes[3],
          child: StockTransactionView<Transfert>(),
        ),
        FocusScope(node: controller.nodes[4], child: UserPaymentView<Sale>()),
        FocusScope(
          node: controller.nodes[5],
          child: UserPaymentView<Purchase>(),
        ),
        FocusScope(node: controller.nodes[6], child: FeesPaymentView()),
        FocusScope(node: controller.nodes[7], child: UserView<Customer>()),
        FocusScope(node: controller.nodes[8], child: UserView<Supplier>()),
        FocusScope(node: controller.nodes[9], child: UserView<Employee>()),
        FocusScope(node: controller.nodes[10], child: ProductView()),
        FocusScope(node: controller.nodes[11], child: WarehouseView()),
        FocusScope(node: controller.nodes[12], child: SynchronisationView()),
        FocusScope(node: controller.nodes[13], child: SettingView()),
        FocusScope(node: controller.nodes[14], child: RolePermissionView()),
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
        minExtendedWidth: 340,
        unselectedLabelTextStyle: TextStyle(
          fontSize: 16,
          color: controller.theme.colorScheme.onSurface,
        ),
        selectedLabelTextStyle: TextStyle(
          fontSize: 16,
          color: controller.theme.colorScheme.onSurface,
        ),

        backgroundColor: controller.theme.scaffoldBackgroundColor,
        onDestinationSelected: (i) {
          controller.index = i;
          controller.selectedNode.requestFocus();

          controller.tabCtrl.index = i;
        },
        trailing: IconButton(
          onPressed: () => controller.extended = !controller.extended,
          icon:
              controller.extended
                  ? Icon(Icons.keyboard_arrow_left)
                  : Icon(Icons.keyboard_arrow_right),
        ),
        extended: controller.extended ? true : true,
        elevation: 5,

        selectedIndex: controller.index,
        leading: FittedBox(child: CircleAvatar(child: Icon(Icons.person))),
        destinations: [
          NavigationRailDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: Text('dashboard'.tr),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/sales.png", height: 28, width: 28),
            label: Text('sales'.tr),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/purchase.png", height: 28, width: 28),
            label: Text('purchases'.tr),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/mission.png", height: 28, width: 28),
            label: Text('missions'.tr),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/money-in.png", height: 28, width: 28),
            label: Text('customer_payments'.tr),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/money-out.png", height: 28, width: 28),
            label: Text('supplier_payments'.tr),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/customer.png", height: 28, width: 28),
            label: Text('customers'.tr),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/supplier.png", height: 28, width: 28),
            label: Text('suppliers'.tr),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/supplier.png", height: 28, width: 28),
            label: Text('employees'.tr),
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
            label: Text('synchronisation'.tr),
          ),
          NavigationRailDestination(
            icon: Image.asset("assets/settings.png", height: 28, width: 28),
            label: Text('settings'.tr),
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
              title: Center(child: Text('${controller.employee.email}')),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
