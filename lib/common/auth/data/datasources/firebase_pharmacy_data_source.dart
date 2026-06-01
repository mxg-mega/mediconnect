import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediconnect/common/auth/data/datasources/pharmacy_data_source.dart';
import 'package:mediconnect/common/auth/data/models/pharmacy_model.dart';
import 'package:mediconnect/common/auth/data/datasources/storage_layer.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

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
    final data = pharmacy.toJson();
    final geoFirePoint = GeoFirePoint(GeoPoint(pharmacy.location.latitude, pharmacy.location.longitude));
    data['geo'] = geoFirePoint.data;

    await _firestore.collection('businesses').doc(pharmacy.id).update(data);
    try {
      final ownerUid = pharmacy.employeeIds.isNotEmpty
          ? pharmacy.employeeIds.first
          : '';
      if (ownerUid.isNotEmpty) {
        await _putBusinessCache(pharmacy.toJson(), ownerUid);
      }
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
    
    final data = newPharmacy.toJson();
    final geoFirePoint = GeoFirePoint(GeoPoint(newPharmacy.location.latitude, newPharmacy.location.longitude));
    data['geo'] = geoFirePoint.data;

    batch.set(businessRef, data);

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
      await _putBusinessCache(newPharmacy.toJson(), ownerUid);
      await storageLayer.put('current_memberships', {'data': [membershipData]});
    } catch (_) {}
    
    return newPharmacy;
  }

  @override
  Future<void> clearPharmacyCache() async {
    try {
      await storageLayer.delete('current_business');
      await storageLayer.delete('current_memberships');
    } catch (_) {}
  }

  Future<void> _putBusinessCache(Map<String, dynamic> data, String ownerUid) async {
    final cache = Map<String, dynamic>.from(data);
    cache['owner_uid'] = ownerUid;
    await storageLayer.put('current_business', cache);
  }

  PharmacyModel _modelFromCache(Map<String, dynamic> data) {
    final copy = Map<String, dynamic>.from(data);
    copy.remove('owner_uid');
    copy.remove('geo');
    return PharmacyModel.fromJson(copy);
  }

  bool _cachedBusinessBelongsToUser(Map<String, dynamic> businessData, String uid) {
    final ownerUid = businessData['owner_uid']?.toString();
    if (ownerUid != null && ownerUid.isNotEmpty) {
      return ownerUid == uid;
    }
    final employeeIds = (businessData['employee_ids'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    return employeeIds.contains(uid);
  }

  @override
  Future<PharmacyModel?> syncLinkedPharmacyForUser(String uid) async {
    try {
      final businessData = await storageLayer.get('current_business');
      if (_cachedBusinessBelongsToUser(businessData, uid)) {
        return _modelFromCache(businessData);
      }
      await clearPharmacyCache();
    } catch (_) {
      await clearPharmacyCache();
    }

    final memberships = await _firestore
        .collection('users')
        .doc(uid)
        .collection('memberships')
        .limit(1)
        .get();

    if (memberships.docs.isEmpty) return null;

    final pharmacyId = memberships.docs.first.id;
    final doc = await _firestore.collection('businesses').doc(pharmacyId).get();
    if (!doc.exists) return null;

    final model = PharmacyModel.fromJson(doc.data()!);
    try {
      await _putBusinessCache(model.toJson(), uid);
    } catch (_) {}
    return model;
  }
}
