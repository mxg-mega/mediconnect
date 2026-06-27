import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/patient_app/presentation/widgets/category_card.dart';
import 'package:mediconnect/features/patient_app/presentation/widgets/pharmacy_card.dart';
import 'package:mediconnect/features/patient_app/presentation/dashboard/providers/dashboard_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppTheme.colors(context);
    final dashboardState = ref.watch(dashboardProvider);
    final pharmacies = dashboardState.nearbyPharmacies;
    final user = dashboardState.user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.paddingOf(context).top + 24,
                    left: 20,
                    right: 20,
                    bottom: 70,
                  ),
                  margin: const EdgeInsets.only(bottom: 60),
                  decoration: BoxDecoration(
                    color: colors.patient.bg,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Profile section
                      Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.white24,
                                backgroundImage: (user != null && user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty)
                                    ? NetworkImage(user.profileImageUrl!)
                                    : null,
                                child: (user == null || user.profileImageUrl == null || user.profileImageUrl!.isEmpty)
                                    ? const Icon(Icons.person, color: Colors.white)
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: colors.patient.bg, width: 2),
                                  ),
                                  child: const Icon(Icons.check, size: 10, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi, ${user?.firstName ?? user?.fullName ?? 'Patient'}',
                                  style: AppTextStyles.interP16M.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'How are you today?',
                                  style: AppTextStyles.interP14R.copyWith(
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SvgPicture.asset(
                                AppIcons.notification_bell_available,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                                width: 26,
                                height: 26,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: colors.patient.bg, width: 1.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Search Bar
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            SvgPicture.asset(
                              AppIcons.search,
                              width: 20,
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                colors.neutral.secondaryText,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Search Medications/Pharmacy',
                                style: AppTextStyles.interP14R.copyWith(
                                  color: colors.neutral.tertiaryText,
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 24,
                              color: colors.neutral.border.withValues(alpha: 0.3),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: SvgPicture.asset(
                                AppIcons.filter3,
                                width: 20,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  colors.neutral.secondaryText,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Quick Actions Card
                Positioned(
                  bottom: 0,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildActionItem(context, AppIcons.pill, 'Browse\nMedications'),
                        _buildActionItem(context, AppIcons.mapLocation, 'Locate\nPharmacy'),
                        _buildActionItem(context, AppIcons.history, 'View\nActivity'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Popular Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Popular category'),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 2,
                      separatorBuilder: (context, index) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        return CategoryCard(
                          title: index == 0 ? 'Cold & Flu' : 'First Aid',
                          imageUrl: 'https://picsum.photos/seed/${index == 0 ? 'c1' : 'c2'}/300/200',
                          width: 160,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Nearby Pharmacies
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Nearby Pharmacies'),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 260,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: pharmacies.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        return PharmacyCard(pharmacy: pharmacies[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Top Pharmacies
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Top Pharmacies'),
                  const SizedBox(height: 16),
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pharmacies.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return PharmacyCard(
                        pharmacy: pharmacies.reversed.toList()[index],
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, String iconPath, String label) {
    final colors = AppTheme.colors(context);
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colors.patient.bg,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              iconPath,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.interP12M.copyWith(
              color: colors.neutral.primaryText,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final colors = AppTheme.colors(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.h3Sb.copyWith(
            color: colors.neutral.primaryText,
            fontSize: 18,
          ),
        ),
        Text(
          'View All',
          style: AppTextStyles.interP14M.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
