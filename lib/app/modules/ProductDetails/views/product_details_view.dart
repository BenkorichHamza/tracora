import 'package:flutter/material.dart';

import 'package:get/get.dart';
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
                          Container(
                            child: ListView(
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildDetailCard(
                                  icon: Icons.label,
                                  title: controller.product.translateName ?? '',
                                  subtitle: 'name'.tr,
                                ),
                                _buildDetailCard(
                                  icon: Icons.label,
                                  title: controller.product.code ?? '',
                                  subtitle: 'code'.tr,
                                ),

                                _buildDetailCard(
                                  icon: Icons.attach_money,
                                  title:
                                      controller.product.buyPrice
                                          .formatPrice() ??
                                      '',
                                  subtitle: 'buy_price'.tr,
                                ),
                                _buildDetailCard(
                                  icon: Icons.attach_money,
                                  title:
                                      controller.product.sellPrice
                                          .formatPrice() ??
                                      '',
                                  subtitle: 'sell_price'.tr,
                                ),
                                _buildDetailCard(
                                  icon: Icons.attach_money,
                                  title:
                                      controller.product.sellPrice1
                                          .formatPrice() ??
                                      '',
                                  subtitle: 'sell_price_1'.tr,
                                ),

                                _buildDetailCard(
                                  icon: Icons.attach_money,
                                  title:
                                      controller.product.sellPrice2
                                          .formatPrice() ??
                                      '',
                                  subtitle: 'sell_price_2'.tr,
                                ),

                                _buildDetailCard(
                                  icon: Icons.inventory,
                                  title:
                                      controller.product.packaging
                                          .formatNumber() ??
                                      '',
                                  subtitle: 'packaging'.tr,
                                ),
                                _buildDetailCard(
                                  icon: Icons.warning,
                                  title:
                                      controller.product.alert.formatNumber() ??
                                      '',
                                  subtitle: 'alert_stock'.tr,
                                ),

                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Section title
                                        Text(
                                          'stock_info'.tr,
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyLarge,
                                        ),
                                        SizedBox(height: 12),

                                        // Your chips row
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Garage stock chip
                                            Chip(
                                              label: Text(
                                                'G: ${((controller.product.rest ?? 0) - (controller.product.missionQte ?? 0)).formatNumber()}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor: () {
                                                final rest =
                                                    (controller.product.rest ??
                                                        0) -
                                                    (controller
                                                            .product
                                                            .missionQte ??
                                                        0);
                                                final alert =
                                                    controller.product.alert ??
                                                    10;
                                                if (rest <= 0)
                                                  return Colors.redAccent;
                                                if (rest < alert)
                                                  return Colors.orange;
                                                return Colors.blueGrey;
                                              }(),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),

                                            // Camion chip only if there’s a mission quantity
                                            if ((controller
                                                        .product
                                                        .missionQte ??
                                                    0) >
                                                0) ...[
                                              const SizedBox(width: 8),
                                              Chip(
                                                avatar: Icon(
                                                  Icons.local_shipping,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                                label: Text(
                                                  'M: ${controller.product.missionQte?.formatNumber()} | S: ${controller.product.missionSelledQte?.formatNumber()}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                backgroundColor: Colors.green,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  Container transactions() {
    return Container(
      child: Obx(
        () => ListView.builder(
          itemCount: controller.transactions.length,
          itemBuilder: (c, i) {
            var transaction = controller.transactions[i];
            return ListTile(
              leading: Icon(
                transaction.direction == 1
                    ? Icons.arrow_circle_up_outlined
                    : Icons.arrow_circle_down_outlined,
                color:
                    transaction.direction == 1 ? Colors.green : Colors.orange,
              ),
              title: Text(controller.product?.name ?? ''),
              subtitle: Text(transaction.price.formatPrice() ?? ''),
              trailing: Material(
                color:
                    transaction.direction == 1 ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Text(
                    ' ${transaction.qte.formatNumber()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
