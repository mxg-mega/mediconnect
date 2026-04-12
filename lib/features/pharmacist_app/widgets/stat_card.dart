import 'package:flutter/material.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color backgroundColor;
  final Color valueColor;
  final Color subtitleColor;
  final Widget? valueSuffix;
  final bool arrowOnValueLine;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.backgroundColor,
    required this.valueColor,
    required this.subtitleColor,
    this.valueSuffix,
    this.arrowOnValueLine = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(context.figmaWidth(12)),
        decoration: BoxDecoration(
          color: backgroundColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(context.figmaWidth(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTextStyles.interP12R.copyWith(
                color: theme.neutral.primaryText,
              ),
            ),
            SizedBox(height: context.figmaHeight(8)),
            Row(
              children: [
                Text(
                  value,
                  style: AppTextStyles.interP24R.copyWith(
                    color: valueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (valueSuffix != null) ...[
                  SizedBox(width: context.figmaWidth(4)),
                  valueSuffix!,
                ],
                const Spacer(),
                if (arrowOnValueLine)
                  Icon(
                    Icons.arrow_forward,
                    size: context.figmaWidth(14),
                    color: theme.neutral.secondaryText,
                  ),
              ],
            ),
            SizedBox(height: context.figmaHeight(4)),
            Row(
              children: [
                Text(
                  subtitle,
                  style: AppTextStyles.interP12R.copyWith(color: subtitleColor),
                ),
                const Spacer(),
                if (!arrowOnValueLine)
                  Icon(
                    Icons.arrow_forward,
                    size: context.figmaWidth(14),
                    color: subtitleColor,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
