import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediconnect/common/auth/data/datasources/storage_layer.dart';
import 'package:mediconnect/features/patient_app/domain/entities/patient_activity_item.dart';
import 'package:mediconnect/features/patient_app/domain/repositories/patient_activity_repository.dart';

class PatientActivityRepositoryImpl implements PatientActivityRepository {
  final StorageLayer localDataSource;
  final FirebaseFirestore firestore;
  final String userId;

  static const String _localRecentActivityKey = 'patient_recent_activity';

  PatientActivityRepositoryImpl({
    required this.localDataSource,
    required this.firestore,
    required this.userId,
  });

  @override
  Future<List<PatientActivityItem>> getRecentActivity() async {
    try {
      final data = await localDataSource.get(_localRecentActivityKey);
      final List<dynamic> itemsList = data['items'] ?? [];
      return itemsList.map((e) => PatientActivityItem.fromJson(Map<String, dynamic>.from(e))).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (_) {
      return []; // Return empty if not found
    }
  }

  @override
  Future<void> addRecentActivity(PatientActivityItem item) async {
    final currentActivity = await getRecentActivity();
    
    // Remove if exists to push to top
    currentActivity.removeWhere((e) => e.id == item.id && e.type == item.type);
    
    currentActivity.insert(0, item);
    
    // Keep only last 50 items to prevent bloat
    if (currentActivity.length > 50) {
      currentActivity.removeLast();
    }

    await localDataSource.put(_localRecentActivityKey, {
      'items': currentActivity.map((e) => e.toJson()).toList(),
    });
  }

  @override
  Future<void> removeRecentActivity(String id) async {
    final currentActivity = await getRecentActivity();
    currentActivity.removeWhere((e) => e.id == id);
    
    await localDataSource.put(_localRecentActivityKey, {
      'items': currentActivity.map((e) => e.toJson()).toList(),
    });
  }

  @override
  Future<void> clearRecentActivity() async {
    await localDataSource.delete(_localRecentActivityKey);
  }

  @override
  Future<List<PatientActivityItem>> getFavorites() async {
    if (userId.isEmpty) return [];
    
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return PatientActivityItem.fromJson(data);
    }).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<void> toggleFavorite(PatientActivityItem item) async {
    if (userId.isEmpty) return;

    final docRef = firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc('${item.type.name}_${item.id}');

    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
    } else {
      final newItem = item.copyWith(isFavorite: true, timestamp: DateTime.now());
      await docRef.set(newItem.toJson());
    }
  }
}
