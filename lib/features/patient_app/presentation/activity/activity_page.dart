import 'package:flutter/material.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/text_styles.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>
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
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildSectionHeader(context, 'Recent Searches', onClearAll: () {}),
        const SizedBox(height: 16),
        Dismissible(
          key: Key('temp_item_1'),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) => {
            // TODO: dismissed item dhould be removed from the list
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          child: _buildSearchItem(
            context,
            'Amoxicillin 500 mg',
            'July 18, 2025 • 14:35',
          ),
        ),
        _buildSearchItem(context, 'Ibuprofen', 'July 17, 2025 • 09:12'),
        _buildSearchItem(
          context,
          'Pharmacy near me',
          'July 16, 2025 • 18:47',
          isDeletable: true,
        ),
        _buildViewMoreButton(context, () {}),

        const SizedBox(height: 24),
        _buildSectionHeader(context, 'Viewed Medications', onClearAll: () {}),
        const SizedBox(height: 16),
        _buildMedicationItem(
          context,
          'Amoxicillin 500 mg Capsule',
          'Viewed July 18, 2025 • 14:37',
          'assets/images/amoxicillin_gsk.png',
          isFavorited: false,
        ),
        _buildMedicationItem(
          context,
          'Paracetamol 500 mg Tablet',
          'Viewed July 15, 2025 • 09:15',
          'assets/images/ibuprofen_pfizer.png', // Placeholder image
          isFavorited: false,
        ),
        _buildViewMoreButton(context, () {}),

        const SizedBox(height: 24),
        _buildSectionHeader(context, 'Viewed Pharmacies', onClearAll: () {}),
        const SizedBox(height: 16),
        _buildPharmacyItem(
          context,
          'New-Health Pharmacy Ltd',
          '10 min away • Closes 7pm',
          'Viewed July 18, 2025 • 14:40',
          null, // Placeholder
          isBookmarked: false,
        ),
        _buildPharmacyItem(
          context,
          'Apogee Pharmacy & Stores',
          '16 min away • Open Now',
          'Viewed July 15, 2025 • 09:15',
          null, // Placeholder
          isBookmarked: false,
        ),
        _buildViewMoreButton(context, () {}),
      ],
    );
  }

  Widget _buildFavoritesTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildSectionHeader(context, 'Favorite Medications', onClearAll: () {}),
        const SizedBox(height: 16),
        _buildMedicationItem(
          context,
          'Amoxicillin 500 mg Capsule',
          'Favorited July 18, 2025 • 14:37',
          'assets/images/amoxicillin_gsk.png',
          isFavorited: true,
        ),
        _buildMedicationItem(
          context,
          'Paracetamol 500 mg Tablet',
          'Favorited July 15, 2025 • 09:15',
          'assets/images/ibuprofen_pfizer.png',
          isFavorited: true,
        ),
        _buildMedicationItem(
          context,
          'Ibuprofen 200 mg Tablet',
          'Favorited July 12, 2025 • 017:27',
          'assets/images/ibuprofen_pfizer.png',
          isFavorited: true,
        ),
        _buildViewMoreButton(context, () {}),

        const SizedBox(height: 24),
        _buildSectionHeader(
          context,
          'Bookmarked Pharmacies',
          onClearAll: () {},
        ),
        const SizedBox(height: 16),
        _buildPharmacyItem(
          context,
          'New-Health Pharmacy Ltd',
          'Favorited July 18, 2025 • 14:40',
          null, // Date subtitle
          null, // image
          isBookmarked: true,
          showDistance: false,
        ),
        _buildPharmacyItem(
          context,
          'Apogee Pharmacy & Stores',
          'Favorited July 15, 2025 • 09:15',
          null, // Date subtitle
          null, // image
          isBookmarked: true,
          showDistance: false,
        ),
        _buildViewMoreButton(context, () {}),
      ],
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

  Widget _buildSearchItem(
    BuildContext context,
    String query,
    String date, {
    bool isDeletable = false,
  }) {
    final colors = AppTheme.colors(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                      query,
                      style: AppTextStyles.interP18M.copyWith(
                        color: colors.neutral.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: AppTextStyles.interP14R.copyWith(
                        color: colors.neutral.tertiaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isDeletable)
              Container(
                width: 60,
                height: 80,
                color: colors.support.red,
                child: const Icon(Icons.delete_outline, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationItem(
    BuildContext context,
    String title,
    String subtitle,
    String imagePath, {
    required bool isFavorited,
  }) {
    final colors = AppTheme.colors(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: colors.neutral.bgTint,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.medication),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.interP18M.copyWith(
                    color: colors.neutral.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.interP14R.copyWith(
                    color: colors.neutral.tertiaryText,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isFavorited ? Icons.favorite : Icons.favorite_border,
            color: isFavorited
                ? colors.support.red
                : colors.neutral.secondaryText,
          ),
        ],
      ),
    );
  }

  Widget _buildPharmacyItem(
    BuildContext context,
    String name,
    String info,
    String? viewedDate,
    String? imagePath, {
    required bool isBookmarked,
    bool showDistance = true,
  }) {
    final colors = AppTheme.colors(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        children: [
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              color: colors.neutral.bgTint,
              borderRadius: BorderRadius.circular(8),
              image: imagePath != null
                  ? DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imagePath == null
                ? const Icon(Icons.local_pharmacy_outlined)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.interP18M.copyWith(
                    color: colors.neutral.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                if (showDistance)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: colors.neutral.secondaryText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        info,
                        style: AppTextStyles.interP14R.copyWith(
                          color: colors.neutral.secondaryText,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    info,
                    style: AppTextStyles.interP14R.copyWith(
                      color: colors.neutral.tertiaryText,
                    ),
                  ),
                if (viewedDate != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    viewedDate,
                    style: AppTextStyles.interP14R.copyWith(
                      color: colors.neutral.tertiaryText,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: isBookmarked
                ? colors.patient.bg
                : colors.neutral.secondaryText,
          ),
        ],
      ),
    );
  }

  Widget _buildViewMoreButton(BuildContext context, VoidCallback onPressed) {
    final colors = AppTheme.colors(context);
    return Center(
      child: TextButton.icon(
        onPressed: onPressed,
        label: const Text('View more'),
        icon: const Icon(Icons.keyboard_arrow_down),
        style: TextButton.styleFrom(
          foregroundColor: colors.patient.bg,
          textStyle: AppTextStyles.interP16M,
        ),
      ),
    );
  }
}
