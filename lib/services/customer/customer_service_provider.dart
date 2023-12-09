import 'package:male_naturapp/services/customer/customer_service.dart';
import 'package:male_naturapp/services/customer/customer_service_sqlite.dart';

class DefaultCustomerServiceProvider {
  static CustomerService getDefaultCustomerService() {
    return CustomerServiceSqlite();
  }
}