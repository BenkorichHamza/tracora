import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/stock_transaction_repository.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/CustomerDetails/views/employee_detais.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/StockTransactionDetails/views/stock_transaction_details_view.dart';
import 'package:tracora/app/modules/UserPayment/controllers/user_payment_controller.dart';
import 'package:tracora/app/modules/UserPaymentDetails/views/user_payment_details_view.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/routes/app_pages.dart';
import 'package:tracora/app/widgets/empty_widget.dart';
import 'package:tracora/app/widgets/money_transaction_tile.dart';
import 'package:tracora/app/widgets/stock_transaction_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/user_details_controller.dart';

class UserDetailsView<T> extends GetView<UserDetailsController<T>> {
  const UserDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.user.id == null
              ? Scaffold()
              : T == Employee
              ? EmployeeDetailsView()
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

                  // foregroundColor: Colors.white,
                  backgroundColor:
                      Get.find<HomeController>()
                          .theme
                          .colorScheme
                          .surfaceContainer,
                  bottom: TabBar(
                    // labelColor: Colors.white,
                    // indicatorColor: Colors.white,
                    // unselectedLabelColor: Colors.white60,
                    controller: controller.tabCtrl,
                    tabs: [
                      Tab(text: "profile", icon: Icon(Icons.person)),
                      controller.userType == "customer"
                          ? Tab(
                            text: "sales",
                            icon: Image.asset(
                              "assets/sales.png",
                              height: 25,
                              width: 25,
                            ),
                          )
                          : controller.userType == "employee"
                          ? Tab(
                            text: "sales",
                            icon: Image.asset(
                              "assets/sales.png",
                              height: 25,
                              width: 25,
                            ),
                          )
                          : Tab(
                            text: "purchases",
                            icon: Image.asset(
                              "assets/purchase.png",
                              height: 25,
                              width: 25,
                            ),
                          ),
                      controller.userType == "customer"
                          ? Tab(
                            text: "payments",
                            icon: Image.asset(
                              "assets/money-in.png",
                              height: 25,
                              width: 25,
                            ),
                          )
                          : Tab(
                            text: "payments",
                            icon: Image.asset(
                              "assets/money-out.png",
                              height: 25,
                              width: 25,
                            ),
                          ),
                      Tab(
                        text: "products",
                        icon: Image.asset(
                          "assets/inventory.png",
                          height: 25,
                          width: 25,
                        ),
                      ),
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
                          stockTransactions(),
                          moneyTransactions(),
                          Center(
                            child: Obx(
                              () => ListView.builder(
                                itemCount:
                                    controller.productTransactions.length,
                                itemBuilder: (context, index) {
                                  final transaction =
                                      controller.productTransactions[index];
                                  return listItem(transaction);
                                },
                              ),
                            ),
                          ),
                        ],
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
                            label: Text('print'.tr),
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
                            label: Text('edit'.tr),
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
                            label: Text('delete'.tr),
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
            controller.moneyTransactions.isEmpty
                ? EmptyWidget()
                : ListView.builder(
                  itemCount: controller.moneyTransactions.length,

                  itemBuilder: (c, i) {
                    var moneyTransaction = controller.moneyTransactions[i];
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

  Widget stockTransactions() {
    return Obx(
      () =>
          controller.stockTransactions.isEmpty
              ? EmptyWidget()
              : ListView.builder(
                itemCount: controller.stockTransactions.length,

                itemBuilder: (c, i) {
                  var transaction = controller.stockTransactions[i];
                  return StockTransactionTile(
                    onValidate: (item) {
                      StockTransactionRepository<T>().insert(
                        item.copyWith(status: 1),
                      );
                    },
                    onTap: (t) {
                      showDialog(
                        context: Get.context!,

                        builder: (c) {
                          Get.find<StockTransactionController<Sale>>()
                              .toDetails(transaction);
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

  Padding listItem(ProductTransaction productTransaction) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        onTap: () {},
        subtitle: Text(productTransaction.price.formatPrice() ?? ''),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor:
            Get.find<HomeController>().isDark
                ? Get.find<HomeController>()
                    .theme
                    .colorScheme
                    .surfaceContainerHigh
                : Colors.white,
        contentPadding: EdgeInsets.only(right: 8, top: 0, bottom: 0, left: 8),
        leading: productTransaction.product?.leading(),
        title: Text(productTransaction.product?.translateName ?? 'product'.tr),
        trailing: Material(
          borderRadius: BorderRadius.circular(100),
          color: Get.find<HomeController>().dark.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'qte ${productTransaction.qte.formatNumber() ?? '0'}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget profile() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        final primaryColor =
            Get.find<HomeController>().dark.colorScheme.primaryContainer;
        final cardBg = isDark ? theme.cardColor : Colors.white;
        final borderClr =
            isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE2E8F0);
        final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
        final textSecondary = isDark ? Colors.white60 : const Color(0xFF64748B);

        return Obx(() {
          final user = controller.user;

          final hasValidPhone = (user.phone ?? '').isPhoneNumber;
          final hasValidEmail = (user.email ?? '').isEmail;
          final isCreditPaid = user.toPay <= 0;
          final creditColor =
              isCreditPaid ? const Color(0xFF10B981) : const Color(0xFFEF4444);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // HERO USER CARD
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderClr),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    user.circleAvatar(radius: 50),
                    const SizedBox(height: 12),
                    Text(
                      user.firstName?.isNotEmpty == true
                          ? user.firstName!
                          : 'user'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if ((user.companyName ?? '').isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        user.companyName!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    // CREDIT BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: creditColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: creditColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isCreditPaid
                                ? Icons.check_circle_outline_rounded
                                : Icons.error_outline_rounded,
                            size: 16,
                            color: creditColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${'credit'.tr}: ${user.toPay.formatPrice()}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: creditColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // CONTACT INFORMATION SECTION
              Text(
                'contact_info'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              // PHONE TILE
              _buildContactTile(
                icon: Icons.phone_outlined,
                title: (user.phone ?? '').isNotEmpty ? user.phone! : 'phone'.tr,
                subtitle: 'phone'.tr,
                actionIcon: Icons.call_rounded,
                isEnabled: hasValidPhone,
                onPressed:
                    !hasValidPhone
                        ? null
                        : () {
                          launchUrl(Uri(scheme: 'tel', path: user.phone!));
                        },
                primaryColor: primaryColor,
                cardBg: cardBg,
                borderClr: borderClr,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),

              const SizedBox(height: 8),

              // EMAIL TILE
              _buildContactTile(
                icon: Icons.email_outlined,
                title: (user.email ?? '').isNotEmpty ? user.email! : 'email'.tr,
                subtitle: 'email'.tr,
                actionIcon: Icons.mail_rounded,
                isEnabled: hasValidEmail,
                onPressed:
                    !hasValidEmail
                        ? null
                        : () {
                          launchUrl(Uri(scheme: 'mailto', path: user.email!));
                        },
                primaryColor: primaryColor,
                cardBg: cardBg,
                borderClr: borderClr,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),

              const SizedBox(height: 16),

              // TAX & LEGAL IDS SECTION
              Text(
                'legal_identifiers'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _buildLegalBadge(
                      label: 'NIN',
                      value: user.nin,
                      cardBg: cardBg,
                      borderClr: borderClr,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildLegalBadge(
                      label: 'NIS',
                      value: user.nis,
                      cardBg: cardBg,
                      borderClr: borderClr,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildLegalBadge(
                      label: 'NIF',
                      value: user.nif,
                      cardBg: cardBg,
                      borderClr: borderClr,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required IconData actionIcon,
    required bool isEnabled,
    required VoidCallback? onPressed,
    required Color primaryColor,
    required Color cardBg,
    required Color borderClr,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderClr),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            style: IconButton.styleFrom(
              backgroundColor:
                  isEnabled ? primaryColor : primaryColor.withOpacity(0.08),
              foregroundColor:
                  isEnabled ? Colors.white : textSecondary.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onPressed,
            icon: Icon(actionIcon, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalBadge({
    required String label,
    required String? value,
    required Color cardBg,
    required Color borderClr,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final displayValue = (value ?? '').isNotEmpty ? value! : '--';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderClr),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            displayValue,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
