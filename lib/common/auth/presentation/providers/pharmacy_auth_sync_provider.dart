import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dashboard/dashboard_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_entry/providers/dispense_entry_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_history/providers/dispense_history_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/medication_catalog/providers/medication_catalog_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/widgets/pharmacy_status_provider.dart';

void invalidatePharmacyProviders(Ref ref) {
  ref.invalidate(currentPharmacyIdProvider);
  ref.invalidate(currentPharmacyProvider);
  ref.invalidate(currentPharmacyStatusProvider);
}

/// Clears pharmacist-scoped Riverpod state so inventory/dispense/dashboard
/// cannot leak across logout/login in the same app session.
void resetPharmacistSessionProviders(Ref ref) {
  invalidatePharmacyProviders(ref);
  ref.invalidate(inventoryProvider);
  ref.invalidate(dispenseHistoryProvider);
  ref.invalidate(dashboardProvider);
  ref.invalidate(dispenseEntryProvider);
  ref.invalidate(medicationCatalogProvider);
}

/// Watches auth changes and resets pharmacy + pharmacist feature providers.
final pharmacyAuthSyncProvider = Provider<void>((ref) {
  ref.listen(
    authProvider.select((s) => s.user?.id),
    (previous, next) {
      if (previous != next) {
        resetPharmacistSessionProviders(ref);
      }
    },
  );

  ref.listen(
    authProvider.select((s) => s.status),
    (previous, next) {
      if (previous == AuthStatus.loading &&
          next == AuthStatus.authenticated) {
        resetPharmacistSessionProviders(ref);
      }
    },
  );
});
