import 'package:flutter/material.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final appTheme = AppTheme.colors(context);

    return AppScaffold(
      onBack: () {},
      body: Column(
        children: [
          Text(
            'Enter Verification Code',
            style: AppTextStyles.interP16R.copyWith(
              color: appTheme.neutral.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Please enter the code we sent to your email to reset your account password.',
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Your Email'),
            controller: emailController,
          ),

          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, context.figmaHeight(50)),
            ),
            child: const Text('Send Code'),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('You can resend code in ', style: AppTextStyles.interP14R.copyWith(
                color: appTheme.neutral.border,
              ),),
              Text('59', style: AppTextStyles.interP14R.copyWith(
                color: appTheme.support.red,
              ),),
              Text(' seconds', style: AppTextStyles.interP14R.copyWith(
                color: appTheme.neutral.border,
              ),),
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
