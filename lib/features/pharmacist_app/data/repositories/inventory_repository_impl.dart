import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';
import 'package:mediconnect/features/pharmacist_app/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final FirebaseFirestore _firestore;

  InventoryRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _inventoryRef(String pharmacyId) =>
      _firestore.collection('businesses').doc(pharmacyId).collection('inventory');

  @override
  Stream<List<InventoryItem>> getInventory(String pharmacyId) {
    return _inventoryRef(pharmacyId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => InventoryItem.fromJson(doc.data())).toList();
    });
  }

  @override
  Future<void> addInventoryItem(InventoryItem item) async {
    await _inventoryRef(item.pharmacyId).doc(item.id).set(item.toJson());
  }

  @override
  Future<void> updateInventoryItem(InventoryItem item) async {
    await _inventoryRef(item.pharmacyId).doc(item.id).update(item.toJson());
  }

  @override
  Future<void> deleteInventoryItem(String id) async {
    // Note: This requires pharmacyId context. In a real repository, 
    // we might need to pass it or have it in the repository state.
    // For now, we search across all pharmacies or assume a single one.
    final query = await _firestore.collectionGroup('inventory').where('id', isEqualTo: id).get();
    for (var doc in query.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<InventoryItem?> getInventoryItemById(String id) async {
    final query = await _firestore.collectionGroup('inventory').where('id', isEqualTo: id).limit(1).get();
    if (query.docs.isEmpty) return null;
    return InventoryItem.fromJson(query.docs.first.data());
  }
}
