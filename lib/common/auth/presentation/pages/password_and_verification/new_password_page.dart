import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/common/widgets/k_input_field.dart';
import 'package:mediconnect/common/widgets/labeled_input.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/auth/presentation/providers/password_visibility_provider.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class NewPasswordPage extends ConsumerWidget {
  const NewPasswordPage({super.key});

  void _createNewPassword(BuildContext context) {
    // Implement password creation logic here
    // temporary effect
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: AlertDialog(
            icon: SvgPicture.asset(
              AppIcons.pulsating_success,
              width: context.figmaWidth(100),
              height: context.figmaHeight(100),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Password Changed!', style: AppTextStyles.interP18M),
                Text(
                  'Your password has been successfully created.',
                  style: AppTextStyles.interP16R,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              KElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('login Now'),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pwController = TextEditingController();
    final confirmPwController = TextEditingController();

    return AppScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Create New Password'),
                Text(
                  'Password must be at least 6 characters and include letters, numbers, & a special character (e.g. !\$@%).',
                ),
                LabeledInput(
                  label: 'Password',
                  child: KInputField(
                    controller: pwController,
                    hintText: '123456789',
                    isPasswordField: true,
                    visibilityProvider: passwordVisibilityProvider1,
                  ),
                ),
                LabeledInput(
                  label: 'Confirm Password',
                  child: KInputField(
                    controller: confirmPwController,
                    hintText: '123456789',
                    isPasswordField: true,
                    visibilityProvider: confirmPasswordVisibilityProvider,
                  ),
                ),
              ],
            ),
          ),
          KElevatedButton(
            onPressed: () {
              _createNewPassword(context);
            },
            child: Text('Create New Password'),
          ),
        ],
      ),
    );
  }
}
