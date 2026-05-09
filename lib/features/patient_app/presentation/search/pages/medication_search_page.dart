import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/common/medication/domain/entities/pharmacy_listing.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/patient_app/presentation/search/providers/search_provider.dart';
import 'package:mediconnect/core/router/routes_names.dart';
import 'package:go_router/go_router.dart';

class MedicationSearchPage extends ConsumerStatefulWidget {
  const MedicationSearchPage({super.key});

  @override
  ConsumerState<MedicationSearchPage> createState() => _MedicationSearchPageState();
}

class _MedicationSearchPageState extends ConsumerState<MedicationSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<String> _recentSearches = [
    'Ibuprofen',
    'Amoxicillin',
    'Omeprazole',
    'Paracetamol',
  ];

  final List<String> _popularSearches = [
    'Ibuprofen',
    'Amoxicillin',
    'Omeprazole',
    'Paracetamol',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      ref.read(patientSearchQueryProvider.notifier).state = query;
      setState(() {
        _isSearching = true;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(patientSearchQueryProvider.notifier).state = '';
    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: SvgPicture.asset(
              AppIcons.arrow,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                colors.neutral.primaryText,
                BlendMode.srcIn,
              ),
            ),
            padding: EdgeInsets.zero,
            onPressed: () {
              if (_isSearching) {
                _clearSearch();
              } else {
                context.pop();
              }
            },
          ),
        ),
        title: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors.patient.bg,
              width: 1,
            ),
          ),
          child: TextField(
            controller: _searchController,
            onSubmitted: _onSearchSubmitted,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search Medications by name, b...',
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
                    colors.neutral.primaryText,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: SvgPicture.asset(
                        AppIcons.x,
                        width: 18,
                        height: 18,
                      ),
                      onPressed: _clearSearch,
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AppIcons.filter,
              width: 24,
              height: 24,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isSearching ? _buildSearchResults() : _buildSearchLanding(),
    );
  }

  Widget _buildSearchLanding() {
    final colors = AppTheme.colors(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent',
                style: AppTextStyles.interP16M.copyWith(
                  color: colors.neutral.secondaryText,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Clear All',
                  style: AppTextStyles.interP14M.copyWith(
                    color: colors.support.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._recentSearches.map((search) => _buildSearchItem(search, true)),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Searches',
                style: AppTextStyles.interP16M.copyWith(
                  color: colors.neutral.secondaryText,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: AppTextStyles.interP14M.copyWith(
                    color: colors.support.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._popularSearches.map((search) => _buildSearchItem(search, false)),
        ],
      ),
    );
  }

  Widget _buildSearchItem(String text, bool isRecent) {
    final colors = AppTheme.colors(context);
    return InkWell(
      onTap: () {
        _searchController.text = text;
        _onSearchSubmitted(text);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            SvgPicture.asset(
              AppIcons.history,
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
                text,
                style: AppTextStyles.interP16R.copyWith(
                  color: colors.neutral.secondaryText,
                ),
              ),
            ),
            if (isRecent)
              GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  AppIcons.x,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    colors.neutral.secondaryText,
                    BlendMode.srcIn,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final searchAsync = ref.watch(medicationSearchResultsProvider);

    return searchAsync.when(
      data: (medications) {
        if (medications.isEmpty) {
          return const Center(child: Text('No medications found'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: medications.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final med = medications[index];
            return _buildMedicationResultCard(med);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildMedicationResultCard(PharmacyListing med) {
    final colors = AppTheme.colors(context);
    return GestureDetector(
      onTap: () => context.push(AppRoutes.medicationDetails),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: med.medicationImageUrl != null
                ? Image.network(
                    med.medicationImageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: colors.neutral.bgTint,
                      child: const Icon(Icons.medication),
                    ),
                  )
                : Container(
                    width: 80,
                    height: 80,
                    color: colors.neutral.bgTint,
                    child: const Icon(Icons.medication),
                  ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          med.medicationName,
                          style: AppTextStyles.interP16M.copyWith(
                            color: colors.neutral.primaryText,
                          ),
                        ),
                      ),
                      const Icon(Icons.favorite_border, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Generic', // Generic label for now
                    style: AppTextStyles.interP12R.copyWith(
                      color: colors.neutral.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '0.0 (0)', // Global rating placeholder
                        style: AppTextStyles.interP12M.copyWith(
                          color: colors.neutral.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${med.currency} ${med.price.toStringAsFixed(0)}',
                        style: AppTextStyles.interP16Sm.copyWith(
                          color: colors.neutral.primaryText,
                        ),
                      ),
                      Text(
                        med.pharmacyName,
                        style: AppTextStyles.interP12R.copyWith(
                          color: colors.neutral.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: med.stockStatus == StockStatus.inStock ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${med.stockStatus.displayName} • ${med.distance} • ${med.isPharmacyOpen ? 'Open' : 'Closed'}',
                        style: AppTextStyles.interP12R.copyWith(
                          color: colors.neutral.secondaryText,
                        ),
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
