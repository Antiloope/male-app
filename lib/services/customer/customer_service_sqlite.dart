import 'dart:async';

import 'package:male_naturapp/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:male_naturapp/models/customer.dart';
import 'package:male_naturapp/services/customer/customer_service.dart';

class CustomerServiceSqlite implements CustomerService {

  static const  String _customerIdColumnName = 'id';
  static const String _customerNameColumnName = 'name';
  static const String _customerPhoneColumnName = 'phone';

  static const String _customerTableName = 'customers';

  static void createTable(Database database, int version) {
    database.execute(
      'CREATE TABLE $_customerTableName('
          '$_customerIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT, '
          '$_customerNameColumnName TEXT, '
          '$_customerPhoneColumnName INTEGER)',
    );
  }

  static Map<String, dynamic> customerToMap(Customer customer) {
    return {
      _customerIdColumnName: customer.id,
      _customerNameColumnName: customer.name,
      _customerPhoneColumnName: customer.phone,
    };
  }

  static Customer mapToCustomer(Map<String, dynamic> map) {
    return Customer(
      id: map[_customerIdColumnName] as int,
      name: map[_customerNameColumnName] as String,
      phone: map[_customerPhoneColumnName] as int,
    );
  }

  @override
  Future<Customer> save(Customer customer) async {
    Database database = DatabaseHelper().getConnection();

    database.insert(
      _customerTableName,
      customerToMap(customer),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return customer;
  }

  @override
  Future<List<Customer>> getByName(String name) async {
    Database database = DatabaseHelper().getConnection();

    final List<Map<String, dynamic>> maps = await database.query(_customerTableName,where: "$_customerNameColumnName = '$name'");

    return List.generate(maps.length, (i) {
      return Customer(
        id: maps[i][_customerIdColumnName] as int,
        name: maps[i][_customerNameColumnName] as String,
        phone: maps[i][_customerPhoneColumnName] as int,
      );
    });
  }

  @override
  Future<List<Customer>> getAllCustomers() async {
    Database database = DatabaseHelper().getConnection();

    final List<Map<String, dynamic>> maps = await database.query(_customerTableName);

    return List.generate(maps.length, (i) {return mapToCustomer(maps[i]);});
  }

  @override
  void delete(int id) async {
    Database database = DatabaseHelper().getConnection();

    await database.delete(_customerTableName, where: '$_customerIdColumnName = $id');
  }
}