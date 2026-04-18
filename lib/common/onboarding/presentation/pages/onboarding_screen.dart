import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediconnect/common/onboarding/data/page_data.dart';
import 'package:mediconnect/common/onboarding/presentation/pages/widgets/page_indicator.dart';
import 'package:mediconnect/common/onboarding/presentation/pages/widgets/presentation_widget.dart';
import 'package:mediconnect/common/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/providers/settings_provider.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);

    return AppScaffold(
      removeBodyPadding: true,
      scaffoldActions: [
        TextButton(
          onPressed: () async {
            // Mark onboarding as seen in persistent settings
            await ref.read(settingsProvider.notifier).setHasSeenOnboarding(true);
            
            if (context.mounted) {
              context.go('/login'); // Go to login after onboarding
            }
          },
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
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
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
            PageIndicator(
              currentIndex: onboardingState.currentPageIndex,
              totalPages: orientationPages.length,
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: onboardingState.isLoading
                  ? null
                  : () async {
                      // Mark onboarding as seen in persistent settings
                      await ref.read(settingsProvider.notifier).setHasSeenOnboarding(true);
                      
                      if (context.mounted) {
                        context.go('/login'); // Go to login after onboarding
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
