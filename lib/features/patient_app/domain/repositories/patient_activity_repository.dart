import 'package:mediconnect/features/patient_app/domain/entities/patient_activity_item.dart';

abstract class PatientActivityRepository {
  Future<List<PatientActivityItem>> getRecentActivity();
  Future<void> addRecentActivity(PatientActivityItem item);
  Future<void> removeRecentActivity(String id);
  Future<void> clearRecentActivity();

  Future<List<PatientActivityItem>> getFavorites();
  Future<void> toggleFavorite(PatientActivityItem item);
}
