import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class PharmacyCard extends StatelessWidget {
  final Pharmacy pharmacy;

  const PharmacyCard({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Card(
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colors.neutral.border.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: SizedBox(
        width: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pharmacy.frontalImageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  pharmacy.frontalImageUrl!,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 140,
                      width: double.infinity,
                      color: colors.neutral.bg,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 140,
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
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colors.neutral.bg,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.business_outlined, size: 40),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pharmacy.name,
                    style: AppTextStyles.h4Sb.copyWith(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '10 min away • Closes 7pm',
                        style: AppTextStyles.interP12R.copyWith(
                          color: colors.neutral.tertiaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.star,
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                          colors.support.yellow,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${pharmacy.rating.averageRating.toStringAsFixed(1)} (${pharmacy.rating.totalReviews})',
                        style: AppTextStyles.interP12M,
                      ),
                    ],
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
