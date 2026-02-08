import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/common/domain/entities/medication.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class MedicationCard extends StatelessWidget {
  final Medication medication;

  const MedicationCard({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    final textStyles = AppTheme.textTheme(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (medication.imageUrls.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  medication.imageUrls.first,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 120,
                      width: double.infinity,
                      color: colors.neutral.bg,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 120,
                      width: double.infinity,
                      color: colors.neutral.bg,
                      child: const Icon(Icons.error),
                    );
                  },
                ),
              )
            else
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colors.neutral.bg,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: const Center(
                  child: Icon(Icons.medication_outlined, size: 40),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication.name,
                    style: textStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Brand by ${medication.manufacturer}',
                    style: AppTextStyles.interP12R.copyWith(color: colors.neutral.secondaryText),
                  ),
                  const SizedBox(height: 8),
                   Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.star,
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(colors.support.yellow, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${medication.rating.averageRating.toStringAsFixed(1)} (${medication.rating.totalReviews})',
                        style: AppTextStyles.interP12R,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₦1,500', // TODO: Get price from a proper source
                    style: AppTextStyles.h4Sb,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
