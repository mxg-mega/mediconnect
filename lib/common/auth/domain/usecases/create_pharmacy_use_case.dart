import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/common/auth/domain/repositories/pharmacy_repository.dart';

class CreatePharmacyUseCase {
  final PharmacyRepository repository;

  CreatePharmacyUseCase(this.repository);

  Future<Pharmacy> call(Pharmacy pharmacy, String ownerUid, String role) async {
    return await repository.createPharmacy(pharmacy, ownerUid, role);
  }
}
