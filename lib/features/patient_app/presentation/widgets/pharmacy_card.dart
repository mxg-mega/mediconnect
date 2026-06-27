import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mediconnect/features/patient_app/presentation/search/providers/search_provider.dart';

class PharmacyCard extends ConsumerWidget {
  final Pharmacy pharmacy;

  const PharmacyCard({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppTheme.colors(context);

    // Calculate Distance
    final userLocationAsync = ref.watch(userLocationProvider);
    String distanceText = pharmacy.address.isNotEmpty
        ? pharmacy.address
        : 'Distance unknown';
    if (userLocationAsync.hasValue &&
        userLocationAsync.value != null &&
        pharmacy.location.latitude != 0.0) {
      final distanceInMeters = Geolocator.distanceBetween(
        userLocationAsync.value!.latitude,
        userLocationAsync.value!.longitude,
        pharmacy.location.latitude,
        pharmacy.location.longitude,
      );
      distanceText = '${(distanceInMeters / 1000).toStringAsFixed(1)} km away';
    }

    // Calculate Operating Hours
    String hoursText = 'Hours unknown';
    if (pharmacy.operatingHours.isNotEmpty) {
      final today = DateTime.now().weekday; // 1 = Monday
      final days = [
        'monday',
        'tuesday',
        'wednesday',
        'thursday',
        'friday',
        'saturday',
        'sunday',
      ];
      final todayString = days[today - 1];

      final todayHours = pharmacy.operatingHours.firstWhere(
        (h) => h.dayOfWeek.toLowerCase() == todayString,
        orElse: () => pharmacy.operatingHours.first,
      );

      if (todayHours.isClosed) {
        hoursText = 'Closed today';
      } else {
        hoursText = 'Closes ${todayHours.closeTime}';
      }
    }

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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pharmacy.frontalImageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  pharmacy.frontalImageUrl!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: ColoredBox(
                        color: colors.neutral.bg,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: ColoredBox(
                        color: colors.neutral.bg,
                        child: const Icon(Icons.error),
                      ),
                    );
                  },
                ),
              )
            else
              SizedBox(
                height: 120,
                width: double.infinity,
                child: DecoratedBox(
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
                      Expanded(
                        child: Text(
                          '$distanceText • $hoursText',
                          style: AppTextStyles.interP12R.copyWith(
                            color: colors.neutral.tertiaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
