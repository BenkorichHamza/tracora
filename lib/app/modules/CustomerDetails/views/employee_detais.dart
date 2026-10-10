import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/StockTransactionDetails/views/mission_details_view.dart';
import 'package:tracora/app/modules/StockTransactionDetails/views/stock_transaction_details_view.dart';
import 'package:tracora/app/modules/UserPayment/controllers/user_payment_controller.dart';
import 'package:tracora/app/modules/UserPaymentDetails/controllers/user_payment_details_controller.dart';
import 'package:tracora/app/modules/UserPaymentDetails/views/user_payment_details_view.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:tracora/app/widgets/empty_widget.dart';
import 'package:tracora/app/widgets/money_transaction_tile.dart';
import 'package:tracora/app/widgets/stock_transaction_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/user_details_controller.dart';

class EmployeeDetailsView extends GetView<UserDetailsController<Employee>> {
  const EmployeeDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.user.id == null
              ? Scaffold()
              : Scaffold(
                appBar: AppBar(
                  title: Text(
                    controller.user.firstName ??
                        controller.user.companyName ??
                        '',
                  ),
                  actions: [
                    Obx(() => controller.user.circleAvatar(radius: 22)),
                    SizedBox(width: 8),
                  ],

                  foregroundColor: Colors.white,
                  backgroundColor:
                      Get.find<HomeController>()
                          .dark
                          .colorScheme
                          .primaryContainer,
                  bottom: TabBar(
                    labelColor: Colors.white,
                    indicatorColor: Colors.white,
                    unselectedLabelColor: Colors.white60,
                    controller: controller.tabCtrl,
                    tabs: [
                      Tab(text: "profile", icon: Icon(Icons.person)),
                      Tab(text: "permissions", icon: Icon(Icons.key)),
                      // Tab(
                      //   text: "purchases",
                      //   icon: Image.asset(
                      //     "assets/purchase.png",
                      //     height: 25,
                      //     width: 25,
                      //   ),
                      // ),
                      // Tab(
                      //   text: "customer payment",
                      //   icon: Image.asset(
                      //     "assets/money-in.png",
                      //     height: 25,
                      //     width: 25,
                      //   ),
                      // ),
                      // Tab(
                      //   text: "supplier payment",
                      //   icon: Image.asset(
                      //     "assets/money-out.png",
                      //     height: 25,
                      //     width: 25,
                      //   ),
                      // ),
                      // Tab(
                      //   text: "fees",
                      //   icon: Image.asset(
                      //     "assets/reduction.png",
                      //     height: 25,
                      //     width: 25,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        controller: controller.tabCtrl,
                        children: [
                          profile(),
                          Container(
                            child: Column(
                              children: [
                                ...controller.user.roles?.map(
                                      (e) => Text(e.name ?? ''),
                                    ) ??
                                    [],
                              ],
                            ),
                          ),
                          // moneyTransactions(),
                          // moneyTransactions(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton.icon(
                        onPressed: () {
                          controller.createAccessCode();
                        },
                        icon: Icon(Icons.key),
                        label: Text('create_access_code'.tr),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.print_outlined),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              backgroundColor:
                                  Get.find<HomeController>()
                                      .dark
                                      .colorScheme
                                      .primaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: controller.printTicket,
                            label: Text('print_invoice'.tr),
                          ),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.edit),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: controller.edit,
                            label: Text('edit_sale'.tr),
                          ),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.delete_outline),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: controller.delete,
                            label: Text('delete_sale'.tr),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }

  Container moneyTransactions() {
    return Container(
      child: Obx(
        () =>
            controller.employeeMoneyTransactions.isEmpty
                ? EmptyWidget()
                : ListView.builder(
                  itemCount: controller.employeeMoneyTransactions.length,

                  itemBuilder: (c, i) {
                    var moneyTransaction =
                        controller.employeeMoneyTransactions[i];
                    return MoneyTransactionTile(
                      onValidate: (item) {
                        print(item.status);
                      },
                      onTap: (t) {
                        showDialog(
                          context: Get.context!,

                          builder: (c) {
                            Get.find<UserPaymentController<Sale>>().toDetails(
                              t,
                            );
                            return Center(
                              child: Dialog(
                                backgroundColor: Colors.transparent,
                                clipBehavior: Clip.antiAlias,
                                elevation: 10,
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 450),

                                  child: Center(
                                    child: UserPaymentDetailsView<Sale>(),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      item: moneyTransaction,
                      highest: i.isEven,
                      selected: false,
                    );
                  },
                ),
      ),
    );
  }

  Widget employeeStockTransactions() {
    return Obx(
      () =>
          controller.employeeTransaction.isEmpty
              ? EmptyWidget()
              : ListView.builder(
                itemCount: controller.employeeTransaction.length,

                itemBuilder: (c, i) {
                  var transaction = controller.employeeTransaction[i];
                  return StockTransactionTile(
                    onValidate: (item) {
                      print(item.status);
                    },
                    onTap: (t) {
                      showDialog(
                        context: Get.context!,

                        builder: (c) {
                          Get.find<StockTransactionController<Sale>>()
                              .toDetails(t);
                          return Center(
                            child: Dialog(
                              backgroundColor: Colors.transparent,
                              clipBehavior: Clip.antiAlias,
                              elevation: 10,
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 450),

                                child: Center(
                                  child: StockTransactionDetailsView<Sale>(),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    item: transaction,
                    highest: i.isEven,
                    selected: false,
                  );
                },
              ),
    );
  }

  Widget profile() {
    final user = controller.user;
    final context = Get.context!;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      children: [
        // --- HERO SUBSCRIPTION / CREDIT CARD ---
        _buildUserHeroCard(context, user),

        const SizedBox(height: 20),

        // --- BALANCE CARD ---
        Card(
          elevation: 0,
          color:
              user.toPay <= 0
                  ? Colors.green.withOpacity(0.08)
                  : Colors.deepOrange.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color:
                  user.toPay <= 0
                      ? Colors.green.withOpacity(0.3)
                      : Colors.deepOrange.withOpacity(0.3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'credit'.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  user.toPay.formatPrice(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        user.toPay <= 0
                            ? Colors.green.shade700
                            : Colors.deepOrange.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // --- CONTACT INFORMATION ---
        _buildSectionTitle(context, 'Contact Information'),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            children: [
              _buildContactTile(
                context,
                icon: Icons.phone_outlined,
                title: (user.phone ?? '').isNotEmpty ? user.phone! : 'phone'.tr,
                isValid: (user.phone ?? '').isPhoneNumber,
                onPressed:
                    () => launchUrl(Uri(scheme: 'tel', path: user.phone!)),
              ),
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              _buildContactTile(
                context,
                icon: Icons.email_outlined,
                title: (user.email ?? '').isNotEmpty ? user.email! : 'email'.tr,
                isValid: (user.email ?? '').isEmail,
                onPressed:
                    () => launchUrl(Uri(scheme: 'mailto', path: user.email!)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // --- IDENTIFICATION DETAILS ---
        _buildSectionTitle(context, 'Identification'),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            children: [
              _buildIdTile(context, label: 'NIN', value: user.nin),
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              _buildIdTile(context, label: 'NIS', value: user.nis),
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              _buildIdTile(context, label: 'NIF', value: user.nif),
            ],
          ),
        ),
      ],
    );
  }

  // --- NEW SUBSCRIPTION / CREDIT CARD COMPONENT ---
  Widget _buildUserHeroCard(BuildContext context, UserModel user) {
    // 1. Palette list matching your circleAvatar extension
    final avatarColors = [
      Colors.teal[900]!,
      Colors.amber,
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.cyan,
      Colors.indigo,
      Colors.pink,
      Colors.brown,
      Colors.deepOrange,
      Colors.deepPurple,
    ];

    // 2. Extract the exact color selected by circleAvatar
    final baseAvatarColor = const Color.fromARGB(255, 0, 153, 5);
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        // Glassmorphic / Alpha Gradient based on avatar color
        gradient: LinearGradient(
          colors: [
            baseAvatarColor.withOpacity(isDark ? 0.35 : 0.20),
            baseAvatarColor.withOpacity(isDark ? 0.15 : 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // Smooth dynamic border with alpha
        border: Border.all(
          color: baseAvatarColor.withOpacity(0.35),
          width: 1.5,
        ),
        // Glowing shadow matching avatar color
        boxShadow: [
          BoxShadow(
            color: baseAvatarColor.withOpacity(0.12),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Card Branding Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: baseAvatarColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'MEMBER PROFILE',
                    style: TextStyle(
                      color: baseAvatarColor.withOpacity(0.9),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.contactless_rounded,
                color: baseAvatarColor.withOpacity(0.7),
                size: 22,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Main Details Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar Container with a soft dynamic glow ring
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: baseAvatarColor.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: user.circleAvatar(radius: 28),
              ),

              const SizedBox(width: 12),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.firstName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.storefront_outlined,
                          size: 14,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.warehouse?.name ?? 'no_warehouse'.tr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Roles with matching color tint
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children:
                          user.roles
                              ?.where(
                                (r) => r.name != null && r.name!.isNotEmpty,
                              )
                              .map(
                                (role) => _buildCardRoleBadge(
                                  context,
                                  role.name!,
                                  baseAvatarColor,
                                ),
                              )
                              .toList() ??
                          [],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Role Badge adaptively colored with the user avatar tint
  Widget _buildCardRoleBadge(
    BuildContext context,
    String roleName,
    Color themeColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: themeColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getRoleIcon(roleName), size: 13, color: themeColor),
          const SizedBox(width: 5),
          Text(
            roleName.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: themeColor,
            ),
          ),
        ],
      ),
    );
  } // --- OVERLAY BADGE FOR THE CARD ---

  // Helper: Dynamic Role Icons
  IconData _getRoleIcon(String role) {
    final lower = role.toLowerCase();
    if (lower.contains('admin')) return Icons.admin_panel_settings_rounded;
    if (lower.contains('manager')) return Icons.manage_accounts_rounded;
    if (lower.contains('driver')) return Icons.local_shipping_rounded;
    if (lower.contains('user') || lower.contains('client'))
      return Icons.person_rounded;
    return Icons.verified_user_rounded;
  }

  // --- HELPER COMPONENTS ---
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildContactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isValid,
    required VoidCallback onPressed,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: TextStyle(
          color:
              isValid
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.outline,
        ),
      ),
      trailing: IconButton.filledTonal(
        onPressed: isValid ? onPressed : null,
        icon: const Icon(Icons.arrow_outward, size: 18),
      ),
    );
  }

  Widget _buildIdTile(
    BuildContext context, {
    required String label,
    String? value,
  }) {
    final displayValue = (value ?? '').isEmpty ? '—' : value!;
    return ListTile(
      dense: true,
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      title: Text(
        displayValue,
        style: TextStyle(
          fontWeight: displayValue == '—' ? FontWeight.normal : FontWeight.w600,
          color:
              displayValue == '—'
                  ? Theme.of(context).colorScheme.outline
                  : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  // --- NEW PROMINENT ROLE BADGE COMPONENT ---
  Widget _buildLargeRoleBadge(BuildContext context, String roleName) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.15),
            primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getRoleIcon(roleName), size: 18, color: primaryColor),
          const SizedBox(width: 8),
          Text(
            roleName.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Assign contextual icons based on role keywords
}

// Helper: Section Headers
Widget _buildSectionTitle(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.only(left: 4),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

// Helper: Actionable Contact Tiles
