import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.onTap,
    required this.item,
    required this.highest,
    required this.selected,
  });

  final Function(UserModel item) onTap;
  final UserModel item;
  final bool highest;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ListTile(
        selected: selected,
        // selectedColor: Colors.amber.withAlpha(200),
        selectedTileColor: Colors.amber.withAlpha(50),

        tileColor: Get.find<HomeController>().theme.colorScheme.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        onTap: () => onTap(item),
        leading: item.circleAvatar(),
        title: Text(item.firstName ?? ''),
        subtitle: Text((item.email ?? '').isEmpty ? 'email' : item.email!),
        trailing: Text(
          (item.toPay).formatPrice() ?? '',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
