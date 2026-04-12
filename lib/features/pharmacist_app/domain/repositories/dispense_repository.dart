import 'package:mediconnect/features/pharmacist_app/domain/models/dispense_record.dart';

abstract class DispenseRepository {
  Future<void> recordDispense(DispenseRecord record);
  Stream<List<DispenseRecord>> getDispenseHistory(String pharmacyId);
  Future<DispenseRecord?> getDispenseById(String id);
}
