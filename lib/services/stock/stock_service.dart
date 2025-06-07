import 'package:male_naturapp/models/stock_item.dart';

abstract class StockService {
  Future<List<StockItem>> getAllStockItems();
  Future<StockItem?> getStockItemById(int id);
  Future<StockItem?> getStockItemByProductId(int productId);
  Future<void> updateQuantity(int id, int newQuantity);
  Future<void> updatePrice(int id, double newPrice);
  Future<void> addStockItem(StockItem stockItem);
  Future<void> deleteStockItem(int id);
} 