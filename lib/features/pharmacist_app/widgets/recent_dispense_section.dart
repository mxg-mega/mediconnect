import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/dispense_record.dart';
import 'package:mediconnect/features/pharmacist_app/widgets/recent_dispense_card.dart';

class RecentDispenseSection extends StatelessWidget {
  const RecentDispenseSection({
    super.key,
    required this.records,
  });

  final List<DispenseRecord> records;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    final currencyFormat = NumberFormat.currency(
      symbol: '₦',
      decimalDigits: 0,
      locale: 'en_NG',
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.figmaWidth(16)),
      decoration: BoxDecoration(
        color: theme.neutral.buttonTextWhite,
        borderRadius: BorderRadius.circular(context.figmaWidth(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Dispense',
                  style: AppTextStyles.interP16M.copyWith(
                    color: theme.neutral.primaryText,
                  )),
              TextButton(
                onPressed: () {
                  context.push('/pharmacist/dispense-history');
                },
                child: Text(
                  'View all',
                  style: AppTextStyles.interP14M
                      .copyWith(color: theme.pharmacist.bg),
                ),
              ),
            ],
          ),
          SizedBox(height: context.figmaHeight(16)),
          if (records.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: context.figmaHeight(24)),
              child: Text(
                'No dispense records yet',
                style: AppTextStyles.interP14R.copyWith(
                  color: theme.neutral.secondaryText,
                ),
              ),
            )
          else
            ...records.map((record) {
              final dateFormat = DateFormat('MMM d, HH:mm:ss');

              // Build medication summary
              final medNames = record.items
                  .map((item) => '${item.medicationName} (${item.brandName})')
                  .toList();
              final displayMeds = medNames.isNotEmpty ? medNames.first : '';
              final moreCount = medNames.length > 1
                  ? ' + ${medNames.length - 1} more'
                  : '';

              return RecentDispenseCard(
                date: dateFormat.format(record.recordedAt),
                medications: displayMeds,
                moreCount: moreCount,
                details:
                    '${record.items.length} items • ${currencyFormat.format(record.totalAmount)}',
              );
            }),
        ],
      ),
    );
  }
}
