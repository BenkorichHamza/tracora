import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/FeesPaymentDetails/controllers/fees_payment_details_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class FeesPaymentDetailsView extends GetView<FeesPaymentDetailsController> {
  const FeesPaymentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor =
        Get.find<HomeController>().dark.colorScheme.primaryContainer;
    final surfaceBg =
        isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF1F5F9);
    final cardBg = isDark ? theme.cardColor : Colors.white;
    final borderClr =
        isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? Colors.white60 : const Color(0xFF64748B);

    return PopScope(
      child: Obx(() {
        if (controller.moneyTransaction.id == null) {
          return Scaffold(backgroundColor: surfaceBg, body: const SizedBox());
        }

        final titleText =
            controller.moneyTransaction.description?.isNotEmpty == true
                ? controller.moneyTransaction.description!
                : 'fees_payment'.tr;

        return Scaffold(
          backgroundColor: surfaceBg,
          appBar: AppBar(
            backgroundColor: theme.colorScheme.surfaceContainer,
            // foregroundColor: Colors.white,
            elevation: 0,
            title: Text(
              titleText,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            actions: [
              IconButton(
                onPressed: controller.edit,
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'edit'.tr,
              ),
              IconButton(
                onPressed: controller.delete,
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: 'delete'.tr,
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Obx(() {
            if (controller.loading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            final rawDate = controller.moneyTransaction.dateTime ?? 0;
            final formattedDate =
                rawDate == 0
                    ? (controller.moneyTransaction.createdAt
                            ?.formatDateTime() ??
                        '-- / -- / ----')
                    : (controller.moneyTransaction.dateTime.formatDate() ??
                        '-- / -- / ----');

            final formattedAmount =
                (controller.moneyTransaction.amount ?? 0).formatPrice() ??
                '0 DA';

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // HERO RECEIPT AMOUNT CARD
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
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 64,
                              width: 64,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF10B981,
                                ).withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "assets/reduction.png",
                                fit: BoxFit.contain,
                                errorBuilder:
                                    (_, __, ___) => const Icon(
                                      Icons.account_balance_wallet_outlined,
                                      color: Color(0xFF10B981),
                                      size: 32,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'payment'.tr.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: textSecondary,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formattedAmount,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF10B981),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // DETAILS SECTION
                      _buildDetailCard(
                        icon: Icons.notes_rounded,
                        title: titleText,
                        subtitle: 'description'.tr,
                        cardBg: cardBg,
                        borderClr: borderClr,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),

                      const SizedBox(height: 8),

                      _buildDetailCard(
                        icon: Icons.calendar_today_rounded,
                        title: formattedDate,
                        subtitle: 'date'.tr,
                        cardBg: cardBg,
                        borderClr: borderClr,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                    ],
                  ),
                ),

                // BOTTOM ACTION BAR
                _buildBottomActionBar(context, primaryColor, cardBg, borderClr),
              ],
            );
          }),
        );
      }),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color cardBg,
    required Color borderClr,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF2563EB)),
          ),
          const SizedBox(width: 14),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(
    BuildContext context,
    Color primaryColor,
    Color cardBg,
    Color borderClr,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(top: BorderSide(color: borderClr)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.print_outlined, size: 18),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: controller.print,
                label: Text(
                  'print_ticket'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit_outlined, size: 18),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: controller.edit,
                label: Text(
                  'edit_sale'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444).withOpacity(0.12),
                foregroundColor: const Color(0xFFEF4444),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(14),
              ),
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              onPressed: controller.delete,
            ),
          ],
        ),
      ),
    );
  }
}
