import 'package:flutter/material.dart';
import 'package:mediconnect/common/auth/presentation/pages/password_and_verification/code_verification_page.dart';
import 'package:mediconnect/common/auth/presentation/pages/password_and_verification/new_password_page.dart';
import 'package:mediconnect/common/widgets/k_form_field.dart';
import 'package:mediconnect/common/widgets/k_input_field.dart';
import 'package:mediconnect/core/router/k_navigate.dart';
import 'package:mediconnect/common/widgets/labeled_input.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return AppScaffold(
      onBack: () {},
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reset Your Password',
            // style: Theme.of(context).textTheme.titleLarge,
            style: AppTextStyles.inter32M.copyWith(fontSize: 26),
          ),
          SizedBox(height: context.figmaHeight(48)),
          LabeledInput(
            label: 'Email',
            required: true,
            child: KFormField(
              hintText: 'Your Email',
              controller: emailController,
            ),
          ),

          SizedBox(height: context.figmaHeight(30)),

          ElevatedButton(
            onPressed: () {
              navigateToPage(
                context,
                CodeVerificationPage(nextPage: NewPasswordPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, context.figmaHeight(50)),
            ),
            child: const Text('Send Code'),
          ),
        ],
      ),
    );
  }
}
