import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/router/k_navigate.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dashboard/dashboard_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_entry/pages/dispense_entry_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/notification/notification_page.dart';
import 'package:mediconnect/features/pharmacist_app/widgets/recent_dispense_section.dart';
import 'package:mediconnect/features/pharmacist_app/widgets/sales_activity_card.dart';
import 'package:mediconnect/features/pharmacist_app/widgets/stat_card.dart';

class PharmacistDashboard extends ConsumerWidget {
  const PharmacistDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.colors(context);
    final authState = ref.watch(authProvider);
    final dashboard = ref.watch(dashboardProvider);

    final userName = authState.user?.firstName ?? 'Pharmacist';

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.figmaWidth(16),
                vertical: context.figmaHeight(20),
              ),
              decoration: BoxDecoration(
                color: theme.pharmacist.bg,
                borderRadius: BorderRadius.circular(context.figmaWidth(20)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: context.figmaWidth(24),
                            backgroundColor: Colors.blue.shade50.withValues(
                              alpha: 0.2,
                            ),
                            child: SvgPicture.asset(
                              AppIcons.profile,
                              width: context.figmaWidth(28),
                              height: context.figmaHeight(28),
                              colorFilter: ColorFilter.mode(
                                theme.neutral.buttonTextWhite,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: SvgPicture.asset(
                              AppIcons.approved_badge,
                              width: context.figmaWidth(20),
                              height: context.figmaHeight(20),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: context.figmaWidth(12)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, $userName',
                            style: AppTextStyles.p14Sm.copyWith(
                              color: theme.neutral.buttonTextWhite,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'How are you today?',
                            style: AppTextStyles.interP12R.copyWith(
                              color: theme.neutral.buttonTextWhite.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => navigateToPage(context, const NotificationPage()),
                        child: SvgPicture.asset(
                          AppIcons.notification_bell_available,
                          width: context.figmaWidth(24),
                          height: context.figmaHeight(24),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.figmaHeight(20)),
                  SearchBar(
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SvgPicture.asset(
                        AppIcons.search,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                          theme.neutral.secondaryText,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    hintText: 'Search Medications by name...',
                    hintStyle: WidgetStateProperty.all(
                      AppTextStyles.interP14R.copyWith(
                        color: theme.neutral.secondaryText,
                      ),
                    ),
                    onChanged: (value) {},
                    trailing: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          AppIcons.filter,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                            theme.neutral.secondaryText,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                    backgroundColor: WidgetStateProperty.all(
                      theme.neutral.buttonTextWhite,
                    ),
                    elevation: WidgetStateProperty.all(0),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.figmaHeight(24)),

            // Sales Activity
            SalesActivityCard(
              totalSales: dashboard.todaySalesTotal,
              itemsSold: dashboard.todayItemsSold,
            ),
            SizedBox(height: context.figmaHeight(24)),

            // Stats Grid
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StatCard(
                    title: 'Average Rating',
                    value: dashboard.averageRating.toStringAsFixed(1),
                    subtitle: 'Inventory',
                    backgroundColor: theme.support.yellow,
                    valueColor: theme.neutral.primaryText,
                    subtitleColor: theme.neutral.secondaryText,
                    valueSuffix: SvgPicture.asset(
                      AppIcons.star,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                        theme.support.yellow,
                        BlendMode.srcIn,
                      ),
                    ),
                    arrowOnValueLine: true,
                  ),
                  SizedBox(width: context.figmaWidth(16)),
                  StatCard(
                    title: 'Total SKUs',
                    value: _formatNumber(dashboard.totalSkus),
                    subtitle: 'Inventory',
                    backgroundColor: theme.support.blue,
                    valueColor: theme.support.blue,
                    subtitleColor: theme.support.blue,
                    arrowOnValueLine: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.figmaHeight(16)),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StatCard(
                    title: 'Low Stock',
                    value: dashboard.lowStockCount.toString(),
                    subtitle: 'Needs attention',
                    backgroundColor: theme.support.red,
                    valueColor: theme.support.red,
                    subtitleColor: theme.support.red,
                  ),
                  SizedBox(width: context.figmaWidth(16)),
                  StatCard(
                    title: 'Expiring',
                    value: dashboard.expiringCount.toString(),
                    subtitle: 'Within 30 days',
                    backgroundColor: theme.support.orange,
                    valueColor: theme.support.orange,
                    subtitleColor: theme.support.orange,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.figmaHeight(24)),

            // Recent Dispense
            RecentDispenseSection(
              records: dashboard.recentDispenses,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.pharmacist.bg,
        shape: const CircleBorder(),
        onPressed: () {
          navigateToPage(context, const DispenseEntryPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)},${(number % 1000).toString().padLeft(3, '0')}';
    }
    return number.toString();
  }
}
