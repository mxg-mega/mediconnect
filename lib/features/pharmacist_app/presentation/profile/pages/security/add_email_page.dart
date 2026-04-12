import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/router/routes_names.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';

class AddEmailPage extends ConsumerStatefulWidget {
  const AddEmailPage({super.key});

  @override
  ConsumerState<AddEmailPage> createState() => _AddEmailPageState();
}

class _AddEmailPageState extends ConsumerState<AddEmailPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    final user = ref.watch(currentUserProvider);

    return AppScaffold(
      removeBodyPadding: true,
      title: const Text(''),
      body: Padding(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add an email address',
              style: AppTextStyles.interP18M.copyWith(color: theme.neutral.primaryText),
            ),
            SizedBox(height: context.figmaHeight(8)),
            Text(
              'Adding this email address will replace ${user?.email ?? 'Muneer.sani@gmail.com'} on this account.',
              style: AppTextStyles.interP14R.copyWith(color: theme.neutral.secondaryText),
            ),
            SizedBox(height: context.figmaHeight(32)),
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter email address',
                filled: true,
                fillColor: theme.neutral.bgTint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.neutral.border.withValues(alpha: 0.3)),
                ),
              ),
            ),
            const Spacer(),
            KElevatedButton(
              onPressed: () {
                context.push(
                  AppRoutes.pharmacistSecurityVerification,
                  extra: {
                    'title': 'Enter Confirmation Code',
                    'subtitle': 'We sent an email with your confirmation code to ${_controller.text}',
                    'nextRoute': AppRoutes.pharmacistSecuritySuccess,
                    'successData': {
                      'type': 'email',
                      'title': 'You\'ve added your email address to your account',
                      'subtitle': 'Your email address will only be visible to you',
                      'value': _controller.text,
                    }
                  },
                );
              },
              child: const Text('Next'),
            ),
            SizedBox(height: context.figmaHeight(20)),
          ],
        ),
      ),
    );
  }
}
