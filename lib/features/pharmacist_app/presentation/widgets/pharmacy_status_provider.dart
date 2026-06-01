import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/data/models/pharmacy_model.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';

enum PharmacySetupStatus {
  complete,
  registrationIncomplete,
  pendingVerification,
}

final currentPharmacyProvider = FutureProvider<Pharmacy?>((ref) async {
  final pharmacyId = await ref.watch(currentPharmacyIdProvider.future);
  if (pharmacyId == null) return null;

  final getPharmacy = ref.watch(getPharmacyInfoUseCaseProvider);
  return getPharmacy(pharmacyId);
});

final currentPharmacyStatusProvider =
    FutureProvider<PharmacySetupStatus>((ref) async {
  final storageLayer = ref.watch(hiveStorageLayerProvider);
  final user = ref.watch(currentUserProvider);

  if (user == null || user.userType != UserType.pharmacist) {
    return PharmacySetupStatus.complete;
  }

  Map<String, dynamic>? businessData;

  try {
    businessData = await storageLayer.get('current_business');
  } catch (_) {}

  if (businessData == null || businessData.isEmpty) {
    final pharmacyId = await ref.watch(currentPharmacyIdProvider.future);
    if (pharmacyId == null) {
      return PharmacySetupStatus.registrationIncomplete;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('businesses')
          .doc(pharmacyId)
          .get();
      if (doc.exists) {
        businessData = doc.data();
      }
    } catch (_) {}
  }

  if (businessData == null || businessData.isEmpty) {
    return PharmacySetupStatus.registrationIncomplete;
  }

  final pharmacy = PharmacyModel.fromJson(businessData);

  if (!pharmacy.hasCompletedRegistration) {
    return PharmacySetupStatus.registrationIncomplete;
  }

  if (!pharmacy.isVerified) {
    return PharmacySetupStatus.pendingVerification;
  }

  return PharmacySetupStatus.complete;
});
