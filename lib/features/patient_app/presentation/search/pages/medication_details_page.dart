import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class MedicationDetailsPage extends ConsumerStatefulWidget {
  const MedicationDetailsPage({super.key});

  @override
  ConsumerState<MedicationDetailsPage> createState() => _MedicationDetailsPageState();
}

class _MedicationDetailsPageState extends ConsumerState<MedicationDetailsPage>
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrow,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              colors.neutral.primaryText,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Details',
          style: AppTextStyles.h2Sb.copyWith(
            color: colors.neutral.primaryText,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 24),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderImage(),
                _buildMedicationInfo(),
                _buildTabs(),
                _buildTabContent(),
                const SizedBox(height: 120), // Space for sticky bottom bar
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildStickyBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      width: double.infinity,
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/amoxicillin_gsk.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildMedicationInfo() {
    final colors = AppTheme.colors(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amoxicillin',
            style: AppTextStyles.inter32M.copyWith(
              color: colors.neutral.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Brand • by GlaxoSmithKline',
            style: AppTextStyles.interP14R.copyWith(
              color: colors.neutral.secondaryText,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Packaging',
                    style: AppTextStyles.interP14M.copyWith(
                      color: colors.neutral.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Amoxil 500 mg. 10 capsules',
                    style: AppTextStyles.interP14R.copyWith(
                      color: colors.neutral.secondaryText,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '4.8',
                    style: AppTextStyles.interP14M.copyWith(
                      color: colors.neutral.secondaryText,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Row(
                    children: List.generate(
                      5,
                      (index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(264)',
                    style: AppTextStyles.interP14R.copyWith(
                      color: colors.neutral.secondaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final colors = AppTheme.colors(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.neutral.border,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: colors.patient.bg,
        unselectedLabelColor: colors.neutral.secondaryText,
        indicatorColor: colors.patient.bg,
        indicatorWeight: 3,
        labelStyle: AppTextStyles.interP16M,
        unselectedLabelStyle: AppTextStyles.interP16R,
        dividerColor: Colors.transparent,
        onTap: (index) {
          setState(() {});
        },
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Reviews'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return _tabController.index == 0 ? _buildOverviewTab() : _buildReviewsTab();
  }

  Widget _buildOverviewTab() {
    final colors = AppTheme.colors(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Descriptions'),
          const SizedBox(height: 8),
          Text(
            'Amoxil® (amoxicillin) is a broad-spectrum, penicillin-class antibiotic that inhibits bacterial cell-wall synthesis. It treats a wide range of infections including respiratory, ear, sinus, skin/soft-tissue, and urinary trac by targeting peptidoglycan cross-linking in susceptible organisms.',
            style: AppTextStyles.interP14R.copyWith(
              color: colors.neutral.secondaryText,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Benefits & Uses'),
          const SizedBox(height: 8),
          Text(
            'Respiratory tract infections, otitis media, skin/soft tissue infections, urinary tract infections, dental infections; often combined with clavulanate for beta-lactamase producers.',
            style: AppTextStyles.interP14R.copyWith(
              color: colors.neutral.secondaryText,
            ),
          ),
          const SizedBox(height: 24),
          _buildReviewsSummaryCard(),
          const SizedBox(height: 32),
          _buildMedicationHorizontalList('Other Amoxil variants'),
          const SizedBox(height: 32),
          _buildMedicationHorizontalList('Similar Products'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final colors = AppTheme.colors(context);
    return Text(
      title,
      style: AppTextStyles.interP16M.copyWith(
        color: colors.neutral.primaryText,
      ),
    );
  }

  Widget _buildReviewsSummaryCard() {
    final colors = AppTheme.colors(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.neutral.bgTint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: List.generate(5, (index) {
                    final rating = 5 - index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text('$rating', style: AppTextStyles.interP12R),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: 0.8 / rating, // Placeholder
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colors.patient.bg,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 24),
              Column(
                children: [
                  Text(
                    '4.8',
                    style: AppTextStyles.inter32M.copyWith(
                      color: colors.neutral.primaryText,
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '264 reviews',
                    style: AppTextStyles.interP12R.copyWith(
                      color: colors.patient.bg,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: SvgPicture.asset(
              AppIcons.file, // Placeholder for write review icon
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            label: const Text('Write a review'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.patient.bg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationHorizontalList(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.interP16M,
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See all',
                style: AppTextStyles.interP12R,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return _buildSmallMedicationCard();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSmallMedicationCard() {
    final colors = AppTheme.colors(context);
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.neutral.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                'assets/images/amoxicillin_gsk.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amoxicillin 250 mg',
                  style: AppTextStyles.interP14M,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Brand • by GSK',
                  style: AppTextStyles.interP10R,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₦1,500', style: AppTextStyles.interP14M),
                    const Icon(Icons.favorite_border, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    final colors = AppTheme.colors(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRatingSummary(),
          const SizedBox(height: 32),
          const Center(child: Text('Rate and review')),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => const Icon(Icons.star_border, size: 40, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Write a review'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.patient.bg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buildSortBy(),
          const SizedBox(height: 24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) => _buildReviewItem(),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSummary() {
    final colors = AppTheme.colors(context);
    return Row(
      children: [
        Column(
          children: [
            Text(
              '4.8',
              style: AppTextStyles.inter32M.copyWith(
                color: colors.neutral.primaryText,
              ),
            ),
            Row(
              children: List.generate(
                5,
                (index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '264 reviews',
              style: AppTextStyles.interP12R.copyWith(
                color: colors.patient.bg,
              ),
            ),
          ],
        ),
        const SizedBox(width: 32),
        Expanded(
          child: Column(
            children: List.generate(5, (index) {
              final rating = 5 - index;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 0.8 / rating, // Placeholder
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colors.patient.bg,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSortBy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sort by', style: AppTextStyles.interP16M),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSortChip('Most relevant', true),
            const SizedBox(width: 8),
            _buildSortChip('Newest', false),
            const SizedBox(width: 8),
            _buildSortChip('Highest', false, hasStar: true),
          ],
        ),
      ],
    );
  }

  Widget _buildSortChip(String label, bool isSelected, {bool hasStar = false}) {
    final colors = AppTheme.colors(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? colors.patient.bg.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? colors.patient.bg : colors.neutral.border,
        ),
      ),
      child: Row(
        children: [
          if (isSelected)
            Icon(Icons.check, size: 16, color: colors.patient.bg)
          else if (hasStar)
            const Icon(Icons.star, size: 16, color: Colors.grey),
          if (isSelected || hasStar) const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.interP14M.copyWith(
              color: isSelected ? colors.patient.bg : colors.neutral.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem() {
    final colors = AppTheme.colors(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/metformin_merck.png'), // Placeholder
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jane Y', style: AppTextStyles.interP14M),
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '16/06/2025',
                        style: AppTextStyles.interP12R.copyWith(
                          color: colors.neutral.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Ear infection resolved in three days; friendly pediatric suspension for my child.',
            style: AppTextStyles.interP14R.copyWith(
              color: colors.neutral.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '22 people found this helpful',
            style: AppTextStyles.interP12R.copyWith(
              color: colors.neutral.secondaryText,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Was this review helpful?',
                style: AppTextStyles.interP12R,
              ),
              const Spacer(),
              Text('Yes', style: AppTextStyles.interP12M),
              const SizedBox(width: 16),
              Text('No', style: AppTextStyles.interP12M),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottomBar() {
    final colors = AppTheme.colors(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New-Health Pharmacy Ltd',
                      style: AppTextStyles.interP16M,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'In stock • 20 left',
                          style: AppTextStyles.interP12R.copyWith(
                            color: colors.neutral.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Closed • Opens 8 am Mon • 900 m',
                      style: AppTextStyles.interP12R.copyWith(
                        color: colors.neutral.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₦2,500',
                style: AppTextStyles.interP20M.copyWith(
                  color: colors.neutral.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Directions',
                  AppIcons.directions,
                  colors.patient.bg,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Call',
                  AppIcons.phone,
                  colors.patient.bg,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'view',
                  AppIcons.eyeOpen,
                  colors.patient.bg,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, String icon, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.interP14M.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
