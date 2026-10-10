import 'package:flutter/material.dart';

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
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        // color: colorScheme.surfaceVariant,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline, width: 1),
        ),
      ),
      child: Row(
        children: [
          _toolbarButton(
            label: title,
            isActive: !showForm,
            onTap: onHideForm,
            icon: Icons.list_alt,
            colorScheme: colorScheme,
          ),
          const SizedBox(width: 8),
          _toolbarButton(
            label: formTitle,
            isActive: showForm,
            onTap: onFormTap,
            icon: Icons.edit,
            colorScheme: colorScheme,
            trailing:
                showForm
                    ? IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 18,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onCloseForm,
                    )
                    : null,
          ),
        ],
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
