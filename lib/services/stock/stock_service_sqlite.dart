import 'package:male_naturapp/models/stock_item.dart';
import 'package:male_naturapp/models/product.dart';
import 'package:male_naturapp/services/stock/stock_service.dart';
import 'package:male_naturapp/services/product/product_service.dart';
import 'package:male_naturapp/services/product/product_service_provider.dart';
import 'package:male_naturapp/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class StockServiceSqlite implements StockService {

  static const String _stockIdColumnName = 'id';
  static const String _stockProductIdColumnName = 'product_id';
  static const String _stockQuantityColumnName = 'quantity';
  static const String _stockPriceColumnName = 'price';
  static const String _stockLastUpdatedColumnName = 'last_updated';

  static const String _stockTableName = 'stock_items';

  late final ProductService _productService;

  StockServiceSqlite() {
    _productService = DefaultProductServiceProvider.getDefaultProductService();
  }

  static void initializeTables(Database database, int version) {
    database.execute(
      'CREATE TABLE $_stockTableName('
          '$_stockIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT, '
          '$_stockProductIdColumnName INTEGER, '
          '$_stockQuantityColumnName INTEGER, '
          '$_stockPriceColumnName REAL, '
          '$_stockLastUpdatedColumnName TEXT, '
          'FOREIGN KEY ($_stockProductIdColumnName) REFERENCES products(id))',
    );
  }

  static void upgradeTables(Database database, int oldVersion, int newVersion) {
    if (oldVersion < 5) {
      database.execute(
        'CREATE TABLE $_stockTableName('
            '$_stockIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$_stockProductIdColumnName INTEGER, '
            '$_stockQuantityColumnName INTEGER, '
            '$_stockPriceColumnName REAL, '
            '$_stockLastUpdatedColumnName TEXT, '
            'FOREIGN KEY ($_stockProductIdColumnName) REFERENCES products(id))',
      );
    }
  }

  static Map<String, dynamic> stockItemToMap(StockItem stockItem) {
    return {
      _stockIdColumnName: stockItem.id,
      _stockProductIdColumnName: stockItem.productId,
      _stockQuantityColumnName: stockItem.quantity,
      _stockPriceColumnName: stockItem.price,
      _stockLastUpdatedColumnName: stockItem.lastUpdated.toIso8601String(),
    };
  }

  static StockItem mapToStockItem(Map<String, dynamic> map, {Product? product}) {
    return StockItem(
      id: map[_stockIdColumnName] as int,
      productId: map[_stockProductIdColumnName] as int,
      quantity: map[_stockQuantityColumnName] as int,
      price: map[_stockPriceColumnName] as double,
      lastUpdated: DateTime.parse(map[_stockLastUpdatedColumnName] as String),
      product: product,
    );
  }

  @override
  Future<List<StockItem>> getAllStockItems() async {
    Database database = DatabaseHelper().getConnection();

    // Join con la tabla de productos para obtener información completa
    final List<Map<String, dynamic>> maps = await database.rawQuery('''
      SELECT s.*, p.name, p.description, p.category, p.external_id
      FROM $_stockTableName s
      LEFT JOIN products p ON s.$_stockProductIdColumnName = p.id
      ORDER BY s.$_stockIdColumnName
    ''');

    return List.generate(maps.length, (i) {
      final map = maps[i];
      Product? product;
      
      if (map['name'] != null) {
        product = Product(
          id: map[_stockProductIdColumnName] as int,
          name: map['name'] as String,
          description: map['description'] as String,
          category: map['category'] as int,
          externalId: map['external_id'] as String?,
        );
      }
      
      return mapToStockItem(map, product: product);
    });
  }

  @override
  Future<StockItem?> getStockItemById(int id) async {
    Database database = DatabaseHelper().getConnection();

    final List<Map<String, dynamic>> maps = await database.rawQuery('''
      SELECT s.*, p.name, p.description, p.category, p.external_id
      FROM $_stockTableName s
      LEFT JOIN products p ON s.$_stockProductIdColumnName = p.id
      WHERE s.$_stockIdColumnName = ?
    ''', [id]);

    if (maps.isEmpty) return null;

    final map = maps[0];
    Product? product;
    
    if (map['name'] != null) {
      product = Product(
        id: map[_stockProductIdColumnName] as int,
        name: map['name'] as String,
        description: map['description'] as String,
        category: map['category'] as int,
        externalId: map['external_id'] as String?,
      );
    }

    return mapToStockItem(map, product: product);
  }

  @override
  Future<StockItem?> getStockItemByProductId(int productId) async {
    Database database = DatabaseHelper().getConnection();

    final List<Map<String, dynamic>> maps = await database.rawQuery('''
      SELECT s.*, p.name, p.description, p.category, p.external_id
      FROM $_stockTableName s
      LEFT JOIN products p ON s.$_stockProductIdColumnName = p.id
      WHERE s.$_stockProductIdColumnName = ?
    ''', [productId]);

    if (maps.isEmpty) return null;

    final map = maps[0];
    Product? product;
    
    if (map['name'] != null) {
      product = Product(
        id: map[_stockProductIdColumnName] as int,
        name: map['name'] as String,
        description: map['description'] as String,
        category: map['category'] as int,
        externalId: map['external_id'] as String?,
      );
    }

    return mapToStockItem(map, product: product);
  }

  @override
  Future<void> updateQuantity(int id, int newQuantity) async {
    Database database = DatabaseHelper().getConnection();

    await database.update(
      _stockTableName,
      {
        _stockQuantityColumnName: newQuantity,
        _stockLastUpdatedColumnName: DateTime.now().toIso8601String(),
      },
      where: '$_stockIdColumnName = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> updatePrice(int id, double newPrice) async {
    Database database = DatabaseHelper().getConnection();

    await database.update(
      _stockTableName,
      {
        _stockPriceColumnName: newPrice,
        _stockLastUpdatedColumnName: DateTime.now().toIso8601String(),
      },
      where: '$_stockIdColumnName = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> addStockItem(StockItem stockItem) async {
    Database database = DatabaseHelper().getConnection();

    final stockData = stockItemToMap(stockItem);
    stockData.remove(_stockIdColumnName); // Remover ID para auto-increment
    stockData[_stockLastUpdatedColumnName] = DateTime.now().toIso8601String();

    await database.insert(
      _stockTableName,
      stockData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteStockItem(int id) async {
    Database database = DatabaseHelper().getConnection();

    await database.delete(
      _stockTableName,
      where: '$_stockIdColumnName = ?',
      whereArgs: [id],
    );
  }
} 