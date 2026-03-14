import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/common/auth/domain/repositories/pharmacy_repository.dart';

class GetPharmacyInfoUseCase {
  final PharmacyRepository pharmacyRepository;

  GetPharmacyInfoUseCase({required this.pharmacyRepository});

  Future<Pharmacy> call(String pharmacyId) async {
    // TODO: Implement pharmacy info retrieval
    // This will involve making HTTP request to /pharmacy/info endpoint
    // using the HttpStorageLayer for CRUD operations
    throw UnimplementedError('Pharmacy info retrieval not yet implemented');
  }
}
