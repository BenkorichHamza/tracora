import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/widgets/window_buttons.dart';
import '../controllers/statistic_controller.dart';

class StatisticView extends GetView<StatisticController> {
  const StatisticView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedTab = 0.obs;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF030712) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 45,
              child: MoveWindow(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    WindowButtons(homeController: Get.find<HomeController>()),
                  ],
                ),
              ),
            ),
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Header Bar & Dynamic Segmented Switcher
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'statistics'.tr,
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -1.2,
                                      color:
                                          isDark
                                              ? Colors.white
                                              : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF10B981),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Live Business Insights',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              isDark
                                                  ? const Color(0xFF94A3B8)
                                                  : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  _AnimatedPressScale(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      controller.loadStatistics();
                                    },
                                    child: _HeaderIconButton(
                                      icon: LucideIcons.refreshCw,
                                      isDark: isDark,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Obx(
                                    () => _AnimatedPressScale(
                                      onTap: () async {
                                        HapticFeedback.lightImpact();
                                        final primaryColor =
                                            Theme.of(context).primaryColor;
                                        final isDark =
                                            Theme.of(context).brightness ==
                                            Brightness.dark;

                                        final DateTimeRange?
                                        picked = await showDateRangePicker(
                                          context: context,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime.now().add(
                                            const Duration(days: 1),
                                          ),
                                          initialDateRange:
                                              controller.from == 0
                                                  ? null
                                                  : DateTimeRange(
                                                    start:
                                                        controller.from
                                                            .toDatetime()!,
                                                    end: controller.to
                                                        .toDatetime()!
                                                        .subtract(
                                                          const Duration(
                                                            days: 1,
                                                          ),
                                                        ),
                                                  ),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme:
                                                    isDark
                                                        ? ColorScheme.dark(
                                                          primary: primaryColor,
                                                          onPrimary:
                                                              Colors.white,
                                                          surface: const Color(
                                                            0xFF1E293B,
                                                          ), // Modern slate-800
                                                          onSurface:
                                                              const Color(
                                                                0xFFF8FAFC,
                                                              ),
                                                          surfaceContainerHigh:
                                                              const Color(
                                                                0xFF334155,
                                                              ),
                                                        )
                                                        : ColorScheme.light(
                                                          primary: primaryColor,
                                                          onPrimary:
                                                              Colors.white,
                                                          surface: Colors.white,
                                                          onSurface: const Color(
                                                            0xFF0F172A,
                                                          ), // Modern slate-900
                                                          surfaceContainerHigh:
                                                              const Color(
                                                                0xFFF1F5F9,
                                                              ),
                                                        ),
                                                datePickerTheme: DatePickerThemeData(
                                                  headerBackgroundColor:
                                                      primaryColor,
                                                  headerForegroundColor:
                                                      Colors.white,
                                                  backgroundColor:
                                                      isDark
                                                          ? const Color(
                                                            0xFF0F172A,
                                                          )
                                                          : Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          24,
                                                        ),
                                                  ),
                                                  rangePickerShape:
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              24,
                                                            ),
                                                      ),
                                                  dayStyle: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  rangeSelectionBackgroundColor:
                                                      primaryColor.withOpacity(
                                                        0.15,
                                                      ),
                                                  rangeSelectionOverlayColor:
                                                      WidgetStateProperty.all(
                                                        primaryColor
                                                            .withOpacity(0.1),
                                                      ),
                                                ),
                                              ),
                                              child: Center(
                                                child: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                        maxWidth: 520,
                                                        maxHeight: 680,
                                                      ),
                                                  child: child!,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                        if (picked != null) {
                                          controller.from =
                                              picked
                                                  .start
                                                  .millisecondsSinceEpoch;
                                          controller.to =
                                              picked.end
                                                  .add(const Duration(days: 1))
                                                  .millisecondsSinceEpoch;
                                          controller.loadStatistics();
                                        }
                                      },
                                      child: _DateRangeFilterChip(
                                        from: controller.from,
                                        to: controller.to,
                                        isDark: isDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Custom Glassmorphic Segmented Switcher
                          Obx(
                            () => Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color:
                                    isDark
                                        ? const Color(0xFF111827)
                                        : const Color(0xFFE2E8F0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  _TabButton(
                                    title: 'Financial Metrics',
                                    icon: LucideIcons.lineChart,
                                    isSelected: selectedTab.value == 0,
                                    isDark: isDark,
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      selectedTab.value = 0;
                                    },
                                  ),
                                  _TabButton(
                                    title: 'Entity Analytics',
                                    icon: LucideIcons.layoutGrid,
                                    isSelected: selectedTab.value == 1,
                                    isDark: isDark,
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      selectedTab.value = 1;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Dashboard Main Body
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    sliver: SliverToBoxAdapter(
                      child: Obx(() {
                        final stats = controller.statistics;

                        if (selectedTab.value == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              // Hero Revenue Banner
                              _MasterExecutiveCard(
                                totalSale: stats.totalSale.formatNumber(),
                                totalPurchase:
                                    stats.totalPurchase.formatPrice(),
                                totalFees: stats.totalFeesPayment.formatPrice(),
                                isDark: isDark,
                              ),
                              const SizedBox(height: 24),

                              // Section 1: Inflow vs Outflow
                              _SectionHeader(
                                title: 'CASHFLOW INSIGHTS',
                                isDark: isDark,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _AuraStatCard(
                                      title: 'Customer Payments',
                                      value:
                                          stats.totalCustomerPayment
                                              ?.formatPrice(),
                                      subtitle: 'Inflow',
                                      icon: LucideIcons.arrowDownLeft,
                                      glowColor: const Color(0xFF10B981),
                                      isDark: isDark,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _AuraStatCard(
                                      title: 'Supplier Payments',
                                      value:
                                          stats.totalSupplierPayment
                                              .formatPrice(),
                                      subtitle: 'Outflow',
                                      icon: LucideIcons.arrowUpRight,
                                      glowColor: const Color(0xFFF59E0B),
                                      isDark: isDark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Section 2: Receivables & Payables
                              Row(
                                children: [
                                  Expanded(
                                    child: _AuraStatCard(
                                      title: 'Customer Credit',
                                      value:
                                          stats.totalCustomerCredit
                                              .formatPrice(),
                                      subtitle: 'Receivable',
                                      icon: LucideIcons.userCheck,
                                      glowColor: const Color(0xFF6366F1),
                                      isDark: isDark,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _AuraStatCard(
                                      title: 'Supplier Credit',
                                      value:
                                          stats.totalSupplierCredit
                                              .formatPrice(),
                                      subtitle: 'Payable',
                                      icon: LucideIcons.userX,
                                      glowColor: const Color(0xFFEF4444),
                                      isDark: isDark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Section 3: Ratio Indicator Card
                              _VolumeBreakdownCard(
                                salesPayment:
                                    stats.totalSalePayment?.formatPrice() ??
                                    '0',
                                purchasePayment:
                                    stats.totalPurchasePayment.formatPrice(),
                                saleCount:
                                    stats.saleCount?.formatNumber() ?? '0',
                                purchaseCount:
                                    stats.purchaseCount?.formatNumber() ?? '0',
                                isDark: isDark,
                              ),
                              const SizedBox(height: 32),
                            ],
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              _SectionHeader(
                                title: 'TRANSACTION ACTIVITY',
                                isDark: isDark,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _MetricSquareTile(
                                      label: 'Sales Orders',
                                      count: stats.saleCount?.formatNumber(),
                                      icon: LucideIcons.shoppingBag,
                                      color: const Color(0xFF10B981),
                                      isDark: isDark,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _MetricSquareTile(
                                      label: 'Purchases',
                                      count:
                                          stats.purchaseCount?.formatNumber(),
                                      icon: LucideIcons.truck,
                                      color: const Color(0xFFF59E0B),
                                      isDark: isDark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              _SectionHeader(
                                title: 'SYSTEM DIRECTORY',
                                isDark: isDark,
                              ),
                              const SizedBox(height: 12),
                              _DirectoryRowItem(
                                title: 'Products Stocked',
                                value: stats.productCount?.formatNumber(),
                                icon: LucideIcons.package,
                                accentColor: const Color(0xFF0EA5E9),
                                isDark: isDark,
                              ),
                              const SizedBox(height: 10),
                              _DirectoryRowItem(
                                title: 'Active Customers',
                                value: stats.customerCount?.formatNumber(),
                                icon: LucideIcons.users,
                                accentColor: const Color(0xFF8B5CF6),
                                isDark: isDark,
                              ),
                              const SizedBox(height: 10),
                              _DirectoryRowItem(
                                title: 'Registered Suppliers',
                                value: stats.supplierCount?.formatNumber(),
                                icon: LucideIcons.building2,
                                accentColor: const Color(0xFFEC4899),
                                isDark: isDark,
                              ),
                              const SizedBox(height: 32),
                            ],
                          );
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// --- UI COMPONENTS & INTERACTION WIDGETS ---
// ============================================================================

class _AnimatedPressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _AnimatedPressScale({required this.child, required this.onTap});

  @override
  State<_AnimatedPressScale> createState() => _AnimatedPressScaleState();
}

class _AnimatedPressScaleState extends State<_AnimatedPressScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

class _MasterExecutiveCard extends StatelessWidget {
  final String totalSale;
  final String totalPurchase;
  final String totalFees;
  final bool isDark;

  const _MasterExecutiveCard({
    required this.totalSale,
    required this.totalPurchase,
    required this.totalFees,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF312E81)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF312E81).withOpacity(0.4),
            blurRadius: 28,
            offset: const Offset(0, 12),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      LucideIcons.sparkles,
                      size: 12,
                      color: Colors.amberAccent,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'GROSS REVENUE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.trendingUp,
                  size: 18,
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FittedBox(
            child: Text(
              totalSale,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withOpacity(0.10)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Purchases',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        totalPurchase,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 28, width: 1, color: Colors.white12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Fees',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          totalFees,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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

class _AuraStatCard extends StatelessWidget {
  final String title;
  final String? value;
  final String subtitle;
  final IconData icon;
  final Color glowColor;
  final bool isDark;

  const _AuraStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.glowColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(isDark ? 0.08 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: glowColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 18, color: glowColor),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: glowColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VolumeBreakdownCard extends StatelessWidget {
  final String salesPayment;
  final String purchasePayment;
  final String saleCount;
  final String purchaseCount;
  final bool isDark;

  const _VolumeBreakdownCard({
    required this.salesPayment,
    required this.purchasePayment,
    required this.saleCount,
    required this.purchaseCount,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PAYMENT DISTRIBUTION RATIO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color:
                      isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                ),
              ),
              Icon(
                LucideIcons.percent,
                size: 16,
                color:
                    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sales Payments ($saleCount)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                salesPayment,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.72,
              minHeight: 10,
              backgroundColor: Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Purchase Payments ($purchaseCount)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                purchasePayment,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFF97316),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.42,
              minHeight: 10,
              backgroundColor: Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF97316)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricSquareTile extends StatelessWidget {
  final String label;
  final String? count;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _MetricSquareTile({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 18),
          Text(
            count ?? '0',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectoryRowItem extends StatelessWidget {
  final String title;
  final String? value;
  final IconData icon;
  final Color accentColor;
  final bool isDark;

  const _DirectoryRowItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 18, color: accentColor),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const Spacer(),
          Text(
            value ?? '0',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4,
        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? (isDark ? const Color(0xFF1E293B) : Colors.white)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                    : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color:
                    isSelected
                        ? (isDark ? Colors.white : const Color(0xFF0F172A))
                        : (isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8)),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color:
                      isSelected
                          ? (isDark ? Colors.white : const Color(0xFF0F172A))
                          : (isDark
                              ? const Color(0xFF64748B)
                              : const Color(0xFF94A3B8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final bool isDark;

  const _HeaderIconButton({required this.icon, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Icon(
        icon,
        size: 18,
        color: isDark ? Colors.white : const Color(0xFF0F172A),
      ),
    );
  }
}

class _DateRangeFilterChip extends StatelessWidget {
  final int from;
  final int to;
  final bool isDark;

  const _DateRangeFilterChip({
    required this.from,
    required this.to,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.calendar,
            size: 16,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            from == 0
                ? 'Filter'
                : '${from.formatDate()!} - ${to.formatDate()!}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
