import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';
import 'package:mediconnect/features/patient_app/data/repositories/patient_activity_repository_impl.dart';
import 'package:mediconnect/features/patient_app/domain/entities/patient_activity_item.dart';
import 'package:mediconnect/features/patient_app/domain/repositories/patient_activity_repository.dart';

final patientActivityRepositoryProvider = Provider<PatientActivityRepository>((ref) {
  final storageLayer = ref.watch(storageLayerProvider);
  final user = ref.watch(currentUserProvider);
  return PatientActivityRepositoryImpl(
    localDataSource: storageLayer,
    firestore: FirebaseFirestore.instance,
    userId: user?.id ?? '',
  );
});

final recentActivityProvider = FutureProvider<List<PatientActivityItem>>((ref) async {
  final repository = ref.watch(patientActivityRepositoryProvider);
  return await repository.getRecentActivity();
});

final favoritesActivityProvider = FutureProvider<List<PatientActivityItem>>((ref) async {
  final repository = ref.watch(patientActivityRepositoryProvider);
  return await repository.getFavorites();
});

class ActivityNotifier extends StateNotifier<void> {
  final Ref ref;

  ActivityNotifier(this.ref) : super(null);

  Future<void> logActivity(PatientActivityItem item) async {
    final repo = ref.read(patientActivityRepositoryProvider);
    await repo.addRecentActivity(item);
    ref.invalidate(recentActivityProvider);
  }

  Future<void> removeRecentActivity(String id) async {
    final repo = ref.read(patientActivityRepositoryProvider);
    await repo.removeRecentActivity(id);
    ref.invalidate(recentActivityProvider);
  }

  Future<void> clearAllRecent() async {
    final repo = ref.read(patientActivityRepositoryProvider);
    await repo.clearRecentActivity();
    ref.invalidate(recentActivityProvider);
  }

  Future<void> toggleFavorite(PatientActivityItem item) async {
    final repo = ref.read(patientActivityRepositoryProvider);
    await repo.toggleFavorite(item);
    ref.invalidate(favoritesActivityProvider);
  }
}

final activityNotifierProvider = StateNotifierProvider<ActivityNotifier, void>((ref) {
  return ActivityNotifier(ref);
});
