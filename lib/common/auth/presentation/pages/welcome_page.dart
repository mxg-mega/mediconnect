import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/logo.dart';
import 'package:mediconnect/common/widgets/providers/app_scaffold_provider.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/router/routes_names.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(appScaffoldProvider.notifier);
    final theme = AppTheme.colors(context);

    return AppScaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: context.figmaHeight(100),
                  width: context.figmaWidth(90),
                  decoration: ShapeDecoration(
                    shape: StarBorder.polygon(sides: 6.0),
                    color: provider.getBackgroundColor(),
                  ),
                  child: Center(child: Logo()),
                ),
                Text(
                  'Welcome to Medconnect!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.interP22R.copyWith(
                    color: theme.neutral.primaryText,
                  ),
                ),
                const SizedBox(height: 40),
                KElevatedButton(
                  onPressed: () => context.push(AppRoutes.login),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),
                KElevatedButton(
                  onPressed: () => context.push(AppRoutes.signup),
                  backgroundColor: Colors.white,
                  textColor: theme.pharmacist.bg,
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      'If you see your application status still pending. Contact us at ',
                  style: AppTextStyles.p14Sm.copyWith(
                    color: theme.neutral.secondaryText,
                  ),
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Handle tap on email
                    },
                  text: ' MedConnect@gmail.com',
                  style: AppTextStyles.interP14M.copyWith(
                    color: theme.neutral.bg00,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
