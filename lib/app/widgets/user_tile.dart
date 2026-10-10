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
    required this.user,
    required this.highest,
    required this.selected,
  });

  final Function(UserModel item) onTap;
  final UserModel user;
  final bool highest;
  final bool selected;

  @override
  Widget build(BuildContext context) {
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
            selectedTileColor:
                Get.find<HomeController>().theme.colorScheme.surfaceContainer,

            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            onTap: () => onTap(user),
            leading: user?.circleAvatar(),
            title: Text(user?.firstName ?? ''),
            subtitle: Text((user.email ?? user.phone ?? "")),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (user.toPay ?? 0).formatPrice() ?? '',
                  style: const TextStyle(
                    fontSize: 18,
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
}
