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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.extent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
          children: [
            Obx(
              () => _buildStatCard(
                'Total Customer Payment',
                controller.statistics.totalCustomerPayment?.formatPrice(),
                LucideIcons.wallet,
              ),
            ),
            Obx(
              () => _buildStatCard(
                'Total Supplier Payment',
                controller.statistics.totalSupplierPayment.formatPrice(),
                LucideIcons.truck,
              ),
            ),
            Obx(
              () => _buildStatCard(
                'Total Sale Payment',
                controller.statistics.totalSalePayment?.formatPrice(),
                LucideIcons.wallet,
              ),
            ),
            Obx(
              () => _buildStatCard(
                'Total Purchase Payment',
                controller.statistics.totalPurchasePayment.formatPrice(),
                LucideIcons.truck,
              ),
            ),
            Obx(
              () => _buildStatCard(
                'Total Fees',
                controller.statistics.totalFeesPayment.formatPrice(),
                LucideIcons.receipt,
              ),
            ),
            Obx(
              () => _buildStatCard(
                'Total Purchase',
                controller.statistics.totalPurchase.formatPrice(),
                LucideIcons.shoppingCart,
              ),
            ),
            Obx(
              () => _buildStatCard(
                'Total Sale',
                controller.statistics.totalSale.formatNumber(),
                LucideIcons.dollarSign,
              ),
            ),
            Obx(
              () => _buildStatCard(
                'Total Customer Credit',
                controller.statistics.totalCustomerCredit.formatPrice(),
                LucideIcons.userCheck,
              ),
            ),
            Obx(
              () => _buildStatCard(
                'Total Supplier Credit',
                controller.statistics.totalSupplierCredit.formatPrice(),
                LucideIcons.userX,
              ),
            ),

            Obx(
              () => _buildStatCard(
                'Purchases',
                controller.statistics.purchaseCount?.formatNumber(),
                LucideIcons.package,
              ),
            ),
            Obx(
              () => _buildStatCard(
                'Sales',
                controller.statistics.saleCount?.formatNumber(),
                LucideIcons.store,
              ),
            ),
            Obx(
              () => _buildStatCard(
                'Products',
                controller.statistics.productCount?.formatNumber(),
                LucideIcons.list,
              ),
            ),
            Obx(
              () => _buildStatCard(
                'Customers',
                controller.statistics.customerCount?.formatNumber(),
                LucideIcons.users,
              ),
            ),
            Obx(
              () => _buildStatCard(
                'Suppliers',
                controller.statistics.supplierCount?.formatNumber(),
                LucideIcons.factory,
              ),
            ),
          ],
        ),
      ),
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
