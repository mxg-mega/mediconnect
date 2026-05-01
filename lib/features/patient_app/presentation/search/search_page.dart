
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/patient_app/presentation/widgets/medication_card.dart';
import 'package:mediconnect/features/patient_app/presentation/widgets/pharmacy_card.dart';
import 'package:mediconnect/features/patient_app/providers/medication_provider.dart';
import 'package:mediconnect/features/patient_app/providers/pharmacy_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    return Scaffold(
      backgroundColor: colors.neutral.bgTint,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              elevation: 0,
              backgroundColor: colors.neutral.bgTint,
              title: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: _tabController.index == 0
                        ? 'Search Medications'
                        : 'Search Pharmacies',
                    hintStyle: AppTextStyles.interP14R.copyWith(
                      color: colors.neutral.tertiaryText,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        AppIcons.search,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          colors.neutral.secondaryText,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.patient.bg.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            AppIcons.filter,
                            width: 18,
                            height: 18,
                            colorFilter: ColorFilter.mode(
                              colors.patient.bg,
                              BlendMode.srcIn,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  onSubmitted: (value) {
                    // Handle search
                  },
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: colors.patient.bg,
                    unselectedLabelColor: colors.neutral.secondaryText,
                    indicatorColor: colors.patient.bg,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: AppTextStyles.interP16M,
                    unselectedLabelStyle: AppTextStyles.interP16R,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppIcons.pill,
                              width: 18,
                              height: 18,
                              colorFilter: ColorFilter.mode(
                                _tabController.index == 0
                                    ? colors.patient.bg
                                    : colors.neutral.secondaryText,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('Medications'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppIcons.location,
                              width: 18,
                              height: 18,
                              colorFilter: ColorFilter.mode(
                                _tabController.index == 1
                                    ? colors.patient.bg
                                    : colors.neutral.secondaryText,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('Pharmacies'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildMedicationsTab(context),
            _buildPharmacyTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationsTab(BuildContext context) {
    final medications = ref.watch(medicationListProvider);
    final colors = AppTheme.colors(context);

    return Container(
      color: colors.neutral.bgTint,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Recommended For You'),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: medications.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return MedicationCard(medication: medications[index]);
                },
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Product on Sale'),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: medications.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return MedicationCard(
                      medication: medications.reversed.toList()[index]);
                },
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildPharmacyTab(BuildContext context) {
    final pharmacies = ref.watch(pharmacyListProvider);
    final colors = AppTheme.colors(context);

    return Container(
      color: colors.neutral.bgTint,
      child: Column(
        children: [
          // Map Section
          SizedBox(
            height: 300,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(9.0765, 7.3986), // Abuja
                    zoom: 12,
                  ),
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                // Floating map style button
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.layers, size: 20),
                      onPressed: () {
                        // Toggle map type
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Pharmacy List Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 100),
                ],
              ),
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
            color: colors.patient.bg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

