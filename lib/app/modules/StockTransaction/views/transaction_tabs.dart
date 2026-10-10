import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/widgets/window_buttons.dart';

class TransactionTabs<T> extends GetView<StockTransactionController<T>> {
  const TransactionTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<HomeController>().theme;
    final colorScheme = theme.colorScheme;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Obx(() {
        final isMainActive = controller.selectedFormIndex == -1;

        return MoveWindow(
          child: Row(
            children: [
              // Fixed Main / List View Tab Button
              _buildTabChip(
                context: context,
                label: controller.title,
                icon: Icons.format_list_bulleted_rounded,
                isActive: isMainActive,
                colorScheme: colorScheme,
                onTap: () => controller.selectedFormIndex = -1,
              ),

              const SizedBox(width: 8),

              // Vertical Divider separating main tab from dynamic forms
              VerticalDivider(
                width: 1,
                indent: 8,
                endIndent: 8,
                color: colorScheme.outlineVariant.withOpacity(0.6),
              ),

              const SizedBox(width: 8),

              // Dynamic Form Tabs (Scrollable)
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. Flexible with FlexFit.loose lets the scroll view take ONLY as much
                    // width as its children need, up to the maximum available parent width.
                    Flexible(
                      fit: FlexFit.loose,
                      child: SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal, // Enable horizontal scrolling when items overflow
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children:
                              controller.forms
                                  .map(
                                    (form) => _buildTabChip(
                                      context: context,
                                      label:
                                          form.user?.firstName ??
                                          controller.newTitle,
                                      icon: Icons.shopping_bag_outlined,
                                      isActive:
                                          form.index ==
                                          controller.selectedFormIndex,
                                      colorScheme: colorScheme,
                                      onTap: () {
                                        controller.selectedFormIndex =
                                            form.index;
                                        controller.forms = controller.forms
                                            .sublist(0);
                                      },
                                      onClose:
                                          () =>
                                              controller.deleteForm(form.index),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // 2. The Add button will sit directly beside the last tab when uncrowded,
                    // and stay pinned on the right edge once tabs fill the row.
                    Tooltip(
                      message: 'Add new form',
                      child: InkWell(
                        onTap: () => controller.addNewForm(),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              WindowButtons(homeController: Get.find<HomeController>()),
            ],
          ),
        );
      }),
    );
  }

  /// Modern Animated Tab Chip Component
  Widget _buildTabChip({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isActive,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
    VoidCallback? onClose,
  }) {
    final activeBg = colorScheme.surface;
    final inactiveBg = Colors.transparent;
    final activeTextColor = colorScheme.primary;
    final inactiveTextColor = colorScheme.onSurfaceVariant;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isActive ? activeBg : inactiveBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              isActive
                  ? colorScheme.primary.withOpacity(0.3)
                  : Colors.transparent,
          width: 1,
        ),
        boxShadow:
            isActive
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
                : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: isActive ? activeTextColor : inactiveTextColor,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? activeTextColor : inactiveTextColor,
                  ),
                ),
                if (onClose != null) ...[
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: onClose,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.close_rounded,
                        size: 15,
                        color:
                            isActive
                                ? activeTextColor.withOpacity(0.7)
                                : inactiveTextColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
