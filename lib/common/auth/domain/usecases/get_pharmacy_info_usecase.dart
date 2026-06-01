import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/common/auth/domain/repositories/pharmacy_repository.dart';

class GetPharmacyInfoUseCase {
  final PharmacyRepository pharmacyRepository;

  GetPharmacyInfoUseCase({required this.pharmacyRepository});

  Future<Pharmacy> call(String pharmacyId) async {
    return pharmacyRepository.getPharmacyInfo(pharmacyId);
  }
}
