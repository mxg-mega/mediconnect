import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/common/auth/presentation/widgets/auth_method_button.dart';
// import 'package:mediconnect/common/auth/presentation/widgets/auth_method_button.dart';
import 'package:mediconnect/common/auth/presentation/widgets/login_form.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
// import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authNotifier = ref.read(authProvider.notifier);
        await authNotifier.signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (mounted) {
          context.go('/'); // Navigate to home on successful login
        }
      } catch (e) {
        // Error is now handled by AuthNotifier and displayed inline in LoginForm
        debugPrint('Login failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final authState = ref.watch(authProvider);

    return AppScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Login Account', style: GoogleFonts.inter(fontSize: 24)),
              const SizedBox(height: 8),
              Text('Please Login with your registered account'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LoginForm(
                  _formKey,
                  _emailController,
                  _passwordController,
                  _submitForm,
                ),
              ),
              const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: context.figmaHeight(1),
                  color: AppColors.of(context).neutral.border,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Or continue with',
                  style: AppTextStyles.interP14M.copyWith(
                    color: AppColors.of(context).neutral.secondaryText,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: context.figmaHeight(1),
                  color: AppColors.of(context).neutral.border,
                ),
              ),
            ],
          ),
              const SizedBox(height: 16),
          AuthMethodButton(
            onPressed: () {},
            label: const Text('Sign in with Google'),
            path: 'assets/svg/flat-color-icons_google.svg',
          ),
          const SizedBox(height: 12),
          AuthMethodButton(
            onPressed: () {},
            label: const Text('Sign in with Apple'),
            path: 'assets/svg/ic_baseline-apple.svg',
          ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  context.go('/signup');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account? '),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        color: AppColors.of(context).support.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
