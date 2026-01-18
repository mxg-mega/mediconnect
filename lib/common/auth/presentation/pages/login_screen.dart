import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
// import 'package:mediconnect/common/auth/presentation/widgets/auth_method_button.dart';
import 'package:mediconnect/common/auth/presentation/widgets/login_form.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/colors.dart';
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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login Failed: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final authState = ref.watch(authProvider);

    return AppScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Login Account', style: GoogleFonts.inter(fontSize: 24)),
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
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              context.go('/signup');
            },
            child: Row(
              children: [
                const Text('Don\'t have an account? '),
                Text(
                  'Sign Up',
                  style: TextStyle(color: AppColors.of(context).support.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
