import 'package:flutter/material.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class LabeledInput extends StatelessWidget {
  final String label;
  final Widget child;
  final bool required;

  const LabeledInput({
    super.key,
    required this.label,
    required this.child,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTextStyles.interP14R.copyWith(
              color: AppTheme.colors(context).neutral.primaryText,
            ),
            children: [
              if (required)
                TextSpan(
                  text: ' *',
                  style: AppTextStyles.interP14R.copyWith(
                    color: AppTheme.colors(context).support.red,
                    overflow: TextOverflow.fade
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
