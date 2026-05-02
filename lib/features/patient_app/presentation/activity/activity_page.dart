import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/features/patient_app/domain/entities/patient_activity_item.dart';
import 'package:mediconnect/features/patient_app/presentation/activity/providers/activity_provider.dart';

class ActivityPage extends ConsumerStatefulWidget {
  const ActivityPage({super.key});

  @override
  ConsumerState<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends ConsumerState<ActivityPage>
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
      backgroundColor: colors.patient.bg,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 60, left: 24, bottom: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              'Activity',
              style: AppTextStyles.inter32M.copyWith(color: Colors.white),
            ),
          ),

          // Tab Content Area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colors.neutral.bgTint,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Tab Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        dividerColor: Colors.transparent,
                        indicatorColor: colors.patient.bg,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: colors.neutral.primaryText,
                        unselectedLabelColor: colors.neutral.secondaryText,
                        labelStyle: AppTextStyles.interP24R.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        unselectedLabelStyle: AppTextStyles.interP24R,
                        tabs: const [
                          Tab(text: 'Recent Activity'),
                          Tab(text: 'Favorites'),
                        ],
                      ),
                    ),
                  ),

                  // Tab View
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildRecentActivityTab(context),
                        _buildFavoritesTab(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityTab(BuildContext context) {
    final recentActivityAsync = ref.watch(recentActivityProvider);

    return recentActivityAsync.when(
      data: (items) {
        final searches = items.where((e) => e.type == ActivityItemType.search).toList();
        final medications = items.where((e) => e.type == ActivityItemType.medication).toList();
        final pharmacies = items.where((e) => e.type == ActivityItemType.pharmacy).toList();

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (searches.isNotEmpty) ...[
              _buildSectionHeader(context, 'Recent Searches', onClearAll: () {
                for (var s in searches) {
                  ref.read(activityNotifierProvider.notifier).removeRecentActivity(s.id);
                }
              }),
              const SizedBox(height: 16),
              ...searches.map((item) => _buildDismissibleItem(
                    item: item,
                    child: _buildSearchItem(context, item),
                  )),
              const SizedBox(height: 24),
            ],

            if (medications.isNotEmpty) ...[
              _buildSectionHeader(context, 'Viewed Medications', onClearAll: () {
                for (var m in medications) {
                  ref.read(activityNotifierProvider.notifier).removeRecentActivity(m.id);
                }
              }),
              const SizedBox(height: 16),
              ...medications.map((item) => _buildDismissibleItem(
                    item: item,
                    child: _buildMedicationItem(context, item),
                  )),
              const SizedBox(height: 24),
            ],

            if (pharmacies.isNotEmpty) ...[
              _buildSectionHeader(context, 'Viewed Pharmacies', onClearAll: () {
                for (var p in pharmacies) {
                  ref.read(activityNotifierProvider.notifier).removeRecentActivity(p.id);
                }
              }),
              const SizedBox(height: 16),
              ...pharmacies.map((item) => _buildDismissibleItem(
                    item: item,
                    child: _buildPharmacyItem(context, item),
                  )),
              const SizedBox(height: 24),
            ],

            if (items.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No recent activity'),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error loading activity: $e')),
    );
  }

  Widget _buildFavoritesTab(BuildContext context) {
    final favoritesAsync = ref.watch(favoritesActivityProvider);

    return favoritesAsync.when(
      data: (items) {
        final medications = items.where((e) => e.type == ActivityItemType.medication).toList();
        final pharmacies = items.where((e) => e.type == ActivityItemType.pharmacy).toList();

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (medications.isNotEmpty) ...[
              _buildSectionHeader(context, 'Favorite Medications', onClearAll: () {}),
              const SizedBox(height: 16),
              ...medications.map((item) => _buildMedicationItem(context, item)),
              const SizedBox(height: 24),
            ],

            if (pharmacies.isNotEmpty) ...[
              _buildSectionHeader(context, 'Bookmarked Pharmacies', onClearAll: () {}),
              const SizedBox(height: 16),
              ...pharmacies.map((item) => _buildPharmacyItem(context, item, showDistance: false)),
              const SizedBox(height: 24),
            ],

            if (items.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No favorites yet'),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error loading favorites: $e')),
    );
  }

  Widget _buildDismissibleItem({required PatientActivityItem item, required Widget child}) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        ref.read(activityNotifierProvider.notifier).removeRecentActivity(item.id);
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    required VoidCallback onClearAll,
  }) {
    final colors = AppTheme.colors(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.interP18M.copyWith(
            color: colors.neutral.primaryText,
          ),
        ),
        TextButton(
          onPressed: onClearAll,
          child: Text(
            'Clear All',
            style: AppTextStyles.interP14M.copyWith(color: colors.support.red),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchItem(BuildContext context, PatientActivityItem item) {
    final colors = AppTheme.colors(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTextStyles.interP18M.copyWith(
                        color: colors.neutral.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.timestamp.day}/${item.timestamp.month}/${item.timestamp.year}',
                      style: AppTextStyles.interP14R.copyWith(
                        color: colors.neutral.tertiaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationItem(BuildContext context, PatientActivityItem item) {
    final colors = AppTheme.colors(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: colors.neutral.bgTint,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: (item.imagePath != null && item.imagePath!.isNotEmpty) 
                ? (item.imagePath!.startsWith('http') 
                    ? Image.network(item.imagePath!) 
                    : Image.asset(item.imagePath!))
                : const Icon(Icons.medication),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.interP18M.copyWith(
                    color: colors.neutral.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle ?? '',
                  style: AppTextStyles.interP14R.copyWith(
                    color: colors.neutral.tertiaryText,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              item.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: item.isFavorite ? colors.support.red : colors.neutral.secondaryText,
            ),
            onPressed: () {
              ref.read(activityNotifierProvider.notifier).toggleFavorite(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPharmacyItem(BuildContext context, PatientActivityItem item, {bool showDistance = true}) {
    final colors = AppTheme.colors(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              color: colors.neutral.bgTint,
              borderRadius: BorderRadius.circular(8),
              image: (item.imagePath != null && item.imagePath!.isNotEmpty)
                  ? DecorationImage(
                      image: item.imagePath!.startsWith('http') ? NetworkImage(item.imagePath!) as ImageProvider : AssetImage(item.imagePath!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (item.imagePath == null || item.imagePath!.isEmpty)
                ? const Icon(Icons.local_pharmacy_outlined)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.interP18M.copyWith(
                    color: colors.neutral.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                if (showDistance && item.subtitle != null)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: colors.neutral.secondaryText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.subtitle!,
                        style: AppTextStyles.interP14R.copyWith(
                          color: colors.neutral.secondaryText,
                        ),
                      ),
                    ],
                  )
                else if (item.subtitle != null)
                  Text(
                    item.subtitle!,
                    style: AppTextStyles.interP14R.copyWith(
                      color: colors.neutral.tertiaryText,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  '${item.timestamp.day}/${item.timestamp.month}/${item.timestamp.year}',
                  style: AppTextStyles.interP14R.copyWith(
                    color: colors.neutral.tertiaryText,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              item.isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: item.isFavorite ? colors.patient.bg : colors.neutral.secondaryText,
            ),
            onPressed: () {
              ref.read(activityNotifierProvider.notifier).toggleFavorite(item);
            },
          ),
        ],
      ),
    );
  }
}
