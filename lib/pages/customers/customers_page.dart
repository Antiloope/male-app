import 'package:flutter/material.dart';
import 'package:male_naturapp/models/customer.dart';
import 'package:male_naturapp/pages/customers/customer_details_page.dart';
import 'package:male_naturapp/pages/customers/new_customer_page.dart';
import 'package:male_naturapp/services/customer/customer_service.dart';
import 'package:male_naturapp/services/customer/customer_service_provider.dart';


class CustomersPage extends StatefulWidget {
  CustomersPage({super.key});
  
  static const Icon icon = Icon(Icons.person);
  static const String title = "Clientes";
  
  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  _CustomersPageState() : customerService = DefaultCustomerServiceProvider.getDefaultCustomerService();
  
  late final CustomerService customerService;
  
  List<Customer> _customers = [];

  Future<void> _newCustomer() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewCustomerPage()));
    if (result != null && result == true) {
      var customers = await customerService.getAllCustomers();
      setState(() {
        _customers = customers;
      });
    }
  }

  void _deleteItem(int id) async {
    customerService.delete(id);
    var customers = await customerService.getAllCustomers();
    setState(() {
      _customers = customers;
    });
  }
  void _customerDetails(int id) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomerDetailsPage(customerId: id)));
    if (result != null && result == true) {
      var customers = await customerService.getAllCustomers();
      setState(() {
        _customers = customers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Customer>>(
        future: customerService.getAllCustomers(),
        builder: (BuildContext context, AsyncSnapshot<List<Customer>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          else if (snapshot.hasError) {
            return Text('Error al cargar los datos');
          }
          else {
            _customers = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async {
                var customers = await customerService.getAllCustomers();
                setState(() {
                  _customers = customers;
                });
                return Future(() => null);
              },
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 3),
                itemCount: _customers.length,
                prototypeItem: SizedBox(
                  height: 50,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        _customerDetails(_customers[index].id);
                      },
                      child: Card(
                        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(_customers[index].name)),
                            Expanded(
                              child: Text(_customers[index].id.toString())),
                            Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    _deleteItem(_customers[index].id);
                                  },
                                  icon: Icon(Icons.delete)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
              }),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newCustomer,
        child: Icon(Icons.add),
      ),
    );
  }
}