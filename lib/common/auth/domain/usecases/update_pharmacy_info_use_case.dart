import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/common/auth/domain/repositories/pharmacy_repository.dart';

class UpdatePharmacyInfoUseCase {
  final PharmacyRepository repository;

  UpdatePharmacyInfoUseCase(this.repository);

  Future<void> call(Pharmacy pharmacy) async {
    await repository.updatePharmacyInfo(pharmacy);
  }
}
