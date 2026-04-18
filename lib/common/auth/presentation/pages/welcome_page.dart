import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/logo.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.colors(context);
    final user = ref.watch(currentUserProvider);

    return AppScaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(context.figmaWidth(24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: context.figmaHeight(120),
                width: context.figmaWidth(120),
                decoration: BoxDecoration(
                  color: user?.userType == UserType.patient
                      ? theme.patient.bg.withValues(alpha: 0.1)
                      : theme.pharmacist.bg.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Logo()),
              ),
              SizedBox(height: context.figmaHeight(32)),
              Text(
                'Account Setup Complete!',
                textAlign: TextAlign.center,
                style: AppTextStyles.inter24M.copyWith(
                  color: theme.neutral.primaryText,
                ),
              ),
              SizedBox(height: context.figmaHeight(16)),
              Text(
                'Welcome to Medconnect, ${user?.firstName ?? 'User'}. Your account is ready. You can now access your dashboard.',
                textAlign: TextAlign.center,
                style: AppTextStyles.interP16R.copyWith(
                  color: theme.neutral.secondaryText,
                ),
              ),
              const Spacer(),
              KElevatedButton(
                onPressed: () {
                  if (user?.userType == UserType.patient) {
                    context.go('/patient/dashboard');
                  } else {
                    context.go('/pharmacist/dashboard');
                  }
                },
                child: const Text('Go to Dashboard'),
              ),
              SizedBox(height: context.figmaHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}
