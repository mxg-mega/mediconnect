import 'package:mediconnect/common/auth/data/datasources/pharmacy_data_source.dart';
import 'package:mediconnect/common/auth/data/models/pharmacy_model.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/common/auth/domain/repositories/pharmacy_repository.dart';

class PharmacyRepositoryImpl implements PharmacyRepository {
  final PharmacyDataSource remoteDataSource;

  PharmacyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Pharmacy> getPharmacyInfo(String pharmacyId) async {
    final model = await remoteDataSource.getPharmacyInfo(pharmacyId);
    return model.toEntity();
  }

  @override
  Future<List<String>> getEmployeeIds(String pharmacyId) async {
    return await remoteDataSource.getEmployeeIds(pharmacyId);
  }

  @override
  Future<void> updatePharmacyInfo(Pharmacy pharmacy) async {
    await remoteDataSource.updatePharmacyInfo(PharmacyModel.fromEntity(pharmacy));
  }

  @override
  Future<Pharmacy> createPharmacy(Pharmacy pharmacy, String ownerUid, String role) async {
    final model = PharmacyModel.fromEntity(pharmacy);
    final created = await remoteDataSource.createPharmacy(model, ownerUid, role);
    return created.toEntity();
  }

  @override
  Future<Pharmacy?> syncLinkedPharmacyForUser(String uid) async {
    final model = await remoteDataSource.syncLinkedPharmacyForUser(uid);
    return model?.toEntity();
  }

  @override
  Future<void> clearPharmacyCache() async {
    await remoteDataSource.clearPharmacyCache();
  }
}
