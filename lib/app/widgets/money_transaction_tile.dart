import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class MoneyTransactionTile extends StatelessWidget {
  const MoneyTransactionTile({
    super.key,
    required this.onTap,
    required this.item,
    required this.highest,
    required this.selected,
  });

  final Function(MoneyTransaction item) onTap;
  final MoneyTransaction item;
  final bool highest;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      // selectedColor: Colors.amber.withAlpha(200),
      selectedTileColor: Colors.amber.withAlpha(50),
      tileColor:
          highest
              ? Get.find<HomeController>()
                  .theme
                  .colorScheme
                  .surfaceContainerHigh
              : null,
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      onTap: () => onTap(item),
      leading: item.user?.circleAvatar(),
      title: Text(item.user?.firstName ?? ''),
      subtitle: Text((item.dateTime ?? item.createdAt).formatDateTime() ?? ''),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            (item.amount ?? 0).formatPrice() ?? '',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: item.employee?.circleAvatar(radius: 15) ?? SizedBox(),
          ),
        ],
      ),
    );
  }
}
