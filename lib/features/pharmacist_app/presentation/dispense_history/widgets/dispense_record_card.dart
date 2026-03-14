import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/dispense_record.dart';

class DispenseRecordCard extends StatelessWidget {
  final DispenseRecord record;
  final VoidCallback onTap;

  const DispenseRecordCard({
    super.key,
    required this.record,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    // Note: 'dth' is not standard, but the image shows "Jan 6th".
    // Manual formatting for 'st', 'nd', 'rd', 'th' might be needed if strictly following.
    // For simplicity, using a close format.

    final medsText = record.items
        .map(
          (e) => '${e.medicationName} ${e.isBrand ? '(${e.brandName})' : ''}',
        )
        .join(', ');
    final truncatedMedsText = medsText.length > 40
        ? '${medsText.substring(0, 37)}...'
        : medsText;

    final moreCount = record.items.length > 2 ? record.items.length - 2 : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: context.figmaHeight(16)),
        padding: EdgeInsets.all(context.figmaWidth(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(context.figmaWidth(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DISPENCE RECORD',
                  style: AppTextStyles.interP12M.copyWith(
                    color: theme.neutral.tertiaryText,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  DateFormat('MMM dth, HH:mm:ss')
                      .format(record.recordedAt)
                      .replaceAll('th', _getOrdinal(record.recordedAt.day)),
                  style: AppTextStyles.interP12R.copyWith(
                    color: theme.neutral.primaryText,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.figmaHeight(12)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(context.figmaWidth(8)),
                  decoration: BoxDecoration(
                    color: theme.neutral.bgTint,
                    borderRadius: BorderRadius.circular(context.figmaWidth(8)),
                  ),
                  child: SvgPicture.asset(
                    AppIcons.file,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      theme.neutral.bg,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: context.figmaWidth(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        truncatedMedsText,
                        style: AppTextStyles.interP14M.copyWith(
                          color: theme.neutral.primaryText,
                        ),
                      ),
                      if (moreCount > 0)
                        Text(
                          '+ $moreCount more',
                          style: AppTextStyles.interP12R.copyWith(
                            color: theme.pharmacist.bg,
                          ),
                        ),
                      SizedBox(height: context.figmaHeight(8)),
                      Text(
                        '${record.items.length} items • ₦${NumberFormat('#,###').format(record.totalAmount)}',
                        style: AppTextStyles.interP12R.copyWith(
                          color: theme.neutral.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getOrdinal(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
