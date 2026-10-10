import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/synchronisation_controller.dart';

class SynchronisationStateView extends GetView<SynchronisationController> {
  const SynchronisationStateView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final syncing = controller.syncing;
      final operations = controller.operationsLength;

      // Color logic: Green when synced (0 ops), Red when pending ops exist
      final isSynced = operations == 0;
      final statusColor =
          isSynced ? const Color(0xFF10B981) : const Color(0xFFEF4444);

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: statusColor.withOpacity(0.25), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Fixed-size Status Container (Prevents icon jump) ---
            SizedBox(
              width: 18,
              height: 18,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child:
                      syncing
                          ? SizedBox(
                            key: const ValueKey('loader'),
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                statusColor,
                              ),
                            ),
                          )
                          : _StatusBulb(
                            key: ValueKey('bulb_$isSynced'),
                            color: statusColor,
                          ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // --- Fixed Width Text Container (Prevents text label jump) ---
            SizedBox(
              width:
                  80, // Fixed width prevents width shifts when switching text
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    syncing
                        ? 'Synchronizing...'
                        : (isSynced ? 'Up to date' : 'Sync Required'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$operations pending op${operations == 1 ? '' : 's'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: theme.textTheme.bodySmall?.color?.withOpacity(
                        0.65,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // --- Fixed Size Action Button ---
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: syncing ? null : controller.sync,
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 76, // Fixed width for "Sync" vs "Syncing" state
                  height: 30, // Fixed height
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        syncing
                            ? theme.disabledColor.withOpacity(0.1)
                            : statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sync_rounded,
                        size: 15,
                        color: syncing ? theme.disabledColor : statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Sync',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: syncing ? theme.disabledColor : statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _StatusBulb extends StatelessWidget {
  final Color color;

  const _StatusBulb({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
