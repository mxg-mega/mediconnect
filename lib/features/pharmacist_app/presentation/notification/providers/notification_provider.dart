import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/notification/domain/notification_item.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, List<NotificationItem>>((ref) {
  return NotificationNotifier();
});

class NotificationNotifier extends StateNotifier<List<NotificationItem>> {
  NotificationNotifier() : super([]) {
    _loadInitialData();
  }

  void _loadInitialData() {
    state = [
      NotificationItem(
        title: 'Paracetamol running low',
        subtitle: 'Quantity: 4 left',
        timeAgo: '1h',
        type: NotificationType.lowStock,
        date: DateTime.now(),
      ),
      NotificationItem(
        title: 'New Review',
        subtitle: 'Jane Doe left a 4-star review. View conversation.',
        timeAgo: '2h',
        type: NotificationType.newReview,
        date: DateTime.now(),
      ),
      NotificationItem(
        title: 'Ibuprofen batch expiring soon',
        subtitle: 'Expires in 3 days',
        timeAgo: '2h',
        type: NotificationType.expiringSoon,
        date: DateTime.now(),
      ),
      NotificationItem(
        title: 'New Review',
        subtitle: 'John Doe left a 3-star review. View conversation.',
        timeAgo: '1d',
        type: NotificationType.newReview,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationItem(
        title: 'Amoxil running low',
        subtitle: 'Quantity: 4 left',
        timeAgo: '1d',
        type: NotificationType.lowStock,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationItem(
        title: 'Pharmacy license approved',
        subtitle: 'Your Pharmacy license have been approved',
        timeAgo: '2d',
        type: NotificationType.licenseApproved,
        date: DateTime(2025, 6, 12),
      ),
       NotificationItem(
        title: 'Account Security / OTP Notification',
        subtitle: 'Your login code is 123456 (expires in 5 minutes). Do not share this code.',
        timeAgo: '2d',
        type: NotificationType.security,
        date: DateTime(2025, 6, 12),
      ),
    ];
  }

  void markAllAsRead() {
    state = [];
  }
}
