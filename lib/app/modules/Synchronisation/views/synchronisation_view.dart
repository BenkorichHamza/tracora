import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/sync_operation.dart';
import 'package:tracora/app/data/repositories/sync_repository.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/modules/Synchronisation/controllers/synchronisation_controller.dart';

class SynchronisationView extends GetView<SynchronisationController> {
  const SynchronisationView({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalScrollController = ScrollController();
    final homeController = Get.find<HomeController>();

    return Obx(() {
      // Rebuilds when homeController.theme changes
      final _ = homeController.theme;
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Synchronization Center',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(color: theme.dividerColor, height: 1.0),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () {
                SyncRepository().stockBalance(0);
              },
            ),
          ],
        ),
        body: Obx(() {
          final groupedData = controller.groupedPendingOperations;

          if (groupedData.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_done_outlined,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'All synchronized!',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'There are no pending changes at this time.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return Scrollbar(
            controller: horizontalScrollController,
            thumbVisibility: true,
            trackVisibility: true,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
              ),
              child: ListView.builder(
                controller: horizontalScrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(24),
                itemCount: groupedData.keys.length,
                itemBuilder: (context, index) {
                  final tableName = groupedData.keys.elementAt(index);
                  final operations = groupedData[tableName]!;

                  return TableGroupCard(
                    tableName: tableName,
                    operations: operations,
                  );
                },
              ),
            ),
          );
        }),
      );
    });
  }
}

class TableGroupCard extends StatelessWidget {
  final String tableName;
  final List<SyncOperation> operations;

  const TableGroupCard({
    super.key,
    required this.tableName,
    required this.operations,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 1200,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(11),
              ),
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.table_chart_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tableName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${operations.length}',
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Operations List inside Card
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: operations.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final op = operations[index];
                return OperationItemTile(operation: op);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OperationItemTile extends StatelessWidget {
  final SyncOperation operation;

  const OperationItemTile({super.key, required this.operation});

  Color _getOperationColor(String? op, ColorScheme colorScheme) {
    switch (op?.toUpperCase()) {
      case 'INSERT':
      case 'CREATE':
        return colorScheme.primary;
      case 'UPDATE':
        return colorScheme.tertiary;
      case 'DELETE':
        return colorScheme.error;
      default:
        return colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final opType = operation.operation?.toUpperCase() ?? 'UNKNOWN';
    final badgeColor = _getOperationColor(opType, colorScheme);
    final hasError =
        operation.lastError != null && operation.lastError!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasError ? colorScheme.error : theme.dividerColor,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  opType,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'CREATED: ${operation.createdAt.formatDateTime() ?? "N/A"} / ${operation.createdAt ?? "N/A"}',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (operation.data != null && operation.data!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                operation.data!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
          if (hasError) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.error_outline, size: 14, color: colorScheme.error),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    operation.lastError!,
                    style: TextStyle(color: colorScheme.error, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
