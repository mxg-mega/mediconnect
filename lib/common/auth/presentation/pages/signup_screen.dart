import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/auth/presentation/pages/setup_finalization_page.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/common/auth/presentation/widgets/auth_method_button.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/common/widgets/k_form_field.dart';
import 'package:mediconnect/common/widgets/labeled_input.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authNotifier = ref.read(authProvider.notifier);
        await authNotifier.signUp(
          email: _emailController.text,
          password: _passwordController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phoneNumber: _phoneNumberController.text,
        );
        if (mounted) {
          context.go('/'); // Navigate to home on successful signup
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signup Failed: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return AppScaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Your Account', style: AppTextStyles.inter24M),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Already have an account?',
                      style: AppTextStyles.interP16M.copyWith(
                        color: AppColors.of(context).neutral.primaryText,
                      ),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.go('/login');
                        },
                      text: ' Sign In',
                      style: AppTextStyles.interP16M.copyWith(
                        color: AppColors.of(context).support.red,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.of(
                        context,
                      ).neutral.placeholderDisabled,
                      // child: Icon(Icons.person, size: 50),
                      child: SvgPicture.asset(
                        AppIcons.profile,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          // Implement image picker functionality here
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.of(context).support.green,
                          child: Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: AppColors.of(context).neutral.primaryText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(),
              LabeledInput(
                required: true,
                label: 'First Name',
                child: KFormField(
                  prefix: SvgPicture.asset(AppIcons.profile),
                  hintText: 'John Doe',
                  controller: _firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
              ),
              LabeledInput(
                required: true,
                label: 'Last Name',
                child: KFormField(
                  controller: _lastNameController,
                  hintText: 'Last Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
              ),
              LabeledInput(
                required: true,
                label: 'Email',
                child: KFormField(
                  controller: _emailController,
                  hintText: 'Email',
                  prefix: SvgPicture.asset(AppIcons.mail),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              LabeledInput(
                required: true,
                label: 'Password',
                child: KFormField(
                  controller: _passwordController,
                  hintText: 'Password',
                  prefix: SvgPicture.asset(AppIcons.lock),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              Text(
                'Password must be at least 6 characters and include letters, numbers, & a special character (e.g. !\$@%).',
              ),
              LabeledInput(
                required: true,
                label: 'Confirm Password',
                child: KFormField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  prefix: SvgPicture.asset(AppIcons.lock),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'By signing up, you agree to our ',
                  style: AppTextStyles.interP14R.copyWith(
                    color: AppColors.of(context).neutral.primaryText,
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      style: AppTextStyles.interP14R.copyWith(
                        color: AppColors.of(context).support.red,
                      ),
                    ),
                    TextSpan(
                      text: ' and ',
                      style: AppTextStyles.interP14R.copyWith(
                        color: AppColors.of(context).neutral.primaryText,
                      ),
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: AppTextStyles.interP14R.copyWith(
                        color: AppColors.of(context).support.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              KElevatedButton(
                // Temporarily commented out to avoid errors
                // onPressed: authState.isLoading ? null : _submitForm,
                onPressed: () {
                  context.push('/code-verification', extra: const SetupFinalizationPage());
                },
                child: authState.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Next'),
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
            ],
          ),
        ),
      ),
    );
  }
}
