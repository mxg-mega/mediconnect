import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/router/routes_names.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/medication_catalog/providers/medication_catalog_provider.dart';

class MedicationCatalogPage extends ConsumerStatefulWidget {
  const MedicationCatalogPage({super.key});

  @override
  ConsumerState<MedicationCatalogPage> createState() => _MedicationCatalogPageState();
}

class _MedicationCatalogPageState extends ConsumerState<MedicationCatalogPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showRecent = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _showRecent = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    final state = ref.watch(medicationCatalogProvider);
    final notifier = ref.read(medicationCatalogProvider.notifier);

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, theme),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.figmaWidth(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Browse MedConnect app medication catalog medications. Search by name, brand, category, dosage or strength.',
                  style: AppTextStyles.interP14R.copyWith(
                    color: theme.neutral.secondaryText,
                  ),
                ),
                SizedBox(height: context.figmaHeight(20)),
                _buildSearchBar(theme, notifier),
                SizedBox(height: context.figmaHeight(16)),
                _buildFilters(theme, state, notifier),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state.filteredMedications.isEmpty && state.searchQuery.isNotEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: theme.neutral.tertiaryText),
                        const SizedBox(height: 16),
                        Text('No medications found', style: AppTextStyles.interP16M),
                      ],
                    ),
                  )
                else
                  _buildMedicationList(state, theme, notifier),
                
                if (_showRecent && state.recentSearches.isNotEmpty && _searchController.text.isEmpty)
                  _buildRecentOverlay(state, theme, notifier),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppColorsTheme theme) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.figmaWidth(16),
        right: context.figmaWidth(16),
        top: context.figmaHeight(20),
        bottom: context.figmaHeight(10),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          Expanded(
            child: Text(
              'Medication Catalog',
              textAlign: TextAlign.center,
              style: AppTextStyles.interP18M.copyWith(
                color: theme.neutral.primaryText,
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance for back button
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppColorsTheme theme, MedicationCatalogNotifier notifier) {
    return SearchBar(
      controller: _searchController,
      focusNode: _searchFocusNode,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SvgPicture.asset(
          AppIcons.search,
          width: 20,
          colorFilter: ColorFilter.mode(
            theme.neutral.secondaryText,
            BlendMode.srcIn,
          ),
        ),
      ),
      hintText: 'Search Medications by name, brand, category,...',
      hintStyle: WidgetStateProperty.all(
        AppTextStyles.interP14R.copyWith(
          color: theme.neutral.secondaryText,
        ),
      ),
      onChanged: (value) {
        notifier.updateSearchQuery(value);
      },
      backgroundColor: WidgetStateProperty.all(
        theme.neutral.bgTint,
      ),
      elevation: WidgetStateProperty.all(0),
      side: WidgetStateProperty.all(
        BorderSide(color: theme.neutral.border.withValues(alpha: 0.3)),
      ),
    );
  }

  Widget _buildFilters(AppColorsTheme theme, MedicationCatalogState state, MedicationCatalogNotifier notifier) {
    return Row(
      children: [
        _buildFilterChip(
          'All',
          CatalogFilter.all,
          state.filter == CatalogFilter.all,
          theme,
          notifier,
        ),
        SizedBox(width: context.figmaWidth(8)),
        _buildFilterChip(
          'Brand',
          CatalogFilter.brand,
          state.filter == CatalogFilter.brand,
          theme,
          notifier,
        ),
        SizedBox(width: context.figmaWidth(8)),
        _buildFilterChip(
          'Generic',
          CatalogFilter.generic,
          state.filter == CatalogFilter.generic,
          theme,
          notifier,
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    String label,
    CatalogFilter filter,
    bool isSelected,
    AppColorsTheme theme,
    MedicationCatalogNotifier notifier,
  ) {
    return GestureDetector(
      onTap: () => notifier.updateFilter(filter),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.figmaWidth(24),
          vertical: context.figmaHeight(8),
        ),
        decoration: BoxDecoration(
          color: isSelected ? theme.pharmacist.bg : theme.neutral.buttonTextWhite,
          borderRadius: BorderRadius.circular(context.figmaWidth(8)),
          border: Border.all(
            color: isSelected ? theme.pharmacist.bg : theme.neutral.border.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.interP14M.copyWith(
            color: isSelected ? theme.neutral.buttonTextWhite : theme.neutral.secondaryText,
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationList(MedicationCatalogState state, AppColorsTheme theme, MedicationCatalogNotifier notifier) {
    return ListView.builder(
      padding: EdgeInsets.all(context.figmaWidth(16)),
      itemCount: state.filteredMedications.length,
      itemBuilder: (context, index) {
        final med = state.filteredMedications[index];
        return _buildMedicationCard(med, theme, notifier);
      },
    );
  }

  Widget _buildMedicationCard(med, AppColorsTheme theme, MedicationCatalogNotifier notifier) {
    return GestureDetector(
      onTap: () {
        notifier.addToRecent(med);
        context.push(AppRoutes.pharmacistAddMedication, extra: med);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: context.figmaHeight(16)),
        padding: EdgeInsets.all(context.figmaWidth(16)),
        decoration: BoxDecoration(
          color: theme.neutral.bgTint,
          borderRadius: BorderRadius.circular(context.figmaWidth(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    med.name,
                    style: AppTextStyles.interP16M.copyWith(
                      color: theme.neutral.primaryText,
                    ),
                  ),
                ),
                Text(
                  med.dosageForms.isNotEmpty ? med.dosageForms.join(', ') : 'Label',
                  style: AppTextStyles.interP12R.copyWith(
                    color: theme.neutral.primaryText,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.figmaHeight(4)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    med.brandNames.isNotEmpty ? med.brandNames.first : 'Generic',
                    style: AppTextStyles.interP12R.copyWith(
                      color: theme.neutral.tertiaryText,
                    ),
                  ),
                ),
                Text(
                  med.category,
                  style: AppTextStyles.interP12R.copyWith(
                    color: theme.pharmacist.bg,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOverlay(MedicationCatalogState state, AppColorsTheme theme, MedicationCatalogNotifier notifier) {
    return Positioned(
      top: 0,
      left: context.figmaWidth(16),
      right: context.figmaWidth(16),
      child: Container(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        decoration: BoxDecoration(
          color: theme.neutral.buttonTextWhite,
          borderRadius: BorderRadius.circular(context.figmaWidth(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent',
                  style: AppTextStyles.interP14M.copyWith(
                    color: theme.neutral.primaryText,
                  ),
                ),
                TextButton(
                  onPressed: () => notifier.clearRecentSearches(),
                  child: Text(
                    'Clear All',
                    style: AppTextStyles.interP12R.copyWith(
                      color: theme.support.red,
                    ),
                  ),
                ),
              ],
            ),
            ...state.recentSearches.map((med) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: med.imageUrls.isNotEmpty 
                    ? Image.network(med.imageUrls.first, width: 40, height: 40, errorBuilder: (_, __, ___) => const Icon(Icons.medication))
                    : const Icon(Icons.medication, size: 40),
                  title: Text(med.name, style: AppTextStyles.interP14M),
                  subtitle: Text(med.brandNames.join(', '), style: AppTextStyles.interP12R),
                  onTap: () {
                    notifier.addToRecent(med);
                    context.push(AppRoutes.pharmacistAddMedication, extra: med);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
