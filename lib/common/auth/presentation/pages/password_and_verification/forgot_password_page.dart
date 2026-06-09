import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/common/widgets/k_form_field.dart';
import 'package:mediconnect/common/widgets/labeled_input.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/core/constants/colors.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendCode() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    // Clear previous errors
    ref.read(authProvider.notifier).clearError();

    try {
      await ref.read(authProvider.notifier).sendEmailVerification(email, intent: 'password_reset');
      if (mounted) {
        // Push explicitly – do NOT use context.go or signOut() here.
        // Either would mutate auth state, causing GoRouter to recreate
        // and dispose this widget before navigation can happen.
        context.push('/code-verification', extra: {'email': email, 'intent': 'password_reset'});
      }
    } catch (e) {
      // Error handled by provider and shown in UI
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return AppScaffold(
      onBack: () => context.pop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reset Your Password',
            style: AppTextStyles.inter32M.copyWith(fontSize: 26),
          ),
          SizedBox(height: context.figmaHeight(48)),
          LabeledInput(
            label: 'Email',
            required: true,
            child: KFormField(
              hintText: 'Your Email',
              controller: _emailController,
            ),
          ),
          
          if (authState.hasError && authState.errorMessage != null) ...[
            const SizedBox(height: 8),
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

          SizedBox(height: context.figmaHeight(30)),

          SizedBox(
            width: double.infinity,
            child: KElevatedButton(
              onPressed: authState.isLoading ? null : _sendCode,
              child: authState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Send Code'),
            ),
          ),
        ],
      ),
    );
  }
}
