import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/router/routes_names.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _currentObscure = true;
  bool _newObscure = true;
  bool _confirmObscure = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);

    return AppScaffold(
      removeBodyPadding: true,
      title: const Text('Change Password'),
      body: Padding(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPasswordField(
                'Current Password (Updated 20/06/2025)',
                _currentPasswordController,
                _currentObscure,
                () => setState(() => _currentObscure = !_currentObscure),
                theme,
              ),
              SizedBox(height: context.figmaHeight(16)),
              _buildPasswordField(
                'New Password',
                _newPasswordController,
                _newObscure,
                () => setState(() => _newObscure = !_newObscure),
                theme,
              ),
              SizedBox(height: context.figmaHeight(16)),
              _buildPasswordField(
                'Confirm Password',
                _confirmPasswordController,
                _confirmObscure,
                () => setState(() => _confirmObscure = !_confirmObscure),
                theme,
              ),
              SizedBox(height: context.figmaHeight(12)),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Forgot Password?',
                  style: AppTextStyles.interP14M.copyWith(color: theme.support.red),
                ),
              ),
              const Spacer(),
              KElevatedButton(
                onPressed: () {
                  // Navigate to verification
                  context.push(
                    AppRoutes.pharmacistSecurityVerification,
                    extra: {
                      'title': 'Enter Confirmation Code',
                      'subtitle': 'We sent an email with your confirmation code to Muneer.sani@gmail.com',
                      'nextRoute': AppRoutes.pharmacistSecuritySuccess,
                      'successData': {
                        'title': 'Password Changed!',
                        'subtitle': 'You can now use your new password to securely sign in to your account.',
                      }
                    },
                  );
                },
                child: const Text('Change Password'),
              ),
              SizedBox(height: context.figmaHeight(20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscure,
    VoidCallback onToggle,
    AppColorsTheme theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.interP14M.copyWith(color: theme.neutral.secondaryText),
        ),
        SizedBox(height: context.figmaHeight(8)),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
            ),
            filled: true,
            fillColor: theme.neutral.bgTint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.neutral.border.withValues(alpha: 0.3)),
            ),
          ),
        ),
      ],
    );
  }
}
