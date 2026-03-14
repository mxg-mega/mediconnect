import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/router/k_navigate.dart';
import 'package:mediconnect/core/router/routes_names.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class SalesActivityCard extends StatelessWidget {
  const SalesActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales Activity (Today)',
            style: AppTextStyles.interP14M.copyWith(
              color: theme.neutral.primaryText,
            ),
          ),
          SizedBox(height: context.figmaHeight(8)),
          Text(
            '₦14,700.00',
            style: AppTextStyles.h2Sb.copyWith(
              color: theme.neutral.primaryText,
            ),
          ),
          SizedBox(height: context.figmaHeight(4)),
          Text(
            '12 items sold',
            style: AppTextStyles.interP12R.copyWith(
              color: theme.neutral.secondaryText,
            ),
          ),
          SizedBox(height: context.figmaHeight(16)),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    //Navigate to sales details page
                    pushTo(context, AppRoutes.dispenseEntry);
                  },
                  icon: SvgPicture.asset(
                    AppIcons.addMed,
                    colorFilter: ColorFilter.mode(
                      theme.neutral.buttonTextWhite,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: Text('New Dispense', style: AppTextStyles.interP14R),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.pharmacist.bg,
                    foregroundColor: theme.neutral.buttonTextWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        context.figmaWidth(8),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: context.figmaHeight(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: context.figmaWidth(8)),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    pushTo(context, AppRoutes.dispenseHistory);
                  },
                  icon: SvgPicture.asset(
                    AppIcons.history,
                    colorFilter: ColorFilter.mode(
                      theme.neutral.buttonTextWhite,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: Text(
                    'Dispense History',
                    style: AppTextStyles.interP14R,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.pharmacist.bg,
                    foregroundColor: theme.neutral.buttonTextWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        context.figmaWidth(8),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: context.figmaHeight(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
