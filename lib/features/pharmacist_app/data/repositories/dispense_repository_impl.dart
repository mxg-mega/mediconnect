import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/dispense_record.dart';
import 'package:mediconnect/features/pharmacist_app/domain/repositories/dispense_repository.dart';

class DispenseRepositoryImpl implements DispenseRepository {
  final FirebaseFirestore _firestore;

  DispenseRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> recordDispense(DispenseRecord record) async {
    await _firestore
        .collection('businesses')
        .doc(record.pharmacyId)
        .collection('dispense_records')
        .doc(record.id)
        .set(record.toJson());
  }

  @override
  Stream<List<DispenseRecord>> getDispenseHistory(String pharmacyId) {
    return _firestore
        .collection('businesses')
        .doc(pharmacyId)
        .collection('dispense_records')
        .orderBy('recorded_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => DispenseRecord.fromJson(doc.data()))
              .toList();
        });
  }

  @override
  Future<DispenseRecord?> getDispenseById(String id) async {
    final querySnapshot = await _firestore
        .collectionGroup('dispense_records')
        .where('id', isEqualTo: id)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;
    return DispenseRecord.fromJson(querySnapshot.docs.first.data());
  }
}
