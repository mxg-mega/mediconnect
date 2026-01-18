import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/presentation/widgets/k_input_field.dart';
import 'package:mediconnect/common/auth/presentation/widgets/labeled_input.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/auth/presentation/providers/password_visibility_provider.dart';

class NewPasswordPage extends ConsumerWidget {
  const NewPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pwController = TextEditingController();
    final confirmPwController = TextEditingController();

    return AppScaffold(
      body: Column(
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
    );
  }
}
