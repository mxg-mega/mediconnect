import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediconnect/common/auth/data/datasources/pharmacy_data_source.dart';
import 'package:mediconnect/common/auth/data/models/pharmacy_model.dart';
import 'package:mediconnect/common/auth/data/datasources/storage_layer.dart';

class FirebasePharmacyDataSource implements PharmacyDataSource {
  final FirebaseFirestore _firestore;
  final StorageLayer storageLayer;

  FirebasePharmacyDataSource({
    required this.storageLayer,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<PharmacyModel> getPharmacyInfo(String pharmacyId) async {
    final doc = await _firestore.collection('businesses').doc(pharmacyId).get();
    if (!doc.exists) {
      throw Exception('Pharmacy not found');
    }
    final model = PharmacyModel.fromJson(doc.data()!);
    try {
      await storageLayer.put('current_business', model.toJson());
    } catch (_) {}
    return model;
  }

  @override
  Future<List<String>> getEmployeeIds(String pharmacyId) async {
    final doc = await _firestore.collection('businesses').doc(pharmacyId).get();
    if (!doc.exists) return [];
    final data = doc.data()!;
    final List<dynamic> employees = data['employee_ids'] ?? [];
    return employees.map((e) => e.toString()).toList();
  }

  @override
  Future<void> updatePharmacyInfo(PharmacyModel pharmacy) async {
    await _firestore.collection('businesses').doc(pharmacy.id).update(pharmacy.toJson());
    try {
      await storageLayer.put('current_business', pharmacy.toJson());
    } catch (_) {}
  }

  @override
  Future<PharmacyModel> createPharmacy(PharmacyModel pharmacy, String ownerUid, String role) async {
    final batch = _firestore.batch();
    
    // Create new business ref
    final businessRef = _firestore.collection('businesses').doc();
    final newPharmacy = pharmacy.copyWith(
      id: businessRef.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      employeeIds: [ownerUid], // Adding the creator implicitly to employeeIds
    );
    batch.set(businessRef, newPharmacy.toJson());

    // Create membership
    final membershipRef = _firestore
        .collection('users')
        .doc(ownerUid)
        .collection('memberships')
        .doc(businessRef.id);
        
    final membershipData = {
      'bid': businessRef.id,
      'role': role,
      'joinedAt': DateTime.now().toIso8601String(),
    };
    batch.set(membershipRef, membershipData);

    await batch.commit();
    try {
      await storageLayer.put('current_business', newPharmacy.toJson());
      await storageLayer.put('current_memberships', {'data': [membershipData]});
    } catch (_) {}
    
    return newPharmacy;
  }
}
