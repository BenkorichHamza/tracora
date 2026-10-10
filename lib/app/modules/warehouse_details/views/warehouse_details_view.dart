import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/StockTransactionDetails/views/stock_transaction_details_view.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/widgets/stock_transaction_tile.dart';

import '../controllers/warehouse_details_controller.dart';

class WarehouseDetailsView extends GetView<WarehouseDetailsController> {
  const WarehouseDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(controller.warehouse.name ?? 'Warehouse Details'),
        ),
        centerTitle: true,

        bottom: TabBar(
          controller: controller.tabCtrl,
          tabs: const [
            Tab(text: 'Details'),
            Tab(text: 'Products'),
            Tab(text: 'Transactions'),
            Tab(text: 'History'),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => TabBarView(
                controller: controller.tabCtrl,
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Card
                        _buildHeaderCard(Get.find<HomeController>().theme),
                        const SizedBox(height: 16),

                        // Overview Section
                        _buildSectionTitle('Overview'),
                        const SizedBox(height: 8),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                _buildDetailRow(
                                  icon: Icons.title,
                                  label: 'Name',
                                  value: controller.warehouse.name,
                                ),
                                const Divider(),
                                _buildDetailRow(
                                  icon: Icons.category_outlined,
                                  label: 'Type',
                                  value: controller.warehouse.type,
                                ),
                                const Divider(),
                                _buildDetailRow(
                                  icon: Icons.location_on_outlined,
                                  label: 'Location',
                                  value: controller.warehouse.location,
                                ),
                                if (controller.warehouse.description != null &&
                                    controller
                                        .warehouse
                                        .description!
                                        .isNotEmpty) ...[
                                  const Divider(),
                                  _buildDetailRow(
                                    icon: Icons.description_outlined,
                                    label: 'Description',
                                    value: controller.warehouse.description,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // System Metadata Section
                        _buildSectionTitle('Audit Information'),
                        const SizedBox(height: 8),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                _buildDetailRow(
                                  icon: Icons.access_time,
                                  label: 'Created At',
                                  value: _formatTimestamp(
                                    controller.warehouse.createdAt,
                                  ),
                                ),

                                const Divider(),
                                _buildDetailRow(
                                  icon: Icons.update,
                                  label: 'Updated At',
                                  value: _formatTimestamp(
                                    controller.warehouse.updatedAt,
                                  ),
                                ),
                                if (controller.warehouse.deletedAt != null) ...[
                                  const Divider(),
                                  _buildDetailRow(
                                    icon: Icons.auto_delete_outlined,
                                    label: 'Deleted At',
                                    value: _formatTimestamp(
                                      controller.warehouse.deletedAt,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  warehouseProducts(),
                  warehouseTrqasactions(),
                  Center(child: Text('History')),
                ],
              ),
            ),
          ),
          _buildBottomActionBar(context),
        ],
      ),
    );
  }

  String _formatTimestamp(int? timestamp) {
    if (timestamp == null || timestamp == 0) return 'N/A';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('yyyy-MM-dd hh:mm a').format(date);
  }

  Widget _buildHeaderCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warehouse_outlined,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.warehouse.translateName ?? 'N/A',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ListTile(
                      dense: true,
                      title: Text(
                        'Employee: ${controller.employee.firstName ?? 'N/A'}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      trailing: controller.employee.circleAvatar(radius: 15),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String? value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  ListView warehouseTrqasactions() {
    return ListView.builder(
      itemBuilder: (context, index) {
        final transaction = controller.transactions[index];
        return StockTransactionTile(
          item: transaction,
          selected: false,
          highest: false,
          onTap: (v) {
            showDialog(
              context: Get.context!,

              builder: (c) {
                var stockTransactionController =
                    transaction.type == "sale"
                        ? Get.find<StockTransactionController<Sale>>()
                        : transaction.type == "purchase"
                        ? Get.find<StockTransactionController<Purchase>>()
                        : Get.find<StockTransactionController<Transfert>>();
                stockTransactionController.toDetails(transaction);
                return Center(
                  child: Dialog(
                    backgroundColor: Colors.transparent,
                    clipBehavior: Clip.antiAlias,
                    elevation: 10,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 450),

                      child: Center(
                        child:
                            transaction.type == "sale"
                                ? StockTransactionDetailsView<Sale>()
                                : transaction.type == "purchase"
                                ? StockTransactionDetailsView<Purchase>()
                                : StockTransactionDetailsView<Transfert>(),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          onValidate: (v) {},
        );
      },
      itemCount: controller.transactions.length,
    );
  }

  ListView warehouseProducts() {
    return ListView.builder(
      itemCount: controller.products.length,
      itemBuilder: (context, index) {
        final product = controller.products[index];
        return listItem(product);
      },
    );
  }

  Padding listItem(Product product) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Obx(
        () => ListTile(
          // selected: controller.selected.id == product.id,
          // key:
          //     product.id == controller.selected.id
          //         ? controller.selectedKey
          //         : null,
          // onTap: () {
          //   controller.toDetails(product);
          // },
          subtitle: Text(product.sellPrice.formatPrice() ?? ''),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.withAlpha(100)),
          ),
          tileColor:
              Get.find<HomeController>().isDark
                  ? Get.find<HomeController>()
                      .theme
                      .colorScheme
                      .surfaceContainerHigh
                  : Colors.white,
          contentPadding: EdgeInsets.only(right: 8, top: 0, bottom: 0, left: 8),
          leading: product.leading(),
          title: Text(product.translateName ?? 'product'.tr),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Garage stock chip
              Chip(
                label: Text(
                  'G: ${((product.rest ?? 0)).formatNumber()}',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: () {
                  final rest = (product.rest ?? 0);
                  final alert = product.alert ?? 10;
                  if (rest <= 0) return Colors.redAccent;
                  if (rest < alert) return Colors.orange;
                  return Colors.blueGrey; // you can pick a neutral color
                }(),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(child: SizedBox()),

            IconButton.filledTonal(
              style: IconButton.styleFrom(
                backgroundColor: Colors.amber.withAlpha(50),
                foregroundColor: Colors.amber,
                padding: const EdgeInsets.all(14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: controller.edit,
              icon: const Icon(Icons.edit_outlined, size: 20),
              tooltip: 'edit'.tr,
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.errorContainer,
                foregroundColor: theme.colorScheme.onErrorContainer,
                padding: const EdgeInsets.all(14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: controller.delete,
              icon: const Icon(Icons.delete_outline, size: 20),
              tooltip: 'delete_sale'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
