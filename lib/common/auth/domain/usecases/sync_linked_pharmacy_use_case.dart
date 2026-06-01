import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/common/auth/domain/repositories/pharmacy_repository.dart';

class SyncLinkedPharmacyUseCase {
  final PharmacyRepository pharmacyRepository;

  SyncLinkedPharmacyUseCase({required this.pharmacyRepository});

  /// Fetches the user's linked pharmacy from Firestore memberships,
  /// validates/clears stale Hive cache, and returns the synced pharmacy.
  Future<Pharmacy?> call(String uid) async {
    return pharmacyRepository.syncLinkedPharmacyForUser(uid);
  }
}
