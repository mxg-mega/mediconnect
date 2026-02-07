import 'package:flutter/material.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/notification/domain/notification_item.dart';

class NotificationListItem extends StatelessWidget {
  const NotificationListItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: item.iconBackgroundColor,
        child: Icon(
          item.icon,
          color: item.iconColor,
        ),
      ),
      title: Text(
        item.title,
        style: AppTextStyles.interP16M,
      ),
      subtitle: Text(
        item.subtitle,
        style: AppTextStyles.interP14R,
      ),
      trailing: Text(
        item.timeAgo,
        style: AppTextStyles.interP12R,
      ),
    );
  }
}
