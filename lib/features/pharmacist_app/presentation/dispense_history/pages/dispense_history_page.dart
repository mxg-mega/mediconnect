import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/dispense_record.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_history/providers/dispense_history_provider.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    final historyState = ref.watch(dispenseHistoryProvider);
    final records = historyState.filteredRecords;
    final groupedRecords = _groupRecords(records);

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
                      color: theme.neutral.secondaryText.withValues(alpha: 0.5),
                    ),
                  ),
                  onChanged: (value) {
                    ref.read(dispenseHistoryProvider.notifier).updateSearch(value);
                  },
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
                        color: theme.neutral.border.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.figmaHeight(24)),
              Expanded(
                child: historyState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : records.isEmpty
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
                color: theme.neutral.secondaryText.withValues(alpha: 0.2),
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
    if (records.isEmpty) return [];

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final monthFormat = DateFormat('MMM yyyy');

    final todayRecords = records
        .where((r) => r.recordedAt.isAfter(todayStart))
        .toList();

    final olderRecords = records
        .where((r) => !r.recordedAt.isAfter(todayStart))
        .toList();

    // Group older records by month
    final Map<String, List<DispenseRecord>> monthGroups = {};
    for (final record in olderRecords) {
      final key = monthFormat.format(record.recordedAt);
      monthGroups.putIfAbsent(key, () => []).add(record);
    }

    return [
      if (todayRecords.isNotEmpty)
        _RecordGroup(header: 'Today', records: todayRecords),
      ...monthGroups.entries.map(
        (entry) => _RecordGroup(header: entry.key, records: entry.value),
      ),
    ];
  }
}

class _RecordGroup {
  final String header;
  final List<DispenseRecord> records;

  _RecordGroup({required this.header, required this.records});
}
