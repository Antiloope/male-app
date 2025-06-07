import 'stock_service.dart';
import 'stock_service_sqlite.dart';

class DefaultStockServiceProvider {
  static StockService getDefaultStockService() {
    return StockServiceSqlite();
  }
} 