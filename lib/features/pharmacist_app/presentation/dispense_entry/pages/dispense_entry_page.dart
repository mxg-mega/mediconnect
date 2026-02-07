import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_entry/providers/dispense_entry_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_entry/widgets/medication_search_result_tile.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_entry/widgets/recorded_by_section.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_entry/widgets/selected_medication_card.dart';

class DispenseEntryPage extends ConsumerWidget {
  const DispenseEntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.colors(context);
    final dispenseState = ref.watch(dispenseEntryProvider);
    final dispenseNotifier = ref.read(dispenseEntryProvider.notifier);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Dispense Entry'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create a new dispense record and log items sold. Stock will be deducted automatically.',
              style: AppTextStyles.interP16R.copyWith(
                color: theme.neutral.secondaryText,
              ),
            ),
            const SizedBox(height: 16),
            SearchBar(
              hintText: 'Search Medications by name, brand or strength',
              onChanged: (value) {
                dispenseNotifier.updateSearchQuery(value);
              },
            ),
            const SizedBox(height: 24),
            if (dispenseState.searchQuery.isNotEmpty && dispenseNotifier.searchResults.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dispenseNotifier.searchResults.length,
                itemBuilder: (context, index) {
                  final medication = dispenseNotifier.searchResults[index];
                  return MedicationSearchResultTile(
                    medication: medication,
                    onTap: () {
                      dispenseNotifier.addMedication(medication);
                    },
                  );
                },
              )
            else if (dispenseState.selectedMedications.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected Items',
                        style: AppTextStyles.interP18M.copyWith(
                          color: theme.neutral.primaryText,
                        ),
                      ),
                      Text(
                        '${dispenseState.selectedMedications.length} Item${dispenseState.selectedMedications.length > 1 ? 's' : ''}',
                        style: AppTextStyles.interP14M.copyWith(
                          color: theme.pharmacist.bg,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dispenseState.selectedMedications.length,
                    itemBuilder: (context, index) {
                      final medication = dispenseState.selectedMedications[index];
                      return SelectedMedicationCard(medication: medication);
                    },
                  ),
                  const SizedBox(height: 24),
                  const RecordedBySection(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement save dispense logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Dispense Saved! (Not really)'))
                        );
                      },
                      child: const Text('Save Dispense'),
                    ),
                  ),
                ],
              )
            else
              const SizedBox.shrink(), // Or some empty state widget
          ],
        ),
      ),
    );
  }
}
