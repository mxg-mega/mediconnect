import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class RecentDispenseCard extends StatelessWidget {
  final String date;
  final String medications;
  final String moreCount;
  final String details;

  const RecentDispenseCard({
    super.key,
    required this.date,
    required this.medications,
    required this.moreCount,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    return Padding(
      padding: EdgeInsets.only(bottom: context.figmaHeight(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DISPENCE RECORD',
                style: AppTextStyles.interP12M
                    .copyWith(color: theme.neutral.secondaryText),
              ),
              Text(
                date,
                style: AppTextStyles.interP12M
                    .copyWith(color: theme.neutral.secondaryText),
              ),
            ],
          ),
          SizedBox(height: context.figmaHeight(8)),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.figmaWidth(12)),
                decoration: BoxDecoration(
                  color: theme.neutral.placeholderDisabled,
                  borderRadius: BorderRadius.circular(context.figmaWidth(8)),
                ),
                child: SvgPicture.asset(
                  AppIcons.receipt,
                  width: context.figmaWidth(24),
                  height: context.figmaHeight(24),
                  colorFilter: ColorFilter.mode(
                      theme.neutral.secondaryText, BlendMode.srcIn),
                ),
              ),
              SizedBox(width: context.figmaWidth(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: AppTextStyles.interP14R
                            .copyWith(color: theme.neutral.primaryText),
                        children: [
                          TextSpan(text: medications),
                          TextSpan(
                            text: moreCount,
                            style: AppTextStyles.interP14R.copyWith(
                                color: theme.neutral.secondaryText),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.figmaHeight(4)),
                    Text(
                      details,
                      style: AppTextStyles.interP12R
                          .copyWith(color: theme.neutral.secondaryText),
                    ),
                  ],
                ),
              )
            ],
          ),
          if (moreCount.isNotEmpty) ...[
            SizedBox(height: context.figmaHeight(16)),
            const Divider(),
          ]
        ],
      ),
    );
  }
}
