class Medication {
  final String id;
  final String name;
  final String brand;
  final String manufacturer;
  final int stock;
  final String packSize;
  final double price;
  final String? imageUrl;

  Medication({
    required this.id,
    required this.name,
    required this.brand,
    required this.manufacturer,
    required this.stock,
    required this.packSize,
    required this.price,
    this.imageUrl,
  });
}
