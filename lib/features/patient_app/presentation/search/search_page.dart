
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/patient_app/data/models/mock_data.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: _tabController.index == 0
                ? 'Search Medications by name, brand, or...'
                : 'Search Pharmacy by name or location',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: const Icon(Icons.filter_list),
            filled: true,
            fillColor: colors.neutral.bg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: colors.patient.bg,
          unselectedLabelColor: colors.neutral.secondaryText,
          indicatorColor: colors.patient.bg,
          tabs: const [
            Tab(text: 'Medications'),
            Tab(text: 'Pharmacy'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMedicationsTab(context),
          _buildPharmacyTab(context),
        ],
      ),
    );
  }

  Widget _buildMedicationsTab(BuildContext context) {
    final medications = ref.watch(medicationListProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Recommended For You'),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
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
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: medications.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return MedicationCard(medication: medications.reversed.toList()[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPharmacyTab(BuildContext context) {
    final pharmacies = ref.watch(pharmacyListProvider);
    return Column(
      children: [
        const SizedBox(
          height: 250,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(9.0765, 7.3986), // Abuja
              zoom: 12,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
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
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      return PharmacyCard(pharmacy: pharmacies[index]);
                    },
                  ),
                ),
              ],
            ),
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
        Text(title, style: AppTextStyles.h3Sb.copyWith(color: colors.neutral.primaryText)),
        Text('View All', style: AppTextStyles.interP14M.copyWith(color: colors.patient.bg)),
      ],
    );
  }
}

