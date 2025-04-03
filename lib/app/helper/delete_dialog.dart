import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> deleteConfirmation() {
  return Get.dialog(
    SimpleDialog(
      title: Center(child: Text("delete_item".tr)),
      children: [
        Row(
          children: [
            SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                child: Text("yes".tr),
                onPressed: () {
                  Get.back(result: true);
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                child: Text("no".tr),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ],
    ),
  );
}
