import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/UserPaymentDetails/controllers/user_payment_details_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/widgets/qr_code.dart';

class UserPaymentDetailsView<T>
    extends GetView<UserPaymentDetailsController<T>> {
  const UserPaymentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      child: Obx(() {
        final tx = controller.moneyTransaction;

        if (tx.id == null) {
          return const Scaffold();
        }

        final bool isValidated = tx.status == 1;
        final statusColor = isValidated ? Colors.green : Colors.amber.shade800;
        final statusBg =
            isValidated ? Colors.green.withOpacity(0.1) : Colors.amber.shade50;

        return Scaffold(
          backgroundColor: theme.colorScheme.surfaceContainer,
          appBar: AppBar(
            title: Text(
              (tx.dateTime ?? tx.createdAt)?.formatDate() ?? '',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            // scaffoldColorScheme: Get.find<HomeController>().dark.colorScheme,
          ),
          bottomNavigationBar:
              isValidated
                  ? null
                  : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        onPressed: () => controller.approve(),
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text('approve'.tr),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
          bottomSheet: _buildBottomActionBar(context),
          body:
              controller.loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Status Chip Header
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: statusColor.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isValidated
                                      ? Icons.check_circle
                                      : Icons.hourglass_top_rounded,
                                  size: 16,
                                  color: statusColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isValidated
                                      ? 'Validée'
                                      : 'En attente de validation',
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 2. Main Hero Paid Amount Display
                        Text(
                          'Total versé',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${tx.amount.formatNumber()} DA',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 3. User Detail Card
                        Card(
                          elevation: 0,
                          color: theme.colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: theme.colorScheme.outlineVariant
                                  .withOpacity(0.5),
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading:
                                tx.user?.circleAvatar(radius: 24) ??
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor:
                                      theme.colorScheme.primaryContainer,
                                  child: Icon(
                                    Icons.person_outline,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                            title: Text(
                              tx.user?.firstName ?? 'User',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            // subtitle: Text(
                            //   'Identifiant transaction #${tx.id}',
                            //   style: TextStyle(
                            //     color: theme.colorScheme.onSurfaceVariant,
                            //     fontSize: 12,
                            //   ),
                            // ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 4. Detailed Breakdown Section
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant
                                  .withOpacity(0.5),
                            ),
                          ),
                          child: Column(
                            children: [
                              _DetailRow(
                                icon: Icons.history,
                                label: 'Ancien crédit',
                                value: '${tx.credit.formatNumber()} DA',
                                theme: theme,
                              ),
                              Divider(
                                height: 1,
                                indent: 16,
                                endIndent: 16,
                                color: theme.colorScheme.outlineVariant
                                    .withOpacity(0.4),
                              ),
                              _DetailRow(
                                icon: Icons.payments_outlined,
                                label: 'Montant réglé',
                                value: '${tx.amount.formatNumber()} DA',
                                valueColor: theme.colorScheme.primary,
                                theme: theme,
                              ),
                              Divider(
                                height: 1,
                                indent: 16,
                                endIndent: 16,
                                color: theme.colorScheme.outlineVariant
                                    .withOpacity(0.4),
                              ),
                              _DetailRow(
                                icon: Icons.account_balance_wallet_outlined,
                                label: 'Nouveau solde',
                                value:
                                    '${((tx.credit ?? 0) - (tx.amount ?? 0)).formatNumber()} DA',
                                theme: theme,
                              ),
                            ],
                          ),
                        ),
                        Center(child: QrCode(tx.id.toString(), size: 200)),
                      ],
                    ),
                  ),
        );
      }),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        // color: theme.colorScheme.surfaceDim,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 10,
        //     offset: const Offset(0, -3),
        //   ),
        // ],
      ),
      child: SafeArea(
        top: false,
        child:
        //  Row(
        //   children: [
        //     Expanded(child: SizedBox()),
        //     IconButton.filledTonal(
        //       style: IconButton.styleFrom(
        //         backgroundColor: Colors.green.withAlpha(50),
        //         foregroundColor: Colors.green,
        //         padding: const EdgeInsets.all(14),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //       ),
        //       onPressed: controller.printTicket,
        //       icon: const Icon(Icons.print_outlined, size: 20),
        //       tooltip: 'print_ticket'.tr,
        //     ),
        //     const SizedBox(width: 8),
        //     IconButton.filledTonal(
        //       style: IconButton.styleFrom(
        //         backgroundColor: Colors.amber.withAlpha(50),
        //         foregroundColor: Colors.amber,
        //         padding: const EdgeInsets.all(14),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //       ),
        //       onPressed: controller.edit,
        //       icon: const Icon(Icons.edit_outlined, size: 20),
        //       tooltip: 'edit'.tr,
        //     ),
        //     const SizedBox(width: 8),
        //     IconButton.filledTonal(
        //       style: IconButton.styleFrom(
        //         backgroundColor: theme.colorScheme.errorContainer,
        //         foregroundColor: theme.colorScheme.onErrorContainer,
        //         padding: const EdgeInsets.all(14),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //       ),
        //       onPressed: controller.delete,
        //       icon: const Icon(Icons.delete_outline, size: 20),
        //       tooltip: 'delete_sale'.tr,
        //     ),
        //   ],
        // ),
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
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final ThemeData theme;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: valueColor ?? theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
