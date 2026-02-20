import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/router/k_navigate.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/terms_and_conditions/data/terms_and_conditions_text.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/terms_and_conditions/display_page.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      titleText: 'Terms and Conditions',
      onBack: () => navigateBack(context),
      body: Column(
        children: [
          const SizedBox(height: 16),
          ListTile(
            onTap: () => navigateToPage(
              context,
              DisplayPage(
                title: 'Terms of Service',
                content: termsAndConditionsText[0],
              ),
            ),
            leading: SvgPicture.asset(AppIcons.file2, width: 24, height: 24),
            title: Text('Terms of Service', style: AppTextStyles.interP16M),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const SizedBox(height: 16),
          ListTile(
            onTap: () => navigateToPage(
              context,
              DisplayPage(
                title: 'Privacy Policy',
                content: termsAndConditionsText[1],
              ),
            ),
            leading: SvgPicture.asset(AppIcons.lock, width: 24, height: 24),
            title: Text('Privacy Policy', style: AppTextStyles.interP16M),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }
}
