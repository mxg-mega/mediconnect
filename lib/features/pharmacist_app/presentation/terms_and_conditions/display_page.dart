import 'package:flutter/material.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/router/k_navigate.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/terms_and_conditions/data/terms_and_conditions_text.dart';

class DisplayPage extends StatelessWidget {
  const DisplayPage({super.key, required this.title, required this.content});

  final String title;
  final TermsAndConditionsTextModel content;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      onBack: () => navigateBack(context),
      titleText: title,
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(content.title, style: AppTextStyles.interP18M),
          const SizedBox(height: 16),
          ...content.description.map(
            (paragraph) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(paragraph, style: AppTextStyles.interP16R),
            ),
          ),
        ],
      ),
    );
  }
}
