import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class StockTransactionTile extends StatelessWidget {
  const StockTransactionTile({
    super.key,
    required this.onTap,
    required this.onValidate,
    required this.item,
    required this.highest,
    required this.selected,
  });

  final Function(StockTransaction item) onTap;
  final Function(StockTransaction item) onValidate;
  final StockTransaction item;
  final bool highest;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (item.type == "transfert") {
      final totalItems = (item.productTransactions ?? []).length;

      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          selected: selected,
          selectedTileColor:
              Get.find<HomeController>().theme.colorScheme.surfaceContainer,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: selected ? Colors.green : Colors.grey.withAlpha(100),
            ),
          ),

          // tileColor:
          //     Get.find<HomeController>().isDark
          //         ? Get.find<HomeController>()
          //             .theme
          //             .colorScheme
          //             .surfaceContainer
          //         : Colors.white,
          onTap: () => onTap(item),

          /// LEADING ICON
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.swap_horiz, color: Colors.green, size: 24),
          ),

          /// TITLE (WAREHOUSES)
          title: Row(
            children: [
              SizedBox(
                // width: 300,
                child: Text(
                  item.from_warehouse?.name ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  // color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  size: 14,
                  // color: Colors.white,
                ),
              ),

              const SizedBox(width: 8),

              Flexible(
                child: Text(
                  item.to_warehouse?.name ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          /// SUBTITLE
          subtitle: Text(
            (item.dateTime ?? item.createdAt).formatDateTime() ?? '',
          ),

          /// TRAILING
          trailing:
              item.employee?.circleAvatar(radius: 15) ??
              const CircleAvatar(
                radius: 15,
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.admin_panel_settings),
              ),
        ),
      );
    }

    /// ORIGINAL UI FOR OTHER TYPES
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          ListTile(
            selected: selected,
            selectedTileColor:
                Get.find<HomeController>().theme.colorScheme.surfaceContainer,
            // : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: selected ? Colors.green : Colors.grey.withAlpha(100),
              ),
            ),
            // tileColor:
            // Get.find<HomeController>().isDark
            //     ?
            // Get.find<HomeController>()
            //     .theme
            //     .colorScheme
            //     .surfaceContainerHigh,
            // : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            onTap: () => onTap(item),
            leading: item.user?.circleAvatar(),
            title: Text(item.user?.firstName ?? ''),
            subtitle: Text(
              (item.dateTime ?? item.createdAt).formatDateTime() ?? '',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (item.topay ?? 0).formatPrice() ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      item.employee?.circleAvatar(radius: 15) ??
                      const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Icons.admin_panel_settings),
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

class MoneyTransactionItem extends StatelessWidget {
  const MoneyTransactionItem({
    super.key,
    required this.onTap,
    required this.onValidate,
    required this.item,
    required this.highest,
    required this.selected,
  });

  final Function(MoneyTransaction item) onTap;
  final Function(MoneyTransaction item) onValidate;
  final MoneyTransaction item;
  final bool highest;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (item.type == "fees") {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            ListTile(
              selected: selected,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: selected ? Colors.green : Colors.grey.withAlpha(100),
                ),
              ),
              // tileColor:
              //     Get.find<HomeController>().isDark
              //         ? Get.find<HomeController>()
              //             .theme
              //             .colorScheme
              //             .surfaceContainerHigh
              //         : Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              onTap: () => onTap(item),
              leading: Image.asset("assets/reduction.png"),
              title: Text(item.description ?? ''),
              subtitle: Text(
                (item.dateTime ?? item.createdAt).formatDateTime() ?? '',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (item.amount ?? 0).formatPrice() ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        item.employee?.circleAvatar(radius: 15) ??
                        const CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.deepPurple,
                          child: Icon(Icons.admin_panel_settings),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    /// ORIGINAL UI FOR OTHER TYPES
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          ListTile(
            selected: selected,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: selected ? Colors.green : Colors.grey.withAlpha(100),
              ),
            ),
            // tileColor:
            //     Get.find<HomeController>().isDark
            //         ? Get.find<HomeController>()
            //             .theme
            //             .colorScheme
            //             .surfaceContainerHigh
            //         : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            onTap: () => onTap(item),
            leading: item.user?.circleAvatar(),
            title: Text(item.user?.firstName ?? ''),
            subtitle: Text(
              (item.dateTime ?? item.createdAt).formatDateTime() ?? '',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (item.amount ?? 0).formatPrice() ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      item.employee?.circleAvatar(radius: 15) ??
                      const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Icons.admin_panel_settings),
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
