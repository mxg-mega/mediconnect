import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/presentation/widgets/k_input_field.dart';
import 'package:mediconnect/common/auth/presentation/providers/password_visibility_provider.dart';

class PasswordFieldExample extends ConsumerWidget {
  const PasswordFieldExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Password Field Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Password Fields with Individual Visibility Toggle'),
            const SizedBox(height: 20),
            KInputField(
              controller: passwordController,
              hintText: 'Enter password',
              isPasswordField: true,
              visibilityProvider: passwordVisibilityProvider1,
            ),
            const SizedBox(height: 16),
            KInputField(
              controller: confirmPasswordController,
              hintText: 'Confirm password',
              isPasswordField: true,
              visibilityProvider: confirmPasswordVisibilityProvider,
            ),
            const SizedBox(height: 16),
            KInputField(
              controller: TextEditingController(),
              hintText: 'Regular text field',
              isPasswordField: false,
            ),
          ],
        ),
      ),
    );
  }
}
