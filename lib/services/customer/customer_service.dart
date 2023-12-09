import '../../models/customer.dart';

abstract class CustomerService {
  Future<Customer> save(Customer customer);
  Future<List<Customer>> getByName(String name);
  Future<List<Customer>> getAllCustomers();
  Future<Customer> getCustomerById(int id);
  void delete(int id);
}