import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/core/router/routes_names.dart';

class SecuritySuccessPage extends ConsumerWidget {
  final Map<String, dynamic> data;
  const SecuritySuccessPage({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.colors(context);
    final title = data['title'] as String;
    final subtitle = data['subtitle'] as String;
    final isPassword = data['type'] == 'password';
    final fieldValue = data['value'] as String?;

    return AppScaffold(
      removeBodyPadding: true,
      hasAppBar: !isPassword,
      title: const Text(''),
      body: Padding(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        child: Column(
          mainAxisAlignment: isPassword ? MainAxisAlignment.center : MainAxisAlignment.start,
          crossAxisAlignment: isPassword ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            if (isPassword) ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.support.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle, size: 60, color: theme.support.green),
              ),
              SizedBox(height: context.figmaHeight(24)),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.interP22M.copyWith(color: theme.neutral.primaryText),
              ),
              SizedBox(height: context.figmaHeight(12)),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.interP14R.copyWith(color: theme.neutral.secondaryText),
              ),
            ] else ...[
              Text(
                title,
                style: AppTextStyles.interP18M.copyWith(color: theme.neutral.primaryText),
              ),
              SizedBox(height: context.figmaHeight(8)),
              Text(
                subtitle,
                style: AppTextStyles.interP14R.copyWith(color: theme.neutral.secondaryText),
              ),
              SizedBox(height: context.figmaHeight(32)),
              if (fieldValue != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.neutral.bgTint,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    fieldValue,
                    style: AppTextStyles.interP14M.copyWith(color: theme.neutral.primaryText),
                  ),
                ),
            ],
            const Spacer(),
            KElevatedButton(
              onPressed: () {
                context.go(AppRoutes.pharmacistSecurity);
              },
              child: const Text('Close'),
            ),
            SizedBox(height: context.figmaHeight(20)),
          ],
        ),
      ),
    );
  }
}
