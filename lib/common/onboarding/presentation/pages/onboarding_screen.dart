import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediconnect/common/onboarding/data/page_data.dart';
import 'package:mediconnect/common/onboarding/presentation/pages/widgets/page_indicator.dart';
import 'package:mediconnect/common/onboarding/presentation/pages/widgets/presentation_widget.dart';
import 'package:mediconnect/common/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);

    return AppScaffold(
      scaffoldActions: [
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.colors(context).support.red,
          ),
          child: Text(
            'Skip',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            SizedBox(
              height: context.figmaHeight(467),
              width: context.figmaWidth(392),
              child: PageView.builder(
                itemCount: orientationPages.length,
                itemBuilder: (_, index) => PresentationWidget(
                  svgPath: orientationPages[index].svgPath,
                  title: orientationPages[index].title,
                  description: orientationPages[index].description,
                ),
                onPageChanged: (index) {
                  ref
                      .read(onboardingProvider.notifier)
                      .setCurrentPageIndex(index);
                },
              ),
            ),
            // const SizedBox(height: 10),
            PageIndicator(
              currentIndex: onboardingState.currentPageIndex,
              totalPages: orientationPages.length,
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: onboardingState.isLoading
                  ? null
                  : () async {
                      final onboardingNotifier = ref.read(
                        onboardingProvider.notifier,
                      );
                      await onboardingNotifier.completeOnboarding();
                      if (context.mounted) {
                        context.go('/'); // Navigate to the main app
                      }
                    },
              child: onboardingState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
