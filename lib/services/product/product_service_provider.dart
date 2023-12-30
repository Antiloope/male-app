import 'package:male_naturapp/services/product/product_service.dart';
import 'package:male_naturapp/services/product/product_service_sqlite.dart';

class DefaultProductServiceProvider {
  static ProductService getDefaultProductService() {
    return ProductServiceSqlite();
  }
}