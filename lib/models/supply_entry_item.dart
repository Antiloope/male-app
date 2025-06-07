import 'package:male_naturapp/models/product.dart';

class SupplyEntryItem {
  final Product product;
  final int quantity;

  SupplyEntryItem({
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return 'SupplyEntryItem{product: ${product.name}, quantity: $quantity}';
  }
} 