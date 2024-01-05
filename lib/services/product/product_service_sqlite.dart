
import 'package:male_naturapp/models/product.dart';
import 'package:male_naturapp/models/product_category.dart';
import 'package:male_naturapp/services/product/product_service.dart';
import 'package:male_naturapp/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class ProductServiceSqlite implements ProductService {

  static const String _productIdColumnName = 'id';
  static const String _productExternalIdColumnName = 'external_id';
  static const String _productNameColumnName = 'name';
  static const String _productDescriptionColumnName = 'description';
  static const String _productCategoryColumnName = 'category';

  static const String _productTableName = 'products';

  static const String _productCategoryIdColumnName = 'id';
  static const String _productCategoryNameColumnName = 'name';

  static const String _productCategoryTableName = 'categories';

  static void initializeTables(Database database, int version) {
    database.execute(
      'CREATE TABLE $_productTableName('
          '$_productIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT, '
          '$_productNameColumnName TEXT, '
          '$_productExternalIdColumnName TEXT, '
          '$_productDescriptionColumnName TEXT, '
          '$_productCategoryColumnName INTEGER)',
    );
    database.execute(
      'CREATE TABLE $_productCategoryTableName('
          '$_productCategoryIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT, '
          '$_productCategoryNameColumnName TEXT)',
    );
  }

  static void upgradeTables(Database database, int oldVersion, int newVersion) {
    database.execute(
      'CREATE TABLE $_productCategoryTableName('
          '$_productCategoryIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT, '
          '$_productCategoryNameColumnName TEXT)',
    );
  }

  static Map<String, dynamic> productToMap(Product product) {
    return {
      _productIdColumnName:           product.id,
      _productNameColumnName:         product.name,
      _productExternalIdColumnName:   product.externalId,
      _productDescriptionColumnName:  product.description,
      _productCategoryColumnName:     product.category,
    };
  }

  static Product mapToProduct(Map<String, dynamic> map) {
    return Product(
      id:           map[_productIdColumnName] as int,
      name:         map[_productNameColumnName] as String,
      externalId:   map[_productExternalIdColumnName] as String,
      description:  map[_productDescriptionColumnName] as String,
      category:     map[_productCategoryColumnName] as int,
    );
  }

  static Map<String, dynamic> categoryToMap(ProductCategory category) {
    return {
      _productCategoryIdColumnName:   category.id,
      _productCategoryNameColumnName: category.name,
    };
  }

  static ProductCategory mapToCategory(Map<String, dynamic> map) {
    return ProductCategory(
      id:           map[_productCategoryIdColumnName] as int,
      name:         map[_productCategoryNameColumnName] as String,
    );
  }

  @override
  Future<Product> save(Product product) async {
    Database database = DatabaseHelper().getConnection();

    database.insert(
      _productTableName,
      productToMap(product),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return product;
  }

  @override
  Future<Product> editProduct(Product product) async {
    Database database = DatabaseHelper().getConnection();
    int id = product.id!;

    database.update(
      _productTableName,
      productToMap(product),
      where: '$_productIdColumnName = $id',
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return product;
  }

  @override
  Future<ProductCategory> saveCategory(ProductCategory category) async {
    Database database = DatabaseHelper().getConnection();

    database.insert(
      _productCategoryTableName,
      categoryToMap(category),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return category;
  }

  @override
  Future<List<Product>> getAllProducts() async {
    Database database = DatabaseHelper().getConnection();

    final List<Map<String, dynamic>> maps = await database.query(_productTableName);

    return List.generate(maps.length, (i) {return mapToProduct(maps[i]);});
  }

  @override
  void delete(int id) async {
    Database database = DatabaseHelper().getConnection();

    await database.delete(_productTableName, where: '$_productIdColumnName = $id');
  }

  @override
  void deleteCategory(int id) async {
    Database database = DatabaseHelper().getConnection();

    await database.delete(_productCategoryTableName, where: '$_productCategoryIdColumnName = $id');
  }

  @override
  Future<Product> getProductById(int id) async {
    Database database = DatabaseHelper().getConnection();

    final List<Map<String, dynamic>> maps = await database.query(_productTableName, where: "$_productIdColumnName = $id");

    return List.generate(maps.length, (i) {
      return mapToProduct(maps[i]);
    })[0];
  }

  @override
  Future<List<ProductCategory>> getAllCategories() async {
    Database database = DatabaseHelper().getConnection();

    final List<Map<String, dynamic>> maps = await database.query(_productCategoryTableName);

    return List.generate(maps.length, (i) {return mapToCategory(maps[i]);});
  }

  @override
  Future<ProductCategory> getCategoryByName(String name) async {
    Database database = DatabaseHelper().getConnection();

    final List<Map<String, dynamic>> maps = await database.query(_productCategoryTableName, where: "$_productCategoryNameColumnName = '$name'");

    return List.generate(maps.length, (i) {return mapToCategory(maps[i]);})[0];
  }

  @override
  Future<ProductCategory> getCategoryById(int id) async {
    Database database = DatabaseHelper().getConnection();

    final List<Map<String, dynamic>> maps = await database.query(_productCategoryTableName, where: "$_productCategoryIdColumnName = $id");

    return List.generate(maps.length, (i) {return mapToCategory(maps[i]);})[0];
  }

  @override
  void editCategory(int id, String name) async {
    Database database = DatabaseHelper().getConnection();

    await database.update(_productCategoryTableName, [{_productCategoryNameColumnName: name}] as Map<String, Object?>, where: "$_productCategoryIdColumnName = $id");
  }
}