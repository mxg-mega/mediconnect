import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/router/routes_names.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      titleText: 'Terms and Conditions',
      onBack: () => context.pop(),
      body: Column(
        children: [
          const SizedBox(height: 16),
          ListTile(
            tileColor: AppColors.of(context).neutral.buttonTextWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            // onTap: () => navigateToPage(
            //   context,
            //   DisplayPage(
            //     title: 'Terms of Service',
            //     content: termsAndConditionsText[0],
            //   ),
            // ),
            onTap: () {
              context.push(AppRoutes.pharmacistTermsOfService);
            },
            leading: SvgPicture.asset(
              AppIcons.file2,
              width: context.figmaWidth(18),
              height: context.figmaHeight(20),
            ),
            title: Text('Terms of Service', style: AppTextStyles.interP16M),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const SizedBox(height: 16),
          ListTile(
            tileColor: AppColors.of(context).neutral.buttonTextWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            // onTap: () => navigateToPage(
            //   context,
            //   DisplayPage(
            //     title: 'Privacy Policy',
            //     content: termsAndConditionsText[1],
            //   ),
            // ),
            onTap: () {
              context.push(AppRoutes.pharmacistPrivacyPolicy);
            },
            leading: SvgPicture.asset(
              AppIcons.lock,
              width: context.figmaWidth(18),
              height: context.figmaHeight(20),
            ),
            title: Text('Privacy Policy', style: AppTextStyles.interP16M),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }
}
