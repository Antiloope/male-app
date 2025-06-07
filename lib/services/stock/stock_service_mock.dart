import 'package:male_naturapp/models/stock_item.dart';
import 'package:male_naturapp/models/product.dart';
import 'package:male_naturapp/models/product_category.dart';
import 'stock_service.dart';

class MockStockService implements StockService {
  
  // Datos mock de categorías
  static final List<ProductCategory> _mockCategories = [
    ProductCategory(id: 1, name: 'Aceites'),
    ProductCategory(id: 2, name: 'Mieles'),
    ProductCategory(id: 3, name: 'Cosméticos'),
    ProductCategory(id: 4, name: 'Tés'),
  ];

  // Datos mock de productos
  static final List<Product> _mockProducts = [
    Product(id: 1, name: 'Aceite de oliva virgen extra', description: 'Aceite premium de primera extracción', category: 1),
    Product(id: 2, name: 'Miel de lavanda', description: 'Miel natural con aroma a lavanda', category: 2),
    Product(id: 3, name: 'Shampoo orgánico', description: 'Shampoo sin sulfatos para todo tipo de cabello', category: 3),
    Product(id: 4, name: 'Té verde matcha', description: 'Té matcha orgánico de alta calidad', category: 4),
    Product(id: 5, name: 'Aceite esencial de romero', description: 'Aceite puro para aromaterapia', category: 1),
    Product(id: 6, name: 'Crema facial hidratante', description: 'Crema natural con aloe vera', category: 3),
  ];

  // Datos mock de stock
  static final List<StockItem> _mockStockItems = [
    StockItem(
      id: 1,
      productId: 1,
      quantity: 45,
      price: 15.50,
      lastUpdated: DateTime.now().subtract(Duration(days: 2)),
      product: _mockProducts[0],
    ),
    StockItem(
      id: 2,
      productId: 2,
      quantity: 23,
      price: 12.80,
      lastUpdated: DateTime.now().subtract(Duration(days: 1)),
      product: _mockProducts[1],
    ),
    StockItem(
      id: 3,
      productId: 3,
      quantity: 8,
      price: 18.90,
      lastUpdated: DateTime.now().subtract(Duration(days: 3)),
      product: _mockProducts[2],
    ),
    StockItem(
      id: 4,
      productId: 4,
      quantity: 67,
      price: 24.50,
      lastUpdated: DateTime.now().subtract(Duration(hours: 12)),
      product: _mockProducts[3],
    ),
    StockItem(
      id: 5,
      productId: 5,
      quantity: 3,
      price: 22.00,
      lastUpdated: DateTime.now().subtract(Duration(days: 5)),
      product: _mockProducts[4],
    ),
    StockItem(
      id: 6,
      productId: 6,
      quantity: 15,
      price: 28.75,
      lastUpdated: DateTime.now().subtract(Duration(days: 4)),
      product: _mockProducts[5],
    ),
  ];

  @override
  Future<List<StockItem>> getAllStockItems() async {
    await Future.delayed(Duration(milliseconds: 500)); // Simular latencia
    return _mockStockItems;
  }

  @override
  Future<StockItem?> getStockItemById(int id) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _mockStockItems.firstWhere((item) => item.id == id);
  }

  @override
  Future<StockItem?> getStockItemByProductId(int productId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _mockStockItems.firstWhere((item) => item.productId == productId);
  }

  @override
  Future<void> updateQuantity(int id, int newQuantity) async {
    await Future.delayed(Duration(milliseconds: 300));
    final itemIndex = _mockStockItems.indexWhere((item) => item.id == id);
    if (itemIndex != -1) {
      // En una implementación real, actualizarías la base de datos
      print('Actualizada cantidad del item $id a $newQuantity');
    }
  }

  @override
  Future<void> updatePrice(int id, double newPrice) async {
    await Future.delayed(Duration(milliseconds: 300));
    final itemIndex = _mockStockItems.indexWhere((item) => item.id == id);
    if (itemIndex != -1) {
      // En una implementación real, actualizarías la base de datos
      print('Actualizado precio del item $id a $newPrice');
    }
  }

  @override
  Future<void> addStockItem(StockItem stockItem) async {
    await Future.delayed(Duration(milliseconds: 300));
    // En una implementación real, guardarías en la base de datos
    print('Agregado nuevo item de stock: ${stockItem.name}');
  }

  @override
  Future<void> deleteStockItem(int id) async {
    await Future.delayed(Duration(milliseconds: 300));
    // En una implementación real, eliminarías de la base de datos
    print('Eliminado item de stock con id: $id');
  }

  // Método auxiliar para obtener el nombre de la categoría
  static String getCategoryName(int categoryId) {
    final category = _mockCategories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => ProductCategory(name: 'Sin categoría'),
    );
    return category.name;
  }
}