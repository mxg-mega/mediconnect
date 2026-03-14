import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/widgets/code_input_field.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/router/routes_names.dart';

class CodeVerificationPage extends StatelessWidget {
  const CodeVerificationPage({super.key, required this.nextPage});

  final Widget nextPage;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.colors(context);

    return AppScaffold(
      onBack: () => context.pop(),
      body: Column(
        children: [
          Text(
            'Enter Verification Code',
            style: AppTextStyles.inter32M.copyWith(fontSize: 24),
          ),
          Text(
            'Please enter the code we sent to your email to verify your account.',
            style: AppTextStyles.interP16R,
          ),

          CodeInputField(
            onCompleted: (code) {
              // In a real app, verify code then navigate
              context.push(AppRoutes.setupFinalization);
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'You can resend code in ',
                style: AppTextStyles.interP14R.copyWith(
                  color: appTheme.neutral.border,
                ),
              ),
              Text(
                '59',
                style: AppTextStyles.interP14R.copyWith(
                  color: appTheme.support.red,
                ),
              ),
              Text(
                ' seconds',
                style: AppTextStyles.interP14R.copyWith(
                  color: appTheme.neutral.border,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Resend Code',
              style: AppTextStyles.interP14R.copyWith(
                color: appTheme.support.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
