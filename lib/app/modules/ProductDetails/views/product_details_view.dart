import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.product.id == null
              ? Scaffold()
              : Scaffold(
                appBar: AppBar(
                  title: Text(
                    controller.product.name ?? controller.product.nameAr ?? '',
                  ),
                  actions: [
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: controller.product.leading(),
                      ),
                    ),
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
                      Tab(text: "details", icon: Icon(Icons.description)),
                      Tab(
                        text: "customers",
                        icon: Image.asset(
                          "assets/customer.png",
                          height: 25,
                          width: 25,
                        ),
                      ),
                      Tab(
                        text: "suppliers",
                        icon: Image.asset(
                          "assets/supplier.png",
                          height: 25,
                          width: 25,
                        ),
                      ),
                      Tab(
                        text: "transactions",
                        icon: Image.asset(
                          "assets/reduction.png",
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
                          Obx(() {
                            final warehouseStock = [
                              ...controller.warehouseStock,
                            ];

                            /// SORT BY STOCK DESC
                            controller.warehouseStock.sort(
                              (a, b) =>
                                  b.values.first.compareTo(a.values.first),
                            );

                            return buildProductDetails(context);
                          }),
                          customers(),
                          suppliers(),
                          transactions(),
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
                            onPressed: controller.print,
                            label: Text("${'print'.tr}"),
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
                            label: Text("${'edit'.tr}"),
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
                            label: Text("${'delete'.tr}"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }

  Widget buildProductDetails(BuildContext context) {
    final product = controller.product;
    final ThemeData theme = Get.find<HomeController>().theme;
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 1. HERO HEADER CARD (Name, Code & Pricing)
          _buildHeroHeaderCard(product, theme),

          const SizedBox(height: 20),

          /// 2. KEY METRICS (Packaging & Alert Threshold)
          _buildSectionTitle('Inventory Overview', theme),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.inventory_2_outlined,
                  label: 'packaging'.tr,
                  value:
                      product.packaging != null
                          ? product.packaging!.formatNumber()
                          : '1'.tr,
                  color: colorScheme.primary,
                  theme: theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.warning_amber_outlined,
                  label: 'alert_stock'.tr,
                  value:
                      product.alert != null
                          ? product.alert!.formatNumber()
                          : 'non_available'.tr,
                  color: colorScheme.tertiary,
                  theme: theme,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// 3. WAREHOUSE STOCKS LIST
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle('Warehouse Availability', theme),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${controller.warehouseStock.length} Locations',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (controller.warehouseStock.isEmpty)
            _buildEmptyStockState(theme)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.warehouseStock.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final e = controller.warehouseStock[index];
                final warehouse = e.keys.first;
                final stock = e.values.first;
                final alertThreshold = product.alert ?? 0;

                return _buildWarehouseStockCard(
                  theme: theme,
                  warehouseName: warehouse.name ?? 'Unknown Warehouse',
                  stockCount: stock,
                  alertThreshold: alertThreshold,
                );
              },
            ),
        ],
      ),
    );
  }

  /// HERO HEADER CARD WIDGET
  Widget _buildHeroHeaderCard(Product product, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final String productName =
        product.translateName?.isNotEmpty == true
            ? product.translateName!
            : "non_available".tr;
    final String productCode =
        product.code?.isNotEmpty == true ? product.code! : "non_available".tr;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  productName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.qr_code, color: colorScheme.onPrimary, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      productCode,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(
            color: colorScheme.onPrimary.withValues(alpha: 0.2),
            height: 1,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPriceItem(
                  label: 'buy_price'.tr,
                  value:
                      product.buyPrice != null
                          ? product.buyPrice!.formatPrice()
                          : "non_available".tr,
                  icon: Icons.shopping_cart_outlined,
                  theme: theme,
                ),
              ),
              Container(
                height: 35,
                width: 1,
                color: colorScheme.onPrimary.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _buildPriceItem(
                  label: 'sell_price'.tr,
                  value:
                      product.sellPrice != null
                          ? product.sellPrice!.formatPrice()
                          : "non_available".tr,
                  icon: Icons.sell_outlined,
                  theme: theme,
                  isHighlight: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceItem({
    required String label,
    required String value,
    required IconData icon,
    required ThemeData theme,
    bool isHighlight = false,
  }) {
    final colorScheme = theme.colorScheme;
    final labelColor = colorScheme.onPrimary.withValues(alpha: 0.8);
    final valueColor =
        isHighlight
            ? (theme.brightness == Brightness.dark
                ? colorScheme.tertiaryContainer
                : colorScheme.onPrimary)
            : colorScheme.onPrimary;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: labelColor, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(color: labelColor),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// INVENTORY METRIC TILE
  Widget _buildMetricTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// WAREHOUSE STOCK CARD
  Widget _buildWarehouseStockCard({
    required ThemeData theme,
    required String warehouseName,
    required num stockCount,
    required num alertThreshold,
  }) {
    final colorScheme = theme.colorScheme;
    final bool isZero = stockCount <= 0;
    final bool isLowStock = !isZero && stockCount <= alertThreshold;

    final Color statusColor =
        isZero
            ? colorScheme.error
            : isLowStock
            ? (colorScheme.tertiary)
            : (theme.brightness == Brightness.dark
                ? Colors.greenAccent
                : Colors.green.shade700);

    final String statusText =
        isZero
            ? 'Out of Stock'
            : isLowStock
            ? 'Low Stock'
            : 'In Stock';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.warehouse_rounded, color: statusColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  warehouseName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statusText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                stockCount.formatNumber(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              Text(
                'Units',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.6,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildEmptyStockState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'No warehouse stock data available.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildWarehouseStocks() {
    return Obx(() {
      final stocks = [...controller.warehouseStock];

      controller.warehouseStock.sort(
        (a, b) => b.values.first.compareTo(a.values.first),
      );

      return Column(
        children:
            controller.warehouseStock.map((e) {
              final warehouse = e.keys.first;
              final stock = e.values.first;
              final isZero = stock == 0;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      isZero
                          ? Colors.red.withOpacity(.06)
                          : Colors.green.withOpacity(.06),
                  border: Border.all(
                    color:
                        isZero
                            ? Colors.red.withOpacity(.3)
                            : Colors.green.withOpacity(.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warehouse_outlined, size: 18),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        warehouse.name ?? "non_available".tr,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isZero ? Colors.red : Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        stock.formatNumber() ?? "0",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      );
    });
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? iconColor,
    Color? titleColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor ?? Colors.grey.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infocCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Colors.blue),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Container customers() {
    return Container(
      child: Obx(
        () => ListView.builder(
          itemCount: controller.customers.length,
          itemBuilder: (c, i) {
            var customer = controller.customers[i];
            return ListTile(
              leading: customer.circleAvatar(),
              title: Text(customer.firstName ?? ''),
              subtitle: Text(customer.companyName ?? ''),
              trailing: IconButton(icon: Icon(Icons.call), onPressed: () {}),
            );
          },
        ),
      ),
    );
  }

  Container suppliers() {
    return Container(
      child: Obx(
        () => ListView.builder(
          itemCount: controller.suppliers.length,
          itemBuilder: (c, i) {
            var supplier = controller.suppliers[i];
            return ListTile(
              leading: supplier.circleAvatar(),
              title: Text(supplier.firstName ?? ''),
              subtitle: Text(supplier.companyName ?? ''),
              trailing: IconButton(icon: Icon(Icons.call), onPressed: () {}),
            );
          },
        ),
      ),
    );
  }

  Widget transactions() {
    final ThemeData theme = Get.find<HomeController>().theme;
    final colorScheme = theme.colorScheme;

    return Obx(() {
      if (controller.transactions.isEmpty) {
        return _buildEmptyTransactionsState(theme);
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.transactions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final transaction = controller.transactions[index];
          final direction = transaction.direction;

          // Dynamic status color & icon mapping
          final (
            Color dirColor,
            IconData dirIcon,
            String dirLabel,
          ) = switch (direction) {
            1 => (
              Colors.green.shade600,
              Icons.arrow_downward_rounded, // Stock In / Purchase
              'in'.tr,
            ),
            0 => (
              colorScheme.primary,
              Icons.swap_horiz_rounded, // Transfer / Adjustment
              'transfer'.tr,
            ),
            _ => (
              Colors.orange.shade700,
              Icons.arrow_upward_rounded, // Stock Out / Sale
              'out'.tr,
            ),
          };

          final productName =
              controller.product?.translateName?.isNotEmpty == true
                  ? controller.product!.translateName!
                  : (controller.product?.name ?? "non_available".tr);

          final priceText =
              transaction.price != null
                  ? transaction.price.formatPrice()
                  : "non_available".tr;

          final qtyText =
              transaction.qte != null ? transaction.qte.formatNumber() : '0';

          return Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                // Optional: Handle transaction detail tap
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    /// Direction Indicator Icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: dirColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(dirIcon, color: dirColor, size: 22),
                    ),
                    const SizedBox(width: 14),

                    /// Transaction Info (Title, Subtitle, Tag)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: dirColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  dirLabel,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: dirColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                priceText,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.textTheme.bodySmall?.color
                                      ?.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// Quantity Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: dirColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: dirColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${direction == 1
                            ? '+'
                            : direction == 0
                            ? ''
                            : '-'}$qtyText',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: dirColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  /// Empty State Placeholder
  Widget _buildEmptyTransactionsState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: theme.hintColor.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'no_transactions'.tr,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockSummary(BuildContext context) {
    final rest = (controller.product.rest ?? 0);

    final alert = controller.product.alert ?? 10;

    Color garageColor;
    if (rest <= 0) {
      garageColor = Colors.red;
    } else if (rest < alert) {
      garageColor = Colors.orange;
    } else {
      garageColor = Colors.green;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'stock_info'.tr,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                /// GARAGE
                _stockChip(
                  icon: Icons.home_work_outlined,
                  label: "G: ${rest.formatNumber()}",
                  color: garageColor,
                ),

                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stockChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
