import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/widgets/window_buttons.dart';

class StockTransactionTabs extends StatelessWidget {
  const StockTransactionTabs({
    super.key,
    required this.onFormTap,
    required this.onHideForm,
    required this.onCloseForm,
    required this.showForm,
    required this.title,
    required this.formTitle,
  });

  final VoidCallback onFormTap;
  final VoidCallback onHideForm;
  final VoidCallback onCloseForm;
  final bool showForm;
  final String title;
  final String formTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outline, width: 1),
        ),
      ),
      child: Stack(
        children: [
          // 1. MoveWindow fills background to allow dragging the window
          Positioned.fill(child: MoveWindow()),

          // 2. Interactive tab content placed on top of MoveWindow
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Main List Tab
                        _buildTabChip(
                          context: context,
                          label: title,
                          icon: Icons.list_alt,
                          isActive: !showForm,
                          colorScheme: colorScheme,
                          onTap: onHideForm,
                        ),

                        // Active Form Tab
                        _buildTabChip(
                          context: context,
                          label: formTitle,
                          icon: Icons.shopping_bag_outlined,
                          isActive: showForm,
                          colorScheme: colorScheme,
                          onTap: onFormTap,
                          onClose: showForm ? onCloseForm : null,
                        ),
                      ],
                    ),
                  ),
                ),
                WindowButtons(homeController: Get.find<HomeController>()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isActive,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
    VoidCallback? onClose,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color:
                  isActive
                      ? colorScheme.primary.withOpacity(0.15)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    isActive
                        ? colorScheme.primary
                        : colorScheme.outline.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color:
                      isActive
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color:
                        isActive
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                  ),
                ),
                if (onClose != null) ...[
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: onClose,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: colorScheme.primary,
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
