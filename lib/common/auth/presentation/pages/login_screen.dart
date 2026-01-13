import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

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
    final authState = ref.watch(authProvider);

    return AppScaffold(
      body: Column(
        children: [
          Text('Login Account', style: GoogleFonts.inter(fontSize: 24)),
          Text('Please Login with your registered account'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text('Email'),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(
                      hint: Text('Johndoe@gmail.com'),
                      prefixIcon: Icon(Icons.mail),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  Text('Password'),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.remove_red_eye),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.lightTheme.support.red,
                    ),
                    child: const Text('Forgot Password?'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        double.infinity,
                        context.figmaHeight(50),
                      ),
                    ),
                    onPressed: authState.isLoading ? null : _submitForm,
                    child: authState.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Login'),
                  ),
                  Row(
                    children: [
                      Divider(),
                      Text(' Or continue with '),
                      Divider(),
                    ],
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    label: Text('Sign in with Google'),
                    icon: SvgPicture.asset(
                      'assets/svg/flat-color-icons_google.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    label: Text('Sign in with Apple'),
                    icon: SvgPicture.asset(
                      'assets/svg/ic_baseline-apple.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      context.go('/signup');
                    },
                    child: Row(
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
        ],
      ),
    );
  }
}
