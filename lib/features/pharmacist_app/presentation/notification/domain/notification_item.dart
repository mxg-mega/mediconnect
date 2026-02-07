import 'package:flutter/material.dart';

enum NotificationType {
  lowStock,
  newReview,
  expiringSoon,
  licenseApproved,
  security,
}

class NotificationItem {
  final String title;
  final String subtitle;
  final String timeAgo;
  final NotificationType type;
  final DateTime date;

  NotificationItem({
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.type,
    required this.date,
  });

  IconData get icon {
    switch (type) {
      case NotificationType.lowStock:
        return Icons.warning_amber_rounded;
      case NotificationType.newReview:
        return Icons.star_border_rounded;
      case NotificationType.expiringSoon:
        return Icons.hourglass_empty_rounded;
      case NotificationType.licenseApproved:
        return Icons.check_circle_outline_rounded;
      case NotificationType.security:
        return Icons.shield_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  Color get iconBackgroundColor {
    switch (type) {
      case NotificationType.lowStock:
        return Colors.red.shade100;
      case NotificationType.newReview:
        return Colors.yellow.shade100;
      case NotificationType.expiringSoon:
        return Colors.blue.shade100;
      case NotificationType.licenseApproved:
        return Colors.green.shade100;
      case NotificationType.security:
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

    Color get iconColor {
    switch (type) {
      case NotificationType.lowStock:
        return Colors.red;
      case NotificationType.newReview:
        return Colors.yellow;
      case NotificationType.expiringSoon:
        return Colors.blue;
      case NotificationType.licenseApproved:
        return Colors.green;
      case NotificationType.security:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
