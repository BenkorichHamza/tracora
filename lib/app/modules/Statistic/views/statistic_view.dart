import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

import '../controllers/statistic_controller.dart';
import 'package:lucide_icons/lucide_icons.dart';

class StatisticView extends GetView<StatisticController> {
  const StatisticView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('statistics'.tr),
        backgroundColor:
            Get.find<HomeController>().theme.scaffoldBackgroundColor,
        actions: [
          Obx(
            () => TextButton(
              onPressed: () async {
                DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().add(Duration(days: 1)),
                  initialDateRange:
                      controller.from == 0
                          ? null
                          : DateTimeRange(
                            start: controller.from.toDatetime()!,
                            end: controller.to.toDatetime()!.subtract(
                              Duration(days: 1),
                            ),
                          ),
                );
                if (picked != null) {
                  controller.from = picked.start.millisecondsSinceEpoch;
                  controller.to =
                      picked.end.add(Duration(days: 1)).millisecondsSinceEpoch;
                  controller.loadStatistics();
                }
              },
              child:
                  controller.from == 0
                      ? Text('Select Date Range')
                      : Text(
                        controller.from.formatDate()! +
                            ' - ' +
                            controller.to.formatDate()!,
                      ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final stats = controller.statistics;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
            children: [
              _buildStatCard(
                'Total Customer Payment',
                stats.totalCustomerPayment?.formatPrice(),
                LucideIcons.wallet,
              ),
              _buildStatCard(
                'Total Supplier Payment',
                stats.totalSupplierPayment.formatPrice(),
                LucideIcons.truck,
              ),
              _buildStatCard(
                'Total Sale Payment',
                stats.totalSalePayment?.formatPrice(),
                LucideIcons.wallet,
              ),
              _buildStatCard(
                'Total Purchase Payment',
                stats.totalPurchasePayment.formatPrice(),
                LucideIcons.truck,
              ),
              _buildStatCard(
                'Total Fees',
                stats.totalFeesPayment.formatPrice(),
                LucideIcons.receipt,
              ),
              _buildStatCard(
                'Total Purchase',
                stats.totalPurchase.formatPrice(),
                LucideIcons.shoppingCart,
              ),
              _buildStatCard(
                'Total Sale',
                stats.totalSale.formatNumber(),
                LucideIcons.dollarSign,
              ),
              _buildStatCard(
                'Total Customer Credit',
                stats.totalCustomerCredit.formatPrice(),
                LucideIcons.userCheck,
              ),
              _buildStatCard(
                'Total Supplier Credit',
                stats.totalSupplierCredit.formatPrice(),
                LucideIcons.userX,
              ),

              _buildStatCard(
                'Purchases',
                stats.purchaseCount?.formatNumber(),
                LucideIcons.package,
              ),
              _buildStatCard(
                'Sales',
                stats.saleCount?.formatNumber(),
                LucideIcons.store,
              ),
              _buildStatCard(
                'Products',
                stats.productCount?.formatNumber(),
                LucideIcons.list,
              ),
              _buildStatCard(
                'Customers',
                stats.customerCount?.formatNumber(),
                LucideIcons.users,
              ),
              _buildStatCard(
                'Suppliers',
                stats.supplierCount?.formatNumber(),
                LucideIcons.factory,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String title, String? value, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Get.find<HomeController>().theme.colorScheme.surfaceContainerHigh,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.green),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Text(
                  value != null ? value : 'N/A',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
