import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/k_navigate.dart';
import 'package:mediconnect/common/widgets/logo.dart';
import 'package:mediconnect/common/widgets/providers/app_scaffold_provider.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/patient_app/presentation/main_nav/patient_main_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dashboard/pharmacist_main_page.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  // final UserType role;

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
                KElevatedButton(
                  onPressed: () {
                    // input logic for the cross flow (patient flow, or pharmacist flow)
                    provider.getEffectiveRole() == UserRole.patient
                        ? navigateToPage(context, PatientMainPage())
                        : navigateToPage(context, PharmacistMainPage());
                    // navigateToPage(context, PharmacistMainPage());
                  },
                  child: Text('Go To Dashboard'),
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
