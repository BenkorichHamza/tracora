import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/User/controllers/user_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class EmployeeSelector extends StatefulWidget {
  const EmployeeSelector({super.key, required this.onSelect});

  final Function(UserModel) onSelect;

  @override
  State<EmployeeSelector> createState() => _EmployeeSelectorState();
}

class _EmployeeSelectorState extends State<EmployeeSelector> {
  UserModel selected = UserModel();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController<Employee>>(
      builder: (c) {
        return Obx(
          () => Theme(
            data: Get.find<HomeController>().dark,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<UserModel>(
                padding: EdgeInsets.symmetric(horizontal: 8),
                icon: SizedBox(),
                value: selected,

                borderRadius: BorderRadius.circular(8),
                items:
                    ([UserModel()] + c.users).map((user) {
                      return DropdownMenuItem<UserModel>(
                        value: user,
                        child: Row(
                          children: [
                            user.circleAvatar(radius: 15),
                            SizedBox(width: 8),
                            Text(user.firstName ?? user.lastName ?? "all".tr),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (selectedUser) {
                  setState(() {
                    selected = selectedUser ?? selected;
                  });
                  widget.onSelect(selected);
                },
                hint: Text('Select employee'),
              ),
            ),
          ),
        );
      },
    );
  }
}
