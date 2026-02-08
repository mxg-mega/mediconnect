import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
// import 'package:mediconnect/features/patient_app/data/models/mock_data.dart';
import 'package:mediconnect/features/patient_app/presentation/widgets/category_card.dart';
import 'package:mediconnect/features/patient_app/presentation/widgets/pharmacy_card.dart';
import 'package:mediconnect/features/patient_app/providers/pharmacy_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppTheme.colors(context);
    final pharmacies = ref.watch(pharmacyListProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: colors.patient.bg,
          expandedHeight: 150.0,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(color: colors.patient.bg),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        'https://picsum.photos/seed/pfp/200/200',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, Muneer',
                          style: AppTextStyles.interP12R.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'How are you today?',
                          style: AppTextStyles.interP12R.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: SvgPicture.asset(
                        AppIcons.notification_bell_available,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SearchBar(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SvgPicture.asset(
                      AppIcons.search,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                        colors.neutral.secondaryText,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  hintText: 'Search Medications by name...',
                  hintStyle: WidgetStateProperty.all(
                    AppTextStyles.interP14R.copyWith(
                      color: colors.neutral.secondaryText,
                    ),
                  ),
                  onChanged: (value) {},
                  trailing: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        AppIcons.filter,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                          colors.neutral.secondaryText,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                  backgroundColor: WidgetStateProperty.all(
                    colors.neutral.buttonTextWhite,
                  ),
                  elevation: WidgetStateProperty.all(0),
                ),
              ],
            ),
            titlePadding: const EdgeInsets.only(bottom: 70),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(context.figmaHeight(146)),
            child: Container(
              color: colors.neutral.buttonTextWhite,
              height: context.figmaHeight(146),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionItem(
                    context,
                    AppIcons.pill,
                    'Browse\nMedications',
                  ),
                  _buildActionItem(
                    context,
                    AppIcons.location,
                    'Locate\nPharmacy',
                  ),
                  _buildActionItem(context, AppIcons.history, 'View\nActivity'),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            // color: colors.neutral.bg,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Popular category'),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 160,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 2,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        return CategoryCard(
                          title: index == 0 ? 'Cold & Flu' : 'First Aid',
                          imageUrl:
                              'https://picsum.photos/seed/${index == 0 ? 'c1' : 'c2'}/300/200',
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Nearby Pharmacies'),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 240,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: pharmacies.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        return PharmacyCard(pharmacy: pharmacies[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Top Pharmacies'),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 240,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: pharmacies.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        return PharmacyCard(
                          pharmacy: pharmacies.reversed.toList()[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(BuildContext context, String iconPath, String label) {
    final colors = AppTheme.colors(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: colors.patient.bg.withOpacity(0.1),
          child: SvgPicture.asset(
            iconPath,
            colorFilter: ColorFilter.mode(colors.patient.bg, BlendMode.srcIn),
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.interP12R.copyWith(
            color: colors.neutral.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final colors = AppTheme.colors(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.h3Sb.copyWith(color: colors.neutral.primaryText),
        ),
        Text(
          'View All',
          style: AppTextStyles.interP14M.copyWith(color: colors.patient.bg),
        ),
      ],
    );
  }
}
