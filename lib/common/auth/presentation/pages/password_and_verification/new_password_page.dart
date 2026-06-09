import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/common/widgets/k_input_field.dart';
import 'package:mediconnect/common/widgets/labeled_input.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/auth/presentation/providers/password_visibility_provider.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/core/constants/colors.dart';

class NewPasswordPage extends ConsumerStatefulWidget {
  const NewPasswordPage({
    super.key,
    required this.email,
    required this.resetToken,
  });

  final String email;
  final String resetToken;

  @override
  ConsumerState<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends ConsumerState<NewPasswordPage> {
  final pwController = TextEditingController();
  final confirmPwController = TextEditingController();

  @override
  void dispose() {
    pwController.dispose();
    confirmPwController.dispose();
    super.dispose();
  }

  void _showSuccessDialog(BuildContext context) {
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
                  Navigator.of(context).pop(); // dismiss dialog
                  context.go('/login'); // go to login
                },
                child: const Text('Login Now'),
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

  Future<void> _createNewPassword() async {
    final newPassword = pwController.text;
    final confirmPassword = confirmPwController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) return;
    
    if (newPassword != confirmPassword) {
      ref.read(authProvider.notifier).clearError();
      // Since there's no setErrorMessage exposed, we can trigger an error state manually, 
      // but it's better to just do simple client-side validation first if possible.
      // Wait, let's just let the AuthNotifier do its thing, or handle it locally if it's UI only.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      await ref.read(authProvider.notifier).resetPassword(
            widget.email,
            widget.resetToken,
            newPassword,
          );
          
      if (mounted) {
        _showSuccessDialog(context);
      }
    } catch (e) {
      // Error is caught and stored in authState
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return AppScaffold(
      onBack: () => context.pop(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create New Password',
                    style: AppTextStyles.inter32M.copyWith(fontSize: 26),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Password must be at least 6 characters and include letters, numbers, & a special character (e.g. !\$@%).',
                    style: AppTextStyles.interP16R.copyWith(
                      color: AppTheme.colors(context).neutral.tertiaryText,
                    ),
                  ),
                  const SizedBox(height: 32),
                  LabeledInput(
                    label: 'Password',
                    child: KInputField(
                      controller: pwController,
                      hintText: '123456789',
                      isPasswordField: true,
                      visibilityProvider: passwordVisibilityProvider1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LabeledInput(
                    label: 'Confirm Password',
                    child: KInputField(
                      controller: confirmPwController,
                      hintText: '123456789',
                      isPasswordField: true,
                      visibilityProvider: confirmPasswordVisibilityProvider,
                    ),
                  ),
                  
                  if (authState.hasError && authState.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lightTheme.support.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.lightTheme.support.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: AppColors.lightTheme.support.red, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authState.errorMessage!,
                              style: AppTextStyles.p14Sm.copyWith(color: AppColors.lightTheme.support.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          SizedBox(
            width: double.infinity,
            child: KElevatedButton(
              onPressed: authState.isLoading ? null : _createNewPassword,
              child: authState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Create New Password'),
            ),
          ),
        ],
      ),
    );
  }
}
