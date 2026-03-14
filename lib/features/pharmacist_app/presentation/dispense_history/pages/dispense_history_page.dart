import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/dispense_record.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_history/widgets/dispense_record_card.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_history/widgets/filter_bottom_sheet.dart';

class DispenseHistoryPage extends ConsumerStatefulWidget {
  const DispenseHistoryPage({super.key});

  @override
  ConsumerState<DispenseHistoryPage> createState() =>
      _DispenseHistoryPageState();
}

class _DispenseHistoryPageState extends ConsumerState<DispenseHistoryPage> {
  final TextEditingController _searchController = TextEditingController();

  // Dummy data
  final List<DispenseRecord> dummyRecords = [
    DispenseRecord(
      id: '1',
      saleId: '-S-20260106-0001',
      recordedByRole: 'Staff',
      recordedByName: 'Yusuf A.',
      recordedAt: DateTime(2026, 1, 6, 20, 47, 10),
      totalAmount: 8500,
      items: [
        DispensedItem(
          medicationName: 'Amoxicillin 500 mg',
          brandName: 'Amoxil',
          manufacturer: 'GSK',
          isBrand: true,
          quantity: 2,
          unitPrice: 2500,
          totalPrice: 5000,
        ),
        DispensedItem(
          medicationName: 'Ibuprofen 500mg',
          brandName: 'Advil',
          manufacturer: 'Pfizer',
          isBrand: true,
          quantity: 1,
          unitPrice: 3500,
          totalPrice: 3500,
        ),
      ],
    ),
    DispenseRecord(
      id: '2',
      saleId: '-S-20260106-0002',
      recordedByRole: 'Staff',
      recordedByName: 'Yusuf A.',
      recordedAt: DateTime(2026, 1, 6, 19, 03, 40),
      totalAmount: 4700,
      items: [
        DispensedItem(
          medicationName: 'Panadol 500 mg',
          brandName: 'Panadol',
          manufacturer: 'GSK',
          isBrand: true,
          quantity: 2,
          unitPrice: 1000,
          totalPrice: 2000,
        ),
      ],
    ),
    DispenseRecord(
      id: '3',
      saleId: '-S-20260105-0001',
      recordedByRole: 'Staff',
      recordedByName: 'Yusuf A.',
      recordedAt: DateTime(2026, 1, 5, 15, 24, 40),
      totalAmount: 8500,
      items: [],
    ),
    DispenseRecord(
      id: '4',
      saleId: '-S-20251219-0001',
      recordedByRole: 'Staff',
      recordedByName: 'Yusuf A.',
      recordedAt: DateTime(2025, 12, 19, 15, 24, 40),
      totalAmount: 8500,
      items: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);

    // Grouping records by Month for dummy purpose
    final groupedRecords = _groupRecords(dummyRecords);

    return AppScaffold(
      hasAppBar: true,
      removeBodyPadding: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Dispense History',
          style: AppTextStyles.interP18M.copyWith(
            color: theme.neutral.primaryText,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AppIcons.export,
              width: 24,
              colorFilter: ColorFilter.mode(
                theme.neutral.primaryText,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              context.push('/pharmacist/dispense-history/export');
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.figmaWidth(20),
                ),
                child: Text(
                  'Show recent dispense record. Tap a record to open its Dispense Record',
                  style: AppTextStyles.interP14R.copyWith(
                    color: theme.neutral.secondaryText,
                  ),
                ),
              ),
              SizedBox(height: context.figmaHeight(20)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.figmaWidth(20),
                ),
                child: SearchBar(
                  controller: _searchController,
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
                  hintText: 'Search by Sale ID or Name',
                  hintStyle: WidgetStateProperty.all(
                    AppTextStyles.interP14R.copyWith(
                      color: theme.neutral.secondaryText.withOpacity(0.5),
                    ),
                  ),
                  trailing: [
                    IconButton(
                      icon: SvgPicture.asset(
                        AppIcons.filter,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                          theme.neutral.secondaryText,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () => _showFilterBottomSheet(context),
                    ),
                  ],
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  elevation: WidgetStateProperty.all(0),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        context.figmaWidth(8),
                      ),
                      side: BorderSide(
                        color: theme.neutral.border.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.figmaHeight(24)),
              Expanded(
                child: dummyRecords.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.figmaWidth(20),
                        ),
                        itemCount: groupedRecords.length,
                        itemBuilder: (context, index) {
                          final group = groupedRecords[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDateHeader(context, group.header),
                              SizedBox(height: context.figmaHeight(16)),
                              ...group.records.map(
                                (record) => DispenseRecordCard(
                                  record: record,
                                  onTap: () {
                                    context.push(
                                      '/pharmacist/dispense-history/receipt',
                                      extra: record,
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
          Positioned(
            bottom: context.figmaHeight(20),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.figmaWidth(20)),
              child: KElevatedButton(
                onPressed: () {
                  context.push('/pharmacist/dispense-history/export');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppIcons.export,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                        theme.neutral.buttonTextWhite,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: context.figmaWidth(8)),
                    const Text('Export'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context, String title) {
    final theme = AppTheme.colors(context);
    return Row(
      children: [
        SvgPicture.asset(
          AppIcons.calendar,
          width: 20,
          colorFilter: ColorFilter.mode(
            theme.neutral.primaryText,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: context.figmaWidth(8)),
        Text(
          title,
          style: AppTextStyles.interP16M.copyWith(
            color: theme.neutral.primaryText,
          ),
        ),
        const Icon(Icons.arrow_drop_down),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = AppTheme.colors(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration placeholder
          Container(
            width: context.figmaWidth(200),
            height: context.figmaHeight(200),
            decoration: BoxDecoration(
              color: theme.neutral.bgTint,
              borderRadius: BorderRadius.circular(context.figmaWidth(20)),
            ),
            child: Center(
              child: Icon(
                Icons.assignment_outlined,
                size: 100,
                color: theme.neutral.secondaryText.withOpacity(0.2),
              ),
            ),
          ),
          SizedBox(height: context.figmaHeight(24)),
          Text(
            'No dispenses recorded yet',
            style: AppTextStyles.interP16M.copyWith(
              color: theme.neutral.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  List<_RecordGroup> _groupRecords(List<DispenseRecord> records) {
    // Simplified grouping for dummy data
    // In a real app, this would be more dynamic
    final todayRecords = records
        .where(
          (r) =>
              r.recordedAt.year == 2026 &&
              r.recordedAt.month == 1 &&
              r.recordedAt.day == 6,
        )
        .toList();
    final janRecords = records
        .where(
          (r) =>
              r.recordedAt.year == 2026 &&
              r.recordedAt.month == 1 &&
              r.recordedAt.day != 6,
        )
        .toList();
    final decRecords = records
        .where((r) => r.recordedAt.year == 2025 && r.recordedAt.month == 12)
        .toList();

    return [
      if (todayRecords.isNotEmpty)
        _RecordGroup(header: 'Today', records: todayRecords),
      if (janRecords.isNotEmpty)
        _RecordGroup(header: 'Jan', records: janRecords),
      if (decRecords.isNotEmpty)
        _RecordGroup(header: 'Dec', records: decRecords),
    ];
  }
}

class _RecordGroup {
  final String header;
  final List<DispenseRecord> records;

  _RecordGroup({required this.header, required this.records});
}
