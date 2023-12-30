import 'package:male_naturapp/models/product.dart';
import 'package:male_naturapp/models/product_category.dart';

abstract class ProductService {
  Future<Product> save(Product product);
  Future<ProductCategory> saveCategory(ProductCategory category);
  Future<List<Product>> getAllProducts();
  Future<Product> getProductById(int id);
  Future<List<ProductCategory>> getAllCategories();
  Future<ProductCategory?> getCategoryByName(String name);
  void delete(int id);
  void deleteCategory(int id);
}