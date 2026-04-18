import 'package:mediconnect/common/auth/data/models/pharmacy_model.dart';

abstract class PharmacyDataSource {
  Future<PharmacyModel> getPharmacyInfo(String pharmacyId);
  Future<List<String>> getEmployeeIds(String pharmacyId);
  Future<void> updatePharmacyInfo(PharmacyModel pharmacy);
  Future<PharmacyModel> createPharmacy(PharmacyModel pharmacy, String ownerUid, String role);
}
