import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class TransactionTabs<T> extends GetView<StockTransactionController<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        // color: colorScheme.surfaceVariant,
        border: Border(
          bottom: BorderSide(
            color: Get.find<HomeController>().theme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Obx(
        () => Row(
          children: [
            _toolbarButton(
              label: controller.title,
              isActive: controller.selectedFormIndex == -1,
              onTap: () => controller.selectedFormIndex = -1,
              icon: Icons.list_alt,
              colorScheme: Get.find<HomeController>().theme.colorScheme,
            ),
            const SizedBox(width: 8),

            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...controller.forms.map(
                      (form) => _toolbarButton(
                        label: form.user?.firstName ?? (controller.newTitle),
                        icon: Icons.shopping_bag,
                        isActive: form.index == controller.selectedFormIndex,
                        onTap: () {
                          controller.selectedFormIndex = form.index;
                          controller.forms = controller.forms.sublist(0);
                        },
                        colorScheme:
                            Get.find<HomeController>().theme.colorScheme,
                        trailing: IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 18,
                            color:
                                Get.find<HomeController>()
                                    .theme
                                    .colorScheme
                                    .onPrimaryContainer,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => controller.deleteForm(form.index),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () => controller.addNewForm(),
              icon: Icon(Icons.add_circle),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolbarButton({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? colorScheme.primaryContainer : Colors.transparent,
          border:
              isActive
                  ? Border(
                    top: BorderSide(color: colorScheme.primary, width: 2),
                    left: BorderSide(color: colorScheme.primary, width: 2),
                    right: BorderSide(color: colorScheme.primary, width: 2),
                    bottom: BorderSide(color: Colors.transparent, width: 0),
                  )
                  : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color:
                  isActive
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(label, style: themeTextStyle(colorScheme, isActive)),
            if (trailing != null) ...[const SizedBox(width: 4), trailing],
          ],
        ),
      ),
    );
  }

  TextStyle themeTextStyle(ColorScheme cs, bool isActive) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: isActive ? cs.onPrimaryContainer : cs.onSurfaceVariant,
    );
  }
}
