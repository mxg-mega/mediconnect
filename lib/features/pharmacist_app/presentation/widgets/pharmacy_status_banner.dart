import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/router/routes_names.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/widgets/pharmacy_status_provider.dart';

class PharmacyStatusBanner extends ConsumerWidget {
  const PharmacyStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(currentPharmacyStatusProvider);

    return statusAsync.when(
      data: (status) {
        if (status == PharmacySetupStatus.complete) {
          return const SizedBox.shrink();
        }

        final theme = AppTheme.colors(context);
        final isIncomplete =
            status == PharmacySetupStatus.registrationIncomplete;

        final title = isIncomplete
            ? 'Complete your pharmacy profile'
            : 'Pharmacy verification pending';
        final body = isIncomplete
            ? 'Add your pharmacy details and verification documents to unlock full features.'
            : 'Your documents are under review. We\'ll notify you once verified.';
        final actionLabel = isIncomplete ? 'Complete setup' : 'View status';
        final route = isIncomplete
            ? AppRoutes.pharmacistPharmacyInformation
            : AppRoutes.pharmacistPharmacyVerification;

        return Material(
          color: theme.pharmacist.bgTint,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.figmaWidth(16),
              vertical: context.figmaHeight(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isIncomplete ? Icons.store_outlined : Icons.hourglass_top,
                  color: theme.pharmacist.bg,
                  size: context.figmaFontSize(22),
                ),
                SizedBox(width: context.figmaWidth(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.interP16M.copyWith(
                          color: theme.neutral.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: context.figmaHeight(4)),
                      Text(
                        body,
                        style: AppTextStyles.interP14R.copyWith(
                          color: theme.neutral.secondaryText,
                        ),
                      ),
                      SizedBox(height: context.figmaHeight(8)),
                      TextButton(
                        onPressed: () => context.push(route),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.pharmacist.bg,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(actionLabel),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
