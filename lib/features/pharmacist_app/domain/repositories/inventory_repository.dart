import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';

abstract class InventoryRepository {
  Stream<List<InventoryItem>> getInventory(String pharmacyId);
  Future<void> addInventoryItem(InventoryItem item);
  Future<void> updateInventoryItem(InventoryItem item);
  Future<void> deleteInventoryItem(String id);
  Future<InventoryItem?> getInventoryItemById(String id);
}
