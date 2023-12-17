class Product {
  int? id;
  final String? externalId;
  final String productName;
  final String productDescription;
  final int category;

  Product({
    this.id,
    required this.externalId,
    required this.productName,
    required this.productDescription,
    required this.category,
  });
}