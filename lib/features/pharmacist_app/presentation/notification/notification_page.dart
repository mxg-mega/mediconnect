import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/k_navigate.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/notification/domain/notification_item.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/notification/providers/notification_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/notification/widgets/notification_list_item.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);

    return AppScaffold(
      title: Text(
        'Notification',
        style: AppTextStyles.interP18M,
        textAlign: TextAlign.center,
      ),
      onBack: () => navigateBack(context),
      scaffoldActions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: SvgPicture.asset(
            AppIcons.filter3,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              AppTheme.colors(context).neutral.primaryText,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
      body: notifications.isEmpty
          ? _buildEmptyState(context)
          : _buildNotificationList(context, notifications, ref),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/Push notifications-bro 1.svg',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 24),
          Text('No New Notifications', style: AppTextStyles.interP18M),
        ],
      ),
    );
  }

  Widget _buildNotificationList(
    BuildContext context,
    List<NotificationItem> notifications,
    WidgetRef ref,
  ) {
    final groupedNotifications = _groupNotificationsByDate(notifications);
    final dateSections = groupedNotifications.keys.toList();

    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //   child: Align(
        //     alignment: Alignment.centerRight,
        //     child: TextButton(
        //       onPressed: () {
        //         ref.read(notificationProvider.notifier).markAllAsRead();
        //       },
        //       child: const Text('Mark all as read'),
        //     ),
        //   ),
        // ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: dateSections.length,
            itemBuilder: (context, index) {
              final dateSection = dateSections[index];
              final items = groupedNotifications[dateSection]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    child: dateSection == 'Today'
                        ? Row(
                            children: [
                              Text(dateSection, style: AppTextStyles.h4Sb),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(notificationProvider.notifier)
                                      .markAllAsRead();
                                },
                                child: Text(
                                  'Mark all as read',
                                  style: AppTextStyles.interP14R.copyWith(
                                    color: AppTheme.colors(context).support.red,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Text(dateSection, style: AppTextStyles.h4Sb),
                  ),
                  ...items.map((item) => NotificationListItem(item: item)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Map<String, List<NotificationItem>> _groupNotificationsByDate(
    List<NotificationItem> notifications,
  ) {
    final grouped = <String, List<NotificationItem>>{};
    for (final item in notifications) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final itemDate = DateTime(item.date.year, item.date.month, item.date.day);

      String dateSection;
      if (itemDate == today) {
        dateSection = 'Today';
      } else if (itemDate == yesterday) {
        dateSection = 'Yesterday';
      } else {
        dateSection = DateFormat('MMM d, yyyy').format(item.date);
      }

      if (grouped[dateSection] == null) {
        grouped[dateSection] = [];
      }
      grouped[dateSection]!.add(item);
    }
    return grouped;
  }
}
