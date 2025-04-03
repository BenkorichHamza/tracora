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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildDetailCard(
                                  icon: Icons.label,
                                  title: controller.product.translateName ?? '',
                                  subtitle: 'name'.tr,
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
                                  icon: Icons.shopping_cart,
                                  title:
                                      controller.product.sellPrice
                                          .formatPrice() ??
                                      '',
                                  subtitle: 'sell_price'.tr,
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
                                  iconColor: Colors.red,
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
                            label: Text('edit_product'.tr),
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
                            label: Text('delete_product'.tr),
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
    Color iconColor = Colors.blue,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
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
