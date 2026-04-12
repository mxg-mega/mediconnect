import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/dispense_record.dart';
import 'package:mediconnect/features/pharmacist_app/domain/repositories/dispense_repository.dart';

class DispenseRepositoryImpl implements DispenseRepository {
  final FirebaseFirestore _firestore;

  DispenseRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> recordDispense(DispenseRecord record) async {
    // In a real app, you would use a transaction here to update inventory stock
    // and record the dispense record simultaneously.
    // For now, we record the dispense.
    await _firestore.collection('dispense_records').doc(record.id).set(record.toJson());
  }

  @override
  Stream<List<DispenseRecord>> getDispenseHistory(String pharmacyId) {
    return _firestore
        .collection('dispense_records')
        .where('pharmacy_id', isEqualTo: pharmacyId) // Assuming pharmacy_id is added to model or stored in metadata
        .orderBy('recorded_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => DispenseRecord.fromJson(doc.data())).toList();
    });
  }

  @override
  Future<DispenseRecord?> getDispenseById(String id) async {
    final doc = await _firestore.collection('dispense_records').doc(id).get();
    if (!doc.exists) return null;
    return DispenseRecord.fromJson(doc.data()!);
  }
}
