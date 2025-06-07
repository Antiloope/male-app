import 'product.dart';

class StockItem {
  final int id;
  final int productId;
  final int quantity;
  final double price;
  final DateTime lastUpdated;
  final Product? product;

  StockItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.lastUpdated,
    this.product,
  });

  String get name => product?.name ?? 'Producto desconocido';
  String get description => product?.description ?? '';
  int get categoryId => product?.category ?? 0;
} 