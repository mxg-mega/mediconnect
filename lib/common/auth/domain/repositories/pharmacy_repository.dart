import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';

abstract class PharmacyRepository {
  Future<Pharmacy> getPharmacyInfo(String pharmacyId);
  Future<List<String>> getEmployeeIds(String pharmacyId);
  Future<void> updatePharmacyInfo(Pharmacy pharmacy);
  Future<Pharmacy> createPharmacy(Pharmacy pharmacy, String ownerUid, String role);
}
