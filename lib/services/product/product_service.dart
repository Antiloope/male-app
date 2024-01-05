import 'package:male_naturapp/models/product.dart';
import 'package:male_naturapp/models/product_category.dart';

abstract class ProductService {
  Future<Product> save(Product product);
  void editProduct(Product product);
  Future<ProductCategory> saveCategory(ProductCategory category);
  Future<List<Product>> getAllProducts();
  Future<Product> getProductById(int id);
  Future<List<ProductCategory>> getAllCategories();
  Future<ProductCategory> getCategoryByName(String name);
  Future<ProductCategory> getCategoryById(int id);
  void editCategory(int id, String name);
  void delete(int id);
  void deleteCategory(int id);
}