import 'package:flutter/material.dart';
import 'package:male_naturapp/models/customer.dart';
import 'package:male_naturapp/pages/customers/customer_details_page.dart';
import 'package:male_naturapp/pages/customers/new_customer_page.dart';
import 'package:male_naturapp/services/customer/customer_service.dart';
import 'package:male_naturapp/services/customer/customer_service_provider.dart';
import 'package:male_naturapp/widgets/app_bar_frame.dart';

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
    return AppBarFrame(
      title: CustomersPage.title,
      body: Scaffold(
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
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    itemCount: _customers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _customerDetails(_customers[index].id!);
                        },
                        child: Card(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30,8,8,8),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(_customers[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                                IconButton(
                                    onPressed: () => showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) => AlertDialog(
                                          title: const Text('Eliminación de cliente'),
                                          content: const Text('Confirmas la eliminación del cliente?'),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () => Navigator.pop(context, 'Cancelar'),
                                                child: Text('Cancelar', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary))
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, 'Ok');
                                                  _deleteItem(_customers[index].id!);
                                                },
                                                child: Text('Ok', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary))
                                            ),
                                          ],
                                        )
                                    ),
                                    icon: Icon(Icons.delete)),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newCustomer,
        child: Icon(Icons.add),
      ),
    );
  }
}