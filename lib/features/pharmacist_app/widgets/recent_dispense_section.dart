import 'package:flutter/material.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/widgets/recent_dispense_card.dart';

class RecentDispenseSection extends StatelessWidget {
  const RecentDispenseSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.figmaWidth(16)),
      decoration: BoxDecoration(
        color: theme.neutral.buttonTextWhite,
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Dispense',
                  style: AppTextStyles.interP16M.copyWith(
                    color: theme.neutral.primaryText,
                  )),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View all',
                  style: AppTextStyles.interP14M
                      .copyWith(color: theme.pharmacist.bg),
                ),
              ),
            ],
          ),
          SizedBox(height: context.figmaHeight(16)),
          const RecentDispenseCard(
            date: 'Jan 6th, 20:47:10',
            medications: 'Amoxicillin 500 mg (GSK), Ibupr...',
            moreCount: ' + 1 more',
            details: '3 items • ₦8, 500',
          ),
          const RecentDispenseCard(
            date: 'Jan 6th, 19:03:40',
            medications: 'Panadol 500 mg (GSK), Metformi...',
            moreCount: ' + 1 more',
            details: '3 items • ₦4, 700',
          ),
          const RecentDispenseCard(
            date: 'Jan 6th, 15:24:00',
            medications: 'Another medication, something else',
            moreCount: '', // No "more" here to not show divider
            details: '1 item • ₦1, 200',
          ),
        ],
      ),
    );
  }
}
