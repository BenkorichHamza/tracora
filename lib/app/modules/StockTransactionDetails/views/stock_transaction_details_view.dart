import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/widgets/product_transaction_tile.dart';
import 'package:tracora/app/widgets/qr_code.dart';

import '../controllers/stock_transaction_details_controller.dart';

class StockTransactionDetailsView<T>
    extends GetView<StockTransactionDetailsController<T>> {
  const StockTransactionDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<HomeController>().theme;

    return PopScope(
      child: Obx(() {
        final tx = controller.stockTransaction;

        if (tx.id == null) {
          return const Scaffold(body: SizedBox());
        }

        final isApproved = tx.status == 1;
        final formattedDate = (tx.dateTime ?? tx.createdAt)?.formatDate() ?? '';

        return Scaffold(
          backgroundColor: theme.colorScheme.surfaceContainer,
          appBar: AppBar(
            backgroundColor: theme.colorScheme.surfaceContainer,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  // dense: true,
                  title: Text(
                    '${tx.employee?.firstName ?? 'Admin'}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                  subtitle: Text(formattedDate),
                  leading:
                      tx.employee?.circleAvatar(radius: 12) ??
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.person_outline,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                ),
              ],
            ),
            actions: [
              _buildWarehouseBadge(theme),
              if (!isApproved) ...[
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: controller.approve,
                    icon: const Icon(Icons.check_circle_outline, size: 16),
                    label: Text(
                      'approve'.tr,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ] else
                const SizedBox(width: 12),
            ],
          ),
          body: Obx(() {
            if (controller.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    children: [
                      // --- Financial & User Info Card ---
                      if (controller.transactionType != 'transfert') ...[
                        _buildSummaryCard(context, isApproved),
                        const SizedBox(height: 20),
                      ],

                      // --- Items Header ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Products',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${controller.productTransactions.length} items',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // --- Product Tile List ---
                      ...List.generate(
                        controller.productTransactions.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ProductTransactionTile(
                            productTransaction:
                                controller.productTransactions[index],
                          ),
                        ),
                      ),
                      Center(child: QrCode(tx.id.toString(), size: 200)),
                    ],
                  ),
                ),

                // --- Floating Bottom Action Bar ---
                _buildBottomActionBar(context),
              ],
            );
          }),
        );
      }),
    );
  }

  /// Warehouse routing pill badge
  Widget _buildWarehouseBadge(ThemeData theme) {
    String warehouseLabel = '';
    if (T == Sale) {
      warehouseLabel = controller.stockTransaction.from_warehouse?.name ?? '';
    } else if (T == Purchase) {
      warehouseLabel = controller.stockTransaction.to_warehouse?.name ?? '';
    } else {
      final from = controller.stockTransaction.from_warehouse?.name ?? '';
      final to = controller.stockTransaction.to_warehouse?.name ?? '';
      warehouseLabel = '$from → $to';
    }

    if (warehouseLabel.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.storefront_outlined,
            size: 14,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            warehouseLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Modern Financial Summary Card (replaces the old cart block)
  Widget _buildSummaryCard(BuildContext context, bool isApproved) {
    final theme = Theme.of(context);
    final tx = controller.stockTransaction;

    final statusColor =
        isApproved ? const Color(0xFF10B981) : const Color(0xFFF59E0B);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceDim,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: User & Status Badge
          Row(
            children: [
              tx.user?.circleAvatar(radius: 18) ??
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person_outline,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                  ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.user?.firstName ?? 'Unknown User',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Created by',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(
                          0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isApproved
                          ? Icons.check_circle_rounded
                          : Icons.hourglass_top_rounded,
                      size: 14,
                      color: statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isApproved ? 'Validée' : 'Non validée',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(height: 1, color: theme.dividerColor.withOpacity(0.12)),
          const SizedBox(height: 16),

          // Payment Overview Metrics
          Row(
            children: [
              _buildSummaryMetric(
                context,
                label: 'Total',
                value: tx.total.formatPrice() ?? '0.00',
                valueColor: theme.colorScheme.primary,
                isBold: true,
              ),
              _buildMetricDivider(theme),
              _buildSummaryMetric(
                context,
                label: 'Ancien crédit',
                value: tx.credit.formatPrice() ?? '0.00',
              ),
              _buildMetricDivider(theme),
              _buildSummaryMetric(
                context,
                label: 'Payé',
                value: tx.payment.formatPrice() ?? '0.00',
                valueColor: const Color(0xFF10B981),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMetric(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
    bool isBold = false,
  }) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor ?? theme.textTheme.titleMedium?.color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricDivider(ThemeData theme) {
    return Container(
      height: 24,
      width: 1,
      color: theme.dividerColor.withOpacity(0.15),
    );
  }

  /// Action bar fixed at bottom
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
        // Row(
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
