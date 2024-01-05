import 'package:flutter/material.dart';
import 'package:male_naturapp/models/customer.dart';
import 'package:male_naturapp/services/customer/customer_service.dart';
import 'package:male_naturapp/services/customer/customer_service_provider.dart';

class CustomerDetailsPage extends StatelessWidget {
  CustomerDetailsPage({super.key, required this.customerId}) : customerService = DefaultCustomerServiceProvider.getDefaultCustomerService();

  final int customerId;
  final CustomerService customerService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Customer>(
      future: customerService.getCustomerById(customerId),
      builder: (BuildContext context, AsyncSnapshot<Customer> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        else if (snapshot.hasError) {
          return Text('Error al cargar los datos');
        }
        else {
          Customer customer = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Center(child: Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold))),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            body: ListView(
              padding: EdgeInsets.all(10),
              children: [
                Card(
                  margin: EdgeInsets.all(6),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Center(child: Text('Información personal', style: TextStyle(fontWeight: FontWeight.bold)))),
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text('Nombre: ', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              children: [
                                Text(customer.name),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text('Teléfono: ', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              children: [
                                Text(customer.phone.toString()),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(6),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Center(child: Text('Últimas compras', style: TextStyle(fontWeight: FontWeight.bold)))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(6),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Center(child: Text('Fidelizaciones', style: TextStyle(fontWeight: FontWeight.bold)))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

}