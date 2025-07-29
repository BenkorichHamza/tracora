import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tracora/app/widgets/empty_widget.dart';
import 'package:tracora/app/widgets/money_transaction_tile.dart';
import 'package:tracora/app/widgets/stock_transaction_tile.dart';

import '../controllers/synchronisation_controller.dart';

class SynchronisationView extends GetView<SynchronisationController> {
  const SynchronisationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: const Text('missions'),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: () async {
                        await controller.getMissions();
                      },
                      icon: Obx(
                        () =>
                            controller.missionLoading
                                ? CircularProgressIndicator()
                                : const Icon(Icons.refresh),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Obx(
                    () =>
                        controller.missions.isEmpty
                            ? EmptyWidget()
                            : ListView.builder(
                              padding: EdgeInsets.all(8),
                              itemCount: controller.missions.length,
                              itemBuilder: (c, i) {
                                var mission = controller.missions[i];
                                return StockTransactionTile(
                                  onValidate: (item) {
                                    print(item.status);
                                  },
                                  item: mission,
                                  onTap: (v) {},
                                  highest: false,
                                  selected: false,
                                );
                              },
                            ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: const Text('sales'),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: () async {
                        await controller.getSales();
                      },
                      icon: Obx(
                        () =>
                            controller.saleLoading
                                ? CircularProgressIndicator()
                                : const Icon(Icons.refresh),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Obx(
                    () =>
                        controller.sales.isEmpty
                            ? EmptyWidget()
                            : ListView.builder(
                              padding: EdgeInsets.all(8),
                              itemCount: controller.sales.length,
                              itemBuilder: (c, i) {
                                var mission = controller.sales[i];
                                return StockTransactionTile(
                                  onValidate: (item) {
                                    print(item.status);
                                  },
                                  item: mission,
                                  onTap: (v) {},
                                  highest: false,
                                  selected: false,
                                );
                              },
                            ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: const Text('payments'),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: () async {
                        await controller.getPayments();
                      },
                      icon: Obx(
                        () =>
                            controller.paymentLoading
                                ? CircularProgressIndicator()
                                : const Icon(Icons.refresh),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Obx(
                    () =>
                        controller.payments.isEmpty
                            ? EmptyWidget()
                            : ListView.builder(
                              padding: EdgeInsets.all(8),
                              itemCount: controller.payments.length,
                              itemBuilder: (c, i) {
                                var mission = controller.payments[i];
                                return MoneyTransactionTile(
                                  item: mission,
                                  onTap: (v) {},
                                  onValidate: (item) {
                                    print(item.status);
                                  },
                                  highest: false,
                                  selected: false,
                                );
                              },
                            ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
