class Product {
  int? id;
  final String? externalId;
  final String name;
  final String description;
  final int category;

  Product({
    this.id,
    this.externalId,
    required this.name,
    required this.description,
    required this.category,
  });
}