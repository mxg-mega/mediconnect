import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/common/auth/presentation/widgets/auth_method_button.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm(this.formKey, this.emailController, this.passwordController, this.submitForm, {super.key});

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final void Function() submitForm;

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Text('Email'),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: widget.emailController,
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
            controller: widget.passwordController,
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
              minimumSize: Size(double.infinity, context.figmaHeight(50)),
            ),
            onPressed: authState.isLoading ? null : widget.submitForm,
            child: authState.isLoading
                ? const CircularProgressIndicator()
                : const Text('Login'),
          ),
          Row(children: [Divider(), Text(' Or continue with '), Divider()]),
          AuthMethodButton(
            onPressed: () {},
            label: Text('Sign in with Google'),
            path: 'assets/svg/flat-color-icons_google.svg',
          ),
          AuthMethodButton(
            onPressed: () {},
            label: Text('Sign in with Apple'),
            path: 'assets/svg/ic_baseline-apple.svg',
          ),
        ],
      ),
    );
  }
}
