import 'package:mediconnect/common/domain/entities/medication.dart';

abstract class MedicationCatalogRepository {
  Future<List<Medication>> searchMedications(String query);
  Future<Medication?> getMedicationDetails(String id);
}
